{The main purpose of @name is to define @link(TvRbwMostRecentlyUsed)
 which manages
 a list of the most recently used files in an application.  It creates menu
 items for them that can be used to open those files.}
unit MostRecentlyUsedFiles;

interface

uses System.Types, SysUtils, Classes, Contnrs, Menus;

type
  {
    @name is used to specify the relationship between the
      @link(TRecentFileMenuItem TRecentFileMenuItems)
      generated by @link(TvRbwMostRecentlyUsed) and the one specified
      in @link(TvRbwMostRecentlyUsed.PreviousItem
      TvRbwMostRecentlyUsed.PreviousItem).
      
    @value(mipSibling @link(TRecentFileMenuItem TRecentFileMenuItems)
      generated by @link(TvRbwMostRecentlyUsed) will be the siblings
      of the specified menu item.)

    @value(mipChild @link(TRecentFileMenuItem TRecentFileMenuItems)
      generated by @link(TvRbwMostRecentlyUsed) will be the children
      of the specified menu item.)
  }
  TMenuItemPosition = (mipSibling, mipChild);

  // @name is used for Exceptions generated by @link(TvRbwMostRecentlyUsed).
  E_MRU_Exception = class(Exception);

  // @name is a specialized TMenuItem that has a @link(FileName) property.
  // The caption for the @classname has the file name without the drive
  // or path.
  TRecentFileMenuItem = class(TMenuItem)
  private
    // See @link(FileName).
    FFileName: string;
  public
    // @abstract(@name Destroys @classname.  Do not call @name directly.
    // Call Free instead.)
    // @name extracts itself from @link(TvRbwMostRecentlyUsed.FMenuItems
    // TvRbwMostRecentlyUsed.FMenuItems) before calling inherited.
    destructor Destroy; override;
    // @name is the full file name of the file for the @classname.
    property FileName: string read FFileName;
  end;

  {@name manages
   a list of the most recently used files in an application.  It creates menu
   items for them that can be used to open those files.}
  TvRbwMostRecentlyUsed = class(TComponent)
  private
    // see @link(Capacity).
    FCapacity: integer;
    // @name is the list of files names that is being stored.
    // @seeAlso(FileNames)
    // @seeAlso(FPublicFileNames)
    FFileNames: TStrings;
    // See @link(FileToIgnore).
    FFileToIgnore: string;
    // See @link(MenuItemPosition).
    FMenuItemPosition: TMenuItemPosition;
    // @name stores the TMenuItems created by @classname.
    FMenuItems: TObjectList;
    // See @link(OnClick).
    FOnClick: TNotifyEvent;
    // See @link(PreviousItem).
    FPreviousItem: TMenuItem;
    // @name is a copy of @link(FFileNames).  It is made available
    // through @link(FileNames).
    FPublicFileNames: TStrings;
    // See @link(ShowHint).
    FShowHint: boolean;
    FOnAdvancedDrawItem: TAdvancedMenuDrawItemEvent;
    FOnDrawItem: TMenuDrawItemEvent;
    FOnMeasureItem: TMenuMeasureItemEvent;
    // @name is called by @link(UpDateMenu) to create menu items.
    procedure CreateMenuItems(PriorPosition: integer);
    // @name gets the TMenuItem that is the parent of @link(PreviousItem)
    // and sets AddAsChild based on @link(MenuItemPosition).
    function GetParentItem(out AddAsChild: boolean): TMenuItem;
    // The read accessor for @link(FileNames). @name copies @link(FFileNames)
    // into @link(FPublicFileNames) and returns @link(FPublicFileNames).
    // (This prevents the user from making changes to @link(FFileNames)
    // directly.
    function GetPublicFileNames: TStrings;
    // See @link(MenuItemCount).
    function GetMenuItemCount: integer;
    // @name is called by @link(UpDateMenu) to put @link(PreviousItem)
    // back where it belongs.
    procedure RestorePositionPreviousItem(
      const PositionOfPreviousItem: integer);
    // see @link(Capacity).
    procedure SetCapacity(const Value: integer);
    // See @link(FileToIgnore).
    procedure SetFileToIgnore(const Value: string);
    // See @link(MenuItemPosition).
    procedure SetMenuItemPosition(const Value: TMenuItemPosition);
    // See @link(OnClick).
    procedure SetOnClick(const Value: TNotifyEvent);
    // See @link(PreviousItem).
    procedure SetPreviousItem(const Value: TMenuItem);
    // See @link(ShowHint).
    procedure SetShowHint(const Value: boolean);
    // @name gets rid of filenames in @link(FFileNames) when the capacity is
    // exceeded.
    procedure UpdateCapacity;
    // @name creates menu items for the recently opened files.
    procedure UpDateMenu;
  protected
    // @name is used to set @link(PreviousItem) to nil if
    // @link(PreviousItem) is removed.
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
  public
    // @name adds a file name to the list of files stored by the @classname.
    procedure AddFileName(FileName: string);
    // @name creates an instance of @classname.
    constructor Create(Owner: TComponent); override;
    // @name destroys the current instance of @classname.
    // Don't call @name directly.  Call Free instead.
    destructor Destroy; override;
    // @name removes a file name from the list of files stored
    // by the @classname.
    procedure RemoveFilename(FileName: string);
    // @name is a copy of the list of files stored by @classname.
    property FileNames: TStrings read GetPublicFileNames;
    // @name is the number of TMenuItems managed by @classname.
    property MenuItemCount: integer read GetMenuItemCount;
  published
    // @name is the maximum number of file names
    // that will be stored in a @classname.
    property Capacity: integer read FCapacity write SetCapacity;
    // no TMenuItem is created for @name
    property FileToIgnore: string read FFileToIgnore write SetFileToIgnore;
    { @name is used to specify the relationship between the
        @link(TRecentFileMenuItem TRecentFileMenuItems)
        generated by @classname and the one specified
        in @link(PreviousItem).

      @seealso(TMenuItemPosition)
    }
    property MenuItemPosition: TMenuItemPosition read FMenuItemPosition
      write SetMenuItemPosition;
    // @name is the OnClick event handler for each of the menu items
    // created by @classname.
    property OnClick: TNotifyEvent read FOnClick write SetOnClick;
    // @name is the OnHighlighted event handler for each of the menu items
    // created by @classname.

    property OnAdvancedDrawItem: TAdvancedMenuDrawItemEvent read FOnAdvancedDrawItem write FOnAdvancedDrawItem;
    property OnDrawItem: TMenuDrawItemEvent read FOnDrawItem write FOnDrawItem;
    property OnMeasureItem: TMenuMeasureItemEvent read FOnMeasureItem write FOnMeasureItem;

    // @name is the TMenuItem just before the TMenuItems created by
    // @classname.
    property PreviousItem: TMenuItem read FPreviousItem write SetPreviousItem;
    // If ShowHint is true, the Hint property of the menu items will be
    // set to the full file name.
    property ShowHint: boolean read FShowHint write SetShowHint;
  end;

