unit View_Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls,IniFiles, Vcl.StdCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,IpPeerClient, Vcl.Grids, Vcl.DBGrids,SqlTimSt,
  View_Estatistica;

type
  TfrmView_Main = class(TForm)
    Panel1: TPanel;
    btnGET: TButton;
    Panel2: TPanel;
    MemTable: TFDMemTable;
    MemTableID: TIntegerField;
    MemTableNOMETAREFA: TStringField;
    MemTableRESPONSAVEL: TStringField;
    MemTableSTATUS: TStringField;
    MemTablePRIORIDADE: TIntegerField;
    MemTableDATASTATUS: TDateField;
    dbgTarefas: TDBGrid;
    DataSource1: TDataSource;
    MemTableDATACRIACAO: TDateTimeField;
    Label1: TLabel;
    edtResponsavel: TEdit;
    edtTarefa: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    cboPrioridade: TComboBox;
    cboStatus: TComboBox;
    btnPOST: TButton;
    btnDELETE: TButton;
    btnDesistir: TButton;
    btnPUT: TButton;
    Button1: TButton;
    MemTableDESCPRIORIDADE: TStringField;
    MemTableDESCSTATUS: TStringField;
    memTableEstatistica: TFDMemTable;
    memTableEstatisticaPRIORIDADE: TIntegerField;
    memTableEstatisticaDESCRICAOPRIORIDADE: TStringField;
    memTableEstatisticaNUMEROTOTALTAREFAS: TIntegerField;
    memTableEstatisticaTOTALTAREFASPENDENTES: TIntegerField;
    memTableEstatisticaTOTALTAREFASCONCLUIDAS: TIntegerField;
    memTableEstatisticaPENDENTEPOPRIORIDADE: TIntegerField;
    memTableEstatisticaMEDIAPRIORIDADETAREFASPENDENTES: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure btnGETClick(Sender: TObject);
    procedure btnPOSTClick(Sender: TObject);
    procedure btnDesistirClick(Sender: TObject);
    procedure btnPUTClick(Sender: TObject);
    procedure btnDELETEClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
   FPathURL:String;
   procedure ConfigurarURI; 
   function getURLServico(EndPoint:String):String; 
   procedure HabilitarBotoes(habilitar:boolean);
   procedure HabilitarEdicao(habilitar:boolean);
   
   procedure PreencherDataset(Retorno:String);
   procedure PreencherDatasetEstatistica(Retorno:String);
   procedure LimparEdits;
   function ValidarCamposEntrada:boolean;
   procedure ProcessarPost(Url:String);
   procedure ProcessarPut(Url:String);
   procedure ProcessarGet(Url:String);
   procedure ProcessarDelete(Url:String);
   procedure ProcessarGetEstatistica(Url:String);
  public                 
    { Public declarations }
  end;

var
  frmView_Main: TfrmView_Main;


implementation
uses
Horse, Dataset.Serialize, System.JSON,
RestRequest4D,Funcoes;

 {$R *.dfm}

{ TfrmView_Main }

