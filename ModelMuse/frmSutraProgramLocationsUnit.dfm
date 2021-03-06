inherited frmSutraProgramLocations: TfrmSutraProgramLocations
  HelpType = htKeyword
  HelpKeyword = 'SUTRA_Program_Locations_Dialog'
  Caption = 'SUTRA Program Location'
  ClientHeight = 245
  ClientWidth = 992
  ExplicitWidth = 1008
  ExplicitHeight = 284
  PixelsPerInch = 96
  TextHeight = 18
  object htlblSutra22: TJvHTLabel
    Left = 105
    Top = 17
    Width = 835
    Height = 19
    Caption = 
      '<a href="https://www.usgs.gov/software/sutra-a-model-2d-or-3d-sa' +
      'turated-unsaturated-variable-density-ground-water-flow-solute-or' +
      '">https://www.usgs.gov/software/sutra-a-model-2d-or-3d-saturated' +
      '-unsaturated-variable-density-ground-water-flow-solute-or</a>'
    SuperSubScriptRatio = 0.666666666666666600
  end
  object lblSutra22: TLabel
    Left = 16
    Top = 17
    Width = 78
    Height = 18
    Caption = 'SUTRA 2.2'
  end
  object lblTextEditor: TLabel
    Left = 16
    Top = 129
    Width = 71
    Height = 18
    Caption = 'Text editor'
  end
  object htlblSutra3: TJvHTLabel
    Left = 106
    Top = 76
    Width = 835
    Height = 19
    Caption = 
      '<a href="https://www.usgs.gov/software/sutra-a-model-2d-or-3d-sa' +
      'turated-unsaturated-variable-density-ground-water-flow-solute-or' +
      '">https://www.usgs.gov/software/sutra-a-model-2d-or-3d-saturated' +
      '-unsaturated-variable-density-ground-water-flow-solute-or</a>'
    SuperSubScriptRatio = 0.666666666666666600
  end
  object lblSutra3: TLabel
    Left = 16
    Top = 76
    Width = 78
    Height = 18
    Caption = 'SUTRA 3.0'
  end
  object fedSutra22: TJvFilenameEdit
    Left = 16
    Top = 38
    Width = 967
    Height = 26
    Filter = 
      'Executables (*.exe)|*.exe|Batch Files (*.bat)|*.bat|All files (*' +
      '.*)|*.*'
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = ''
    OnChange = fedSutra22Change
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 204
    Width = 992
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DesignSize = (
      992
      41)
    object btnHelp: TBitBtn
      Left = 728
      Top = 6
      Width = 82
      Height = 27
      HelpType = htKeyword
      Anchors = [akTop, akRight]
      Kind = bkHelp
      NumGlyphs = 2
      TabOrder = 0
      OnClick = btnHelpClick
    end
    object btnOK: TBitBtn
      Left = 816
      Top = 6
      Width = 82
      Height = 27
      Anchors = [akTop, akRight]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 1
      OnClick = btnOKClick
    end
    object btnCancel: TBitBtn
      Left = 904
      Top = 6
      Width = 83
      Height = 27
      Anchors = [akTop, akRight]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 2
    end
  end
  object fedTextEditor: TJvFilenameEdit
    Left = 16
    Top = 150
    Width = 967
    Height = 26
    Filter = 
      'Executables (*.exe)|*.exe|Batch Files (*.bat)|*.bat|All files (*' +
      '.*)|*.*'
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = ''
    OnChange = fedTextEditorChange
  end
  object fedSutra30: TJvFilenameEdit
    Left = 16
    Top = 97
    Width = 967
    Height = 26
    Filter = 
      'Executables (*.exe)|*.exe|Batch Files (*.bat)|*.bat|All files (*' +
      '.*)|*.*'
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    Text = ''
    OnChange = fedSutra30Change
  end
end