// @name registers @link(TvRbwMostRecentlyUsed) with the Delphi IDE on the
// RBW page.
procedure Register;

implementation

{ TvRbwMostRecentlyUsed }

procedure TvRbwMostRecentlyUsed.AddFileName(FileName: string);
begin
  if FFileNames.IndexOf(FileName) = 0 then Exit;
  RemoveFilename(FileName);
  FFileNames.Insert(0, FileName);
  UpdateCapacity;
end;

constructor TvRbwMostRecentlyUsed.Create(Owner: TComponent);
begin
  inherited;
  FFileNames := TStringList.Create;
  FPublicFileNames := TStringList.Create;
  FMenuItems := TObjectList.Create;
  Capacity := 5;
  FShowHint := True;
end;

destructor TvRbwMostRecentlyUsed.Destroy;
begin
  FFileNames.Free;
  FPublicFileNames.Free;
  FMenuItems.Free;
  inherited;
end;

function TvRbwMostRecentlyUsed.GetMenuItemCount: integer;
begin
  result := FMenuItems.Count;
end;

function TvRbwMostRecentlyUsed.GetPublicFileNames: TStrings;
begin
  FPublicFileNames.Assign(FFileNames);
  result := FPublicFileNames;
end;

procedure TvRbwMostRecentlyUsed.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (AComponent = FPreviousItem) and (Operation = opRemove) then
  begin
    FPreviousItem := nil;
  end;
