unit frameScreenObjectLakMf6Unit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frameScreenObjectNoParamUnit,
  Vcl.ComCtrls, Vcl.Grids, RbwDataGrid4, Vcl.StdCtrls, ArgusDataEntry,
  Vcl.Buttons, Vcl.Mask, JvExMask, JvSpin, Vcl.ExtCtrls, UndoItemsScreenObjects,
  frameLakeOutletUnit, System.Generics.Collections, frameGridUnit,
  ScreenObjectUnit, frameFormulaGridUnit, JvToolEdit;

type
  TLakeColumns = (lcStart, lcEnd, lcStatus, lcStage, lcRainfall, lcEvaporation,
    lcRunoff, lcInflow, lcWithdrawal);
	
  TLakeTableColumns = (ltcStage, ltcVolume, ltcSurfaceArea, ltcExchangeArea);

  TframeScreenObjectLakMf6 = class(TframeScreenObjectNoParam)
    pcLake: TPageControl;
    tabLakeTransientProperties: TTabSheet;
    tabLakeTable: TTabSheet;
    frameLakeTable: TframeFormulaGrid;
    tabLakeProperties: TTabSheet;
    lblOutletCount: TLabel;
    cbEmbedded: TCheckBox;
    grpConnectionDirections: TGroupBox;
    cbHorizontal: TCheckBox;
    cbVertical: TCheckBox;
    seOutletCount: TJvSpinEdit;
    lblBottomElev: TLabel;
    edBottomElev: TJvComboEdit;
    edTopElev: TJvComboEdit;
    lblTopElev: TLabel;
    lblLakebedK: TLabel;
    lblLakebedThickness: TLabel;
    edLakebedK: TJvComboEdit;
    edLakebedThickness: TJvComboEdit;
    lblConnLength: TLabel;
    edConnLength: TJvComboEdit;
    edStartingStage: TJvComboEdit;
    lblStartingStage: TLabel;
    procedure seOutletCountEnter(Sender: TObject);
    procedure seOutletCountChange(Sender: TObject);
    procedure rdgModflowBoundarySetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure seNumberOfTimesChange(Sender: TObject);
    procedure rdeFormulaChange(Sender: TObject);
    procedure frameLakeTableGridSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: string);
    procedure cbEmbeddedClick(Sender: TObject);
    procedure cbHorizontalClick(Sender: TObject);
    procedure cbVerticalClick(Sender: TObject);
  private
    FOtherLakes: TStringList;
    FPriorOutletCount: Integer;
    FFrameList: TObjectList<TframeLakeOutlet>;
    FGridCleared: Boolean;
    FOnChange: TNotifyEvent;
    FScreenObject: TScreenObject;
    FGettingData: Boolean;
    procedure InitializeControls;
    procedure SetOnChange(const Value: TNotifyEvent);
    procedure Changed;
    { Private declarations }
  protected
    procedure Loaded; override;
    procedure LayoutMultiRowEditControls; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetData(const List: TScreenObjectEditCollection);
    procedure SetData(List: TScreenObjectEditCollection; SetAll: boolean;
      ClearAll: boolean);
    property OnChange: TNotifyEvent read FOnChange write SetOnChange;
    { Public declarations }
  end;

var
  frameScreenObjectLakMf6: TframeScreenObjectLakMf6;

implementation

uses
  ModflowLakMf6Unit, GoPhastTypes, System.Math,
  frmCustomGoPhastUnit, frmGoPhastUnit;

resourcestring
  StrOutletD = 'Outlet %d';
  StrStatus = 'Status';
  StrStage = 'Stage';
  StrRainfall = 'Rainfall';
  StrEvaporation = 'Evaporation';
  StrRunoff = 'Runoff';
  StrWithdrawal = 'Withdrawal';
  StrVolume = 'Volume';
  StrSurfaceArea = 'Surface area';
  StrExchangeArea = 'Exchange area';
  StrNone = 'none';
  StrInflow = 'Inflow';

const NonOutletTabs = 3;


{$R *.dfm}

{ TframeScreenObjectLakMf6 }

procedure TframeScreenObjectLakMf6.cbEmbeddedClick(Sender: TObject);
begin
  inherited;
  if not FGettingData then
  begin
    cbEmbedded.AllowGrayed := False;

    if cbEmbedded.Checked then
    begin
      if cbHorizontal.Checked then
      begin
        cbVertical.Checked := False
      end
      else if cbVertical.Checked then
      begin
        cbHorizontal.Checked := False
      end;
    end;
  end;
