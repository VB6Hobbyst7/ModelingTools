unit frmPestUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frmCustomGoPhastUnit, Vcl.StdCtrls,
  JvPageList, JvExControls, Vcl.ComCtrls, JvExComCtrls, JvPageListTreeView,
  ArgusDataEntry, PestPropertiesUnit, Vcl.Buttons, Vcl.ExtCtrls, UndoItems,
  frameGridUnit, frameAvailableObjectsUnit, PestObsUnit;

type
  TPestObsGroupColumn = (pogcName, pogcUseTarget, pogcTarget, pogcFileName);

  TUndoPestOptions = class(TCustomUndo)
  private
    FOldPestProperties: TPestProperties;
    FNewPestProperties: TPestProperties;
  protected
    function Description: string; override;
    procedure UpdateProperties(PestProperties: TPestProperties);
  public
    constructor Create(var NewPestProperties: TPestProperties);
    destructor Destroy; override;
    procedure DoCommand; override;
    procedure Undo; override;

  end;

  TfrmPEST = class(TfrmCustomGoPhast)
    tvPEST: TJvPageListTreeView;
    plMain: TJvPageList;
    jvspBasic: TJvStandardPage;
    cbPEST: TCheckBox;
    rdePilotPointSpacing: TRbwDataEntry;
    lblPilotPointSpacing: TLabel;
    cbShowPilotPoints: TCheckBox;
    pnlBottom: TPanel;
    btnHelp: TBitBtn;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    comboTemplateCharacter: TComboBox;
    lblTemplateCharacter: TLabel;
    comboFormulaMarker: TComboBox;
    lblFormulaMarker: TLabel;
    jvspControlDataMode: TJvStandardPage;
    cbSaveRestart: TCheckBox;
    lblPestMode: TLabel;
    comboPestMode: TComboBox;
    jvspDimensions: TJvStandardPage;
    rdeMaxCompDim: TRbwDataEntry;
    lblMaxCompDim: TLabel;
    rdeZeroLimit: TRbwDataEntry;
    lblZeroLimit: TLabel;
    jvspInversionControls: TJvStandardPage;
    rdeInitialLambda: TRbwDataEntry;
    lblInitialLambda: TLabel;
    rdeLambdaAdj: TRbwDataEntry;
    comboLambdaAdj: TLabel;
    rdeIterationClosure: TRbwDataEntry;
    lblIterationClosure: TLabel;
    rdeLambdaTermination: TRbwDataEntry;
    lblLambdaTermination: TLabel;
    rdeMaxLambdas: TRbwDataEntry;
    lblMaxLambdas: TLabel;
    rdeJacobianUpdate: TRbwDataEntry;
    lblJacobianUpdate: TLabel;
    cbLamForgive: TCheckBox;
    cbDerForgive: TCheckBox;
    jvspParameterAdjustmentControls: TJvStandardPage;
    rdeMaxRelParamChange: TRbwDataEntry;
    lblMaxRelParamChange: TLabel;
    rdeMaxFacParamChange: TRbwDataEntry;
    lblMaxFacParamChange: TLabel;
    rdeFactorOriginal: TRbwDataEntry;
    lblFactorOriginal: TLabel;
    rdeBoundStick: TRbwDataEntry;
    lblBoundStick: TLabel;
    cbParameterBending: TCheckBox;
    jvspInversionControls2: TJvStandardPage;
    rdeSwitchCriterion: TRbwDataEntry;
    lblSwitchCriterion: TLabel;
    rdeSwitchCount: TRbwDataEntry;
    lblSwitchCount: TLabel;
    rdeSplitSlopeCriterion: TRbwDataEntry;
    lblSplitSlopeCriterion: TLabel;
    comboAutomaticUserIntervation: TComboBox;
    lblAutomaticUserIntervation: TLabel;
    cbSensitivityReuse: TCheckBox;
    cbBoundsScaling: TCheckBox;
    jvspIterationControls: TJvStandardPage;
    rdeMaxIterations: TRbwDataEntry;
    lblMaxIterations: TLabel;
    rdePhiReductionCriterion: TRbwDataEntry;
    lblPhiReductionCriterion: TLabel;
    rdePhiReductionCount: TRbwDataEntry;
    lblPhiReductionCount: TLabel;
    rdeNoReductionCount: TRbwDataEntry;
    lblNoReductionCount: TLabel;
    rdeSmallParameterReduction: TRbwDataEntry;
    rdeSmallParameterReductionCount: TRbwDataEntry;
    lblSmallParameterReduction: TLabel;
    lblrdeSmallParameterReductionCount: TLabel;
    rdePhiStoppingThreshold: TRbwDataEntry;
    lblPhiStoppingThreshold: TLabel;
    cbLastRun: TCheckBox;
    rdeAbandon: TRbwDataEntry;
    lblAbandon: TLabel;
    jvspOutputOptions: TJvStandardPage;
    jvspSingularValueDecomp: TJvStandardPage;
    cbWriteCov: TCheckBox;
    cbWriteCorrCoef: TCheckBox;
    cbWriteEigenvectors: TCheckBox;
    cbWriteResolution: TCheckBox;
    cbWriteJacobian: TCheckBox;
    cbWriteJacobianEveryIteration: TCheckBox;
    cbWriteVerboseRunRecord: TCheckBox;
    cbWriteIntermResidualForEveryIteration: TCheckBox;
    cbSaveParamValuesIteration: TCheckBox;
    cbSaveParamValuesModelRun: TCheckBox;
    splMain: TSplitter;
    comboSvdMode: TComboBox;
    lblSvdMode: TLabel;
    rdeMaxSingularValues: TRbwDataEntry;
    lblMaxSingularValues: TLabel;
    rdeEigenThreshold: TRbwDataEntry;
    lblEigenThreshold: TLabel;
    comboEigenWrite: TComboBox;
    lblEigenWrite: TLabel;
    jvspLqsr: TJvStandardPage;
    cbUseLqsr: TCheckBox;
    rdeMatrixTolerance: TRbwDataEntry;
    lblMatrixTolerance: TLabel;
    rdeRightHandSideTolerance: TRbwDataEntry;
    lblRightHandSideTolerance: TLabel;
    rdeConditionNumberLimit: TRbwDataEntry;
    lblConditionNumberLimit: TLabel;
    rdeMaxLqsrIterations: TRbwDataEntry;
    lblMaxLqsrIterations: TLabel;
    cbWriteLsqrOutput: TCheckBox;
    jvspObservationGroups: TJvStandardPage;
    frameObservationGroups: TframeGrid;
    dlgOpenCovarianceMatrixFile: TOpenDialog;
    jvspObsGroupAssignments: TJvStandardPage;
    frameObsGroupAssignments: TframeAvailableObjects;
    pnlObservations: TPanel;
    comboObsGroup: TComboBox;
    lblObsGroup: TLabel;
    procedure FormCreate(Sender: TObject); override;
    procedure MarkerChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure cbUseLqsrClick(Sender: TObject);
    procedure comboSvdModeChange(Sender: TObject);
    procedure frameObservationGroupsGridSelectCell(Sender: TObject; ACol,
      ARow: Integer; var CanSelect: Boolean);
    procedure frameObservationGroupsGridButtonClick(Sender: TObject; ACol,
      ARow: Integer);
    procedure FormDestroy(Sender: TObject); override;
    procedure plMainChange(Sender: TObject);
    procedure comboObsGroupChange(Sender: TObject);
  private
    FObsList: TObservationList;
    FNewObsList: TObservationObjectList;
    procedure GetData;
    procedure SetData;
    procedure FixObsGroupNames;
    { Private declarations }
  public