end;

procedure TvRbwMostRecentlyUsed.RemoveFilename(FileName: string);
var
  Position: integer;
begin
  Position := FFileNames.IndexOf(FileName);
  if Position >= 0 then
  begin
    FFileNames.Delete(Position);
    UpDateMenu;
  end;
end;

procedure TvRbwMostRecentlyUsed.SetCapacity(const Value: integer);
begin
  if Value < 0 then
  begin
    FCapacity := 0;
  end
  else
  begin
    FCapacity := Value;
  end;
  UpdateCapacity;
end;

procedure TvRbwMostRecentlyUsed.SetFileToIgnore(const Value: string);
begin
  if FFileToIgnore <> Value then
  begin
    FFileToIgnore := Value;
    UpDateMenu;
  end;
end;

procedure TvRbwMostRecentlyUsed.SetMenuItemPosition(
  const Value: TMenuItemPosition);
begin
  if FMenuItemPosition <> Value then
  begin
    FMenuItemPosition := Value;
    UpDateMenu;
  end;
end;

procedure TvRbwMostRecentlyUsed.SetOnClick(const Value: TNotifyEvent);
begin
  FOnClick := Value;
end;


procedure TvRbwMostRecentlyUsed.SetPreviousItem(const Value: TMenuItem);
var
  ParentComponent: TComponent;
begin
  if Value <> nil then
  begin
    ParentComponent := Value.GetParentComponent;
    if ParentComponent = nil then
    begin
      ParentComponent := Value.GetParentMenu
    end;
    if not ((ParentComponent is TMenuItem) or (ParentComponent is TMenu)) then
    begin
      raise E_MRU_Exception.Create('Invalid parent component');
    end;
  end;

  if FPreviousItem <> nil then
  begin
    FPreviousItem.RemoveFreeNotification(self);
  end;
  FPreviousItem := Value;
  if FPreviousItem <> nil then
  begin
    FPreviousItem.FreeNotification(self);
  end;
  UpDateMenu;
end;

procedure TvRbwMostRecentlyUsed.UpdateCapacity;
begin
  while FFileNames.Count > Capacity do
  begin
    FFileNames.Delete(FFileNames.Count -1);
  end;
  UpDateMenu;
end;

function TvRbwMostRecentlyUsed.GetParentItem(out AddAsChild: boolean): TMenuItem;
var
  ParentComponent: TComponent;
begin
  Assert(PreviousItem <> nil);
  AddAsChild := MenuItemPosition = mipChild;
  // Get the TMenuItem that is the parent of PreviousItem
  // and modify AddAsChild.
  result := nil;
  ParentComponent := PreviousItem.GetParentComponent;
  if ParentComponent is TMenuItem then
  begin
    result := TMenuItem(ParentComponent);
  end
  else if ParentComponent is TMenu then
  begin
    result := TMenu(ParentComponent).Items;
    if ParentComponent is TMainMenu then
    begin
      // can't add as sibling to TMainMenu.Items
      AddAsChild := True;
    end
    else
    begin
      Assert(ParentComponent is TPopUpMenu);
    end;
  end
  else if ParentComponent = nil then
  begin
    AddAsChild := True;
  end
  else
  begin
    Assert(False);
  end;
end;

procedure TvRbwMostRecentlyUsed.CreateMenuItems(PriorPosition: integer);
var
  Index: integer;
  Item: TRecentFileMenuItem;
  ParentItem: TMenuItem;
  AddAsChild: boolean;
