inherited framePackageUzfMf6: TframePackageUzfMf6
  Width = 595
  Height = 526
  ExplicitWidth = 595
  ExplicitHeight = 526
  DesignSize = (
    595
    526)
  object lblNumberOfTrailingWaves: TLabel [2]
    Left = 16
    Top = 143
    Width = 185
    Height = 13
    Caption = 'Number of trailing waves (ntrailwaves)'
    Enabled = False
  end
  object lblNumberOfWaveSets: TLabel [3]
    Left = 16
    Top = 190
    Width = 165
    Height = 13
    Caption = 'Number of wave sets (nwavesets)'
    Enabled = False
  end
  inherited memoComments: TMemo
    Width = 564
    Height = 75
    ExplicitWidth = 564
    ExplicitHeight = 75
  end
  object rgEvapotranspiration: TRadioGroup [5]
    Left = 16
    Top = 237
    Width = 564
    Height = 172
    Caption = 'Evapotranspiration (ET)'
    Enabled = False
    Items.Strings = (
      'Don'#39't simulate ET'
      'Simuate ET only in unsaturated zone (SIMULATE_ET)'
      
        'Simulate unsaturated ET and linear saturated ET (SIMULATE_ET and' +
        ' LINEAR_GWET)'
      
        'Simulate unsaturated ET and squared saturated ET (SIMULATE_ET an' +
        'd SQUARE_GWET)')
    TabOrder = 1
    WordWrap = True
    OnClick = rgEvapotranspirationClick
  end
  object rgUnsatEt: TRadioGroup [6]
    Left = 16
    Top = 415
    Width = 564
    Height = 66
    Caption = 'Unsaturated ET method'
    Enabled = False
    Items.Strings = (
      'Calculate based on water content (UNSAT ETWC)'
      'Calculate based on capillary pressure (UNSAT ETAE)')
    TabOrder = 2
  end
  object cbSeepage: TCheckBox [7]
    Left = 323
    Top = 143
    Width = 257
    Height = 36
    Caption = 'Simulate groundwater seepage (SIMULATE_GWSEEP)'
    Enabled = False
    TabOrder = 3
    WordWrap = True
  end
  object cbSaveBudget: TCheckBox [8]
    Left = 323
    Top = 185
    Width = 257
    Height = 46
    Caption = 'Save binary UZF budget file (.uzf_budget)'
    Enabled = False
    TabOrder = 4
    WordWrap = True
  end
  object rdeNumberOfTrailingWaves: TRbwDataEntry [9]
    Left = 16
    Top = 162
    Width = 145
    Height = 22
    Color = clBtnFace
    Enabled = False
    TabOrder = 5
    Text = '7'
    DataType = dtInteger
    Max = 1.000000000000000000
    Min = 1.000000000000000000
    CheckMin = True
    ChangeDisabledColor = True
  end
  object rdeNumberOfWaveSets: TRbwDataEntry [10]
    Left = 16
    Top = 209
    Width = 145
    Height = 22
    Color = clBtnFace
    Enabled = False
    TabOrder = 6
    Text = '40'
    DataType = dtInteger
    Max = 1.000000000000000000
    Min = 1.000000000000000000
    CheckMin = True
    ChangeDisabledColor = True
  end
  object cbPackageConvergence: TCheckBox [11]
    Left = 16
    Top = 487
    Width = 455
    Height = 18
    Caption = 'Write package convergence (PACKAGE_CONVERGENCE)'
    TabOrder = 7
  end
  inherited rcSelectionController: TRbwController
    ControlList = <
      item
        Control = lblComments
      end
      item
        Control = memoComments
      end
      item
        Control = rgEvapotranspiration
      end
      item
        Control = cbSeepage
      end
      item
        Control = cbSaveBudget
      end
      item
        Control = lblNumberOfTrailingWaves
      end
      item
        Control = rdeNumberOfTrailingWaves
      end
      item
        Control = lblNumberOfWaveSets
      end
      item
        Control = rdeNumberOfWaveSets
      end>
    OnEnabledChange = rcSelectionControllerEnabledChange
  end
end
