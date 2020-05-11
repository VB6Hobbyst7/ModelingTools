unit PestGlobalComparisonScriptWriterUnit;

interface

uses
  CustomModflowWriterUnit, System.SysUtils;

type
  TGlobalComparisonScriptWriter = class(TCustomFileWriter)
  protected
    class function Extension: string; override;
  public
    procedure WriteFile(const AFileName: string);
  end;

implementation

uses
  PestObsUnit, ObservationComparisonsUnit, ScreenObjectUnit, GoPhastTypes,
  frmErrorsAndWarningsUnit, ModelMuseUtilities;

resourcestring
  StrTheObservationComp = 'The observation comparison item "%s" could not be' +
  ' exported. Check that it is defined correctly for this model.';
  StrUnableToExportObs = 'Unable to export observations';

{ TGlobalComparisonScriptWriter }

class function TGlobalComparisonScriptWriter.Extension: string;
begin
  result := '.der_script';
end;

procedure TGlobalComparisonScriptWriter.WriteFile(const AFileName: string);
var
  ScriptFileName: string;
  ComparisonIndex: Integer;
  GloCompItem: TGlobalObsComparisonItem;
  FObsItemDictionary: TObsItemDictionary;
  ObsItem: TCustomObservationItem;
  PriorItem1: TCustomObservationItem;
  PriorItem2: TCustomObservationItem;
  ErrorMessage: string;
  ObservationList: TObservationList;
  ItemIndex: Integer;
  function GetObName(ObjectIndex: Integer; Obs: TCustomObservationItem): string;
  begin
    Result := PrefixedObsName('Der', ObjectIndex, Obs);
  end;
begin
{$IFNDEF PEST}
  Exit;
{$ENDIF}
  frmErrorsAndWarnings.RemoveWarningGroup(Model, StrUnableToExportObs);

  if Model.ModflowGlobalObservationComparisons.Count = 0 then
  begin
    Exit;
  end;

  ScriptFileName := FileName(AFileName);

  ObservationList := TObservationList.Create;
  FObsItemDictionary := TObsItemDictionary.Create;
  try
    Model.FillObsItemList(ObservationList);

    if ObservationList.Count = 0 then
    begin
      Exit;
    end;

    for ItemIndex := 0 to ObservationList.Count - 1 do
    begin
      ObsItem := ObservationList[ItemIndex];
      FObsItemDictionary.Add(ObsItem.GUID, ObsItem);
    end;

    OpenFile(ScriptFileName);
    try

      WriteString('BEGIN DERIVED_OBSERVATIONS');
      NewLine;

      WriteString('  # ');
      WriteString('Global observation comparisons');
      NewLine;

      for ComparisonIndex := 0 to Model.ModflowGlobalObservationComparisons.Count - 1 do
      begin
        GloCompItem := Model.ModflowGlobalObservationComparisons[ComparisonIndex];
        if FObsItemDictionary.TryGetValue(GloCompItem.GUID1, PriorItem1)
          and FObsItemDictionary.TryGetValue(GloCompItem.GUID2, PriorItem2) then
        begin
          WriteString('  DIFFERENCE ');
          WriteString(GetObName(ComparisonIndex, GloCompItem));
          WriteString(' ');
          WriteString(PriorItem1.ExportedName);
          WriteString(' ');
          WriteString(PriorItem2.ExportedName);
          WriteFloat(GloCompItem.ObservedValue);
          WriteFloat(GloCompItem.Weight);
          WriteString(' PRINT');
          NewLine;
        end
        else
        begin
          ErrorMessage := Format(StrTheObservationComp, [GloCompItem.Name]);
          frmErrorsAndWarnings.AddWarning(Model, StrUnableToExportObs, ErrorMessage)
        end;
      end;
      WriteString('END DERIVED_OBSERVATIONS');

    finally
      CloseFile;
    end;
  finally
    FObsItemDictionary.Free;
    ObservationList.Free;
  end;
end;

end.
