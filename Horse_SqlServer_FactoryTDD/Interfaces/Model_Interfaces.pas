unit Model_Interfaces;

interface
uses Data.DB,
   FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Comp.Client;

 type 
   iTarefa = interface
     ['{56AD2CE1-1AE1-4BFF-8005-4F6794578C41}']
    function SetID(const Value: Integer) : iTarefa;
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
   end;

   iConnection = interface
     ['{3D855E03-D792-4DA9-8410-B11727E2728C}']
     function Conexao : TCustomConnection;
     procedure ConfigurarConexao;
   end;   

   iQuery =  interface
     ['{98D64FCB-92F9-4784-A2A1-C47506829498}']
     procedure Query(const Statement : String ; Params : Array of Variant); overload;
     function Query(const Statement : Variant; Params : Array of Variant):TDataset ; overload;
     function Query(const Statement : String):TDataset; overload;
     function Add(Value: string): iQuery;
     function Clear: iQuery; 
     
   end;

   iTarefaFactory = interface
    ['{80FD506E-81D4-4E8C-96EE-0469A260FF20}']
     function Tarefa : iTarefa;
   end;

   iConnectionFactory = interface
    ['{0015DD61-F37B-468F-8826-669D9F791FFD}']
     function Connection : iConnection;
   end;

   iQueryFactory =  interface
     ['{6C3EA0E4-B351-4417-8D2B-60535DB098F1}']
     function Query : iQuery;
   end;

   
implementation

end.
