object frmView_Estatistica: TfrmView_Estatistica
  Left = 0
  Top = 0
  Caption = 'Estatistica de Tarefas'
  ClientHeight = 232
  ClientWidth = 692
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 181
    Width = 692
    Height = 51
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 182
    object Label1: TLabel
      Left = 16
      Top = 5
      Width = 79
      Height = 13
      Caption = 'Total de Tarefas'
    end
    object Label2: TLabel
      Left = 122
      Top = 5
      Width = 91
      Height = 13
      Caption = 'Tarefas Pendentes'
    end
    object Label3: TLabel
      Left = 248
      Top = 5
      Width = 178
      Height = 13
      Caption = 'Tarefas Concluidas nos '#250'ltimos 7 dias'
    end
    object Button1: TButton
      Left = 592
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Fechar'
      TabOrder = 0
      OnClick = Button1Click
    end
    object DBEdit1: TDBEdit
      Left = 16
      Top = 20
      Width = 80
      Height = 21
      TabStop = False
      DataField = 'NUMEROTOTALTAREFAS'
      DataSource = DataSource1
      ReadOnly = True
      TabOrder = 1
    end
    object DBEdit2: TDBEdit
      Left = 126
      Top = 20
      Width = 80
      Height = 21
      TabStop = False
      DataField = 'TOTALTAREFASPENDENTES'
      DataSource = DataSource1
      ReadOnly = True
      TabOrder = 2
    end
    object DBEdit3: TDBEdit
      Left = 283
      Top = 20
      Width = 80
      Height = 21
      TabStop = False
      DataField = 'TOTALTAREFASCONCLUIDAS'
      DataSource = DataSource1
      ReadOnly = True
      TabOrder = 3
    end
  end
  object dbgTarefas: TDBGrid
    Left = 0
    Top = 0
    Width = 692
    Height = 181
    Align = alClient
    DataSource = DataSource1
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object DataSource1: TDataSource
    DataSet = frmView_Main.memTableEstatistica
    Left = 376
    Top = 112
  end
end