//    procedure btnOK1Click(Sender: TObject);

    { Public declarations }
  end;

var
  frmPEST: TfrmPEST;

implementation

uses
  frmGoPhastUnit, GoPhastTypes, RbwDataGrid4, PestObsGroupUnit;

resourcestring
  StrObservationGroupNa = 'Observation Group Name (OBGNME)';
  StrUseGroupTargetGT = 'Use Group Target (GTARG)';
  StrGroupTargetGTARG = 'Group Target (GTARG)';
  StrCovarianceMatrixFi = 'Covariance Matrix File Name (optional) (COVFLE)';

{$R *.dfm}

//procedure TfrmPEST.btnOK1Click(Sender: TObject);
//begin
//  inherited;
//  SetData;
//end;

procedure TfrmPEST.MarkerChange(Sender: TObject);
begin
  inherited;
  if comboTemplateCharacter.Text = comboFormulaMarker.Text then
  begin
    comboTemplateCharacter.Color := clRed;
    comboFormulaMarker.Color := clRed;
    Beep;
  end
  else
  begin
    comboTemplateCharacter.Color := clWindow;
    comboFormulaMarker.Color := clWindow;
  end;
end;

procedure TfrmPEST.plMainChange(Sender: TObject);
var
  Grid: TRbwDataGrid4;
  RowIndex: Integer;
