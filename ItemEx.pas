unit ItemEx;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ADODB, DB, StdCtrls;

type
TItemEx=class(TObject)

public

      caption:string;
      StringValue:string;
end;

implementation

//ʹ��adoquery�е�ֵ���combobox
function FillInComBoBoxWithAdoQuery(objAdoQuery:TAdoQuery;objComBoBox:TComboBox;sql:string;captionFieldName:string;
    valueFieldName:string;noAsFirst:boolean):boolean;

//��noAsFirstΪtrue�ǣ�combobox�ĵ�һ����'��'
var
  objItemEx:TItemEx;
begin
  objComBoBox.Clear;
  objComBoBox.ItemIndex:=-1;
  if noAsFirst
  then begin
     objItemEx:=TItemEx.Create;
     objItemEx.caption:='��';
     objItemEx.StringValue:='';
     objComBoBox.Items.AddObject(objItemEx.caption,objItemEx);
     objComBoBox.ItemIndex:=0;
  end;
  objAdoQuery.Close;
  objAdoQuery.SQL.Clear;
  objAdoQuery.SQL.Add(sql);
  objAdoQuery.Open;
  objAdoQuery.First;
  while not objAdoQuery.Eof do
  begin
    objItemEx:=TItemEx.Create;
    objItemEx.caption:=objAdoQuery.FieldByName(captionFieldName).AsString;
    objItemEx.StringValue:=objAdoQuery.FieldByName(valueFieldName).AsString;
    objComBoBox.Items.AddObject(objItemEx.caption,objItemEx);
    objAdoQuery.Next;
  end;
  objAdoQuery.close;
  result:=true;
end;

//ȡ��comboobx�б�ѡ�������
function GetComBoBoxSelectedStringValue(objComBoBox:TComboBox):string;
var
  objItemEx:TItemEx;
begin
  if (objComBoBox.ItemIndex>-1 )
  then begin
       objItemEx:=(objComBoBox.Items.Objects[objComBoBox.ItemIndex] as  TItemEx);
       result:=objItemEx.StringValue;
  end
  else begin
       result:='';
  end;
end;



end.