procedure TfrmView_Main.btnDELETEClick(Sender: TObject);
begin

  if application.MessageBox(pchar('Deseja mesmo excluir a Tarefa :' + #13 + #13+
    MemTable.fieldbyname('NOMETAREFA').asstring+' ?'+#13 ), 'Atenção', mb_YesNo + mB_defButton2) = idNo then
    exit;

  try
   HabilitarBotoes(false);
   ProcessarDelete(getURLServico('/tarefas/'+MemTable.FieldByName('ID').asString ));
  finally
   HabilitarBotoes(True);
  end;

end;

procedure TfrmView_Main.btnDesistirClick(Sender: TObject);
begin
  HabilitarEdicao(false);
  HabilitarBotoes(true);
end;                    

procedure TfrmView_Main.btnGETClick(Sender: TObject);
begin
  try
   HabilitarBotoes(false);
   ProcessarGet(getURLServico('/tarefas'));
  finally
   HabilitarBotoes(True);
  end;
end;

procedure TfrmView_Main.btnPOSTClick(Sender: TObject);
begin
  if not ValidarCamposEntrada then exit;
 
  if btnPOST.Tag=0 then
  begin
    try
     HabilitarBotoes(false);
     ProcessarPost(getURLServico('/tarefas'));
    finally
     HabilitarBotoes(True);
    end;
  end
  else
  begin
    try
     ProcessarPut(getURLServico('/tarefas'));
    finally
     HabilitarEdicao(false);
     HabilitarBotoes(true);
    end;
    
  end;
end;

procedure TfrmView_Main.btnPUTClick(Sender: TObject);
begin
  if MemTable.IsEmpty then
  begin
    Showmessage('Nenhuma tarefa foi selecionada para alteração.');
    exit;
  end;

  try
   HabilitarBotoes(false);
   HabilitarEdicao(true);
  finally
   //HabilitarBotoes(True);
   //HabilitarEdicao(False);
  end;                  

end;

procedure TfrmView_Main.Button1Click(Sender: TObject);
begin
  try
   HabilitarBotoes(false);
   ProcessarGetEstatistica(getURLServico('/tarefas/estatistica'));
   if memTableEstatistica.RecordCount>0 then
   begin
      Application.CreateForm(TfrmView_Estatistica,frmView_Estatistica);
      frmView_Estatistica.ShowModal;
      frmView_Estatistica.Free;
   end;
  finally
   HabilitarBotoes(True);
  end;

end;

procedure TfrmView_Main.ConfigurarURI;
var
    ArqIni: TIniFile;
    vArquivoIni:String;
begin
   vArquivoIni:= extractfiledir(Application.exename)+'\PARAMETROS.INI';

   ArqIni   := TIniFile.Create(vArquivoIni);

  try
   FPathURL := ArqIni.ReadString('URI', 'URL', 'http://localhost:9000/v1');
  finally
    ArqIni.Free;
  end;
      
          
end;

procedure TfrmView_Main.FormCreate(Sender: TObject);
begin
  ConfigurarURI();
  MemTable.CreateDataSet;
  memTableEstatistica.CreateDataSet;
end;

function TfrmView_Main.getURLServico(EndPoint: String): String;
begin
  Result:=FPathURL+EndPoint;
end;

procedure TfrmView_Main.HabilitarBotoes(habilitar: boolean);
begin
   btnGET.Enabled := habilitar;
   btnPOST.Enabled := habilitar;
   btnDELETE.Enabled := habilitar;
   btnPUT.Enabled := habilitar;
end;

procedure TfrmView_Main.HabilitarEdicao(habilitar: boolean);
   procedure setComboPrioridade(value:String);
    var
     i:Integer;
   begin
     for i:=0 to cboPrioridade.Items.count-1 do
     begin
       if  value=Copy(cboPrioridade.Items[i],1,1) then
          cboPrioridade.itemindex := I;
     end;
   end;

   procedure setComboStatus(value:String);
    var
     i:Integer;
   begin
     for i:=0 to cboStatus.Items.count-1 do
     begin
       if  value=Copy(cboStatus.Items[i],1,1) then
          cboStatus.itemindex := I;
     end;
   end;
   
begin
   if Habilitar=true then
   begin
     edtTarefa.Text := MemTable.FieldByName('NOMETAREFA').AsString;
     edtResponsavel.Text := MemTable.FieldByName('RESPONSAVEL').AsString;

     edtTarefa.Enabled := false;
     edtResponsavel.Enabled := false;

     SetComboStatus(MemTable.FieldByName('STATUS').AsString);
     SetComboPrioridade(MemTable.FieldByName('PRIORIDADE').AsString);
      
     cboPrioridade.Enabled := false;
     cboStatus.Enabled := true;
     cboStatus.SetFocus;  
     btnPOST.Enabled := True;
     btnDesistir.Visible := true;
     dbgTarefas.Enabled := False;
     btnPOST.Tag := 1;
   end
   else
   begin
     edtTarefa.Enabled := true;
     edtResponsavel.Enabled := true;
     cboPrioridade.Enabled := true;
     cboStatus.Enabled := true;
     btnDesistir.Visible := False;
     btnPOST.Tag := 0;
                    
     dbgTarefas.Enabled := True;
     
     LimparEdits;                  
   end;
end;

procedure TfrmView_Main.LimparEdits;
begin
  edtTarefa.Clear;
  edtResponsavel.Clear;
  cboPrioridade.ItemIndex := 0;
  cboStatus.ItemIndex := 0
end;

procedure TfrmView_Main.PreencherDataset(Retorno: String);
var
  ArrayConsulta:TJSONArray;
  ObjTarefa: TJSONObject;
  i:integer;

  function getDescricaoPrioridade(value:Integer):String;
  var
   i:Integer;
  begin
    Result:='';
     for i:=0 to cboPrioridade.Items.count-1 do
     begin
       if  inttostr(value)=Copy(cboPrioridade.Items[i],1,1) then
          Result:=Copy(cboPrioridade.Items[i],5,50);
          
     end;
    
  end;
  function getDescricaoStatus(value:String):String;
  var
   i:Integer;
  begin 
     Result:='';     
     for i:=0 to cboStatus.Items.count-1 do
     begin
       if  value=Copy(cboStatus.Items[i],1,1) then
          Result:=Copy(cboStatus.Items[i],5,50)
     end;
       
  end;
begin

   ArrayConsulta:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Retorno),0 ) as TJSONArray;
   
   if  ArrayConsulta.size = 1 then
   begin
     ObjTarefa:= ArrayConsulta.Items[0] as TJSONObject;
     if ObjTarefa.GetValue<integer>('id', 0) =0 then exit;
   end;
   
   
   for i:=0 to ArrayConsulta.size -1 do
   begin
     ObjTarefa:= ArrayConsulta.Items[i] as TJSONObject;

     MemTable.Append;
     memtable.FieldByName('ID').AsInteger := ObjTarefa.GetValue<integer>('id', 0);
     memtable.FieldByName('NOMETAREFA').AsString := ObjTarefa.GetValue<string>('nometarefa', '');
     memtable.FieldByName('STATUS').AsString := ObjTarefa.GetValue<string>('status', '');
     memtable.FieldByName('RESPONSAVEL').AsString := ObjTarefa.GetValue<string>('responsavel', '');
     memtable.FieldByName('PRIORIDADE').AsInteger := ObjTarefa.GetValue<integer>('prioridade', 1);
     memtable.FieldByName('DESCPRIORIDADE').AsString := getDescricaoPrioridade(ObjTarefa.GetValue<integer>('prioridade', 1));
     memtable.FieldByName('DESCSTATUS').AsString     := getDescricaoStatus(ObjTarefa.GetValue<string>('status', ''));
     memtable.FieldByName('DATASTATUS').asDateTime  := trunc(JSONDate_To_Datetime(ObjTarefa.GetValue<String>('datastatus','0')));
     memtable.FieldByName('DATACRIACAO').asDateTime :=  JSONDate_To_Datetime(ObjTarefa.GetValue<String>('datacriacao','0'));
     //memtable.FieldByName('DATACRIACAO').asVariant := ObjTarefa.GetValue<Variant>('datacriacao', null);
     //memtable.FieldByName('DATASTATUS').asVariant   := ObjTarefa.GetValue<TDateTime>('datastatus', null);
      
     MemTable.Post;
     
   end;