end;

procedure TframeScreenObjectLakMf6.cbHorizontalClick(Sender: TObject);
begin
  inherited;
  if not FGettingData then
  begin
    cbHorizontal.AllowGrayed := False;
    if cbHorizontal.Checked and cbEmbedded.Checked then
    begin
      cbVertical.Checked := False
    end;
  end;
end;

procedure TframeScreenObjectLakMf6.cbVerticalClick(Sender: TObject);
begin
  inherited;
  if not FGettingData then
  begin
    cbVertical.AllowGrayed := False;
    if cbVertical.Checked and cbEmbedded.Checked then
    begin
      cbHorizontal.Checked := False
    end;
  end;
end;

procedure TframeScreenObjectLakMf6.Changed;
begin
  if Assigned(OnChange) and not FGettingData then
  begin
    OnChange(self);
  end;
end;

constructor TframeScreenObjectLakMf6.Create(AOwner: TComponent);
begin
  inherited;
  FFrameList := TObjectList<TframeLakeOutlet>.Create;
end;

destructor TframeScreenObjectLakMf6.Destroy;
begin
  FOtherLakes.Free;
  FFrameList.Free;
  inherited;
end;

procedure TframeScreenObjectLakMf6.frameLakeTableGridSetEditText(
  Sender: TObject; ACol, ARow: Integer; const Value: string);
begin
  inherited;
  Changed;
end;

procedure TframeScreenObjectLakMf6.GetData(
  const List: TScreenObjectEditCollection);
var
  ALake: TLakeMf6;
  OutletIndex: Integer;
  AnOutlet: TLakeOutlet;
  AFrame: TframeLakeOutlet;
  TimeIndex: Integer;
  ALakeItem: TLakeTimeItem;
  FoundFirst: Boolean;
  LakeIndex: Integer;
  FirstLake: TLakeMf6;
  ItemIndex: Integer;
  LakeTableRow: TLakeTableItemMf6;
