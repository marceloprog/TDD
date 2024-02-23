unit Model_TarefasServices;

interface                                             
   
uses
  System.SysUtils,
  System.JSON, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef,
  FireDAC.VCLUI.Wait, FireDAC.Phys.ODBCBase, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet,
   Model_Tarefas, 
    Model_Connection,
    Model_Query;

type
  TModel_TarefasService = class
  private
    { Private declarations }
    FQry : TFDQuery;

    Con : TConnectionFiredac;
      
  public
    Tarefa : TTarefa;
    constructor Create;
    destructor Destroy; 
  
    { Public declarations }
    function InserirTarefa():TJSONArray;
    function ListarTarefas():TJSONArray;
    function ApagarTarefa():TJSONArray;
    function AlterarStatus():TJSONArray;
    function ListarTarefasEstatistica():TJSONArray;
                       
  end;

implementation
uses
  Funcoes,Dataset.Serialize, Model_Interfaces;

{ TModel_TarefasService }

function TModel_TarefasService.AlterarStatus:TJSONArray;
begin
    Result:=Nil; 
    if TRIM(Tarefa.GetSTATUS)='' then
    begin
        Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"Status informado é invalido"}]'),0 ) as TJSONArray;
        exit;
    end;  
    try

       TQuery.New(TConnectionFiredac.New).Clear
              .Query('update tarefas set DATASTATUS=CAST(CURRENT_TIMESTAMP AS DATE), STATUS=:PSTATUS '+
               ' where id=:ID_TAREFA',[Tarefa.GetSTATUS,Tarefa.GetID]);

        Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"sStatus alterado"}]'),0 ) as TJSONArray;

    except on ex:exception do
        begin
          Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"ErrorStatus: '+ex.Message+'"}]'),0 ) as TJSONArray;
        end;
    end;
end;

function TModel_TarefasService.ApagarTarefa: TJSONArray;
begin
    Result:=Nil; 
    if Tarefa.GetID=0 then
    begin
        Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"ID da tarefa não  informado"}]'),0 ) as TJSONArray;
        exit;
    end;  
    
    try
       TQuery.New(TConnectionFiredac.New).Clear
              .Query('delete from tarefas where id=:ID_TAREFA',[Tarefa.GetID]);

        Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"Registro excluido"}]'),0 ) as TJSONArray;
                
    except on ex:exception do
        begin
          Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"ErrorStatus: '+ex.Message+'"}]'),0 ) as TJSONArray;
        end;
    end;
end;


constructor TModel_TarefasService.Create;
begin
   Tarefa := TTarefa.create;
end;

destructor TModel_TarefasService.Destroy;
begin
  Fqry.DisposeOf;
  Tarefa.DisposeOf;
  Con.DisposeOf;
  
  inherited;
  
end;

function TModel_TarefasService.InserirTarefa():TJSONArray;
var
  FQuery : iQuery;
begin

    Result:=Nil; 
    if trim(Tarefa.GetNOMETAREFA)='' then
    begin
        Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"Dados insuficientes para cadastro"}]'),0 ) as TJSONArray;
        exit;
    end;  
    try

       Fquery := TQuery.New(TConnectionFiredac.New);
       
        FQuery.Clear.Query('insert into tarefas (DATACRIACAO,NOMETAREFA,RESPONSAVEL,STATUS,DATASTATUS,PRIORIDADE) '+
                   'values (CURRENT_TIMESTAMP,:PNOMETAREFA,:PRESPONSAVEL,:PSTATUS,CAST(CURRENT_TIMESTAMP AS DATE),:PPRIORIDADE)',
                   [Tarefa.GetNOMETAREFA,Tarefa.GetRESPONSAVEL,Tarefa.GetSTATUS,Tarefa.GetPRIORIDADE]);
            
       Fqry := TFDQuery(FQuery.Clear.Query('SELECT MAX(ID) AS ID_TAREFA FROM TAREFAS'));
            
        Tarefa.SetID(Fqry.FieldByName('ID_TAREFA').AsInteger);

        Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"Tarefa inserida"}]'),0 ) as TJSONArray;

    except on ex:exception do
        begin
          Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"ErrorStatus: '+ex.Message+'"}]'),0 ) as TJSONArray;
        end;
    end;
