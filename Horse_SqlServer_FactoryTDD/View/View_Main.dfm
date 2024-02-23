object frmView_Main: TfrmView_Main
  Left = 0
  Top = 0
  Caption = 'Gerenciador de Tarefas'
  ClientHeight = 423
  ClientWidth = 721
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 360
    Width = 721
    Height = 63
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      721
      63)
    object btnGET: TButton
      Left = 9
      Top = 16
      Width = 150
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Listar Tarefas'
      TabOrder = 0
      OnClick = btnGETClick
    end
    object btnDELETE: TButton
      Left = 172
      Top = 16
      Width = 150
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Excluir Tarefa'
      TabOrder = 1
      OnClick = btnDELETEClick
    end
    object btnPUT: TButton
      Left = 342
      Top = 16
      Width = 150
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Alterar Status'
      TabOrder = 2
      OnClick = btnPUTClick
    end
    object Button1: TButton
      Left = 540
      Top = 16
      Width = 150
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Estat'#237'stica das Tarefas'
      TabOrder = 3
      OnClick = Button1Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 721
    Height = 154
    Align = alTop
    TabOrder = 1
    DesignSize = (
      721
      154)
    object Label1: TLabel
      Left = 1
      Top = 1
      Width = 719
      Height = 16
      Align = alTop
      Alignment = taCenter
      Caption = 'Cadastro de Tarefas  - Horse - (Marcelo Vidal)'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 300
    end
    object Label2: TLabel
      Left = 5
      Top = 25
      Width = 97
      Height = 13
      Caption = 'Descri'#231#227'o  da tarefa'
    end
    object Label3: TLabel
      Left = 343
      Top = 25
      Width = 117
      Height = 13
      Caption = 'Respons'#225'vel pela tarefa'
    end
    object Label4: TLabel
      Left = 427
      Top = 53
      Width = 31
      Height = 13
      Caption = 'Status'
    end
    object Label5: TLabel
      Left = 54
      Top = 53
      Width = 48
      Height = 13
      Caption = 'Prioridade'
    end
    object edtResponsavel: TEdit
      Left = 468
      Top = 22
      Width = 222
      Height = 21
      MaxLength = 30
      TabOrder = 1
    end
    object edtTarefa: TEdit
      Left = 108
      Top = 22
      Width = 228
      Height = 21
      MaxLength = 100
      TabOrder = 0
    end
    object cboPrioridade: TComboBox
      Left = 108
      Top = 49
      Width = 228
      Height = 21
      ItemIndex = 0
      TabOrder = 2
      Text = '1 - '#233' poss'#237'vel esperar'
      Items.Strings = (
        '1 - '#233' poss'#237'vel esperar'
        '2 - pouco urgente '
        '3 - requer aten'#231#227'o em curto prazo, urg'#234'ncia'
        '4 - muito urgente'
        '5 - exige aten'#231#227'o imediata')
    end
    object cboStatus: TComboBox
      Left = 468
      Top = 49
      Width = 222
      Height = 21
      ItemIndex = 0
      TabOrder = 3
      Text = 'A - aberto'
      Items.Strings = (
        'A - aberto'
        'T - em tratamento'
        'F - finalizado')
    end
    object btnPOST: TButton
      Left = 573
      Top = 85
      Width = 114
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Gravar'
      TabOrder = 4
      OnClick = btnPOSTClick
    end
    object btnDesistir: TButton
      Left = 576
      Top = 119
      Width = 114
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Desistir'
      TabOrder = 5
      Visible = False
      OnClick = btnDesistirClick
    end
  end
  object dbgTarefas: TDBGrid
    Left = 0
    Top = 154
    Width = 721
    Height = 206
    Align = alClient
    DataSource = DataSource1
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object MemTable: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 320
    Top = 104
    object MemTableID: TIntegerField
      Alignment = taCenter
      DisplayWidth = 5
      FieldName = 'ID'
    end
    object MemTableNOMETAREFA: TStringField
      DisplayLabel = 'Descri'#231#227'o da Tarefa'
      DisplayWidth = 40
      FieldName = 'NOMETAREFA'
      Size = 100
    end
    object MemTableRESPONSAVEL: TStringField
      DisplayLabel = 'Respons'#225'vel'
      DisplayWidth = 20
      FieldName = 'RESPONSAVEL'
      Size = 30
    end
    object MemTableSTATUS: TStringField
      Alignment = taCenter
      DisplayLabel = 'Stat'
      DisplayWidth = 5
      FieldName = 'STATUS'
      Size = 1
    end
    object MemTableDESCSTATUS: TStringField
      DisplayLabel = 'Status'
      DisplayWidth = 15
      FieldName = 'DESCSTATUS'
      Size = 30
    end
    object MemTablePRIORIDADE: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'Prioridade'
      DisplayWidth = 5
      FieldName = 'PRIORIDADE'
    end
    object MemTableDESCPRIORIDADE: TStringField
      DisplayLabel = 'Prioridade'
      DisplayWidth = 20
      FieldName = 'DESCPRIORIDADE'
      Size = 50
    end
    object MemTableDATASTATUS: TDateField
      DisplayLabel = 'Data Altera'#231#227'o'
      FieldName = 'DATASTATUS'
    end
    object MemTableDATACRIACAO: TDateTimeField
      DisplayLabel = 'Data Cria'#231#227'o'
      FieldName = 'DATACRIACAO'
    end
  end
  object DataSource1: TDataSource
    DataSet = MemTable
    Left = 384
    Top = 120
  end
  object memTableEstatistica: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 408
    Top = 184
    object memTableEstatisticaPRIORIDADE: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'Prioridade'
      FieldName = 'PRIORIDADE'
    end
    object memTableEstatisticaDESCRICAOPRIORIDADE: TStringField
      DisplayLabel = 'Descri'#231#227'o'
      DisplayWidth = 40
      FieldName = 'DESCRICAOPRIORIDADE'
      Size = 50
    end
    object memTableEstatisticaNUMEROTOTALTAREFAS: TIntegerField
      DisplayLabel = 'Total de Tarefas'
      FieldName = 'NUMEROTOTALTAREFAS'
      Visible = False
    end
    object memTableEstatisticaTOTALTAREFASPENDENTES: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'Tarefas Pendentes'
      FieldName = 'TOTALTAREFASPENDENTES'
      Visible = False
    end
    object memTableEstatisticaTOTALTAREFASCONCLUIDAS: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'Tarefas Concluidas'
      FieldName = 'TOTALTAREFASCONCLUIDAS'
      Visible = False
    end
    object memTableEstatisticaPENDENTEPOPRIORIDADE: TIntegerField
      Alignment = taCenter
      DisplayLabel = 'Pendentes por Prioridade'
      FieldName = 'PENDENTEPOPRIORIDADE'
    end
    object memTableEstatisticaMEDIAPRIORIDADETAREFASPENDENTES: TStringField
      Alignment = taCenter
      DisplayLabel = 'M'#233'dia por Prioridade das Tarefas pendentes'
      DisplayWidth = 18
      FieldName = 'MEDIAPRIORIDADETAREFASPENDENTES'
      Size = 15
    end
  end
end