begin
  FGettingData := True;
  try
    FreeAndNil(FOtherLakes);
    ClearGrid(rdgModflowBoundary);
    ClearGrid(frameLakeTable.Grid);
    ALake := nil;
    FGridCleared := False;
    seOutletCount.Enabled := List.Count = 1;
    if List.Count = 1 then
    begin
      FScreenObject := List[0].ScreenObject;
      ALake := FScreenObject.ModflowLak6;
      if ALake = nil then
      begin
        seOutletCount.AsInteger := 0;
      end
      else
      begin
        seOutletCount.AsInteger := ALake.Outlets.Count;
      end;
      tabLakeTable.TabVisible := True;
      cbEmbedded.AllowGrayed := False;
      cbHorizontal.AllowGrayed := False;
      cbVertical.AllowGrayed := False;
    end
    else
    begin
      seOutletCount.AsInteger := 0;
      tabLakeTable.TabVisible := False;
      FScreenObject := nil;
    end;
    if Assigned(seOutletCount.OnChange) then
    begin
      seOutletCount.OnChange(seOutletCount);
    end;
    if (ALake <> nil) then
    begin
      for OutletIndex := 0 to ALake.Outlets.Count - 1 do
      begin
        AnOutlet := ALake.Outlets[OutletIndex].Outlet;
        AFrame := FFrameList[OutletIndex];
        AFrame.GetData(AnOutlet);
      end;
      frameLakeTable.seNumber.AsInteger := ALake.LakeTable.Count;
      for ItemIndex := 0 to ALake.LakeTable.Count -1 do
      begin
        LakeTableRow := ALake.LakeTable.Items[ItemIndex];
        frameLakeTable.Grid.Cells[Ord(ltcStage), ItemIndex+1] := LakeTableRow.Stage;
        frameLakeTable.Grid.Cells[Ord(ltcVolume), ItemIndex+1] := LakeTableRow.Volume;
        frameLakeTable.Grid.Cells[Ord(ltcSurfaceArea), ItemIndex+1] := LakeTableRow.SurfaceArea;
        frameLakeTable.Grid.Cells[Ord(ltcExchangeArea), ItemIndex+1] := LakeTableRow.ExchangeArea;
        //  TLakeTableColumns = (ltcStage, ltcVolume, ltcSurfaceArea, ltcExchangeAread);
      end;
    end;

    FoundFirst := False;
    FirstLake := nil;
    for LakeIndex := 0 to List.Count - 1 do
    begin
      FScreenObject := List[LakeIndex].ScreenObject;
      ALake := FScreenObject.ModflowLak6;
      if ALake <> nil then
      begin
        if not FoundFirst then
        begin
          seNumberOfTimes.AsInteger := ALake.Values.Count;
          for TimeIndex := 0 to ALake.Values.Count - 1 do
          begin
            ALakeItem := ALake.Values[TimeIndex] as TLakeTimeItem;

            rdgModflowBoundary.RealValue[Ord(lcStart), TimeIndex+1] := ALakeItem.StartTime;
            rdgModflowBoundary.RealValue[Ord(lcEnd), TimeIndex+1] := ALakeItem.EndTime;
            rdgModflowBoundary.ItemIndex[Ord(lcStatus), TimeIndex+1] := Ord(ALakeItem.Status);
            rdgModflowBoundary.Cells[Ord(lcStage), TimeIndex+1] := ALakeItem.Stage;
            rdgModflowBoundary.Cells[Ord(lcRainfall), TimeIndex+1] := ALakeItem.Rainfall;
            rdgModflowBoundary.Cells[Ord(lcEvaporation), TimeIndex+1] := ALakeItem.Evaporation;
            rdgModflowBoundary.Cells[Ord(lcRunoff), TimeIndex+1] := ALakeItem.Runoff;
            rdgModflowBoundary.Cells[Ord(lcInflow), TimeIndex+1] := ALakeItem.Inflow;
            rdgModflowBoundary.Cells[Ord(lcWithdrawal), TimeIndex+1] := ALakeItem.Withdrawal;
          end;

          cbHorizontal.Checked := lctHorizontal in ALake.LakeConnections;
          cbVertical.Checked := lctVertical in ALake.LakeConnections;
          cbEmbedded.Checked := ALake.Embedded;

          edStartingStage.Text := ALake.StartingStage;
          edBottomElev.Text := ALake.BottomElevation;
          edTopElev.Text := ALake.TopElevation;
          edLakebedK.Text := ALake.BedK;
          edLakebedThickness.Text := ALake.BedThickness;
          edConnLength.Text := ALake.ConnectionLength;
//          edConnWidth.Text := ALake.ConnectionWidth;

          FirstLake := ALake;
          FoundFirst := True;
        end
        else
        begin
          if  (cbHorizontal.State <> cbGrayed) and
          (cbHorizontal.Checked <> (lctHorizontal in ALake.LakeConnections)) then
          begin
            cbHorizontal.State := cbGrayed;
          end;

          if  (cbVertical.State <> cbGrayed) and
          (cbVertical.Checked <> (lctVertical in ALake.LakeConnections)) then
          begin
            cbVertical.State := cbGrayed;
          end;

          if  (cbEmbedded.State <> cbGrayed) and
          (cbEmbedded.Checked <> ALake.Embedded) then
          begin
            cbEmbedded.State := cbGrayed;
          end;

          if edStartingStage.Text <> ALake.StartingStage then
          begin
            edStartingStage.Text := '';
          end;
          if edBottomElev.Text <> ALake.BottomElevation then
          begin
            edBottomElev.Text := '';
          end;
          if edTopElev.Text <> ALake.TopElevation then
          begin
            edTopElev.Text := '';
          end;
          if edLakebedK.Text <> ALake.BedK then
          begin
            edLakebedK.Text := '';
          end;
          if edLakebedThickness.Text <> ALake.BedThickness then
          begin
            edLakebedThickness.Text := '';
          end;
          if edConnLength.Text <> ALake.ConnectionLength then
          begin
            edConnLength.Text := '';
          end;
//          if edConnWidth.Text <> ALake.ConnectionWidth then
//          begin
//            edConnWidth.Text := '';
//          end;


          if not ALake.Values.IsSame(FirstLake.Values) then
          begin
            ClearGrid(rdgModflowBoundary);
            seNumberOfTimes.AsInteger := 0;
            if Assigned(seNumberOfTimes.OnChange) then
            begin
              seNumberOfTimes.OnChange(seNumberOfTimes);
            end;
            FGridCleared := True;
  //          Break;
          end;
        end;
      end;
    end;
  finally
    FGettingData := False;
  end;