begin
  inherited;
  if plMain.ActivePage = jvspObservationGroups then
  begin
    FixObsGroupNames;
    comboObsGroup.Items.Clear;
    comboObsGroup.Items.Capacity := frameObservationGroups.seNumber.AsInteger;
    Grid := frameObservationGroups.Grid;
    for RowIndex := 1 to frameObservationGroups.seNumber.AsInteger do
    begin
      if Grid.Cells[Ord(pogcName), RowIndex] <> '' then
      begin
        comboObsGroup.Items.AddObject(Grid.Cells[Ord(pogcName), RowIndex],
          Grid.Objects[Ord(pogcName), RowIndex]);
      end;
    end;
  end;
end;

procedure TfrmPEST.btnOKClick(Sender: TObject);
begin
  inherited;
  SetData;

end;

procedure TfrmPEST.cbUseLqsrClick(Sender: TObject);
begin
  inherited;
  if cbUseLqsr.Checked then
  begin
    comboSvdMode.ItemIndex := 0;
  end;
end;

procedure TfrmPEST.comboObsGroupChange(Sender: TObject);
var
  AName: string;
  ObsIndex: Integer;
  AnObs: TCustomObservationItem;
begin
  inherited;
  if comboObsGroup.ItemIndex >= 0 then
  begin
    AName := comboObsGroup.Text;
    frameObsGroupAssignments.lbSrcObjects.Items.BeginUpdate;
    frameObsGroupAssignments.lbDstObjects.Items.BeginUpdate;
    try
      frameObsGroupAssignments.lbSrcObjects.Items.Clear;
      frameObsGroupAssignments.lbDstObjects.Items.Clear;
      for ObsIndex := 0 to FNewObsList.Count - 1 do
      begin
        AnObs := FNewObsList[ObsIndex];
        if AnObs.ObservationGroup = AName then
        begin

        end;
      end;
    finally
      frameObsGroupAssignments.lbDstObjects.Items.EndUpdate;
      frameObsGroupAssignments.lbSrcObjects.Items.EndUpdate;
    end;
  end;
end;

procedure TfrmPEST.comboSvdModeChange(Sender: TObject);
begin
  inherited;
  if comboSvdMode.ItemIndex > 0 then
  begin
    cbUseLqsr.Checked := False;
  end;
end;

procedure TfrmPEST.FormCreate(Sender: TObject);
var
  NewNode: TJvPageIndexNode;
  ControlDataNode: TJvPageIndexNode;
  ObservationNode: TJvPageIndexNode;
begin
  inherited;
  FObsList := TObservationList.Create;
  FNewObsList := TObservationObjectList.Create;

  NewNode := tvPEST.Items.AddChild(
    nil, 'Basic') as TJvPageIndexNode;
  NewNode.PageIndex := jvspBasic.PageIndex;

  ControlDataNode := tvPEST.Items.AddChild(
    nil, 'Control Data') as TJvPageIndexNode;
  ControlDataNode.PageIndex := -1;

  NewNode := tvPEST.Items.AddChild(
    ControlDataNode, 'Mode') as TJvPageIndexNode;
  NewNode.PageIndex := jvspControlDataMode.PageIndex;

  NewNode := tvPEST.Items.AddChild(
    ControlDataNode, 'Dimensions') as TJvPageIndexNode;
  NewNode.PageIndex := jvspDimensions.PageIndex;

  NewNode := tvPEST.Items.AddChild(
    ControlDataNode, 'Inversion Controls 1') as TJvPageIndexNode;
  NewNode.PageIndex := jvspInversionControls.PageIndex;

  NewNode := tvPEST.Items.AddChild(
    ControlDataNode, 'Parameter Adjustment Controls') as TJvPageIndexNode;
  NewNode.PageIndex := jvspParameterAdjustmentControls.PageIndex;

  NewNode := tvPEST.Items.AddChild(
    ControlDataNode, 'Inversion Controls 2') as TJvPageIndexNode;
  NewNode.PageIndex := jvspInversionControls2.PageIndex;

  NewNode := tvPEST.Items.AddChild(
    ControlDataNode, 'Iteration Controls') as TJvPageIndexNode;
  NewNode.PageIndex := jvspIterationControls.PageIndex;

  NewNode := tvPEST.Items.AddChild(
    ControlDataNode, 'Output') as TJvPageIndexNode;
  NewNode.PageIndex := jvspOutputOptions.PageIndex;

  NewNode := tvPEST.Items.AddChild(
    nil, 'Singular Value Decomposition') as TJvPageIndexNode;
  NewNode.PageIndex := jvspSingularValueDecomp.PageIndex;

  NewNode := tvPEST.Items.AddChild(
    nil, 'LQSR') as TJvPageIndexNode;
  NewNode.PageIndex := jvspLqsr.PageIndex;

  ObservationNode := tvPEST.Items.AddChild(
    nil, 'Observations') as TJvPageIndexNode;
  ControlDataNode.PageIndex := -1;

  NewNode := tvPEST.Items.AddChild(
    ObservationNode, 'Observation Groups') as TJvPageIndexNode;
  NewNode.PageIndex := jvspObservationGroups.PageIndex;

  plMain.ActivePageIndex := 0;

  GetData
