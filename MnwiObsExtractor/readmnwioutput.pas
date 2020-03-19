unit ReadMnwiOutput;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Generics.Collections, Generics.Defaults;

type
  TDoubleArray = array of double;

  TMnwiObsType = (motQin, motQout, motQnet, motQCumu, motHwell);

  TMnwiOutRecord = record
    WellID: string;
    TOTIM: double;
    Qin: double;
    Qout: double;
    Qnet: double;
    QCumu: double;
    hwell: double;
    Additional: TDoubleArray;
  end;

  TMnwiObsValue = class(TObject)
    ObsName: string;
    ObsType: TMnwiObsType;
    ObsTime: double;
    SimulatedValue: double;
    Print: Boolean;
  end;

  TMnwiObsValueList = specialize TList<TMnwiObsValue>;
  TMnwiObsValueObjectList = specialize TObjectList<TMnwiObsValue>;
  TMnwiObsValueDictionary = specialize TDictionary<string, TMnwiObsValue>;

  { TObsExtractor }

  TObsExtractor = class(TObject)
  private
    FMnwiObsValueList: TMnwiObsValueList;
    FMnwiOutputFileName: string;
    function GetItem(Index: integer): TMnwiObsValue;
    function GetObsCount: integer;
    procedure SetMnwiOutputFileName(AValue: string);
    function Value(MnwiRecord: TMnwiOutRecord; Index: Integer): double;
  public
    Constructor Create;
    destructor Destroy; override;
    property MnwiOutputFileName: string read FMnwiOutputFileName
      write SetMnwiOutputFileName;
    procedure AddObs(Obs: TMnwiObsValue);
    property ObsCount: integer read GetObsCount;
    property Items[Index: integer]: TMnwiObsValue read GetItem; default;
    procedure ExtractSimulatedValues;
  end;

const
  MissingValue = -1e-31;

implementation

uses RealListUnit;

function ConvertLine(AMnwiOutLine: string): TMnwiOutRecord;
const
  MinNumValues = 6;
var
  Splitter: TStringList;
  AddValuesCount: Integer;
  AddValueIndex: Integer;
begin
  result.WellID := Trim(Copy(AMnwiOutLine, 1, 20));
  Splitter := TStringList.Create;
  try
    Splitter.Delimiter := ' ';
    Splitter.DelimitedText := Trim(Copy(AMnwiOutLine, 22, MAXINT));
    if Pos('(Well is inactive)', AMnwiOutLine) >= 1 then
    begin
      SetLength(result.Additional, 0);
      result.TOTIM := StrToFloat(Splitter[0]);
      result.Qin := MissingValue;
      result.Qout := MissingValue;
      result.Qnet := MissingValue;
      result.QCumu := MissingValue;
      result.hwell := MissingValue;
    end
    else
    begin
      Assert(Splitter.Count >= MinNumValues);
      AddValuesCount := Splitter.Count-MinNumValues;
      SetLength(result.Additional, AddValuesCount);
      result.TOTIM := StrToFloat(Splitter[0]);
      result.Qin := StrToFloat(Splitter[1]);
      result.Qout := StrToFloat(Splitter[2]);
      result.Qnet := StrToFloat(Splitter[3]);
      result.QCumu := StrToFloat(Splitter[4]);
      result.hwell := StrToFloat(Splitter[5]);
      for AddValueIndex := 0 to Pred(AddValuesCount) do
      begin
        result.Additional[AddValueIndex] :=
          StrToFloat(Splitter[MinNumValues + AddValueIndex]);
      end;
    end;

  finally
    Splitter.Free;
  end;
end;

{ TObsExtractor }

procedure TObsExtractor.SetMnwiOutputFileName(AValue: string);
begin
  if FMnwiOutputFileName=AValue then Exit;
  FMnwiOutputFileName:=AValue;
end;

function TObsExtractor.Value(MnwiRecord: TMnwiOutRecord; Index: Integer
  ): double;
var
  AddIndex: Integer;
