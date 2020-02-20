{@name is used to generate the names of new temporary files and
to delete those files when the program closes.  During initialization
of @name, an application-specific temporary directory will be created
if it does not already exist.  If any files are in the directory and
another instance of the program is not already running, the temporary
directory will be cleared.}
unit TempFiles;

interface

uses Windows, SysUtils, Classes;

{@name generates a name for a new temporary file in an application-specific
temporary directory.  When the program
closes, any file whose name matches a name generated by @name will
be deleted if it has not already been deleted.  }
function TempFileName: string;

// @name returns the name of a temporary directory where
// temporary files for an Application can be created.
// If the directory does not exist, @name will create it.
function GetAppSpecificTempDir: string;

type
  //  Mode must be fmOpenRead, fmOpenWrite, or fmOpenReadWrite
  TTempFileStream = class(TFileStream)
    constructor Create(const AFileName: string; Mode: Word);
  end;

procedure ZipAFile(const FileName: string; InStream: TMemoryStream);
// @name reads the data associated with FileName into OutStream and
// sets the position of OutStream to 0.
procedure ExtractAFile(const FileName: string; OutStream: TMemoryStream);

procedure FreeMemory(const FileName: string);

function MemoryUsed(out FileCount: integer): Int64;

//procedure ReclaimMemory;

implementation

uses RTLConsts, Contnrs, Forms, TlHelp32;

var MaxItems: integer = 200;

type
//  TInt64Array = array of Int64;

  TBooleanItem = class(TObject)
    Value: boolean;
  end;

  TBooleanList = class(TObject)
  strict private
    FList: TList;
  private
    function GetCount: integer;
    function GetValue(Index: integer): boolean;
    procedure SetValue(Index: integer; const Value: boolean);
    procedure SetCapacity(const Value: integer);
    function GetCapacity: integer;
  public
    constructor Create;
    Destructor Destroy; override;
    property Values[Index: integer]: boolean read GetValue write SetValue; default;
    procedure Insert(Position: integer; AValue: boolean);
    property Count: integer read GetCount;
    property Capacity: integer read GetCapacity write SetCapacity;
  end;

  TTempItems = class(TObject)
  strict private
    FArchiveName: string;
    FFileListName: string;
    FFileList: TStringList;
    FStreamList: TList;
    FIsDirty: TBooleanList;
    FCanStore: boolean;
    FPositions: array of Int64;
    FFileListStream: TFileStream;
    FFileStream: TFileStream;
    function GetIsDirty(Index: integer): boolean;
    procedure SetIsDirty(Index: integer; const Value: boolean);
    procedure RestoreStreams;
    procedure RestoreAStream(const FileName: string; OutStream: TMemoryStream);
    property IsDirty[Index: integer]: boolean read GetIsDirty write SetIsDirty;
  private
    function GetCount: integer;
  public
    procedure StoreStreams;
    Constructor Create(Const ArchiveName: string);
    Destructor Destroy; override;
    function StreamFromFileName(const FileName: string;
      RestoreIfCached: boolean): TMemoryStream;
    Procedure SetDirtyFile(const FileName: string);
    property CanStore: boolean read FCanStore write FCanStore;
    function MemoryUsed: int64;
    property Count: integer read GetCount;
  end;

var
  TemporaryFiles: TStringList;
  CurrentTempDir: string = '';
  DirCount: integer = 0;
  ErrorCount: integer = 0;
  Directories: TStringList;
  ZipFiles: TStringList;
  FilesToSave: TStringList;
  TempItemList: TList;
  CurrentTempItems: TTempItems = nil;
  PriorTempItems: TTempItems = nil;
  LastCreatedTempItems: TTempItems = nil;

function MemoryUsed(out FileCount: integer): Int64;
var
  Index: Integer;
  TempItem: TTempItems;
  MemUsed: Int64;
begin
  result := 0;
  FileCount := 0;
  for Index := 0 to TempItemList.Count - 1 do
  begin
    TempItem := TempItemList[Index];
    MemUsed := TempItem.MemoryUsed;
    if MemUsed > 0 then
    begin
      Inc(FileCount);
    end;
    result := result + MemUsed;
  end;
end;