end;

procedure TfrmPEST.FormDestroy(Sender: TObject);
begin
  inherited;
  FObsList.Free;
  FNewObsList.Free;
end;

procedure TfrmPEST.frameObservationGroupsGridButtonClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  inherited;
  dlgOpenCovarianceMatrixFile.FileName :=
    frameObservationGroups.Grid.Cells[ACol, ARow];
  if dlgOpenCovarianceMatrixFile.Execute then
  begin
    frameObservationGroups.Grid.Cells[ACol, ARow] :=
      dlgOpenCovarianceMatrixFile.FileName;
  end;
end;

procedure TfrmPEST.frameObservationGroupsGridSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  inherited;
  if (ARow > 0) and (ACol = Ord(pogcTarget)) then
  begin
    CanSelect := frameObservationGroups.Grid.Checked[Ord(pogcUseTarget), ARow];
  end;
end;

procedure TfrmPEST.GetData;
var
  PestProperties: TPestProperties;
  PestControlData: TPestControlData;
  SvdProperties: TSingularValueDecompositionProperties;
  LsqrProperties: TLsqrProperties;
  Grid: TRbwDataGrid4;
  ObsGroups: TPestObservationGroups;
  ItemIndex: Integer;
  ObsGroup: TPestObservationGroup;
  index: Integer;
  AnObs: TCustomObservationItem;
  ATempObs: TCustomObservationItem;
