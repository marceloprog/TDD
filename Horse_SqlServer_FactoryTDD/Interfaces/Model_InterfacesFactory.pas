unit Model_InterfacesFactory;

interface
uses
 Model_Interfaces,
Model_Tarefas,Model_connection,Model_Query ;
 
type
 TModelTarefaFactory = class(TInterfacedObject,iTarefaFactory)
    constructor create;
    destructor Destroy;Override;
    class function New : iTarefaFactory;

    function Tarefa : iTarefa;
 end;

 TMododelConnectionFactory = class(TInterfacedObject , iConnectionFactory)
    constructor create;
    destructor Destroy;Override;
    class function New : iConnectionFactory;

    function Connection : iConnection;
   
 end;

 TMododelQueryFactory = class(TInterfacedObject , iQueryFactory)
    private
     Conexao : TConnectionFiredac;
     FParent : iConnection;
    public
     constructor create;
     destructor Destroy;Override;
     class function New : iQueryFactory;

     function Query : iQuery;
   
 end;
 


implementation


{ TModelTarefaFactory }

constructor TModelTarefaFactory.create;
begin

end;

destructor TModelTarefaFactory.Destroy;
begin

  inherited;
end;

class function TModelTarefaFactory.New: iTarefaFactory;
begin
  Result := Self.create
end;

function TModelTarefaFactory.Tarefa: iTarefa;
begin
 Result := TTarefa.New;
end;

{ TMododelConnectionFactory }

function TMododelConnectionFactory.Connection: iConnection;
begin
 Result := TConnectionFiredac.New;
    
end;

constructor TMododelConnectionFactory.create;
begin

end;

destructor TMododelConnectionFactory.Destroy;
begin

  inherited;
end;

class function TMododelConnectionFactory.New: iConnectionFactory;
begin
  Result := Self.create
  
end;

{ TMododelQueryFactory }

constructor TMododelQueryFactory.create;
begin

end;

destructor TMododelQueryFactory.Destroy;
begin

  inherited;
end;

class function TMododelQueryFactory.New: iQueryFactory;
begin
  Result := Self.create
   
end;


function TMododelQueryFactory.Query: iQuery;
begin
  Result := TQuery.new(FParent);
end;
      
end.