end;

procedure TframeScreenObjectLakMf6.InitializeControls;
begin
  rdgModflowBoundary.Cells[Ord(lcStart), 0] := StrStartingTime;
  rdgModflowBoundary.Cells[Ord(lcEnd), 0] := StrEndingTime;
  rdgModflowBoundary.Cells[Ord(lcStatus), 0] := StrStatus;
  rdgModflowBoundary.Cells[Ord(lcStage), 0] := StrStage;
  rdgModflowBoundary.Cells[Ord(lcRainfall), 0] := StrRainfall;
  rdgModflowBoundary.Cells[Ord(lcEvaporation), 0] := StrEvaporation;
  rdgModflowBoundary.Cells[Ord(lcRunoff), 0] := StrRunoff;
  rdgModflowBoundary.Cells[Ord(lcInflow), 0] := StrInflow;
  rdgModflowBoundary.Cells[Ord(lcWithdrawal), 0] := StrWithdrawal;

  frameLakeTable.Grid.Cells[Ord(ltcStage), 0] := StrStage;
  frameLakeTable.Grid.Cells[Ord(ltcVolume), 0] := StrVolume;
  frameLakeTable.Grid.Cells[Ord(ltcSurfaceArea), 0] := StrSurfaceArea;
  frameLakeTable.Grid.Cells[Ord(ltcExchangeArea), 0] := StrExchangeArea;
end;

procedure TframeScreenObjectLakMf6.LayoutMultiRowEditControls;
begin
  if [csLoading, csReading] * ComponentState <> [] then
  begin
    Exit
  end;
  LayoutControls(rdgModflowBoundary, rdeFormula, lblFormula,
    Max(Ord(lcStage),rdgModflowBoundary.LeftCol));
end;

procedure TframeScreenObjectLakMf6.Loaded;
begin
  inherited;
  if not (csDesigning in ComponentState) then
  begin
    MoveGridToTabSheet(tabLakeTransientProperties);
//    pnlBottom.Parent := tabLakeTransientProperties;
//    pnlGrid.Parent := tabLakeTransientProperties;
//    pnlGrid.Align := alClient;
    pcLake.ActivePageIndex := 0;
    InitializeControls;
  end;
end;

procedure TframeScreenObjectLakMf6.rdeFormulaChange(Sender: TObject);
var
  ColIndex: Integer;
  RowIndex: Integer;
  TempOptions: TGridOptions;
begin
  rdgModflowBoundary.BeginUpdate;
  try
    for RowIndex := rdgModflowBoundary.FixedRows to
      rdgModflowBoundary.RowCount - 1 do
    begin
      for ColIndex := Ord(lcStage) to rdgModflowBoundary.ColCount - 1 do
      begin
        if rdgModflowBoundary.IsSelectedCell(ColIndex, RowIndex) then
        begin
          rdgModflowBoundary.Cells[ColIndex, RowIndex] := rdeFormula.Text;
          if Assigned(rdgModflowBoundary.OnSetEditText) then
          begin
            rdgModflowBoundary.OnSetEditText(
              rdgModflowBoundary,ColIndex,RowIndex, rdeFormula.Text);
          end;
        end;
      end;
    end;
  finally
    rdgModflowBoundary.EndUpdate;
  end;
  TempOptions := rdgModflowBoundary.Options;
  try
    rdgModflowBoundary.Options := [goEditing, goAlwaysShowEditor];
    rdgModflowBoundary.UpdateEditor;
  finally
    rdgModflowBoundary.Options := TempOptions;
  end;
end;

procedure TframeScreenObjectLakMf6.rdgModflowBoundarySetEditText(
  Sender: TObject; ACol, ARow: Integer; const Value: string);
begin
  inherited;
  Changed;
end;

procedure TframeScreenObjectLakMf6.seNumberOfTimesChange(Sender: TObject);
begin
  inherited;
  Changed;
end;

procedure TframeScreenObjectLakMf6.seOutletCountChange(Sender: TObject);
var
  ATabSheet: TTabSheet;
  OutletFrame: TframeLakeOutlet;
  index: Integer;
  AScreenObject: TScreenObject;
