unit SuppleCard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseCard, Buttons, StdCtrls, Mask, DBCtrls, DBCtrlsEh, ExtCtrls,
  ADODB, DB, BaseEdit, BaseSingleEdit;

type
  TSuppleCardForm = class(TBaseCardForm)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label1: TLabel;
    Edit2: TEdit;
    Edit1: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    Label5: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure btnExecute1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnContentClick(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
  private
//    FADOQryTmp: TADOQuery;
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowSuppleCardForm;

implementation

uses SysPublic, MemberInfo, MemberManage;

{$R *.dfm}

procedure ShowSuppleCardForm;
var
  SuppleCardForm: TSuppleCardForm;
begin
  SuppleCardForm:= TSuppleCardForm.Create(Nil);
  SuppleCardForm.ShowModal;
end;

procedure TSuppleCardForm.Edit1Change(Sender: TObject);
begin
  inherited;
  with FADOQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select * From ��Ա���� where ��Ա����=:Param');
    Parameters.ParamByName('Param').Value := Edit1.Text;
    Open;
  end;
  if FADOQuery.RecordCount <1 then exit;
end;

procedure TSuppleCardForm.Edit2Change(Sender: TObject);
begin
  inherited;
  with FADOQuery do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select * From ��Ա���� where ��Ա���=:Param');
    Parameters.ParamByName('Param').Value := Edit2.Text;
    Open;
  end;
  if FADOQuery.RecordCount <1 then exit;
end;

procedure TSuppleCardForm.btnExecute1Click(Sender: TObject);
var
  ADOQryTmp: TADOQuery;
  s: string;
begin
  inherited;

  if not FADOQuery.Active then exit;
//  if not FADOQryTmp.Active then exit;
  if (Edit3.Text='') or (Edit4.Text='') or (Edit5.Text='') then
  begin
    ShowMsg('������ţ������Ѳ���Ϊ�գ�');
    Exit;
  end;

  s:= Trim(Edit4.Text);

  ADOQryTmp:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp);

  ADOQryTmp.Close;
  ADOQryTmp.SQL.Clear;
  ADOQryTmp.SQL.Add('Select * From ��Ա���� Where ����=' + QuotedStr(s));
  ADOQryTmp.Open;

  if ADOQryTmp.RecordCount >=1 then
  begin
    ShowMsg('�˿�����ϵͳ���Ѿ����ڣ�');
    Exit;
  end;

  ADOQryTmp.Close;
  ADOQryTmp.Free; 

  if FADOQuery.FieldByName('����').AsString = Trim(Edit3.Text) then
  begin
    FADOQuery.Edit;
    if trim(FADOQuery.FieldByName('��ʷ����').AsString) ='' then
      FADOQuery.FieldByName('��ʷ����').AsString:= FADOQuery.FieldByName('����').AsString
    else
      FADOQuery.FieldByName('��ʷ����').AsString:= FADOQuery.FieldByName('��ʷ����').AsString + ','+ FADOQuery.FieldByName('����').AsString;
    FADOQuery.FieldByName('����').AsString:= Edit4.Text;
    FADOQuery.FieldByName('������').AsFloat := StrToFloat(Edit5.Text);
    FADOQuery.Post;
    ShowMsg('��Ա�����ɹ���');
    Close;
  end
  else
    ShowMsg('������󣬻�Ա����ʧ�ܣ�');

end;

procedure TSuppleCardForm.FormShow(Sender: TObject);
begin
  inherited;
  btnExecute1.Caption:= '��  ��';
  btnExecute2.Caption:= '��  ��';
end;

procedure TSuppleCardForm.btnContentClick(Sender: TObject);
begin
  inherited;
  ShowMemberInfoForm(FADOQuery);
end;

procedure TSuppleCardForm.Edit2Exit(Sender: TObject);
begin
  inherited;
  if not FADOQuery.Active then exit;
  if FADOQuery.RecordCount <1 then exit;
  Edit1.Text:= '';
  Edit1.Text:= FADOQuery.FieldByName('��Ա����').AsString;
end;

procedure TSuppleCardForm.Edit1Exit(Sender: TObject);
begin
  inherited;
  if not FADOQuery.Active then exit;
  if FADOQuery.RecordCount <1 then exit;
  Edit2.Text:= '';
  Edit2.Text:= FADOQuery.FieldByName('��Ա���').AsString;
end;

procedure TSuppleCardForm.Edit4Change(Sender: TObject);
begin
  inherited;
{  with FADOQryTmp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select * From ��Ա���� where ��Ա���=:Param');
    Parameters.ParamByName('Param').Value := Edit4.Text;
    Open;
  end;
  if FADOQryTmp.RecordCount <1 then exit;}
end;

procedure TSuppleCardForm.Edit5KeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  //ֻ���������ֺ�С����
  if (Key in ['0'..'9']=false) and (Key<> '.') and (key<>#8) then
    key:=#0
end;

end.
