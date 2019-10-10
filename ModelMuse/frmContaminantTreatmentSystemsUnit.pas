unit frmContaminantTreatmentSystemsUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmCustomGoPhastUnit, Vcl.ExtCtrls,
  JvExExtCtrls, JvNetscapeSplitter, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons,
  JvExStdCtrls, JvListBox, frameGridUnit, Mt3dCtsSystemUnit;

type
  TCstWellColumns = (cwcStartTime, cwcEndTime, cwcExtractionWells, cwcInjectionWells);
  TCstExternalFlowColumns = (cefcStartTime, cefcEndTime, cstOutflow, cstInflow, cstInflowConc);

  TfrmContaminantTreatmentSystems = class(TfrmCustomGoPhast)
    tvTreatmentSystems: TTreeView;
    splttr1: TJvNetscapeSplitter;
    pnlBottom: TPanel;
    btnHelp: TBitBtn;
    btnCancelBtn: TBitBtn;
    btnOkBtn: TBitBtn;
    btnDeleteObservation: TButton;
    btnAddObservation: TButton;
    pnlMain: TPanel;
    pgcMain: TPageControl;
    tabWells: TTabSheet;
    tabExternalFlows: TTabSheet;
    frameExternalFlows: TframeGrid;
    tabTreatments: TTabSheet;
    pnlTreatmentOptions: TPanel;
    lblTreatmentOption: TLabel;
    comboTreatmentOption: TComboBox;
    pgcTreatments: TPageControl;
    tabDefaultOptions: TTabSheet;
    frameDefaultOptions: TframeGrid;
    tabIndividualWellOptions: TTabSheet;
    splttr2: TJvNetscapeSplitter;
    tvIndividualObjectOptions: TTreeView;
    pnl1: TPanel;
    pnl2: TPanel;
    cbUseDefaultOptions: TCheckBox;
    frameIndividualWellOptions: TframeGrid;
    pnlTop: TPanel;
    edSystemName: TLabeledEdit;
    frameWells: TframeGrid;
    procedure FormCreate(Sender: TObject); override;
    procedure FormDestroy(Sender: TObject); override;
    procedure tvTreatmentSystemsChange(Sender: TObject; Node: TTreeNode);
  private
    FCtsSystemw: TCtsSystemCollection;
    FWellObjects: TStringList;
    FSelectedSystem: TCtsSystem;
    NCOMP: Integer;
    procedure GetData;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmContaminantTreatmentSystems: TfrmContaminantTreatmentSystems;

implementation

uses
  frmGoPhastUnit, ModflowPackageSelectionUnit, PhastModelUnit, ScreenObjectUnit,
  ModflowTimeUnit;

{$R *.dfm}

{ TfrmContaminantTreatmentSystems }


procedure TfrmContaminantTreatmentSystems.FormCreate(Sender: TObject);
begin
  inherited;
  FCtsSystemw := TCtsSystemCollection.Create(nil);
  FWellObjects := TStringList.Create;
end;

procedure TfrmContaminantTreatmentSystems.FormDestroy(Sender: TObject);
begin
  inherited;
  FCtsSystemw.Free;
  FWellObjects.Free;
end;

procedure TfrmContaminantTreatmentSystems.GetData;
var
  WellPackageChoice: TCtsWellPackageChoice;
  LocalModel: TPhastModel;
  ScreenObjectIndex: Integer;
  AScreenObject: TScreenObject;
  SystemIndex: Integer;
  ASystem: TCtsSystem;
  StressPeriods: TModflowStressPeriods;
begin
  LocalModel := frmGoPhast.PhastModel;

  NCOMP := LocalModel.NumberOfMt3dChemComponents;
  frameExternalFlows.Grid.ColCount := NCOMP + 4;

  WellPackageChoice := LocalModel.ModflowPackages.Mt3dCts.WellPackageChoice;

  StressPeriods := LocalModel.ModflowStressPeriods;
  StressPeriods.FillPickListWithStartTimes(frameWells.Grid, 0);
  StressPeriods.FillPickListWithEndTimes(frameWells.Grid, 1);
  StressPeriods.FillPickListWithStartTimes(frameExternalFlows.Grid, 0);
  StressPeriods.FillPickListWithEndTimes(frameExternalFlows.Grid, 1);
  StressPeriods.FillPickListWithStartTimes(frameDefaultOptions.Grid, 0);
  StressPeriods.FillPickListWithEndTimes(frameDefaultOptions.Grid, 1);
  StressPeriods.FillPickListWithStartTimes(frameIndividualWellOptions.Grid, 0);
  StressPeriods.FillPickListWithEndTimes(frameIndividualWellOptions.Grid, 1);

  for ScreenObjectIndex := 0 to LocalModel.ScreenObjectCount - 1 do
  begin
    AScreenObject := LocalModel.ScreenObjects[ScreenObjectIndex];
    if AScreenObject.Deleted then
    begin
      Continue;
    end;
    case WellPackageChoice of
      cwpcMnw2:
        begin
          if (AScreenObject.ModflowMnw2Boundary <> nil)
            and AScreenObject.ModflowMnw2Boundary.Used then
          begin
            FWellObjects.AddObject(AScreenObject.Name, AScreenObject);
          end;
        end;
      cwpcWel:
        begin
          if (AScreenObject.ModflowWellBoundary <> nil)
            and AScreenObject.ModflowWellBoundary.Used then
          begin
            FWellObjects.AddObject(AScreenObject.Name, AScreenObject);
          end;
        end;
      else
        Assert(False);
    end;
  end;
  FWellObjects.Sorted := True;

  FCtsSystemw.Assign(LocalModel.CtsSystems);
  for SystemIndex := 0 to FCtsSystemw.Count - 1 do
  begin
    ASystem := FCtsSystemw[SystemIndex].CtsSystem;
    tvTreatmentSystems.Items.AddObject(nil, ASystem.Name, ASystem);
  end;