begin
  frameObsGroupAssignments.FrameResize(nil);

  PestProperties := frmGoPhast.PhastModel.PestProperties;

  cbPEST.Checked := PestProperties.PestUsed;
  comboTemplateCharacter.ItemIndex :=
    comboTemplateCharacter.Items.IndexOf(PestProperties.TemplateCharacter);

  comboFormulaMarker.ItemIndex :=
    comboFormulaMarker.Items.IndexOf(PestProperties.ExtendedTemplateCharacter);
  cbShowPilotPoints.Checked := PestProperties.ShowPilotPoints;
  rdePilotPointSpacing.RealValue := PestProperties.PilotPointSpacing;

  PestControlData := PestProperties.PestControlData;
  cbSaveRestart.Checked := Boolean(PestControlData.PestRestart);
  comboPestMode.ItemIndex := Ord(PestControlData.PestMode);

  rdeMaxCompDim.IntegerValue := PestControlData.MaxCompressionDimension;
  rdeZeroLimit.RealValue  := PestControlData.ZeroLimit;

  rdeInitialLambda.RealValue  := PestControlData.InitalLambda;
  rdeLambdaAdj.RealValue  := PestControlData.LambdaAdjustmentFactor;
  rdeIterationClosure.RealValue  := PestControlData.PhiRatioSufficient;
  rdeLambdaTermination.RealValue  := PestControlData.PhiReductionLambda;
  rdeMaxLambdas.IntegerValue := PestControlData.NumberOfLambdas;
  rdeJacobianUpdate.IntegerValue := PestControlData.JacobianUpdate;
  cbLamForgive.Checked := Boolean(PestControlData.LambdaForgive);
  cbDerForgive.Checked := Boolean(PestControlData.DerivedForgive);

  rdeMaxRelParamChange.RealValue  := PestControlData.RelativeMaxParamChange;
  rdeMaxFacParamChange.RealValue  := PestControlData.FactorMaxParamChange;
  rdeFactorOriginal.RealValue  := PestControlData.FactorOriginal;
  rdeBoundStick.IntegerValue  := PestControlData.BoundStick;
  cbParameterBending.Checked := Boolean(PestControlData.UpgradeParamVectorBending);

  rdeSwitchCriterion.RealValue := PestControlData.SwitchCriterion;
  rdeSwitchCount.IntegerValue := PestControlData.OptSwitchCount;
  rdeSwitchCriterion.RealValue := PestControlData.SplitSlopeCriterion;
  comboAutomaticUserIntervation.ItemIndex := Ord(PestControlData.AutomaticUserIntervation);
  cbSensitivityReuse.Checked := Boolean(PestControlData.SensitivityReuse);
  cbBoundsScaling.Checked := Boolean(PestControlData.Boundscaling);

  rdeMaxIterations.IntegerValue := PestControlData.MaxIterations;
  rdePhiReductionCriterion.RealValue := PestControlData.SlowConvergenceCriterion;
  rdePhiReductionCount.IntegerValue := PestControlData.SlowConvergenceCountCriterion;
  rdeNoReductionCount.IntegerValue := PestControlData.ConvergenceCountCriterion;
  rdeSmallParameterReduction.RealValue := PestControlData.ParameterChangeConvergenceCriterion;
  rdeSmallParameterReductionCount.IntegerValue := PestControlData.ParameterChangeConvergenceCount;
  rdePhiStoppingThreshold.RealValue := PestControlData.ObjectiveCriterion;
  cbLastRun.Checked := Boolean(PestControlData.MakeFinalRun);
  rdeAbandon.RealValue := PestControlData.PhiAbandon;

  cbWriteCov.Checked := Boolean(PestControlData.WriteCovariance);
  cbWriteCorrCoef.Checked := Boolean(PestControlData.WriteCorrelations);
  cbWriteEigenvectors.Checked := Boolean(PestControlData.WriteEigenVectors);
  cbWriteResolution.Checked := Boolean(PestControlData.SaveResolution);
  cbWriteJacobian.Checked := Boolean(PestControlData.SaveJacobian);
  cbWriteJacobianEveryIteration.Checked := Boolean(PestControlData.SaveJacobianIteration);
  cbWriteVerboseRunRecord.Checked := Boolean(PestControlData.VerboseRecord);
  cbWriteIntermResidualForEveryIteration.Checked := Boolean(PestControlData.SaveInterimResiduals);
  cbSaveParamValuesIteration.Checked := Boolean(PestControlData.SaveParamIteration);
  cbSaveParamValuesModelRun.Checked := Boolean(PestControlData.SaveParamRun);

  SvdProperties := PestProperties.SvdProperties;
  comboSvdMode.ItemIndex := Ord(SvdProperties.Mode);
  rdeMaxSingularValues.IntegerValue := SvdProperties.MaxSingularValues;
  rdeEigenThreshold.RealValue := SvdProperties.EigenThreshold;
  comboEigenWrite.ItemIndex := Ord(SvdProperties.EigenWrite);

  LsqrProperties := PestProperties.LsqrProperties;
  cbUseLqsr.Checked := Boolean(LsqrProperties.Mode);
  rdeMatrixTolerance.RealValue := LsqrProperties.MatrixTolerance;
  rdeRightHandSideTolerance.RealValue := LsqrProperties.RightHandSideTolerance;
  rdeConditionNumberLimit.RealValue := LsqrProperties.ConditionNumberLimit;
  rdeMaxLqsrIterations.IntegerValue := LsqrProperties.MaxIteration;
  cbWriteLsqrOutput.Checked := Boolean(LsqrProperties.LsqrWrite);

  Grid := frameObservationGroups.Grid;
  Grid.BeginUpdate;
  try
    Grid.Cells[Ord(pogcName), 0] := StrObservationGroupNa;
    Grid.Cells[Ord(pogcUseTarget), 0] := StrUseGroupTargetGT;
    Grid.Cells[Ord(pogcTarget), 0] := StrGroupTargetGTARG;
    Grid.Cells[Ord(pogcFileName), 0] := StrCovarianceMatrixFi;

    ObsGroups := PestProperties.ObservationGroups;
    frameObservationGroups.seNumber.AsInteger := ObsGroups.Count;
    for ItemIndex := 0 to ObsGroups.Count - 1 do
    begin
      ObsGroup := ObsGroups[ItemIndex];
      Grid.Objects[Ord(pogcName), ItemIndex+1] := ObsGroup;
      Grid.Cells[Ord(pogcName), ItemIndex+1] := ObsGroup.ObsGroupName;
      Grid.Checked[Ord(pogcUseTarget), ItemIndex+1] := ObsGroup.UseGroupTarget;
      Grid.RealValue[Ord(pogcTarget), ItemIndex+1] :=
        ObsGroup.GroupTarget;
      Grid.Cells[Ord(pogcFileName), ItemIndex+1] :=
        ObsGroup.AbsoluteCorrelationFileName;
    end;

    frmGoPhast.PhastModel.FillObsItemList(FObsList);
    FNewObsList.Capacity := FObsList.Count;
    for index := 0 to FObsList.Count - 1 do
    begin
      AnObs := FObsList[index];
      ATempObs := TCustomObservationItem.Create(nil);
      FNewObsList.Add(ATempObs);
      ATempObs.Assign(AnObs);
    end;

  finally
    Grid.EndUpdate;
  end;