begin
  Assert(Index >= 0);
  AddIndex := Index - Ord(motHwell) -1;
  if AddIndex >= 0 then
  begin
    if AddIndex < Length(MnwiRecord.Additional) then
    begin
      result := MnwiRecord.Additional[AddIndex];
    end
    else
    begin
      result := MissingValue;
    end;
  end
  else
  begin
    case TMnwiObsType(Index) of
      motQin:
        begin
          result := MnwiRecord.Qin;
        end;
      motQout:
        begin
          result := MnwiRecord.Qout;
        end;
      motQnet:
        begin
          result := MnwiRecord.Qnet;
        end;
      motQCumu:
        begin
          result := MnwiRecord.QCumu;
        end;
      motHwell:
        begin
          result := MnwiRecord.hwell;
        end;
      else
        Assert(False);
    end;
  end;
end;

function TObsExtractor.GetItem(Index: integer): TMnwiObsValue;
begin
  result := FMnwiObsValueList[Index];
end;

function TObsExtractor.GetObsCount: integer;
begin
  result := FMnwiObsValueList.Count;
end;

constructor TObsExtractor.Create;
begin
  FMnwiObsValueList := TMnwiObsValueList.Create;
  FMnwiOutputFileName := '';
end;

destructor TObsExtractor.Destroy;
begin
  FMnwiObsValueList.Free;
  inherited Destroy;
end;

procedure TObsExtractor.AddObs(Obs: TMnwiObsValue);
begin
  FMnwiObsValueList.Add(Obs);
end;

procedure TObsExtractor.ExtractSimulatedValues;
const
  Epsilon = 1e-6;
var
  ObsLines: TStringList;
  ObsRecords: array of TMnwiOutRecord;
  LineIndex: Integer;
  ObsIndex: Integer;
  Times: TRealList;
  Obs: TMnwiObsValue;
  RecordIndex: integer;
  ObsRecord: TMnwiOutRecord;
  FirstRecord: TMnwiOutRecord;
  SecondRecord: TMnwiOutRecord;
  procedure InterpolateValues;
  var
    FirstValue: double;
    SecondValue: double;
  begin
    FirstValue := Value(FirstRecord, Ord(Obs.ObsType));
    SecondValue := Value(SecondRecord, Ord(Obs.ObsType));
    if (FirstValue = MissingValue) or (SecondValue = MissingValue) then
    begin
      Obs.SimulatedValue := MissingValue;
    end
    else
    begin
      Obs.SimulatedValue := FirstValue
        + (SecondValue - FirstValue)
        / (SecondRecord.TOTIM - FirstRecord.TOTIM)
        * (Obs.ObsTime - FirstRecord.TOTIM);
    end;
  end;
begin
  Assert(FMnwiOutputFileName <> '');
  Assert(ObsCount > 0);
  Times := TRealList.Create;
  ObsLines := TStringList.Create;
  try
    ObsLines.LoadFromFile(FMnwiOutputFileName);
    Times.Capacity := ObsLines.Count-1;
    SetLength(ObsRecords, ObsLines.Count-1);
    for LineIndex := 1 to Pred(ObsLines.Count) do
    begin
      ObsRecords[LineIndex-1] := ConvertLine(ObsLines[LineIndex]);
      Times.Add(ObsRecords[LineIndex-1].TOTIM);
    end;
    Times.Sorted := True;
    for ObsIndex := 0 to Pred(ObsCount) do
    begin
      Obs := Items[ObsIndex];
      RecordIndex := Times.IndexOfClosest(Obs.ObsTime);
      Assert(RecordIndex >= 0);
      ObsRecord := ObsRecords[RecordIndex];
      if Abs(Obs.ObsTime - ObsRecord.TOTIM) <= Epsilon then
      begin
        Obs.SimulatedValue := Value(ObsRecord, Ord(Obs.ObsType));
      end
      else
      begin
        if (Obs.ObsTime > ObsRecord.TOTIM)
          and (RecordIndex+1 < Length(ObsRecords)) then
        begin
          FirstRecord := ObsRecord;
          SecondRecord := ObsRecords[RecordIndex+1];
          InterpolateValues;
        end
        else if (Obs.ObsTime < ObsRecord.TOTIM)
          and (RecordIndex >= 1) then
        begin
          FirstRecord := ObsRecords[RecordIndex-1];
          SecondRecord := ObsRecord;
          InterpolateValues;
        end
        else
        begin
          if (Obs.ObsTime > ObsRecord.TOTIM) then
          begin
            Obs.SimulatedValue := MissingValue;
          end
          else
          begin
            Obs.SimulatedValue := Value(ObsRecord, Ord(Obs.ObsType));
          end;
        end;
      end;
    end;
  finally
    ObsLines.Free;
    Times.Free;
  end;
end;

end.