begin
  inherited;
  while FFrameList.Count > seOutletCount.AsInteger do
  begin
    FFrameList.Delete(FFrameList.Count-1);
  end;
  while pcLake.PageCount > seOutletCount.AsInteger + NonOutletTabs do
  begin
    pcLake.Pages[pcLake.PageCount-1].Free;
  end;
  while pcLake.PageCount < seOutletCount.AsInteger + NonOutletTabs do
  begin
    if FOtherLakes = nil then
    begin
      Assert(FScreenObject <> nil);
      FOtherLakes := TStringList.Create;
      FOtherLakes.Add(StrNone);
      for index := 0 to frmGoPhast.PhastModel.ScreenObjectCount - 1 do
      begin
        AScreenObject := frmGoPhast.PhastModel.ScreenObjects[index];
        if (AScreenObject.Name <> FScreenObject.Name)
          and not AScreenObject.Deleted
          and (AScreenObject.ModflowLak6 <> nil)
          and AScreenObject.ModflowLak6.Used then
        begin
          FOtherLakes.AddObject(AScreenObject.Name, AScreenObject);
        end;
      end;
    end;
    ATabSheet := TTabSheet.Create(self);
    ATabSheet.Caption := Format(StrOutletD, [pcLake.PageCount-NonOutletTabs + 1]);
    ATabSheet.PageControl := pcLake;
    OutletFrame := TframeLakeOutlet.Create(nil);
    OutletFrame.GridButtonEvent := rdgModflowBoundary.OnButtonClick;
    OutletFrame.comboOutlet.Items.Assign(FOtherLakes);
    OutletFrame.comboOutlet.ItemIndex := 0;
    FFrameList.Add(OutletFrame);
    OutletFrame.Parent := ATabSheet;
    OutletFrame.Align := alClient;
    OutletFrame.InitializeControls;
    OutletFrame.OnChange := OnChange;
    OutletFrame.FrameLoaded := True;
  end;
end;

procedure TframeScreenObjectLakMf6.seOutletCountEnter(Sender: TObject);
begin
  inherited;
  FPriorOutletCount := seOutletCount.AsInteger;
end;

procedure TframeScreenObjectLakMf6.SetData(List: TScreenObjectEditCollection;
  SetAll, ClearAll: boolean);
var
  ListOfScreenObjects: TList;
  Index: Integer;
  ScreenObject: TScreenObject;
  ALake: TLakeMf6;
  LakeTimes: TLakTimeCollection;
  TimeIndex: Integer;
  StartingTime: Extended;
  EndingTime: Extended;
  ALakeItem: TLakeTimeItem;
  Outlets: TLakeOutlets;
  OutletIndex: Integer;
  AnOutlet: TLakeOutletItem;
  OutletFrame: TframeLakeOutlet;
  TableIndex: Integer;
  TableItem: TLakeTableItemMf6;
  LakeConnections: TLakeConnectionTypes;
begin
  LakeTimes := nil;
  Outlets := nil;
  ListOfScreenObjects := TList.Create;
  try
    Assert(List.Count >= 1);
    for Index := 0 to List.Count - 1 do
    begin
      ListOfScreenObjects.Add(List[Index].ScreenObject);
    end;
    for Index := 0 to ListOfScreenObjects.Count - 1 do
    begin
      ScreenObject := ListOfScreenObjects[Index];
      ALake := ScreenObject.ModflowLak6;
      if ClearAll and (ALake <> nil) then
      begin
        ScreenObject.ModflowLak6 := nil;
        Continue;
      end;
      if (ALake = nil) and SetAll then
      begin
        ScreenObject.CreateLakMf6Boundary;
        ALake := ScreenObject.ModflowLak6;
      end;
      if ALake <> nil then
      begin
        if  (cbHorizontal.State <> cbGrayed) then
        begin
          LakeConnections := ALake.LakeConnections;
          if cbHorizontal.Checked then
          begin
            Include(LakeConnections, lctHorizontal);
          end
          else
          begin
            Exclude(LakeConnections, lctHorizontal);
          end;
          ALake.LakeConnections := LakeConnections;
        end;

        if  (cbVertical.State <> cbGrayed) then
        begin
          LakeConnections := ALake.LakeConnections;
          if cbVertical.Checked then
          begin
            Include(LakeConnections, lctVertical);
          end
          else
          begin
            Exclude(LakeConnections, lctVertical);
          end;
          ALake.LakeConnections := LakeConnections;
        end;

        if  (cbEmbedded.State <> cbGrayed) then
        begin
          ALake.Embedded := cbEmbedded.Checked;
        end;

        if edStartingStage.Text <> '' then
        begin
          ALake.StartingStage := edStartingStage.Text;
        end;
        if edBottomElev.Text <> '' then
        begin
          ALake.BottomElevation := edBottomElev.Text;
        end;
        if edTopElev.Text <> '' then
        begin
          ALake.TopElevation := edTopElev.Text;
        end;
        if edLakebedK.Text <> '' then
        begin
          ALake.BedK := edLakebedK.Text;
        end;
        if edLakebedThickness.Text <> '' then
        begin
          ALake.BedThickness := edLakebedThickness.Text;
        end;
        if edConnLength.Text <> '' then
        begin
          ALake.ConnectionLength := edConnLength.Text;
        end;