end;

procedure TfrmPEST.SetData;
var
  PestProperties: TPestProperties;
  InvalidateModelEvent: TNotifyEvent;
  PestControlData: TPestControlData;
  SvdProperties: TSingularValueDecompositionProperties;
  LsqrProperties: TLsqrProperties;
  RowIndex: Integer;
  Grid: TRbwDataGrid4;
  ObsGroups: TPestObservationGroups;
  AnObsGroup: TPestObservationGroup;
begin
  InvalidateModelEvent := nil;
  PestProperties := TPestProperties.Create(InvalidateModelEvent);
  try
    PestProperties.PestUsed := cbPEST.Checked;
    if comboTemplateCharacter.Text <> '' then
    begin
      PestProperties.TemplateCharacter := comboTemplateCharacter.Text[1];
    end;
    if comboFormulaMarker.Text <> '' then
    begin
      PestProperties.ExtendedTemplateCharacter := comboFormulaMarker.Text[1];
    end;
    PestProperties.ShowPilotPoints := cbShowPilotPoints.Checked;
    PestProperties.PilotPointSpacing := rdePilotPointSpacing.RealValue;

    PestControlData := PestProperties.PestControlData;
    PestControlData.PestRestart := TPestRestart(cbSaveRestart.Checked);
    PestControlData.PestMode := TPestMode(comboPestMode.ItemIndex);

    if rdeMaxCompDim.Text <> '' then
    begin
      PestControlData.MaxCompressionDimension := rdeMaxCompDim.IntegerValue;
    end;
    if rdeZeroLimit.Text <> '' then
    begin
      PestControlData.ZeroLimit := rdeZeroLimit.RealValue;
    end;


    if rdeInitialLambda.Text <> '' then
    begin
      PestControlData.InitalLambda := rdeInitialLambda.RealValue;
    end;
    if rdeLambdaAdj.Text <> '' then
    begin
      PestControlData.LambdaAdjustmentFactor := rdeLambdaAdj.RealValue;
    end;
    if rdeIterationClosure.Text <> '' then
    begin
      PestControlData.PhiRatioSufficient := rdeIterationClosure.RealValue;
    end;
    if rdeLambdaTermination.Text <> '' then
    begin
      PestControlData.PhiReductionLambda := rdeLambdaTermination.RealValue;
    end;
    if rdeMaxLambdas.Text <> '' then
    begin
      PestControlData.NumberOfLambdas := rdeMaxLambdas.IntegerValue;
    end;
    if rdeJacobianUpdate.Text <> '' then
    begin
      PestControlData.JacobianUpdate := rdeJacobianUpdate.IntegerValue;
    end;
   PestControlData.LambdaForgive := TLambdaForgive(cbLamForgive.Checked);
   PestControlData.DerivedForgive := TDerivedForgive(cbDerForgive.Checked);


    if rdeMaxRelParamChange.Text <> '' then
    begin
      PestControlData.RelativeMaxParamChange :=  rdeMaxRelParamChange.RealValue;
    end;
    if rdeMaxFacParamChange.Text <> '' then
    begin
      PestControlData.FactorMaxParamChange :=  rdeMaxFacParamChange.RealValue;
    end;
    if rdeFactorOriginal.Text <> '' then
    begin
      PestControlData.FactorOriginal :=  rdeFactorOriginal.RealValue;
    end;
    if rdeBoundStick.Text <> '' then
    begin
      PestControlData.BoundStick :=  rdeBoundStick.IntegerValue;
    end;
   PestControlData.UpgradeParamVectorBending :=
     TUpgradeParamVectorBending(cbLamForgive.Checked);

    if rdeSwitchCriterion.Text <> '' then
    begin
      PestControlData.SwitchCriterion := rdeSwitchCriterion.RealValue;
    end;
    if rdeSwitchCount.Text <> '' then
    begin
      PestControlData.OptSwitchCount := rdeSwitchCount.IntegerValue;
    end;
    if rdeSwitchCriterion.Text <> '' then
    begin
      PestControlData.SplitSlopeCriterion := rdeSwitchCriterion.RealValue;
    end;
    PestControlData.AutomaticUserIntervation := TAutomaticUserIntervation(comboAutomaticUserIntervation.ItemIndex);
    PestControlData.SensitivityReuse := TSensitivityReuse(cbSensitivityReuse.Checked);
    PestControlData.Boundscaling := TBoundsScaling(cbBoundsScaling.Checked);

    if rdeMaxIterations.Text <> '' then
    begin
      PestControlData.MaxIterations := rdeMaxIterations.IntegerValue;
    end;
    if rdePhiReductionCriterion.Text <> '' then
    begin
      PestControlData.SlowConvergenceCriterion := rdePhiReductionCriterion.RealValue;
    end;
    if rdePhiReductionCount.Text <> '' then
    begin
      PestControlData.SlowConvergenceCountCriterion := rdePhiReductionCount.IntegerValue;
    end;
    if rdeNoReductionCount.Text <> '' then
    begin
      PestControlData.ConvergenceCountCriterion := rdeNoReductionCount.IntegerValue;
    end;
    if rdeSmallParameterReduction.Text <> '' then
    begin
      PestControlData.ParameterChangeConvergenceCriterion := rdeSmallParameterReduction.RealValue;
    end;
    if rdeSmallParameterReductionCount.Text <> '' then
    begin
      PestControlData.ParameterChangeConvergenceCount := rdeSmallParameterReductionCount.IntegerValue;
    end;
    if rdePhiStoppingThreshold.Text <> '' then
    begin
      PestControlData.ObjectiveCriterion := rdePhiStoppingThreshold.RealValue;
    end;
    PestControlData.MakeFinalRun := TMakeFinalRun(cbLastRun.Checked);
    if rdeAbandon.Text <> '' then
    begin
      PestControlData.PhiAbandon := rdeAbandon.RealValue;
    end;

    PestControlData.WriteCovariance := TWriteMatrix(cbWriteCov.Checked);
    PestControlData.WriteCorrelations := TWriteMatrix(cbWriteCorrCoef.Checked);
    PestControlData.WriteEigenVectors := TWriteMatrix(cbWriteEigenvectors.Checked);
    PestControlData.SaveResolution := TSaveResolution(cbWriteResolution.Checked);
    PestControlData.SaveJacobian := TSaveJacobian(cbWriteJacobian.Checked);
    PestControlData.SaveJacobianIteration :=
      TSaveJacobianIteration(cbWriteJacobianEveryIteration.Checked);
    PestControlData.VerboseRecord := TVerboseRecord(cbWriteVerboseRunRecord.Checked);
    PestControlData.SaveInterimResiduals :=
      TSaveInterimResiduals(cbWriteIntermResidualForEveryIteration.Checked);
    PestControlData.SaveParamIteration :=
      TSaveParamIteration(cbSaveParamValuesIteration.Checked);
    PestControlData.SaveParamRun :=
      TSaveParamRun(cbSaveParamValuesModelRun.Checked);


    SvdProperties := PestProperties.SvdProperties;
    SvdProperties.Mode := TSvdMode(comboSvdMode.ItemIndex);
    if rdeMaxSingularValues.Text <> '' then
    begin
      SvdProperties.MaxSingularValues := rdeMaxSingularValues.IntegerValue;
    end;
    if rdeEigenThreshold.Text <> '' then
    begin
      SvdProperties.EigenThreshold := rdeEigenThreshold.RealValue;
    end;
    SvdProperties.EigenWrite := TEigenWrite(comboEigenWrite.ItemIndex);

    LsqrProperties := PestProperties.LsqrProperties;
    LsqrProperties.Mode := TLsqrMode(cbUseLqsr.Checked);
    if rdeMatrixTolerance.Text <> '' then
    begin
      LsqrProperties.MatrixTolerance := rdeMatrixTolerance.RealValue;
    end;
    if rdeRightHandSideTolerance.Text <> '' then
    begin
      LsqrProperties.RightHandSideTolerance := rdeRightHandSideTolerance.RealValue;
    end;
    if rdeConditionNumberLimit.Text <> '' then
    begin
      LsqrProperties.ConditionNumberLimit := rdeConditionNumberLimit.RealValue;
    end;
    if rdeMaxLqsrIterations.Text <> '' then
    begin
      LsqrProperties.MaxIteration := rdeMaxLqsrIterations.IntegerValue;
    end;
    LsqrProperties.LsqrWrite := TLsqrWrite(cbWriteLsqrOutput.Checked);

    ObsGroups := PestProperties.ObservationGroups;
    Grid := frameObservationGroups.Grid;
    for RowIndex := 1 to frameObservationGroups.seNumber.AsInteger do
    begin
      if Grid.Cells[Ord(pogcName), RowIndex] <> '' then
      begin
        AnObsGroup := ObsGroups.Add;
        AnObsGroup.ObsGroupName := Grid.Cells[Ord(pogcName), RowIndex];
        AnObsGroup.UseGroupTarget := Grid.Checked[Ord(pogcUseTarget), RowIndex];
        AnObsGroup.GroupTarget := Grid.RealValueDefault[Ord(pogcTarget), RowIndex, 0];
        AnObsGroup.AbsoluteCorrelationFileName := Grid.Cells[Ord(pogcFileName), RowIndex];
      end;
    end;

    frmGoPhast.UndoStack.Submit(TUndoPestOptions.Create(PestProperties));
  finally
    PestProperties.Free
  end;