end;

procedure TfrmView_Main.PreencherDatasetEstatistica(Retorno: String);
var
  ArrayConsulta:TJSONArray;
  ObjTarefa: TJSONObject;
  i:integer;
begin

   ArrayConsulta:= TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Retorno),0 ) as TJSONArray;
   
   if  ArrayConsulta.size = 1 then
   begin
     ObjTarefa:= ArrayConsulta.Items[0] as TJSONObject;
     if ObjTarefa.GetValue<integer>('prioridade', 0) =0 then exit;
   end;
   
   
   for i:=0 to ArrayConsulta.size -1 do
   begin
     ObjTarefa:= ArrayConsulta.Items[i] as TJSONObject;

     memTableEstatistica.Append;
     memTableEstatistica.FieldByName('PRIORIDADE').AsInteger := ObjTarefa.GetValue<integer>('prioridade', 1);
     memTableEstatistica.FieldByName('DESCRICAOPRIORIDADE').AsString  := ObjTarefa.GetValue<string>('descricaoprioridade', '');
     memTableEstatistica.FieldByName('NUMEROTOTALTAREFAS').AsInteger := ObjTarefa.GetValue<integer>('numerototaltarefas', 0);
     memTableEstatistica.FieldByName('TOTALTAREFASPENDENTES').AsInteger := ObjTarefa.GetValue<integer>('totaltarefaspendentes', 0);
     memTableEstatistica.FieldByName('TOTALTAREFASCONCLUIDAS').AsInteger := ObjTarefa.GetValue<integer>('totaltarefasconcluidas', 0);
     memTableEstatistica.FieldByName('PENDENTEPOPRIORIDADE').AsInteger := ObjTarefa.GetValue<integer>('pendenteporprioridade', 0);
     memTableEstatistica.FieldByName('MEDIAPRIORIDADETAREFASPENDENTES').AsString := ObjTarefa.GetValue<string>('mediaprioridadetarefaspendentes', '');
     memTableEstatistica.Post;
     
   end;