//procedure ReclaimMemory;
//begin
////  Exit;
//  if PriorTempItems <> nil then
//  begin
//    PriorTempItems.CanStore := PriorTempItems.CanStore
//      or (PriorTempItems.Count > 0);
//    PriorTempItems.StoreStreams;
//  end;
//  if CurrentTempItems <> nil then
//  begin
//    CurrentTempItems.CanStore := CurrentTempItems.CanStore
//      or (CurrentTempItems.Count > 0);
//    CurrentTempItems.StoreStreams;
//  end;
//  if LastCreatedTempItems <> nil then
//  begin
//    LastCreatedTempItems.CanStore := LastCreatedTempItems.CanStore
//      or (LastCreatedTempItems.Count > 0);
//    LastCreatedTempItems.StoreStreams;
//  end;
//end;

function CreateZipFile(const DirName: string): string;
var
//  Count: Integer;
  ADirectory: string;
  Position: Integer;
  TempItems: TTempItems;
  Buffer: array[0..MAX_PATH] of Char;
begin
//  if (TemporaryFiles.Count > 0) and ((TemporaryFiles.Count mod MaxItems) = 0) then
//  begin
//    UpdateCurrentDir;
//  end;

//  CurrentTempDir := GetAppSpecificTempDir;
  GetTempFileName(PChar(DirName), PChar('MM_' + IntToStr(TemporaryFiles.Count)),
    0, Buffer);
  result := Buffer;
  while TemporaryFiles.IndexOf(result) >= 0 do
  begin
    TemporaryFiles.Add(result);
    GetTempFileName(PChar(DirName), PChar('MM_' + IntToStr(TemporaryFiles.Count)),
      0, Buffer);
    result := Buffer;
  end;
//  result := TempFileName;
//  result := IncludeTrailingPathDelimiter(DirName) + 'MM.tmp';
//  if FileExists(result) then
//  begin
//    Count := 0;
//    repeat
//      Inc(Count);
//      result := IncludeTrailingPathDelimiter(DirName) + 'MM'
//        + IntToStr(Count) + '.tmp';
//    until (not FileExists(result));
//  end;
  ZipFiles.Add(result);
  TemporaryFiles.Add(result);
  ADirectory := IncludeTrailingPathDelimiter(ExtractFileDir(result));
  Position := Directories.IndexOf(ADirectory);
  TempItems := TTempItems.Create(result);
  TempItemList.Insert(Position, TempItems);
  if LastCreatedTempItems <> nil then
  begin
    LastCreatedTempItems.CanStore := True;
  end;
  LastCreatedTempItems := TempItems;
end;

function GetStandardDirName: string;
var
  ApplicationName: string;
  PathName: array[0..260] of Char;
begin
  if GetTempPath(MAX_PATH, @PathName) = 0 then
  begin
    RaiseLastOSError;
  end;
  result := IncludeTrailingPathDelimiter(Trim(PathName));
  ApplicationName := ExtractFileName(ParamStr(0));
  result := ExcludeTrailingPathDelimiter(result + ChangeFileExt(ApplicationName, ''));
end;

function UpdateCurrentDir: string;
var
  Count: Integer;
  BaseName: string;
begin
  BaseName := GetStandardDirName;
  result := BaseName;
  Count := 0;
  while DirectoryExists(result) do
  begin
    Inc(Count);
    result := BaseName + IntToStr(Count);
  end;
  result := IncludeTrailingPathDelimiter(result);
  CreateDir(result);
  Directories.Add(result);
  CreateZipFile(result);
  CurrentTempDir := result;
end;

// Get the name of an application-specific temporary directory.
// Create the directory if it does not already exist.
function GetAppSpecificTempDir: string;
begin
  if CurrentTempDir <> '' then
  begin
    result := CurrentTempDir;
    Exit;
  end;
  Result := UpdateCurrentDir;
end;


function TempFileName: string;
var
  Buffer: array[0..MAX_PATH] of Char;