end;

procedure TfrmPEST.FixObsGroupNames;
var
  Grid: TRbwDataGrid4;
  RowIndex: Integer;
  ValidName: string;
begin
  Grid := frameObservationGroups.Grid;
  for RowIndex := 1 to frameObservationGroups.seNumber.AsInteger do
  begin
    if Grid.Cells[Ord(pogcName), RowIndex] <> '' then
    begin
      ValidName := ValidObsGroupName(Grid.Cells[Ord(pogcName), RowIndex]);
      //        comboObsGroup.Items.AddObject(ValidName,
      //          Grid.Objects[Ord(pogcName), RowIndex]);
      if ValidName <> Grid.Cells[Ord(pogcName), RowIndex] then
      begin
        Grid.Cells[Ord(pogcName), RowIndex] := ValidName;
      end;
    end;
  end;
end;

{ TUndoPestOptions }

constructor TUndoPestOptions.Create(var NewPestProperties: TPestProperties);
var
  InvalidateModelEvent: TNotifyEvent;
begin
  InvalidateModelEvent := nil;
  FOldPestProperties := TPestProperties.Create(InvalidateModelEvent);
  FOldPestProperties.Assign(frmGoPhast.PhastModel.PestProperties);
  FNewPestProperties := NewPestProperties;
  NewPestProperties := nil;
