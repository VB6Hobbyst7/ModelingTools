unit frameScreenObjectTabbedUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, frameScreenObjectUnit, Vcl.Grids,
  RbwDataGrid4, Vcl.StdCtrls, ArgusDataEntry, Vcl.Buttons, Vcl.Mask, JvExMask,
  JvSpin, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TframeScreenObjectTabbed = class(TframeScreenObject)
    pcMain: TPageControl;
    tabTransient: TTabSheet;
    pnlBottom: TPanel;
    lblNumTimes: TLabel;
    seNumberOfTimes: TJvSpinEdit;
    btnDelete: TBitBtn;
    btnInsert: TBitBtn;
    pnlGrid: TPanel;
    pnlEditGrid: TPanel;
    lblFormula: TLabel;
    rdeFormula: TRbwDataEntry;
    rdgModflowBoundary: TRbwDataGrid4;
    procedure seNumberOfTimesChange(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure rdeFormulaChange(Sender: TObject);
    procedure rdgModflowBoundaryBeforeDrawCell(Sender: TObject; ACol,
      ARow: Integer);
    procedure rdgModflowBoundaryColSize(Sender: TObject; ACol,
      PriorWidth: Integer);
  private
    procedure ClearSelectedRow;
    procedure UpdateNumTimes;
    procedure UpdateTransientEditor;
    { Private declarations }
  protected
    function CanEdit(Sender: TObject; ACol, ARow: Integer): Boolean; virtual;
    procedure CanSelectTimeCell(ARow: Integer; ACol: Integer; var CanSelect: Boolean); virtual;
    procedure LayoutMultiRowEditControls; virtual;
  public
    { Public declarations }
  end;

var
  frameScreenObjectTabbed: TframeScreenObjectTabbed;

implementation

uses
  System.Math, frmCustomGoPhastUnit;

{$R *.dfm}

procedure TframeScreenObjectTabbed.btnDeleteClick(Sender: TObject);
begin
  inherited;
  if rdgModflowBoundary.SelectedRow >= rdgModflowBoundary.FixedRows  then
  begin
    if rdgModflowBoundary.RowCount > rdgModflowBoundary.FixedRows + 1 then
    begin
      ClearSelectedRow;
      rdgModflowBoundary.DeleteRow(rdgModflowBoundary.SelectedRow);
      UpdateNumTimes;

    end
    else
    begin
      ClearSelectedRow;
      seNumberOfTimes.AsInteger := seNumberOfTimes.AsInteger -1;
    end;
  end;
end;

procedure TframeScreenObjectTabbed.btnInsertClick(Sender: TObject);
begin
  if rdgModflowBoundary.SelectedRow >= rdgModflowBoundary.FixedRows  then
  begin
    rdgModflowBoundary.InsertRow(rdgModflowBoundary.SelectedRow);
    ClearSelectedRow;
    UpdateNumTimes;
  end;
end;

function TframeScreenObjectTabbed.CanEdit(Sender: TObject; ACol,
  ARow: Integer): Boolean;
begin
  result := True;
end;

procedure TframeScreenObjectTabbed.CanSelectTimeCell(ARow, ACol: Integer;
  var CanSelect: Boolean);
begin
  CanSelect := True;
end;

procedure TframeScreenObjectTabbed.ClearSelectedRow;
var
  ColIndex: Integer;
begin
  for ColIndex := 0 to rdgModflowBoundary.ColCount - 1 do
  begin
    rdgModflowBoundary.Cells[ColIndex, rdgModflowBoundary.SelectedRow] := '';
    rdgModflowBoundary.Checked[ColIndex, rdgModflowBoundary.SelectedRow] := False;
    rdgModflowBoundary.Objects[ColIndex, rdgModflowBoundary.SelectedRow] := nil;
  end;
end;

procedure TframeScreenObjectTabbed.LayoutMultiRowEditControls;
var
  FormulaColumn: Integer;
begin
  inherited;
  if [csLoading, csReading] * ComponentState <> [] then
  begin
    Exit
  end;

  FormulaColumn := Max(FLastTimeColumn+1,rdgModflowBoundary.LeftCol);
  LayoutControls(rdgModflowBoundary, rdeFormula, lblFormula, FormulaColumn);
end;

procedure TframeScreenObjectTabbed.rdeFormulaChange(Sender: TObject);
var
  RowIndex: Integer;
  ColIndex: Integer;
begin
  inherited;
  rdgModflowBoundary.BeginUpdate;
  try
    for RowIndex := rdgModflowBoundary.FixedRows to
      rdgModflowBoundary.RowCount - 1 do
    begin
      for ColIndex := 2 to rdgModflowBoundary.ColCount -1 do
      begin
        if rdgModflowBoundary.IsSelectedCell(ColIndex, RowIndex)
          and CanEdit(rdgModflowBoundary, ColIndex, RowIndex)  then
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
  UpdateTransientEditor;
end;

procedure TframeScreenObjectTabbed.rdgModflowBoundaryBeforeDrawCell(
  Sender: TObject; ACol, ARow: Integer);
var
  CanSelect: Boolean;
begin
  inherited;
  CanSelect := True;
  CanSelectTimeCell(ARow, ACol, CanSelect);
  if not CanSelect then
  begin
    rdgModflowBoundary.Canvas.Brush.Color := clBtnFace;
  end;
end;

procedure TframeScreenObjectTabbed.rdgModflowBoundaryColSize(Sender: TObject;
  ACol, PriorWidth: Integer);
begin
  inherited;
  LayoutMultiRowEditControls;
end;

procedure TframeScreenObjectTabbed.seNumberOfTimesChange(Sender: TObject);
begin
  inherited;
  rdgModflowBoundary.RowCount := Max(2, seNumberOfTimes.AsInteger + 1);
  if seNumberOfTimes.AsInteger = 0 then
  begin
    ClearGrid(rdgModflowBoundary);
  end;
end;

procedure TframeScreenObjectTabbed.UpdateNumTimes;
begin
  if seNumberOfTimes <> nil then
  begin
    seNumberOfTimes.AsInteger := rdgModflowBoundary.RowCount - 1;
  end;
end;

procedure TframeScreenObjectTabbed.UpdateTransientEditor;
var
  TempOptions: TGridOptions;
begin
  TempOptions := rdgModflowBoundary.Options;
  try
    rdgModflowBoundary.Options := [goEditing, goAlwaysShowEditor];
    rdgModflowBoundary.UpdateEditor;
  finally
    rdgModflowBoundary.Options := TempOptions;
  end;
end;

end.