begin
  if (TemporaryFiles.Count > 0) and ((TemporaryFiles.Count mod MaxItems) = 0) then
  begin
    UpdateCurrentDir;
  end;

  CurrentTempDir := GetAppSpecificTempDir;
  GetTempFileName(PChar(CurrentTempDir), PChar('MM_' + IntToStr(TemporaryFiles.Count)),
    0, Buffer);
  result := Buffer;
  while TemporaryFiles.IndexOf(result) >= 0 do
  begin
    TemporaryFiles.Add(result);
    GetTempFileName(PChar(CurrentTempDir), PChar('MM_' + IntToStr(TemporaryFiles.Count)),
      0, Buffer);
    result := Buffer;
  end;
  TemporaryFiles.Add(result);
end;

procedure RemoveDirectories;
var
  Index: Integer;
begin
  for Index := 0 to Directories.Count - 1 do
  begin
    if DirectoryExists(Directories[Index]) then
    begin
      // If the directory contains files, RemoveDir will fail.
      RemoveDir(Directories[Index]);
    end;
  end;
end;

// delete all files that were generated by TempFileName if they have
// not already been deleted.
procedure DeleteFiles;
var
  Index: integer;
begin
  for Index := 0 to TemporaryFiles.Count - 1 do
  begin
    if FileExists(TemporaryFiles[Index]) then
    begin
      DeleteFile(TemporaryFiles[Index]);
    end;
  end;
  TemporaryFiles.Clear;
end;

