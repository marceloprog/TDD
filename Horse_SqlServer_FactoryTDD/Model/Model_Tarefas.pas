unit Model_Tarefas;

interface

 Uses
  Model_Interfaces;
  
Type

  TTarefa = class(TInterfacedObject, iTarefa)
  private
    { Private declarations }
    FID           : Integer;
    FDATACRIACAO  : TDateTime;
    FNOMETAREFA   : String;
    FRESPONSAVEL  : String;
    FSTATUS       : String;
    FDATASTATUS   : TDateTime;
    FPRIORIDADE   : Integer;
  public
    class function New: iTarefa;
    function SetID(const Value: Integer): iTarefa;
    function SetDATACRIACAO(const Value: TDateTime):iTarefa;
    function SetDATASTATUS(const Value: TDateTime):iTarefa;
    function SetNOMETAREFA(const Value: String):iTarefa;
    function SetPRIORIDADE(const Value: Integer):iTarefa;
    function SetRESPONSAVEL(const Value: String):iTarefa;
    function SetSTATUS(const Value: String):iTarefa;
    function GetID: Integer;
    function GetDATACRIACAO: TDateTime;
    function GetDATASTATUS: TDateTime;
    function GetNOMETAREFA: String;
    function GetPRIORIDADE: Integer;
    function GetRESPONSAVEL: String;
    function GetSTATUS: String;
   {
    property ID           : Integer   read  GetID             write SetID;         
    property DATACRIACAO  : TDateTime read  GetFDATACRIACAO   write SetFDATACRIACAO;
    property NOMETAREFA   : String    read  GetFNOMETAREFA    write SetFNOMETAREFA;
    property RESPONSAVEL  : String    read  GetFRESPONSAVEL   write SetFRESPONSAVEL;
    property STATUS       : String    read  GetFSTATUS        write SetFSTATUS;     
    property DATASTATUS   : TDateTime read  GetFDATASTATUS    write SetFDATASTATUS;
    property PRIORIDADE   : Integer   read  GetFPRIORIDADE    write SetFPRIORIDADE;
    }
  end;
     

implementation

{ TTarefa }

function TTarefa.GetDATACRIACAO: TDateTime;
begin
  Result := FDATACRIACAO;
end;

function TTarefa.GetDATASTATUS: TDateTime;
begin
  Result := FDATASTATUS;
end;

function TTarefa.GetNOMETAREFA: String;
begin
  Result := FNOMETAREFA;
end;

function TTarefa.GetPRIORIDADE: Integer;
begin
  Result := FPRIORIDADE;
end;

function TTarefa.GetRESPONSAVEL: String;
begin
  Result := FRESPONSAVEL;
end;

function TTarefa.GetSTATUS: String;
begin
  Result := FSTATUS;
end;

function TTarefa.GetID: Integer;
begin
  Result := FID ;
end;

class function TTarefa.New: iTarefa;
begin
 Result :=  Self.Create;
end;

function TTarefa.SetDATACRIACAO(const Value: TDateTime): iTarefa;
begin
  Result := Self;
  FDATACRIACAO := Value;
end;

function TTarefa.SetDATASTATUS(const Value: TDateTime): iTarefa;
begin
  Result := Self;
  FDATASTATUS := Value;
end;

function TTarefa.SetNOMETAREFA(const Value: String): iTarefa;
begin
  Result := Self;
  FNOMETAREFA := Value;
end;

function TTarefa.SetPRIORIDADE(const Value: Integer): iTarefa;
begin
  Result := Self;
  FPRIORIDADE := Value;
end;

function TTarefa.SetRESPONSAVEL(const Value: String): iTarefa;
begin
  Result := Self;
  FRESPONSAVEL := Value;
end;

function TTarefa.SetSTATUS(const Value: String): iTarefa;
begin
  Result := Self;
  FSTATUS := Value;
end;

function TTarefa.SetID(const Value: Integer): iTarefa;
begin
  Result := Self;
  FID := Value;
end;

end.


   