unit View_Estatistica;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  Vcl.Grids, Vcl.DBGrids, Vcl.Mask, Vcl.DBCtrls;

type
  TfrmView_Estatistica = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    dbgTarefas: TDBGrid;
    DataSource1: TDataSource;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmView_Estatistica: TfrmView_Estatistica;

implementation
Uses
View_main;

{$R *.dfm}

procedure TfrmView_Estatistica.Button1Click(Sender: TObject);
begin
  Close;
end;

end.
