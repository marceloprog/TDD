program ClientTarefas;

uses
  Vcl.Forms,
  View_Main in 'View\View_Main.pas' {frmView_Main},
  Funcoes in 'Utils\Funcoes.pas',
  View_Estatistica in 'View\View_Estatistica.pas' {frmView_Estatistica};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmView_Main, frmView_Main);
  Application.Run;
end.