end;

function TModel_TarefasService.ListarTarefas: TJSONArray;
begin   
 // ok 
    Result:=nil;
    try
       Fqry:= TFDQuery(TQuery.New(TConnectionFiredac.New)
              .Query('select id,datacriacao,nometarefa,responsavel,status,'+
              'prioridade,datastatus from tarefas order by datastatus')) ;
       
       if Fqry.RecordCount > 0 then
       begin
           Result:= Fqry.ToJSONArray() ;
       end
       else
           Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"Nenhum registro encontrado"}]'),0 ) as TJSONArray;

    except on ex:exception do
        begin
          Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"ErrorStatus: '+ex.Message+'"}]'),0 ) as TJSONArray;
        end;
    end;
     
end;

function TModel_TarefasService.ListarTarefasEstatistica: TJSONArray;
begin   
 // ok
    Result:=nil;
     
    Fqry:= TFDQuery(TQuery.New(TConnectionFiredac.New).Clear
              .Add('with tbtarefas as ( ')
            .Add('SELECT distinct PRIORIDADE, ')
            .Add('coalesce((select count(*) from tarefas),0) as NumeroTotalTarefas, ')
            .Add('coalesce((select count(*) from tarefas WHERE status<>'+Quotedstr('F')+'),0) as TotalTarefasPendentes, ')
            .Add('coalesce((select count(*) from tarefas WHERE status='+Quotedstr('F')+' and cast(datastatus as date)>cast(DATEADD(DAY, -7,Getdate()) as Date) ),0) as TotalTarefasConcluidas ')
            .Add(' FROM TAREFAS ) ')
            .Add(' select prioridade, ')
            .Add('	   CASE prioridade ')
            .Add('			WHEN 1 THEN '+Quotedstr('é possível esperar'))
            .Add('			WHEN 2 THEN '+Quotedstr('pouco urgente') )
            .Add('			WHEN 3 THEN '+Quotedstr('requer atenção em curto prazo, urgência'))
            .Add('			WHEN 4 THEN '+Quotedstr('muito urgente'))
            .Add('			WHEN 5 THEN '+Quotedstr('exige atenção imediata'))
            .Add('			ELSE '+Quotedstr('Sem prioridade'))
            .Add('	       END AS DescricaoPrioridade, ')
            .Add(' NumeroTotalTarefas,   ')
            .Add('TotalTarefasPendentes, ')
            .Add('TotalTarefasConcluidas, ')
            .Add('coalesce((select count(*) from tarefas WHERE status<>'+Quotedstr('F')+' and prioridade =tbtarefas.prioridade group by prioridade),0) as PendentePorPrioridade, ')
            .Add(' iif( coalesce(tbtarefas.TotalTarefasPendentes,0)>0, ')
            .Add('   concat(  ')
            .Add('      cast(  ')
            .Add('       (coalesce((select count(*) from tarefas WHERE status<>'+Quotedstr('F')+' and prioridade =tbtarefas.prioridade group by prioridade),0) ')
            .Add('       /cast(tbtarefas.TotalTarefasPendentes as numeric(9,2)) *100)' )
            .Add('    as numeric(9,2) ),'+Quotedstr(' %')+'),  ')
            .Add('	concat(0.00,'+Quotedstr(' %')+')) as MediaPrioridadeTarefasPendentes ')
            .Add('from tbtarefas   ')
            .Add('  order by prioridade ')
            .Query(''));
    
    
  // STATUS= F  indica tarefa finalizada 
    try
       if Fqry.RecordCount > 0 then
       begin
           Result:= Fqry.ToJSONArray() ;
       end
       else
           Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"Nenhum registro encontrado para estatistica "}]'),0 ) as TJSONArray;
            
    except on ex:exception do
        begin
          Result:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes('[{"status":"ErrorStatus: '+ex.Message+'"}]'),0 ) as TJSONArray;
        end;
    end;
     
end;


end.