// from http://www.tek-tips.com/faqs.cfm?fid=7523
function ProcessCount(const ExeName: String): Integer;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle:= CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize:= SizeOf(FProcessEntry32);
  ContinueLoop:= Process32First(FSnapshotHandle, FProcessEntry32);
  Result:= 0;
  while Integer(ContinueLoop) <> 0 do begin
    if ((UpperCase(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperCase(ExeName)) or (UpperCase(FProcessEntry32.szExeFile) =
      UpperCase(ExeName))) then Inc(Result);
    ContinueLoop:= Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

// Check if the program is already running.
function AlreadyRunning: boolean;
begin
  result := ProcessCount(ExtractFileName(ParamStr(0))) > 1;
end;

// Delete all files in the application-specific temporary directory.
procedure ClearAppSpecificTempDirectory;
var
  TempPath: string;
  F: TSearchRec;
  Files: TStringList;
  Index: Integer;
  FoundFile: boolean;
  FirstDir: string;
  Directories: TStringList;
  PathName: array[0..260] of Char;
  DirIndex: Integer;
begin
  Directories := TStringList.Create;
  try
    FirstDir := GetStandardDirName;

    if GetTempPath(MAX_PATH, @PathName) = 0 then
    begin
      RaiseLastOSError;
    end;
    TempPath := IncludeTrailingPathDelimiter(Trim(PathName));

    FoundFile := FindFirst(FirstDir + '*.*', faDirectory, F) = 0;
    try
      if FoundFile then
      begin
        Directories.Add(IncludeTrailingPathDelimiter(TempPath + F.Name));
        While FindNext(F) = 0 do
        begin
          Directories.Add(IncludeTrailingPathDelimiter(TempPath + F.Name));
        end;
      end;
    finally
      FindClose(F);
    end;


    Files := TStringList.Create;
    try
      for DirIndex := 0 to Directories.Count - 1 do
      begin
        TempPath := Directories[DirIndex];
        FoundFile := FindFirst(TempPath + '*.*', 0, F) = 0;
        try
          if FoundFile then
          begin
            Files.Add(TempPath + F.Name);
            While FindNext(F) = 0 do
            begin
              Files.Add(TempPath + F.Name);
            end;
          end;
        finally
          FindClose(F);
        end;
        for Index := 0 to Files.Count - 1 do
        begin
          if FileExists(Files[Index]) then
          begin
            if AlreadyRunning then
            begin
              Exit;
            end;
            DeleteFile(Files[Index]);
          end;
        end;
        Files.Clear;
        if DirectoryExists(TempPath) then
        begin
          if AlreadyRunning then
          begin
            Exit;
          end;
          RemoveDir(TempPath);
        end;
      end;
    finally
      Files.Free;
    end;
  finally
    Directories.Free;
  end;
end;

{ TTempFileStream }

constructor TTempFileStream.Create(const AFileName: string; Mode: Word);
{const
  AccessModes: array[0..2] of DWORD =
    (GENERIC_READ, GENERIC_WRITE, GENERIC_READ or GENERIC_WRITE);
  ShareMode: DWORD = FILE_SHARE_DELETE or FILE_SHARE_READ or FILE_SHARE_WRITE;
  Flags : DWORD = FILE_ATTRIBUTE_TEMPORARY or FILE_FLAG_DELETE_ON_CLOSE;  }
begin
  if not FileExists(AFileName) then
  begin
    Mode := fmCreate;
  end;
  inherited;
end;

function ZipfileName(const FileName: string): string;
var
  TempDir: string;
  Position: Integer;
begin
  TempDir := IncludeTrailingPathDelimiter(ExtractFileDir(FileName));
  Position := Directories.IndexOf(TempDir);
  result := ZipFiles[Position];
end;

function TempFileItem(const FileName: string): TTempItems;
var
  TempDir: string;
  Position: Integer;
begin
  TempDir := IncludeTrailingPathDelimiter(ExtractFileDir(FileName));
  Position := Directories.IndexOf(TempDir);
  Assert(Position >= 0);
  result := TempItemList[Position];
end;

procedure UpdateCurrentTempItems(const FileName: string);
var
  TempItems: TTempItems;
begin
  TempItems := TempFileItem(FileName);
  Assert(TempItems <> nil);
  if (TempItems <> CurrentTempItems) then
  begin
    if TempItems <> PriorTempItems then
    begin
      if PriorTempItems <> nil then
      begin
        PriorTempItems.StoreStreams;
      end;
    end;
    PriorTempItems := CurrentTempItems;
    CurrentTempItems := TempItems;
  end;
end;

procedure ZipAFile(const FileName: string; InStream: TMemoryStream);
var
  StoredStream: TMemoryStream;
begin
  if FileExists(FileName) then
  begin
    DeleteFile(FileName);
  end;
  UpdateCurrentTempItems(FileName);

  StoredStream := CurrentTempItems.StreamFromFileName(FileName, False);
  StoredStream.Position := 0;
  InStream.Position := 0;
  InStream.SaveToStream(StoredStream);
  CurrentTempItems.SetDirtyFile(FileName);
end;

procedure ExtractAFile(const FileName: string; OutStream: TMemoryStream);
var
  StoredStream: TMemoryStream;
begin
  UpdateCurrentTempItems(FileName);

  StoredStream := CurrentTempItems.StreamFromFileName(FileName, True);
  StoredStream.Position := 0;
  OutStream.Position := 0;
  StoredStream.SaveToStream(OutStream);
  OutStream.Position := 0;
end;

procedure FreeMemory(const FileName: string);
var
  StoredStream: TMemoryStream;
begin
  UpdateCurrentTempItems(FileName);
  StoredStream := CurrentTempItems.StreamFromFileName(FileName, True);
  StoredStream.Clear;
  CurrentTempItems.SetDirtyFile(FileName);
end;

{ TTempItems }

constructor TTempItems.Create(Const ArchiveName: string);
begin
  FArchiveName := ArchiveName;
  FFileStream := TFileStream.Create(FArchiveName, fmCreate or fmShareDenyWrite);
  FFileList := TStringList.Create;
  FFileList.Sorted := True;
  FFileList.Capacity := MaxItems;
  FStreamList := TObjectList.Create;
  FStreamList.Capacity := MaxItems;
  FIsDirty:= TBooleanList.Create;
  FIsDirty.Capacity := MaxItems;
  FFileListStream := nil;
//  FFileStream := nil;
end;

destructor TTempItems.Destroy;
begin
  FFileList.Free;
  FStreamList.Free;
  FIsDirty.Free;
  FFileListStream.Free;
  FFileStream.Free;
  inherited;
end;

function TTempItems.GetCount: integer;
begin
  result := FFileList.Count;
end;

function TTempItems.GetIsDirty(Index: integer): boolean;
begin
  result := FIsDirty[Index];
end;

function TTempItems.MemoryUsed: int64;
var
  Index: Integer;
  MemStream: TMemoryStream;
begin
  result := 0;
  for Index := 0 to FStreamList.Count - 1 do
  begin
    MemStream := FStreamList[Index];
    result := result + MemStream.Size;
  end;
end;

procedure TTempItems.RestoreAStream(const FileName: string; OutStream: TMemoryStream);
var
//  FileStream: TFileStream;
  StreamIndex: Integer;
  StreamSize: Int64;
//  ByteArray: TInt64Array;
begin

  if FFileStream <> nil  then
  begin
    Assert(FileExists(FArchiveName));
    FFileStream.Position := 0;
//    FileStream := TFileStream.Create(FArchiveName, fmOpenRead);
//    try
      StreamIndex := FFileList.IndexOf(FileName);
      Assert(StreamIndex >= 0);
      Assert(OutStream = FStreamList[StreamIndex]);
      if (OutStream.Size = 0) and not IsDirty[StreamIndex] then
      begin
        StreamSize := FPositions[StreamIndex + 1] - FPositions[StreamIndex];
        if StreamSize > 0 then
        begin
          FFileStream.Position := FPositions[StreamIndex];
          OutStream.CopyFrom(FFileStream, StreamSize * SizeOf(Byte))
        end;
      end;
//    finally
//      FileStream.Free;
//    end;
  end;
end;

procedure TTempItems.SetDirtyFile(const FileName: string);
var
  Position: Integer;
begin
  Position := FFileList.IndexOf(FileName);
  Assert(Position >= 0);
  IsDirty[Position] := True;
end;

procedure TTempItems.SetIsDirty(Index: integer; const Value: boolean);
begin
  FIsDirty[Index] := Value;
end;

procedure TTempItems.StoreStreams;
var
  FileIndex: Integer;
  InStream: TMemoryStream;
  NeedToSave: Boolean;
//  FileStream: TFileStream;
  Count: Integer;
  Position: Int64;
begin
  if not CanStore then
  begin
    Exit;
  end;
  NeedToSave := False;
  for FileIndex := 0 to FIsDirty.Count -1 do
  begin
    if IsDirty[FileIndex] then
    begin
      NeedToSave := True;
      break;
    end;
  end;
  if NeedToSave then
  begin
    if (FFileListName <> '') and (FFileList.Count = 0) then
    begin
      Assert(FFileListStream <> nil);
      FFileListStream.Position := 0;
      FFileList.LoadFromStream(FFileListStream);
    end;
    try
      RestoreStreams;

      if FFileStream = nil then
      begin
        FFileStream := TFileStream.Create(FArchiveName, fmCreate or fmShareDenyWrite);
      end;
      FFileStream.Size := 0;
      FFileStream.Position := 0;

      Count := FFileList.Count;
      SetLength(FPositions, Count+1);

      Position := 0;
      for FileIndex := 0 to FFileList.Count - 1 do
      begin
        FPositions[FileIndex] := Position;
        InStream := FStreamList[FileIndex];
        InStream.Position := 0;
        if InStream.Size > 0 then
        begin
          InStream.SaveToStream(FFileStream);
        end;
        IsDirty[FileIndex] := False;
        Position := Position + InStream.Size;
        InStream.Clear;
      end;
      FPositions[Count] := Position;
    finally
      if FFileListName = '' then
      begin
        FFileListName := TempFileName;
        Assert(FFileListStream = nil);
        FFileListStream := TFileStream.Create(FFileListName, fmCreate or fmShareDenyWrite);
        FFileList.SaveToStream(FFileListStream);
      end;
      FFileList.Clear;
    end;
  end
  else
  begin
    for FileIndex := 0 to FIsDirty.Count - 1 do
    begin
      InStream := FStreamList[FileIndex];
      InStream.Clear;
    end;
    FFileList.Clear;
  end;
end;

function TTempItems.StreamFromFileName(const FileName: string; RestoreIfCached: boolean): TMemoryStream;
var
  Position: Integer;
begin
  if (FFileListName <> '') and (FFileList.Count = 0) then
  begin
    Assert(FFileListStream <> nil);
    FFileListStream.Position := 0;
    FFileList.LoadFromStream(FFileListStream);
  end;
  Position := FFileList.IndexOf(FileName);
  if Position < 0 then
  begin
    Position := FFileList.Add(FileName);
    FStreamList.Insert(Position, TMemoryStream.Create);
    FIsDirty.Insert(Position, False);
  end;
  result := FStreamList[Position];
  if (result.Size = 0) and RestoreIfCached and not IsDirty[Position] then
  begin
    RestoreAStream(FileName, result);
  end;
end;

//procedure TTempItems.ReadHeader(var Positions: TInt64Array; TempFileNames: TStringList; FileStream: TFileStream);
//var
//  FileName: string;
//  FileNameSize: Integer;
//  Index: Integer;
//  Count: Integer;
//begin
//  FileStream.Read(Count, SizeOf(Count));
//  TempFileNames.Capacity := Count;
//  SetLength(Positions, Count);
//  for Index := 0 to Count - 1 do
//  begin
//    FileStream.Read(Positions[Index], SizeOf(Int64));
//    FileStream.Read(FileNameSize, SizeOf(FileNameSize));
//    SetString(FileName, nil, FileNameSize);
//    FileStream.Read(Pointer(FileName)^, FileNameSize * SizeOf(Char));
//    TempFileNames.Add(FileName);
//  end;
//  for Index := 0 to Count - 1 do
//  begin
//    Positions[Index] := Positions[Index] + FileStream.Position;
//  end;
//end;

procedure TTempItems.RestoreStreams;
var
//  Positions: TInt64Array;
  Count: Integer;
//  FileStreamSize: Int64;
//  FileStream: TFileStream;
//  TempFileNames: TStringList;
//  ByteArray: TInt64Array;
  StreamSize: Int64;
  InStream: TMemoryStream;
//  Position: Int64;
  StreamIndex: Integer;
begin
  if FFileStream <> nil then
  begin
    Assert(FileExists(FArchiveName));

    Count := Length(FPositions)-1;
    for StreamIndex := 0 to Count - 1 do
    begin
      InStream := FStreamList[StreamIndex];
      if (Instream.Size = 0) and not IsDirty[StreamIndex] then
      begin
        StreamSize := FPositions[StreamIndex + 1] - FPositions[StreamIndex];
        if StreamSize > 0 then
        begin
          FFileStream.Position := FPositions[StreamIndex];
          Instream.CopyFrom(FFileStream, StreamSize * SizeOf(Byte));
        end;
      end;
    end;
  end;
end;

{ TBooleanList }

constructor TBooleanList.Create;
begin
  FList := TObjectList.Create;
end;

destructor TBooleanList.Destroy;
begin
  FList.Free;
  inherited;
end;

function TBooleanList.GetCapacity: integer;
begin
  result := FList.Capacity;
end;

function TBooleanList.GetCount: integer;
begin
  result := FList.Count;
end;

function TBooleanList.GetValue(Index: integer): boolean;
var
  Item: TBooleanItem;
begin
  Item := FList[Index];
  result := Item.Value;
end;

procedure TBooleanList.Insert(Position: integer; AValue: boolean);
var
  Item: TBooleanItem;
begin
  Item := TBooleanItem.Create;
  Item.Value := AValue;
  FList.Insert(Position, Item);
end;

procedure TBooleanList.SetCapacity(const Value: integer);
begin
  FList.Capacity := Value;
end;

procedure TBooleanList.SetValue(Index: integer; const Value: boolean);
var
  Item: TBooleanItem;
begin
  Item := FList[Index];
  Item.Value := Value;
end;

initialization
  if not AlreadyRunning then
  begin
    ClearAppSpecificTempDirectory;
  end;
  TemporaryFiles:= TStringList.Create;
  TemporaryFiles.Sorted := True;
  Directories := TStringList.Create;
  Directories.Sorted := True;
  ZipFiles := TStringList.Create;
  FilesToSave := TStringList.Create;
  TempItemList := TObjectList.Create;
  GetAppSpecificTempDir;

finalization
  TempItemList.Free;
  FilesToSave.Free;
  DeleteFiles;
  RemoveDirectories;
  ZipFiles.Free;
  TemporaryFiles.Free;
  Directories.Free;
//  if ShouldReleaseMutex then
//  begin
//    ReleaseMutex(MutexHandle);
//  end;

end.
