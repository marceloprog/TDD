unit uDmConnection;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef,
  FireDAC.Phys.ODBCBase, 
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet,
  Vcl.Dialogs,Messages, FireDAC.VCLUI.Wait;

  
type
  TDMConnection = class(TDataModule)
    FDConn: TFDConnection;
    FDPhysMSSQLDriverLink: TFDPhysMSSQLDriverLink;
  private
    { Private declarations }
    procedure Conectar;
    procedure Desconectar;
    function ConfigurarConexao:String;
  public
    { Public declarations }
    constructor create; reintroduce;
    destructor Destroy; reintroduce;
  end; 

implementation
uses
  IniFiles;

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

{ TDMConnection }

procedure TDMConnection.Conectar;
begin
  try
    ConfigurarConexao;
  except on ex:exception do
      Raise Exception.Create(ex.Message);
  end;
  
end;

function TDMConnection.ConfigurarConexao:String;
var
    ArqIni: TIniFile;
    vArquivoIni:String;
    
begin
    try
        try
            vArquivoIni:= GetCurrentDir+'\PARAMETROS.INI';
                 
            // Verifica se INI existe...
            if NOT FileExists(vArquivoIni) then
            begin
                Result := 'Arquivo INI não encontrado: ' + vArquivoIni;
                exit;
            end;

            // Instanciar arquivo INI...
            ArqIni := TIniFile.Create(vArquivoIni);

            // Buscar dados do arquivo fisico...
            FDConn.Params.Values['Database'] := ArqIni.ReadString('BANCO', 'Database', '');
            FDConn.Params.Values['DriverID'] := ArqIni.ReadString('BANCO', 'DriverID', '');
            FDConn.Params.Values['User_name'] := ArqIni.ReadString('BANCO', 'User_name', '');
            FDConn.Params.Values['Password'] := ArqIni.ReadString('BANCO', 'Password', '');
            FDConn.Params.Values['Server'] := ArqIni.ReadString('BANCO', 'Server', '');
            //FDConn.Params.Values['Port'] := ArqIni.ReadString('BANCO', 'Port', '');
            FDConn.connected:=true;
                
            Result := 'OK';
        except on ex:exception do
            Raise Exception.Create('Erro ao configurar banco: ' + ex.Message);
        end;

    finally
        if Assigned(ArqIni) then
            ArqIni.DisposeOf;
    end;
end;

constructor TDMConnection.create;
begin
  inherited Create(nil);
  conectar;

end;

procedure TDMConnection.Desconectar;
begin
  FDConn.Connected:=False;
     
end;

destructor TDMConnection.Destroy;
begin
    inherited;
    Desconectar;
    
end;

end.
