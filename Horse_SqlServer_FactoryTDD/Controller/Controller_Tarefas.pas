unit Controller_Tarefas;

interface

procedure Registry;


implementation
Uses
Horse, Dataset.Serialize, System.JSON,Data.DB,
Model_TarefasServices, System.SysUtils ;


procedure DoListarTarefas(Res: THorseResponse);
var
    arrayTarefas : TJSONArray;
    Model_TarefasService : TModel_TarefasService;
    
begin
    Model_TarefasService := TModel_TarefasService.create;
    try
        arrayTarefas:=   Model_TarefasService.ListarTarefas();
        
        if arrayTarefas<>nil then
            res.Send<TJSONArray>(arrayTarefas)
        else    
            res.Send('Tarefas não localizadas').Status(204);
    finally
        Model_TarefasService.DisposeOf;
    end;
end;

procedure DoListarTarefasEstatistica(Res: THorseResponse);
var
    arrayTarefas : TJSONArray;
    Model_TarefasService : TModel_TarefasService;
    
begin
    Model_TarefasService := TModel_TarefasService.create;
    try
        arrayTarefas:=   Model_TarefasService.ListarTarefasEstatistica();
        
        if arrayTarefas<>nil then
            res.Send<TJSONArray>(arrayTarefas)
        else    
            res.Send('Tarefas não localizadas').Status(204);
    finally
        Model_TarefasService.DisposeOf;
    end;
end;


procedure DoInserirTarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
    objTarefa: TJSONObject;
    erro : string;
    body  : TJsonValue;
    Model_TarefasService : TModel_TarefasService;
    arrayTarefas : TJSONArray;
    
begin
    Model_TarefasService := TModel_TarefasService.create;
      
    try
        try
            body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;
          
            //Model_TarefasService.DATA_CRIACAO : TDateTime read  FDATA_CRIACAO  write FDATA_CRIACAO;
            Model_TarefasService.Tarefa.SetNOMETAREFA(body.GetValue<string>('nometarefa', ''));
            Model_TarefasService.Tarefa.SetRESPONSAVEL(body.GetValue<string>('responsavel', ''));
            Model_TarefasService.Tarefa.SetSTATUS(body.GetValue<string>('status', ''));
            Model_TarefasService.Tarefa.SetPRIORIDADE(body.GetValue<integer>('prioridade', 1));
            //Model_TarefasService.Tarefa.DATA_STATUS  : TDateTime read  FDATA_STATUS   write FDATA_STATUS;
                    
            body.DisposeOf;
            arrayTarefas := Model_TarefasService.InserirTarefa();
                                                
           if arrayTarefas<>nil then
           begin
             if pos('ErrorStatus',arrayTarefas.ToString)>0 then
               res.Send<TJSONArray>(arrayTarefas)
             else
               res.Send<TJSONArray>(arrayTarefas).Status(201)
           end
           else
             res.Send('Tarefas não pode ser Inserida').Status(400);

        except on ex:exception do
            begin
                res.Send(ex.Message).Status(400);
                exit;
            end;
        end;

    finally
        Model_TarefasService.DisposeOf;
    end;
end;

procedure DoApagarTarefa(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
    arrayTarefas : TJSONArray;
    Model_TarefasService : TModel_TarefasService;
    
begin
    Model_TarefasService := TModel_TarefasService.create;
    try

        Model_TarefasService.Tarefa.SetID(Req.Params['id'].ToInteger);
    
        arrayTarefas := Model_TarefasService.ApagarTarefa();
        if arrayTarefas<>nil then
            res.Send<TJSONArray>(arrayTarefas).Status(200)
        else
          res.Send('Tarefas não pode ser excluida').Status(400);
        
    
    finally
        Model_TarefasService.DisposeOf;
    end;
end;

procedure DoAlterarStatus(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
    objTarefa: TJSONObject;
    body  : TJsonValue;
    Model_TarefasService : TModel_TarefasService;
    arrayTarefas : TJSONArray;
     
begin

    Model_TarefasService := TModel_TarefasService.create;
      
    try
       body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;
       
       Model_TarefasService.Tarefa.SetID(body.GetValue<integer>('id', 0));
       Model_TarefasService.Tarefa.SetSTATUS(body.GetValue<string>('status', ''));

       if   Model_TarefasService.Tarefa.GetID()>0 then
       begin

         arrayTarefas := Model_TarefasService.AlterarStatus();
          
         if arrayTarefas<>Nil then
           res.Send<TJSONArray>(arrayTarefas).Status(200)
         else
           res.Send('Status não pode ser Alterado').Status(400);
       end
       else
           res.Send('ID da tarefa inválido').Status(400);
       
       body.DisposeOf;
                
    finally
        Model_TarefasService.DisposeOf;
    end;
end;
  

procedure Registry;
begin
    THorse.Get('/v1/tarefas', DoListarTarefas);
    THorse.Get('/v1/tarefas/estatistica',DoListarTarefasEstatistica);
    THorse.Post('/v1/tarefas', DoInserirTarefa);
    THorse.Delete('/v1/tarefas/:id', DoApagarTarefa); 
    THorse.Put('/v1/tarefas', DoAlterarStatus); 

end;

   
end.