begin
  ParentItem := GetParentItem(AddAsChild);
  for Index := 0 to FileNames.Count -1 do
  begin
    if FileNames[Index] <> FileToIgnore then
    begin
      Item := TRecentFileMenuItem.Create(self);
      FMenuItems.Add(Item);
      Item.FFileName := FileNames[Index];
      if ShowHint then
      begin
        Item.Hint := FileNames[Index];
      end;

      if AddAsChild then
      begin
        PreviousItem.Add(Item);
      end
      else
      begin
        Assert(ParentItem <> nil);
        ParentItem.Insert(PriorPosition, Item);
        Inc(PriorPosition);
      end;

      Item.Caption := ExtractFileName(FileNames[Index]);
      if FShowHint then
      begin
        Item.Hint := FileNames[Index];
      end;
      Item.OnClick := OnClick;
      Item.OnAdvancedDrawItem := OnAdvancedDrawItem;
      Item.OnDrawItem := OnDrawItem;
      Item.OnMeasureItem := OnMeasureItem;
    end;
  end;
end;

procedure TvRbwMostRecentlyUsed.RestorePositionPreviousItem(
  const PositionOfPreviousItem: integer);
var
  PriorParentPosition: integer;
  Index: integer;
  ParentItem: TMenuItem;
  AddAsChild: boolean;
begin
  ParentItem := GetParentItem(AddAsChild);
  // Restore the position of PreviousItem.
  if PreviousItem.Visible and (ParentItem <> nil) then
  begin
    if AddAsChild or
      (PositionOfPreviousItem <> ParentItem.IndexOf(PreviousItem)) then
    begin
      PriorParentPosition := 0;
      for Index := 0 to PositionOfPreviousItem do
      begin
        if ParentItem.Items[Index].Visible then
        begin
          Inc(PriorParentPosition);
        end;
      end;
      if AddAsChild then
      begin
        if PriorParentPosition < ParentItem.Count then
        begin
          ParentItem.Remove(PreviousItem);
          ParentItem.Insert(PriorParentPosition, PreviousItem);
        end;
      end
      else
      begin
        ParentItem.Remove(PreviousItem);
        ParentItem.Insert(PriorParentPosition-1, PreviousItem);
      end;
    end;
  end;
end;

procedure TvRbwMostRecentlyUsed.UpDateMenu;
var
  Index: integer;
  PriorPosition: integer;
  ParentItem: TMenuItem;
  AddAsChild: Boolean;
  PositionOfPreviousItem: integer;
begin
  if ([csLoading, csReading] * ComponentState) <> [] then
  begin
    Exit;
  end;

  // Remove all the previously created menu items.
  FMenuItems.Clear;
  if (PreviousItem <> nil) then
  begin

    // Get the TMenuItem that is the parent of PreviousItem
    // and modify AddAsChild.
    ParentItem := GetParentItem(AddAsChild);

    if ParentItem = nil then
    begin
      PositionOfPreviousItem := 0;
    end
    else
    begin
      PositionOfPreviousItem := ParentItem.IndexOf(PreviousItem);
    end;

    PriorPosition := 0;
    // Get position to add sibling.
    if not AddAsChild then
    begin
      for Index := 0 to PositionOfPreviousItem do
      begin
        Assert(ParentItem <> nil);
        if ParentItem.Items[Index].Visible then
        begin
          Inc(PriorPosition);
        end;
      end;
    end;

    CreateMenuItems(PriorPosition);

    RestorePositionPreviousItem(PositionOfPreviousItem);
  end;
end;

procedure TvRbwMostRecentlyUsed.SetShowHint(const Value: boolean);
var
  Index: integer;
  MenuItem: TRecentFileMenuItem;
begin
  if FShowHint <> Value then
  begin
    FShowHint := Value;
    for Index := 0 to FMenuItems.Count -1 do
    begin
      MenuItem := FMenuItems[Index] as TRecentFileMenuItem;
      if FShowHint then
      begin
        MenuItem.Hint := MenuItem.FileName;
      end
      else
      begin
        MenuItem.Hint := '';
      end;
    end;
  end;
end;

{ TRecentFileMenuItem }

destructor TRecentFileMenuItem.Destroy;
var
  RbwMostRecentlyUsed: TvRbwMostRecentlyUsed;
begin
  RbwMostRecentlyUsed := Owner as TvRbwMostRecentlyUsed;
  RbwMostRecentlyUsed.FMenuItems.Extract(self);
  inherited;
end;

procedure Register;
begin
  RegisterComponents('RBW', [TvRbwMostRecentlyUsed]);
end;


end.
