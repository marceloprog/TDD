unit UApiTarefasTest;

interface
uses
  DUnitX.TestFramework,
  System.SysUtils,
  IpPeerClient,
  Data.DB,
  Funcoes;

type

  [TestFixture]
  ApiTarefasTest = class(TObject) 
  private
   vPass:String;
   FPathURL :String;
   
    
  public
    [Setup]
    procedure Setup;
    
    [TearDown]
    procedure TearDown;
    // Sample Methods
    // Simple single Test
    [Test]
    procedure TestPassWord;
    
    [Test]
    procedure TestGet;

    [Test]
    procedure InserirTarefa;
    
  end;

implementation
uses
 RestRequest4D, Model_Interfaces,Model_Tarefas, Model_Connection,
  Model_Query, FireDAC.Comp.Client ;
 

procedure ApiTarefasTest.InserirTarefa;
var
   Tarefa : TTarefa;
   FQuery : iQuery;
   FQry : TFDQuery;
   UltimoId : Integer;
   NovoId : Integer;
begin
   Tarefa := TTarefa.create;
   Tarefa.SetNomeTarefa('Teste de Software');
   Tarefa.SetResponsavel('Marcelo Vidal');
   Tarefa.SetStatus('T');
   Tarefa.SetPrioridade(2);

   Fquery := TQuery.New(TConnectionFiredac.New);

   Fqry := TFDQuery(FQuery.Clear.Query('SELECT MAX(ID) AS ID_TAREFA FROM TAREFAS'));

   UltimoId := Fqry.FieldByName('ID_TAREFA').AsInteger; 
   
   FQuery.Clear.Query('insert into tarefas (DATACRIACAO,NOMETAREFA,RESPONSAVEL,STATUS,DATASTATUS,PRIORIDADE) '+
                   'values (CURRENT_TIMESTAMP,:PNOMETAREFA,:PRESPONSAVEL,:PSTATUS,CAST(CURRENT_TIMESTAMP AS DATE),:PPRIORIDADE)',
                   [Tarefa.GetNOMETAREFA,Tarefa.GetRESPONSAVEL,Tarefa.GetSTATUS,Tarefa.GetPRIORIDADE]);

    Fqry := TFDQuery(FQuery.Clear.Query('SELECT MAX(ID) AS ID_TAREFA FROM TAREFAS'));
         
    NovoId := Fqry.FieldByName('ID_TAREFA').AsInteger; 

    Assert.AreEqual(UltimoId, NovoId); //exception
   
    Tarefa.Free;   
    Fqry.Free;
   
end;

procedure ApiTarefasTest.Setup;
begin
 vPass := FormatDateTime('yyyymmdd', Date());
 FPathURL :=  'http://localhost:9000/v1';
  
 end;

procedure ApiTarefasTest.TearDown;
begin
//
end;

procedure ApiTarefasTest.TestPassWord;
begin
 Assert.AreEqual(vPass, getPassword());

 end;

procedure ApiTarefasTest.TestGet;
var
  CodigoRetorno: String;
begin
    CodigoRetorno := TRequest.New.BaseURL(FPathURL+'/tarefas' )
      .BasicAuthentication('tarefa',vPass)
      .Accept('application/json')                      
      .Get.StatusCode.ToString;

 Assert.IsTrue(CodigoRetorno='200','Eron no Get Código => '+CodigoRetorno);

end;

initialization
  TDUnitX.RegisterTestFixture(ApiTarefasTest);
end.
