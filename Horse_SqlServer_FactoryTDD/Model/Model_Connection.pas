unit Model_Connection;

interface

uses
  FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.ConsoleUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef,
  FireDAC.Phys.ODBCBase, 
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.VCLUI.Wait,
  Model_Interfaces, System.SysUtils, 
  IniFiles;
  
type

 TConnectionFiredac = class(TInterfacedObject, iConnection)
 private
  FDConn : TFDConnection;
  FArqIni: TIniFile;
  FArquivoIni:String;
     
  constructor Create;
  destructor Destroy ; Override; 
   
 public
  class function New:iConnection;
  function Conexao : TCustomConnection;
  procedure ConfigurarConexao;
              
 end;

implementation

{ TConnectionFiredac }

function TConnectionFiredac.Conexao: TCustomConnection;
begin
 Result := FDConn;
end;

procedure TConnectionFiredac.ConfigurarConexao;
begin
  FArquivoIni:= GetCurrentDir+'\PARAMETROS.INI';
  FarqIni := TIniFile.Create(FArquivoIni);
   
  Self.FDConn.Params.Values['Database'] := FArqIni.ReadString('BANCO', 'Database', '');
  Self.FDConn.Params.Values['DriverID'] := FArqIni.ReadString('BANCO', 'DriverID', '');
  Self.FDConn.Params.Values['User_name'] := FArqIni.ReadString('BANCO', 'User_name', '');
  Self.FDConn.Params.Values['Password'] := FArqIni.ReadString('BANCO', 'Password', '');
  Self.FDConn.Params.Values['Server'] := FArqIni.ReadString('BANCO', 'Server', '');

  FArqIni.DisposeOf;
end;

constructor TConnectionFiredac.Create;
begin
  FDConn := TFDConnection.Create(nil);

  ConfigurarConexao;
  
  try
    FDConn.Connected:=True;
  Except
    raise Exception.create('erro na conexao com a base de dados');

  end;

end;

destructor TConnectionFiredac.Destroy;
begin
  FDConn.disposeof;
  
  inherited;
end;

class function TConnectionFiredac.New: iConnection;
begin
  Result := Self.Create;
end;

end.