end;

procedure TfrmContaminantTreatmentSystems.tvTreatmentSystemsChange(
  Sender: TObject; Node: TTreeNode);
var
  ExtractionIndex: Integer;
  CtsObject: TCtsObjectItem;
  ExternalFlowIndex: Integer;
  ExternalFlowsItem: TCtsExternalFlowsItem;
  CompIndex: Integer;
begin
  inherited;
  if FSelectedSystem <> nil then
  begin
    FSelectedSystem.Name := edSystemName.Text;

    FSelectedSystem.CtsObjects.Count := frameWells.seNumber.AsInteger;
    for ExtractionIndex := 0 to FSelectedSystem.CtsObjects.Count - 1 do
    begin
      FSelectedSystem.CtsObjects[ExtractionIndex] := CtsObject;
      CtsObject.StartTime :=
        frameWells.Grid.RealValue[Ord(cwcStartTime), ExtractionIndex+1];
      CtsObject.EndTime :=
        frameWells.Grid.RealValue[Ord(cwcEndTime), ExtractionIndex+1];
      CtsObject.ExtractionWellObjects.DelimitedText :=
        frameWells.Grid.Cells[Ord(cwcExtractionWells), ExtractionIndex+1];
      CtsObject.InjectionWellObjects.DelimitedText :=
        frameWells.Grid.Cells[Ord(cwcInjectionWells), ExtractionIndex+1];
    end;

    FSelectedSystem.ExternalFlows.Count := frameExternalFlows.seNumber.AsInteger;
    for ExternalFlowIndex := 0 to FSelectedSystem.ExternalFlows.Count - 1 do
    begin
      ExternalFlowsItem := FSelectedSystem.ExternalFlows[ExternalFlowIndex];
      ExternalFlowsItem.StartTime :=
        frameWells.Grid.RealValue[Ord(cefcStartTime), ExtractionIndex+1];
      ExternalFlowsItem.EndTime :=
        frameWells.Grid.RealValue[Ord(cefcEndTime), ExtractionIndex+1];
      ExternalFlowsItem.Outflow :=
        frameWells.Grid.Cells[Ord(cstOutflow), ExtractionIndex+1];
      ExternalFlowsItem.Inflow :=
        frameWells.Grid.Cells[Ord(cstInflow), ExtractionIndex+1];
      While ExternalFlowsItem.InflowConcentrations.Count < NCOMP do
      begin
        ExternalFlowsItem.InflowConcentrations.Add.Value := '0';
      end;
      for CompIndex := 0 to NCOMP - 1 do
      begin
        ExternalFlowsItem.InflowConcentrations[CompIndex].Value :=
          frameWells.Grid.Cells[Ord(cstInflow) + CompIndex, ExtractionIndex+1];
      end;
    end;
  end;
  if Node <> nil then
  begin
    FSelectedSystem := Node.Data;
  end
  else
  begin
    FSelectedSystem := nil;
  end;
  if FSelectedSystem <> nil then
  begin
    edSystemName.Text := FSelectedSystem.Name;

    frameWells.seNumber.AsInteger := FSelectedSystem.CtsObjects.Count;
    for ExtractionIndex := 0 to FSelectedSystem.CtsObjects.Count - 1 do
    begin
      CtsObject := FSelectedSystem.CtsObjects[ExtractionIndex];
      frameWells.Grid.RealValue[Ord(cwcStartTime), ExtractionIndex+1] :=
        CtsObject.StartTime;
      frameWells.Grid.RealValue[Ord(cwcEndTime), ExtractionIndex+1] :=
        CtsObject.EndTime;
      frameWells.Grid.Cells[Ord(cwcExtractionWells), ExtractionIndex+1] :=
        CtsObject.ExtractionWellObjects.DelimitedText;
      frameWells.Grid.Cells[Ord(cwcInjectionWells), ExtractionIndex+1] :=
        CtsObject.InjectionWellObjects.DelimitedText;
    end;

    frameExternalFlows.seNumber.AsInteger := FSelectedSystem.ExternalFlows.Count;
    for ExternalFlowIndex := 0 to FSelectedSystem.ExternalFlows.Count - 1 do
    begin
      ExternalFlowsItem := FSelectedSystem.ExternalFlows[ExternalFlowIndex];
      frameWells.Grid.RealValue[Ord(cefcStartTime), ExtractionIndex+1] :=
        ExternalFlowsItem.StartTime;
      frameWells.Grid.RealValue[Ord(cefcEndTime), ExtractionIndex+1] :=
        ExternalFlowsItem.EndTime;
      frameWells.Grid.Cells[Ord(cstOutflow), ExtractionIndex+1] :=
        ExternalFlowsItem.Outflow;
      frameWells.Grid.Cells[Ord(cstInflow), ExtractionIndex+1] :=
        ExternalFlowsItem.Inflow;
      While ExternalFlowsItem.InflowConcentrations.Count < NCOMP do
      begin
        ExternalFlowsItem.InflowConcentrations.Add.Value := '0';
      end;
      for CompIndex := 0 to NCOMP - 1 do
      begin
        frameWells.Grid.Cells[Ord(cstInflow) + CompIndex, ExtractionIndex+1] :=
          ExternalFlowsItem.InflowConcentrations[CompIndex].Value;
      end;
    end;
  end;
end;

end.