end;

procedure TfrmView_Main.ProcessarDelete(Url: String);
var
  LResponse: IResponse;
begin  
  try  
    LResponse := TRequest.New.BaseURL(Url)
      .BasicAuthentication( getUser(),getPassword())
      .Accept('application/json')
      .Delete;

    if LResponse.StatusCode=200 then
    begin  
      if LREsponse.Content.IndexOf('ErrorStatus')>0 then
      begin
         application.MessageBox(pchar(LResponse.JSONValue.ToString+#13+#13+'Verifique !'), 'Atenção', mb_OK+MB_ICONERROR);
      end
      else
      begin
         Showmessage('Tarefa excluida');
         btnGET.Click;
      end;
      LimparEdits;
    end
    else
      application.MessageBox(pchar(LResponse.StatusText+#13+'Verifique !'), 'Atenção', mb_OK+MB_ICONINFORMATION);
  Except
   on e:Exception do
   begin
       application.MessageBox(pchar(E.Message), 'Atenção', mb_OK+MB_ICONERROR);
   end;

  end;
     
end;

procedure TfrmView_Main.ProcessarGet(Url: String);
var
  LResponse: IResponse;
begin
  try
    MemTable.EmptyDataSet;
    LResponse := TRequest.New.BaseURL(Url)
      .BasicAuthentication( getUser(),getPassword())
      .Accept('application/json')
      .Get;

    if LResponse.StatusCode=200 then
    begin
      if LREsponse.Content.IndexOf('ErrorStatus')>0 then
      begin
         application.MessageBox(pchar(LResponse.JSONValue.ToString+#13+#13+'Verifique !'), 'Atenção', mb_OK+MB_ICONERROR);
      end
      else
      begin
        PreencherDataset(LResponse.Content);
      end;
    end
    else
      application.MessageBox(pchar(LResponse.StatusText+#13+'Verifique !'), 'Atenção', mb_OK+MB_ICONINFORMATION);
  Except
   on e:Exception do
   begin
       application.MessageBox(pchar(E.Message), 'Atenção', mb_OK+MB_ICONERROR);
   end;

  end;
end;

procedure TfrmView_Main.ProcessarGetEstatistica(Url: String);
var
  LResponse: IResponse;
begin
  try
    memTableEstatistica.EmptyDataSet;
    LResponse := TRequest.New.BaseURL(Url)
      .BasicAuthentication( getUser(),getPassword())
      .Accept('application/json')
      .Get;

    if LResponse.StatusCode=200 then
    begin
      if LREsponse.Content.IndexOf('ErrorStatus')>0 then
      begin
         application.MessageBox(pchar(LResponse.JSONValue.ToString+#13+#13+'Verifique !'), 'Atenção', mb_OK+MB_ICONERROR);
      end
      else
      begin
        PreencherDatasetEstatistica(LResponse.Content);
      end;
    end
    else
      application.MessageBox(pchar(LResponse.StatusText+#13+'Verifique !'), 'Atenção', mb_OK+MB_ICONINFORMATION);
  Except
   on e:Exception do
   begin
       application.MessageBox(pchar(E.Message), 'Atenção', mb_OK+MB_ICONERROR);
   end;

  end;
end;

procedure TfrmView_Main.ProcessarPost(Url: String);
var
  LResponse: IResponse;
  jsonBody : TJSONObject;
begin
 jsonBody := TJSONObject.Create;
 jsonBody.AddPair('nometarefa', edtTarefa.text);
 jsonBody.AddPair('responsavel', edtResponsavel.Text);
 jsonBody.AddPair('status',  copy(cboStatus.Items[cbostatus.ItemIndex],1,1)  );
 jsonBody.AddPair('prioridade',copy(cboPrioridade.Items[cboPrioridade.ItemIndex],1,1));

 try
    LResponse := TRequest.New.BaseURL(Url)
      .BasicAuthentication( getUser(),getPassword())
      .Accept('application/json')
      .AddBody(jsonBody.ToString)
      .Post;

    if LResponse.StatusCode=201 then
    begin  
      if LREsponse.Content.IndexOf('ErrorStatus')>0 then
      begin
         application.MessageBox(pchar(LResponse.JSONValue.ToString+#13+#13+'Verifique !'), 'Atenção', mb_OK+MB_ICONERROR);
      end
      else
      begin
        Showmessage('Cadastro efetuado com sucesso');
        btnGET.Click;
      end;
      LimparEdits;
    end
    else
    if LResponse.StatusCode=200 then
    begin  
      application.MessageBox(pchar(LResponse.JSONValue.ToString+#13+#13+'Verifique !'), 'Atenção', mb_OK+MB_ICONERROR);
      btnGET.Click;
      LimparEdits;
    end
    else
      application.MessageBox(pchar(LResponse.StatusText+#13+'Verifique !'), 'Atenção', mb_OK+MB_ICONINFORMATION);
  Except
   on e:Exception do
   begin
       application.MessageBox(pchar(E.Message), 'Atenção', mb_OK+MB_ICONERROR);
   end;

  end;

  freeAndNil(jsonBody);
    
end;

procedure TfrmView_Main.ProcessarPut(Url: String);
var
  LResponse: IResponse;
  jsonBody : TJSONObject;
begin
 jsonBody := TJSONObject.Create;
 jsonBody.AddPair('id', MemTable.FieldByName('ID').asString );
 jsonBody.AddPair('status', copy(cboStatus.Items[cbostatus.ItemIndex],1,1)  );

 try
    LResponse := TRequest.New.BaseURL(Url)
      .BasicAuthentication( getUser(),getPassword())
      .Accept('application/json')
      .AddBody(jsonBody.ToString)
      .Put;

    if LResponse.StatusCode=200 then
    begin  
      if LREsponse.Content.IndexOf('ErrorStatus')>0 then
      begin
         application.MessageBox(pchar(LResponse.JSONValue.ToString+#13+#13+'Verifique !'), 'Atenção', mb_OK+MB_ICONERROR);
      end
      else
      begin
         Showmessage('Status alterado sucesso');
         btnGET.Click;
      end;
      LimparEdits;
    end
    else
      application.MessageBox(pchar(LResponse.StatusText+#13+'Verifique !'), 'Atenção', mb_OK+MB_ICONINFORMATION);
  Except
   on e:Exception do
   begin
       application.MessageBox(pchar(E.Message), 'Atenção', mb_OK+MB_ICONERROR);
   end;

  end;

  freeAndNil(jsonBody);
    
end;

function TfrmView_Main.ValidarCamposEntrada: boolean;
begin
 Result:=true;
 if (trim(edtTarefa.text)='') or
   (trim(edtResponsavel.Text)='') or
   (cbostatus.ItemIndex=-1) or
   (cboPrioridade.ItemIndex=-1) then
   begin
     Result:=false;
     showmessage('Preencha todos os campos');
     edtTarefa.SetFocus;
   end;

end;

end.






var
    jsonBody : TJSONObject;
begin
    try
        try
            Result := false;
            erro := '';

            jsonBody := TJSONObject.Create;
            jsonBody.AddPair('nome', nome);
            jsonBody.AddPair('email', email);
            jsonBody.AddPair('fone', fone);

            if verbo = rmPUT then
                jsonBody.AddPair('id_cliente', id_cliente.ToString);


            dm.ReqClientePostPut.Params.Clear;
            dm.ReqClientePostPut.Body.ClearBody;
            dm.ReqClientePostPut.Method := verbo; // POST ou PUT
            dm.ReqClientePostPut.Body.Add(jsonBody.ToString,
                                          ContentTypeFromString('application/json'));
            dm.ReqClientePostPut.Execute;

            // Tratar retorno...
            if (dm.ReqClientePostPut.Response.StatusCode  <> 200) and
               (dm.ReqClientePostPut.Response.StatusCode  <> 201) then
            begin
                erro := 'Erro ao salvar dados: ';
                exit;
            end;

            Result := true;

        except on ex:exception do
                erro := 'Ocorreu um erro: ' + ex.Message;
        end;
    finally
        jsonBody.DisposeOf;
    end;
end;
   
