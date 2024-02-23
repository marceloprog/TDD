unit Model_Query;

interface

uses
  System.SysUtils,
  Model_Interfaces,Data.DB, FireDAC.Comp.Client,System.Classes;

type

 TQuery = Class(TInterfacedObject , iQuery)
 private
  FSQL: TStringList;
  FQuery : TFDQuery;
  
  procedure PreencheQuery(Value : String);
  procedure PreencheParams(Value: array of Variant);
  
  constructor Create(Con : iConnection);
  Destructor Destroy ; override;

 public
   class function New(Con : iConnection) : iQuery;
   procedure Query(const Statement : String ; Params : Array of Variant); overload;
   function Query(const Statement : Variant; Params : Array of Variant):TDataset ; overload;
   function Query(const Statement : String):TDataset; overload;

   function Add(Value: string): iQuery;
   function Clear: iQuery; 
           
 End;

implementation

{ TQuery }

function TQuery.Add(Value: string): iQuery;
begin
  Result := Self;
  FSQL.Add(Value);
end;

function TQuery.Clear: iQuery;
begin
  Result := Self;
  FSQL.Clear;
end;

constructor TQuery.Create(Con : iConnection);
begin
   FQuery := TFDQuery.Create(nil);
   FQuery.Connection := TFDConnection(Con.Conexao);
   FSQL := TStringList.Create;
end;

destructor TQuery.Destroy;
begin
  FreeAndNil(FSQL);
  FQuery.DisposeOf;
  inherited;
end;

class function TQuery.New(Con : iConnection): iQuery;
begin
  Result := Self.Create(Con);
end;

procedure TQuery.PreencheParams(Value: array of Variant);
var
  i:Integer;
begin
  for i:=0 to high(Value) do
  begin
     FQuery.Params.Add;
     FQuery.Params[i].value := Value[I] ;
  end;

end;

procedure TQuery.PreencheQuery(Value: String);
begin
   FQuery.Close;
   FQuery.SQL.Clear;
   FQuery.SQL.Add(Value);
end;

function TQuery.Query(const Statement: String):TDataset;
begin
   if trim(Statement)<>'' then
   begin
     PreencheQuery(Statement);
     FQuery.Open;
   end
   else
   if trim(FSQL.Text)<>'' then
   begin
     PreencheQuery(FSQL.Text);
     FQuery.Open;
   end;      

   Result := FQuery;
end;                

function TQuery.Query(const Statement: Variant;
  Params: array of Variant): TDataset;
begin
   PreencheQuery(Statement);
   PreencheParams(Params);
   FQuery.Open;
   Result := FQuery;
end;

procedure TQuery.Query(const Statement: String; Params: array of Variant);
begin
   PreencheQuery(Statement);
   PreencheParams(Params);
   FQuery.ExecSQL;
end;

end.