end;

function TUndoPestOptions.Description: string;
begin
  result := 'change PEST properties';
end;

destructor TUndoPestOptions.Destroy;
begin
  FOldPestProperties.Free;
  FNewPestProperties.Free;
  inherited;
end;

procedure TUndoPestOptions.DoCommand;
begin
  inherited;
//  frmGoPhast.PhastModel.PestProperties := FNewPestProperties;
  UpdateProperties(FNewPestProperties)
end;

procedure TUndoPestOptions.Undo;
begin
  inherited;
  UpdateProperties(FOldPestProperties)
end;

procedure TUndoPestOptions.UpdateProperties(PestProperties: TPestProperties);
var
  ShouldUpdateView: Boolean;
begin
  ShouldUpdateView := frmGoPhast.PhastModel.PestProperties.ShouldDrawPilotPoints
    <> PestProperties.ShouldDrawPilotPoints;
  if PestProperties.ShouldDrawPilotPoints
    and (PestProperties.PilotPointSpacing
      <> frmGoPhast.PhastModel.PestProperties.PilotPointSpacing) then
  begin
    ShouldUpdateView := True;
  end;
  frmGoPhast.PhastModel.PestProperties := PestProperties;
  if ShouldUpdateView then
  begin
    frmGoPhast.SynchronizeViews(vdTop);
  end;
end;

end.
