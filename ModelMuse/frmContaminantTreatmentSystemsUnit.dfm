inherited frmContaminantTreatmentSystems: TfrmContaminantTreatmentSystems
  Caption = 'Contaminant Treatment Systems'
  ClientHeight = 395
  ClientWidth = 753
  ExplicitLeft = -59
  ExplicitWidth = 769
  ExplicitHeight = 434
  PixelsPerInch = 96
  TextHeight = 18
  object splttr1: TJvNetscapeSplitter
    Left = 121
    Top = 0
    Height = 354
    Align = alLeft
    MinSize = 1
    Maximized = False
    Minimized = False
    ButtonCursor = crDefault
    ExplicitTop = -124
    ExplicitHeight = 350
  end
  object tvTreatmentSystems: TTreeView
    Left = 0
    Top = 0
    Width = 121
    Height = 354
    Align = alLeft
    HideSelection = False
    Indent = 19
    TabOrder = 0
    OnChange = tvTreatmentSystemsChange
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 354
    Width = 753
    Height = 41
    Align = alBottom
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    ExplicitWidth = 728
    DesignSize = (
      753
      41)
    object btnHelp: TBitBtn
      Left = 472
      Top = 6
      Width = 87
      Height = 27
      Anchors = [akRight, akBottom]
      Kind = bkHelp
      NumGlyphs = 2
      TabOrder = 2
      OnClick = btnHelpClick
      ExplicitLeft = 447
    end
    object btnCancelBtn: TBitBtn
      Left = 658
      Top = 6
      Width = 87
      Height = 27
      Anchors = [akRight, akBottom]
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 4
      ExplicitLeft = 633
    end
    object btnOkBtn: TBitBtn
      Left = 565
      Top = 6
      Width = 87
      Height = 27
      Anchors = [akRight, akBottom]
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 3
      OnClick = btnOkBtnClick
      ExplicitLeft = 540
    end
    object btnDeleteSystem: TButton
      Left = 88
      Top = 6
      Width = 77
      Height = 27
      Anchors = [akLeft, akBottom]
      Caption = 'Delete'
      Enabled = False
      TabOrder = 1
      OnClick = btnDeleteSystemClick
    end
    object btnAddSystem: TButton
      Left = 5
      Top = 6
      Width = 77
      Height = 27
      Anchors = [akLeft, akBottom]
      Caption = 'Add'
      TabOrder = 0
      OnClick = btnAddSystemClick
    end
  end
  object pnlMain: TPanel
    Left = 131
    Top = 0
    Width = 622
    Height = 354
    Align = alClient
    Caption = 'pnlMain'
    ParentShowHint = False
    ShowHint = False
    TabOrder = 2
    ExplicitWidth = 597
    object pcMain: TPageControl
      Left = 1
      Top = 42
      Width = 620
      Height = 311
      Margins.Left = 0
      Margins.Top = 60
      Margins.Right = 0
      Margins.Bottom = 0
      ActivePage = tabIndividualWellOptions
      Align = alClient
      Enabled = False
      ParentShowHint = False
      ShowHint = False
      TabOrder = 0
      ExplicitWidth = 595
      object tabWells: TTabSheet
        Caption = 'Wells'
        ParentShowHint = False
        ShowHint = False
        ExplicitWidth = 587
        inline frameWells: TframeGrid
          Left = 0
          Top = 0
          Width = 612
          Height = 278
          Align = alClient
          ParentShowHint = False
          ShowHint = False
          TabOrder = 0
          ExplicitWidth = 587
          ExplicitHeight = 278
          inherited Panel: TPanel
            Top = 237
            Width = 612
            ParentShowHint = False
            ExplicitTop = 237
            ExplicitWidth = 587
            inherited lbNumber: TLabel
              Width = 114
              Height = 18
              Caption = 'Number of times'
              ExplicitWidth = 114
              ExplicitHeight = 18
            end
            inherited sbAdd: TSpeedButton
              Left = 325
              Hint = 
                'Add time period row|Add a time period row at the end of the tabl' +
                'e.'
              ExplicitLeft = 311
            end
            inherited sbInsert: TSpeedButton
              Left = 379
              Hint = 
                'Insert time period row|Insert a time period row above the select' +
                'ed row.'
              ExplicitLeft = 365
            end
            inherited sbDelete: TSpeedButton
              Left = 438
              Hint = 'Delete time period row|Delete the selected time period row'
              ExplicitLeft = 421
            end
            inherited seNumber: TJvSpinEdit
              Height = 26
              ExplicitHeight = 26
            end
          end
          inherited Grid: TRbwDataGrid4
            Width = 612
            Height = 237
            ColCount = 4
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goAlwaysShowEditor]
            OnSetEditText = frameWellsGridSetEditText
            OnButtonClick = frameWellsGridButtonClick
            Columns = <
              item
                AutoAdjustRowHeights = True
                ButtonCaption = '...'
                ButtonFont.Charset = DEFAULT_CHARSET
                ButtonFont.Color = clWindowText
                ButtonFont.Height = -11
                ButtonFont.Name = 'Tahoma'
                ButtonFont.Style = []
                ButtonUsed = False
                ButtonWidth = 20
                CheckMax = False
                CheckMin = False
                ComboUsed = True
                Format = rcf4Real
                LimitToList = False
                MaxLength = 0
                ParentButtonFont = False
                WordWrapCaptions = True
                WordWrapCells = False
                CaseSensitivePicklist = False
                CheckStyle = csCheck
                AutoAdjustColWidths = True
              end
              item
                AutoAdjustRowHeights = True
                ButtonCaption = '...'
                ButtonFont.Charset = DEFAULT_CHARSET
                ButtonFont.Color = clWindowText
                ButtonFont.Height = -11
                ButtonFont.Name = 'Tahoma'
                ButtonFont.Style = []
                ButtonUsed = False
                ButtonWidth = 20
                CheckMax = False
                CheckMin = False
                ComboUsed = True
                Format = rcf4Real
                LimitToList = False
                MaxLength = 0
                ParentButtonFont = False
                WordWrapCaptions = True
                WordWrapCells = False
                CaseSensitivePicklist = False
                CheckStyle = csCheck
                AutoAdjustColWidths = True
              end
              item
                AutoAdjustRowHeights = True
                ButtonCaption = 'Edit'
                ButtonFont.Charset = DEFAULT_CHARSET
                ButtonFont.Color = clWindowText
                ButtonFont.Height = -11
                ButtonFont.Name = 'Tahoma'
                ButtonFont.Style = []
                ButtonUsed = True
                ButtonWidth = 35
                CheckMax = False
                CheckMin = False
                ComboUsed = False
                Format = rcf4String
                LimitToList = False
                MaxLength = 0
                ParentButtonFont = False
                WordWrapCaptions = False
                WordWrapCells = True
                CaseSensitivePicklist = False
                CheckStyle = csCheck
                AutoAdjustColWidths = True
              end
              item
                AutoAdjustRowHeights = False
                ButtonCaption = 'Edit'
                ButtonFont.Charset = DEFAULT_CHARSET
                ButtonFont.Color = clWindowText
                ButtonFont.Height = -11
                ButtonFont.Name = 'Tahoma'
                ButtonFont.Style = []
                ButtonUsed = True
                ButtonWidth = 35
                CheckMax = False
                CheckMin = False
                ComboUsed = False
                Format = rcf4String
                LimitToList = False
                MaxLength = 0
                ParentButtonFont = False
                WordWrapCaptions = False
                WordWrapCells = True
                CaseSensitivePicklist = False
                CheckStyle = csCheck
                AutoAdjustColWidths = True
              end>
            ExplicitWidth = 587
            ExplicitHeight = 237
          end
        end
      end
      object tabTreatments: TTabSheet
        Caption = 'Treatments'
        ImageIndex = 3
        ExplicitWidth = 587
        object pnlTreatmentOptions: TPanel
          Left = 0
          Top = 0
          Width = 612
          Height = 41
          Align = alTop
          TabOrder = 0
          ExplicitWidth = 587
          object lblTreatmentLevel: TLabel
            Left = 263
            Top = 17
            Width = 178
            Height = 18
            Caption = 'Treatment Level (ITRTINJ)'
          end
          object comboTreatmentLevel: TComboBox
            Left = 1
            Top = 9
            Width = 256
            Height = 26
            Style = csDropDownList
            TabOrder = 0
            OnChange = comboTreatmentLevelChange
            Items.Strings = (
              'No treatment (0)'
              'All wells treated alike (1)'
              'Each wells treated individually (2)')
          end
        end
        inline frameDefaultOptions: TframeGrid
          Left = 0
          Top = 41
          Width = 612
          Height = 237
          Align = alClient
          TabOrder = 1
          ExplicitWidth = 579
          ExplicitHeight = 204
          inherited Panel: TPanel
            Top = 196
            Width = 612
            ExplicitTop = 163
            ExplicitWidth = 579
            inherited lbNumber: TLabel
              Width = 114
              Height = 18
              Caption = 'Number of times'
              ExplicitWidth = 114
              ExplicitHeight = 18
            end
            inherited sbAdd: TSpeedButton
              Left = 320
              Hint = 
                'Add time period row|Add a time period row at the end of the tabl' +
                'e.'
              ExplicitLeft = 304
            end
            inherited sbInsert: TSpeedButton
              Left = 379
              Hint = 
                'Insert time period row|Insert a time period row above the select' +
                'ed row.'
              ExplicitLeft = 360
            end
            inherited sbDelete: TSpeedButton
              Left = 438
              Hint = 'Delete time period row|Delete the selected time period row'
              ExplicitLeft = 416
            end
            inherited seNumber: TJvSpinEdit
              Height = 26
              ExplicitHeight = 26
            end
          end
          inherited Grid: TRbwDataGrid4
            Width = 612
            Height = 196
            ColCount = 4
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goAlwaysShowEditor]
            OnSetEditText = frameDefaultOptionsGridSetEditText
            OnButtonClick = frameExternalFlowsGridButtonClick
            Columns = <
              item
                AutoAdjustRowHeights = True
                ButtonCaption = '...'
                ButtonFont.Charset = DEFAULT_CHARSET
                ButtonFont.Color = clWindowText
                ButtonFont.Height = -11
                ButtonFont.Name = 'Tahoma'
                ButtonFont.Style = []
                ButtonUsed = False
                ButtonWidth = 20
                CheckMax = False
                CheckMin = False
                ComboUsed = True
                Format = rcf4Real
                LimitToList = False
                MaxLength = 0
                ParentButtonFont = False
                WordWrapCaptions = True
                WordWrapCells = False
                CaseSensitivePicklist = False
                CheckStyle = csCheck
                AutoAdjustColWidths = True
              end
              item
                AutoAdjustRowHeights = True
                ButtonCaption = '...'
                ButtonFont.Charset = DEFAULT_CHARSET
                ButtonFont.Color = clWindowText
                ButtonFont.Height = -11
                ButtonFont.Name = 'Tahoma'
                ButtonFont.Style = []
                ButtonUsed = False
                ButtonWidth = 20
                CheckMax = False
                CheckMin = False
                ComboUsed = True
                Format = rcf4Real
                LimitToList = False
                MaxLength = 0
                ParentButtonFont = False
                WordWrapCaptions = True
                WordWrapCells = False
                CaseSensitivePicklist = False
                CheckStyle = csCheck
                AutoAdjustColWidths = True
              end
              item
                AutoAdjustRowHeights = True
                ButtonCaption = '...'
                ButtonFont.Charset = DEFAULT_CHARSET
                ButtonFont.Color = clWindowText
                ButtonFont.Height = -11
                ButtonFont.Name = 'Tahoma'
                ButtonFont.Style = []
                ButtonUsed = False
                ButtonWidth = 20
                CheckMax = False
                CheckMin = False
                ComboUsed = True
                Format = rcf4String
                LimitToList = True
                MaxLength = 0
                ParentButtonFont = False
                PickList.Strings = (
                  'percentage change'
                  'concentration change'
                  'mass change'
                  'specified concentration')
                WordWrapCaptions = True
                WordWrapCells = False
                CaseSensitivePicklist = False
                CheckStyle = csCheck
                AutoAdjustColWidths = True
              end
              item
                AutoAdjustRowHeights = True
                ButtonCaption = 'F()'
                ButtonFont.Charset = DEFAULT_CHARSET
                ButtonFont.Color = clWindowText
                ButtonFont.Height = -11
                ButtonFont.Name = 'Tahoma'
                ButtonFont.Style = []
                ButtonUsed = True
                ButtonWidth = 35
                CheckMax = False
                CheckMin = False
                ComboUsed = False
                Format = rcf4String
                LimitToList = False
                MaxLength = 0
                ParentButtonFont = False
                WordWrapCaptions = True
                WordWrapCells = False
                CaseSensitivePicklist = False
                CheckStyle = csCheck
                AutoAdjustColWidths = True
              end>
            ExplicitWidth = 579
            ExplicitHeight = 163
            ColWidths = (
              64
              64
              183
              64)
          end
        end
      end
      object tabIndividualWellOptions: TTabSheet
        Caption = 'Individual Treatments'
        ImageIndex = 1
        ExplicitWidth = 587
        object splttr2: TJvNetscapeSplitter
          Left = 121
          Top = 0
          Height = 278
          Align = alLeft
          MinSize = 1
          Maximized = False
          Minimized = False
          ButtonCursor = crDefault
          ExplicitLeft = 129
          ExplicitHeight = 247
        end
        object tvIndividualObjectOptions: TTreeView
          Left = 0
          Top = 0
          Width = 121
          Height = 278
          Align = alLeft
          HideSelection = False
          Indent = 19
          TabOrder = 0
          OnChange = tvIndividualObjectOptionsChange
        end
        object pnlInidividualWellOptions: TPanel
          Left = 131
          Top = 0
          Width = 481
          Height = 278
          Align = alClient
          Caption = 'pnlInidividualWellOptions'
          Enabled = False
          TabOrder = 1
          ExplicitWidth = 456
          object pnl2: TPanel
            Left = 1
            Top = 1
            Width = 479
            Height = 41
            Align = alTop
            TabOrder = 0
            ExplicitWidth = 454
            object cbUseDefaultOptions: TCheckBox
              Left = 8
              Top = 8
              Width = 201
              Height = 17
              Caption = 'Use default options'
              TabOrder = 0
              OnClick = cbUseDefaultOptionsClick
            end
          end
          inline frameIndividualWellOptions: TframeGrid
            Left = 1
            Top = 42
            Width = 479
            Height = 235
            Align = alClient
            TabOrder = 1
            ExplicitLeft = 1
            ExplicitTop = 42
            ExplicitWidth = 454
            ExplicitHeight = 235
            inherited Panel: TPanel
              Top = 194
              Width = 479
              ExplicitTop = 194
              ExplicitWidth = 454
              inherited lbNumber: TLabel
                Width = 114
                Height = 18
                Caption = 'Number of times'
                ExplicitWidth = 114
                ExplicitHeight = 18
              end
              inherited sbAdd: TSpeedButton
                Left = 247
                Hint = 
                  'Add time period row|Add a time period row at the end of the tabl' +
                  'e.'
                ExplicitLeft = 304
              end
              inherited sbInsert: TSpeedButton
                Left = 294
                Hint = 
                  'Insert time period row|Insert a time period row above the select' +
                  'ed row.'
                ExplicitLeft = 360
              end
              inherited sbDelete: TSpeedButton
                Left = 341
                Hint = 'Delete time period row|Delete the selected time period row'
                ExplicitLeft = 416
              end
              inherited seNumber: TJvSpinEdit
                Height = 26
                ExplicitHeight = 26
              end
            end
            inherited Grid: TRbwDataGrid4
              Width = 479
              Height = 194
              ColCount = 4
              Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goAlwaysShowEditor]
              OnSetEditText = frameIndividualWellOptionsGridSetEditText
              OnButtonClick = frameExternalFlowsGridButtonClick
              Columns = <
                item
                  AutoAdjustRowHeights = True
                  ButtonCaption = '...'
                  ButtonFont.Charset = DEFAULT_CHARSET
                  ButtonFont.Color = clWindowText
                  ButtonFont.Height = -11
                  ButtonFont.Name = 'Tahoma'
                  ButtonFont.Style = []
                  ButtonUsed = False
                  ButtonWidth = 20
                  CheckMax = False
                  CheckMin = False
                  ComboUsed = True
                  Format = rcf4Real
                  LimitToList = False
                  MaxLength = 0
                  ParentButtonFont = False
                  WordWrapCaptions = True
                  WordWrapCells = False
                  CaseSensitivePicklist = False
                  CheckStyle = csCheck
                  AutoAdjustColWidths = True
                end
                item
                  AutoAdjustRowHeights = True
                  ButtonCaption = '...'
                  ButtonFont.Charset = DEFAULT_CHARSET
                  ButtonFont.Color = clWindowText
                  ButtonFont.Height = -11
                  ButtonFont.Name = 'Tahoma'
                  ButtonFont.Style = []
                  ButtonUsed = False
                  ButtonWidth = 20
                  CheckMax = False
                  CheckMin = False
                  ComboUsed = True
                  Format = rcf4Real
                  LimitToList = False
                  MaxLength = 0
                  ParentButtonFont = False
                  WordWrapCaptions = True
                  WordWrapCells = False
                  CaseSensitivePicklist = False
                  CheckStyle = csCheck
                  AutoAdjustColWidths = True
                end
                item
                  AutoAdjustRowHeights = True
                  ButtonCaption = '...'
                  ButtonFont.Charset = DEFAULT_CHARSET
                  ButtonFont.Color = clWindowText
                  ButtonFont.Height = -11
                  ButtonFont.Name = 'Tahoma'
                  ButtonFont.Style = []
                  ButtonUsed = False
                  ButtonWidth = 20
                  CheckMax = False
                  CheckMin = False
                  ComboUsed = True
                  Format = rcf4String
                  LimitToList = True
                  MaxLength = 0
                  ParentButtonFont = False
                  PickList.Strings = (
                    'percentage change'
                    'concentration change'
                    'mass change'
                    'specified concentration')
                  WordWrapCaptions = True
                  WordWrapCells = False
                  CaseSensitivePicklist = False
                  CheckStyle = csCheck
                  AutoAdjustColWidths = True
                end
                item
                  AutoAdjustRowHeights = True
                  ButtonCaption = 'F()'
                  ButtonFont.Charset = DEFAULT_CHARSET
                  ButtonFont.Color = clWindowText
                  ButtonFont.Height = -11
                  ButtonFont.Name = 'Tahoma'
                  ButtonFont.Style = []
                  ButtonUsed = True
                  ButtonWidth = 35
                  CheckMax = False
                  CheckMin = False
                  ComboUsed = False
                  Format = rcf4String
                  LimitToList = False
                  MaxLength = 0
                  ParentButtonFont = False
                  WordWrapCaptions = True
                  WordWrapCells = False
                  CaseSensitivePicklist = False
                  CheckStyle = csCheck
                  AutoAdjustColWidths = True
                end>
              ExplicitWidth = 454
              ExplicitHeight = 194
              ColWidths = (
                64
                64
                183
                64)
            end
          end
        end
      end
      object tabExternalFlows: TTabSheet
        Caption = 'External Flows'
        ImageIndex = 2
        ExplicitWidth = 587
        inline frameExternalFlows: TframeGrid
          Left = 0
          Top = 0
          Width = 612
          Height = 278
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 587
          ExplicitHeight = 278
          inherited Panel: TPanel
            Top = 237
            Width = 612
            ExplicitTop = 237
            ExplicitWidth = 587
            inherited lbNumber: TLabel
              Width = 114
              Height = 18
              Caption = 'Number of times'
              ExplicitWidth = 114
              ExplicitHeight = 18
            end
            inherited sbAdd: TSpeedButton
              Left = 325
              Hint = 
                'Add time period row|Add a time period row at the end of the tabl' +
                'e.'
              ExplicitLeft = 311
            end
            inherited sbInsert: TSpeedButton
              Left = 380
              Hint = 
                'Insert time period row|Insert a time period row above the select' +
                'ed row.'
              ExplicitLeft = 365
            end
            inherited sbDelete: TSpeedButton
              Left = 438
              Hint = 'Delete time period row|Delete the selected time period row'
              ExplicitLeft = 421
            end
            inherited seNumber: TJvSpinEdit
              Height = 26
              ExplicitHeight = 26
            end
          end
          inherited Grid: TRbwDataGrid4
            Width = 612
            Height = 237
            ColCount = 5
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goAlwaysShowEditor]
            OnSetEditText = frameExternalFlowsGridSetEditText
            OnButtonClick = frameExternalFlowsGridButtonClick
            Columns = <
              item
                AutoAdjustRowHeights = True
                ButtonCaption = '...'
                ButtonFont.Charset = DEFAULT_CHARSET
                ButtonFont.Color = clWindowText
                ButtonFont.Height = -11
                ButtonFont.Name = 'Tahoma'
                ButtonFont.Style = []
                ButtonUsed = False
                ButtonWidth = 20
                CheckMax = False
                CheckMin = False
                ComboUsed = True
                Format = rcf4Real
                LimitToList = False
                MaxLength = 0
                ParentButtonFont = False
                WordWrapCaptions = True
                WordWrapCells = False
                CaseSensitivePicklist = False
                CheckStyle = csCheck
                AutoAdjustColWidths = True
              end
              item
                AutoAdjustRowHeights = True
                ButtonCaption = '...'
                ButtonFont.Charset = DEFAULT_CHARSET
                ButtonFont.Color = clWindowText
                ButtonFont.Height = -11
                ButtonFont.Name = 'Tahoma'
                ButtonFont.Style = []
                ButtonUsed = False
                ButtonWidth = 20
                CheckMax = False
                CheckMin = False
                ComboUsed = True
                Format = rcf4Real
                LimitToList = False
                MaxLength = 0
                ParentButtonFont = False
                WordWrapCaptions = True
                WordWrapCells = False
                CaseSensitivePicklist = False
                CheckStyle = csCheck
                AutoAdjustColWidths = True
              end
              item
                AutoAdjustRowHeights = True
                ButtonCaption = 'F()'
                ButtonFont.Charset = DEFAULT_CHARSET
                ButtonFont.Color = clWindowText
                ButtonFont.Height = -11
                ButtonFont.Name = 'Tahoma'
                ButtonFont.Style = []
                ButtonUsed = True
                ButtonWidth = 35
                CheckMax = False
                CheckMin = False
                ComboUsed = False
                Format = rcf4String
                LimitToList = False
                MaxLength = 0
                ParentButtonFont = False
                WordWrapCaptions = True
                WordWrapCells = False
                CaseSensitivePicklist = False
                CheckStyle = csCheck
                AutoAdjustColWidths = True
              end
              item
                AutoAdjustRowHeights = True
                ButtonCaption = 'F()'
                ButtonFont.Charset = DEFAULT_CHARSET
                ButtonFont.Color = clWindowText
                ButtonFont.Height = -11
                ButtonFont.Name = 'Tahoma'
                ButtonFont.Style = []
                ButtonUsed = True
                ButtonWidth = 35
                CheckMax = False
                CheckMin = False
                ComboUsed = False
                Format = rcf4String
                LimitToList = False
                MaxLength = 0
                ParentButtonFont = False
                WordWrapCaptions = True
                WordWrapCells = False
                CaseSensitivePicklist = False
                CheckStyle = csCheck
                AutoAdjustColWidths = True
              end
              item
                AutoAdjustRowHeights = True
                ButtonCaption = 'F()'
                ButtonFont.Charset = DEFAULT_CHARSET
                ButtonFont.Color = clWindowText
                ButtonFont.Height = -11
                ButtonFont.Name = 'Tahoma'
                ButtonFont.Style = []
                ButtonUsed = True
                ButtonWidth = 35
                CheckMax = False
                CheckMin = False
                ComboUsed = False
                Format = rcf4String
                LimitToList = False
                MaxLength = 0
                ParentButtonFont = False
                WordWrapCaptions = True
                WordWrapCells = False
                CaseSensitivePicklist = False
                CheckStyle = csCheck
                AutoAdjustColWidths = True
              end>
            ExplicitWidth = 587
            ExplicitHeight = 237
          end
        end
      end
      object tabMaximumAllowedConc: TTabSheet
        Caption = 'Max Allowed Concentration'
        ImageIndex = 3
        ExplicitWidth = 587
        inline frameMaxConc: TframeGrid
          Left = 0
          Top = 0
          Width = 612
          Height = 278
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 587
          ExplicitHeight = 278
          inherited Panel: TPanel
            Top = 237
            Width = 612
            ExplicitTop = 237
            ExplicitWidth = 587
            inherited lbNumber: TLabel
              Width = 114
              Height = 18
              Caption = 'Number of times'
              ExplicitWidth = 114
              ExplicitHeight = 18
            end
            inherited sbAdd: TSpeedButton
              Left = 325
              Hint = 
                'Add time period row|Add a time period row at the end of the tabl' +
                'e.'
              ExplicitLeft = 311
            end
            inherited sbInsert: TSpeedButton
              Left = 379
              Hint = 
                'Insert time period row|Insert a time period row above the select' +
                'ed row.'
              ExplicitLeft = 363
            end
            inherited sbDelete: TSpeedButton
              Left = 438
              Hint = 'Delete time period row|Delete the selected time period row'
              ExplicitLeft = 420
            end
            inherited seNumber: TJvSpinEdit
              Height = 26
              ExplicitHeight = 26
            end
          end
          inherited Grid: TRbwDataGrid4
            Width = 612
            Height = 237
            ColCount = 3
            Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing, goAlwaysShowEditor]
            OnSetEditText = frameMaxConcGridSetEditText
            OnButtonClick = frameExternalFlowsGridButtonClick
            Columns = <
              item
                AutoAdjustRowHeights = True
                ButtonCaption = '...'
                ButtonFont.Charset = DEFAULT_CHARSET
                ButtonFont.Color = clWindowText
                ButtonFont.Height = -11
                ButtonFont.Name = 'Tahoma'
                ButtonFont.Style = []
                ButtonUsed = False
                ButtonWidth = 20
                CheckMax = False
                CheckMin = False
                ComboUsed = True
                Format = rcf4Real
                LimitToList = False
                MaxLength = 0
                ParentButtonFont = False
                WordWrapCaptions = True
                WordWrapCells = False
                CaseSensitivePicklist = False
                CheckStyle = csCheck
                AutoAdjustColWidths = True
              end
              item
                AutoAdjustRowHeights = True
                ButtonCaption = '...'
                ButtonFont.Charset = DEFAULT_CHARSET
                ButtonFont.Color = clWindowText
                ButtonFont.Height = -11
                ButtonFont.Name = 'Tahoma'
                ButtonFont.Style = []
                ButtonUsed = False
                ButtonWidth = 20
                CheckMax = False
                CheckMin = False
                ComboUsed = True
                Format = rcf4Real
                LimitToList = False
                MaxLength = 0
                ParentButtonFont = False
                WordWrapCaptions = True
                WordWrapCells = False
                CaseSensitivePicklist = False
                CheckStyle = csCheck
                AutoAdjustColWidths = True
              end
              item
                AutoAdjustRowHeights = True
                ButtonCaption = '...'
                ButtonFont.Charset = DEFAULT_CHARSET
                ButtonFont.Color = clWindowText
                ButtonFont.Height = -11
                ButtonFont.Name = 'Tahoma'
                ButtonFont.Style = []
                ButtonUsed = True
                ButtonWidth = 20
                CheckMax = False
                CheckMin = False
                ComboUsed = False
                Format = rcf4String
                LimitToList = False
                MaxLength = 0
                ParentButtonFont = False
                WordWrapCaptions = True
                WordWrapCells = False
                CaseSensitivePicklist = False
                CheckStyle = csCheck
                AutoAdjustColWidths = True
              end>
            ExplicitWidth = 587
            ExplicitHeight = 237
          end
        end
      end
    end
    object pnlTop: TPanel
      Left = 1
      Top = 1
      Width = 620
      Height = 41
      Align = alTop
      TabOrder = 1
      ExplicitWidth = 595
      object edSystemName: TLabeledEdit
        Left = 5
        Top = 8
        Width = 276
        Height = 26
        EditLabel.Width = 95
        EditLabel.Height = 18
        EditLabel.Caption = 'System name'
        Enabled = False
        LabelPosition = lpRight
        TabOrder = 0
        OnChange = edSystemNameChange
      end
    end
  end
  object rcSystem: TRbwController
    ControlList = <
      item
        Control = edSystemName
      end
      item
        Control = pcMain
      end
      item
        Control = btnDeleteSystem
      end>
    Enabled = False
    Left = 588
    Top = 25
  end
  object rparserThreeDFormulaElements: TRbwParser
    Left = 568
    Top = 248
  end
end
