unit Funcoes;

interface

Uses
  Windows,System.DateUtils;

  Type
    tpTarefa = (tfAberto ,tfTratamento, tfFinalizada);

    //MatrizGut de Urgencia  
    tpPrioridade = (tpEsperar ,tpPoucoUrgente, tpUrgenteCurtoPrazo, tpMuitoUrgente, tpAtencaoImediata );

    function StrToTarefa(aValue : String):tpTarefa;
    function TarefaToStr(aVAlue : tpTarefa):String;
    function getUser:String;
    function getPassword:String;
    function JSONDate_To_Datetime(JSONDate: string): TDatetime;
      
implementation

uses
  System.SysUtils;

const
  arTarefas  : array  [0..2] of char = ('A','T','F');
  

function StrToTarefa(aValue : String):tpTarefa;
var
 i:Integer;
begin
  for i :=0 to 2 do
    begin
      if arTarefas[I]=aValue then
        Result:=tpTarefa(I);
    end;

end;

function TarefaToStr(aValue : tpTarefa):String;
var
 i:Integer;
begin
  for i :=0 to 2 do
    begin
      if tpTarefa(i)=aValue then
        Result:=arTarefas[I];
    end;

end;

function getUser:String;
begin
 result:='tarefa';
end;

function getPassword:String;
begin
   {a senha altera diariamente}
   Result:=FormatDateTime('yyyymmdd', Date());
end;

function JSONDate_To_Datetime(JSONDate: string): TDatetime;
var Year, Month, Day, Hour, Minute, Second, Millisecond: Word;
begin
  Year        := StrToInt(Copy(JSONDate, 1, 4));
  Month       := StrToInt(Copy(JSONDate, 6, 2));
  Day         := StrToInt(Copy(JSONDate, 9, 2));

  //'2024-02-08T16:34:16.843Z
  if length(JSONDate)>10 then
  begin
    Hour        := StrToIntDef(Copy(JSONDate, 12, 2),0); 
    Minute      := StrToIntDef(Copy(JSONDate, 15, 2),0); 
    Second      := StrToIntDef(Copy(JSONDate, 18, 2),0); 
    Millisecond := Round(StrToFloatDef(Copy(JSONDate, 21, 3),0));
    Result := EncodeDateTime(Year, Month, Day, Hour, Minute, Second, Millisecond);
  end
  else
  begin
    Result := EncodeDateTime(Year, Month, Day, 0, 0, 0, 0);
  
  end;
end;

end.