//        if edConnWidth.Text <> '' then
//        begin
//          ALake.ConnectionWidth := edConnWidth.Text;
//        end;

        if (LakeTimes = nil) and (seNumberOfTimes.AsInteger > 0) then
        begin
          LakeTimes := TLakTimeCollection.Create(nil, nil, nil);

          for TimeIndex := 0 to seNumberOfTimes.AsInteger - 1 do
          begin
            if TryStrToFloat(rdgModflowBoundary.Cells[Ord(lcStart), TimeIndex+1], StartingTime)
              and TryStrToFloat(rdgModflowBoundary.Cells[Ord(lcEnd), TimeIndex+1], EndingTime) then
            begin
              ALakeItem := LakeTimes.Add as TLakeTimeItem;
              ALakeItem.StartTime := StartingTime;
              ALakeItem.EndTime := EndingTime;
              ALakeItem.Status := TLakeStatus(Max(0,
                rdgModflowBoundary.ItemIndex[Ord(lcStatus), TimeIndex+1]));
              ALakeItem.Stage := rdgModflowBoundary.Cells[Ord(lcStage), TimeIndex+1];
              ALakeItem.Rainfall := rdgModflowBoundary.Cells[Ord(lcRainfall), TimeIndex+1];
              ALakeItem.Evaporation := rdgModflowBoundary.Cells[Ord(lcEvaporation), TimeIndex+1];
              ALakeItem.Runoff := rdgModflowBoundary.Cells[Ord(lcRunoff), TimeIndex+1];
              ALakeItem.Inflow := rdgModflowBoundary.Cells[Ord(lcInflow), TimeIndex+1];
              ALakeItem.Withdrawal := rdgModflowBoundary.Cells[Ord(lcWithdrawal), TimeIndex+1];
            end;
          end;
        end;

        if seOutletCount.AsInteger > 0 then
        begin
          Outlets := TLakeOutlets.Create(nil, nil);
          for OutletIndex := 0 to seOutletCount.asInteger - 1 do
          begin
            AnOutlet := Outlets.Add;
            OutletFrame := FFrameList[OutletIndex];
            OutletFrame.SetData(AnOutlet.Outlet);
          end;
        end;

        if tabLakeTable.TabVisible then
        begin
          ALake.LakeTable.Count := frameLakeTable.seNumber.AsInteger;
          for TableIndex := 0 to ALake.LakeTable.Count -1 do
          begin
            TableItem := ALake.LakeTable.Items[TableIndex];
            TableItem.Stage := frameLakeTable.Grid.Cells[Ord(ltcStage), TableIndex+1];
            TableItem.Volume := frameLakeTable.Grid.Cells[Ord(ltcVolume), TableIndex+1];
            TableItem.SurfaceArea := frameLakeTable.Grid.Cells[Ord(ltcSurfaceArea), TableIndex+1];
            TableItem.ExchangeArea := frameLakeTable.Grid.Cells[Ord(ltcExchangeArea), TableIndex+1];
          end;
        end;

        if LakeTimes <> nil then
        begin
          ALake.Values.Assign(LakeTimes);
        end
        else if not FGridCleared then
        begin
          ALake.Values.Clear;
        end;

        if Outlets <> nil then
        begin
          ALake.Outlets.Assign(Outlets);
        end;
      end;
    end;
  finally
    ListOfScreenObjects.Free;
    LakeTimes.Free;
    Outlets.Free;
  end;
end;

procedure TframeScreenObjectLakMf6.SetOnChange(const Value: TNotifyEvent);
begin
  FOnChange := Value;
end;

end.
