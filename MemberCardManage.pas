unit MemberCardManage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseCard, Buttons, StdCtrls, Mask, DBCtrls, DBCtrlsEh, ADODB, DB,
  BaseSingleEdit;

type
  TMemberCardManageForm = class(TBaseCardForm)
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure btnContentClick(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowMemberCardManageForm(ADOQuery: TADOQuery);

implementation

uses SysPublic, DataM, MemberManage, DepartEdit, MemberInfo;

{$R *.dfm}

procedure ShowMemberCardManageForm(ADOQuery: TADOQuery);
var
  MemberCardManageForm: TMemberCardManageForm;
begin
{  MemberCardManageForm:= TMemberCardManageForm.Create(Nil);
  MemberCardManageForm.ADOQuery1:= ADOQuery;
  MemberCardManageForm.ADOQuery1.Edit;
  if MemberCardManageForm.ADOQuery1.FieldByName('����').AsString = '' then
  begin
    MemberCardManageForm.ShowModal;
  end
  else
  begin
    ShowMsg('�Ѿ���������');
    Exit;
  end;}
end;

procedure TMemberCardManageForm.BitBtn1Click(Sender: TObject);
var
  SaveMoney: Double;
  s: string;
  ADOQryTmp: TADOQuery;
begin
  inherited;
  s:= Trim(Edit1.Text);

  ADOQryTmp:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp);

  ADOQryTmp.Close;
  ADOQryTmp.SQL.Clear;
  ADOQryTmp.SQL.Add('Select * From ��Ա���� Where ����='+ QuotedStr(S));
  ADOQryTmp.Open;

  if ADOQryTmp.RecordCount >=1 then
  begin
    ShowMsg('�˿�����ϵͳ����ʹ�ã�');
    Exit;
  end;
  ADOQryTmp.Close;
  ADOQryTmp.Free;

  if (Trim(Edit1.Text)='') and (Trim(Edit3.Text)='') then
    ShowMsg('���ſ������Ϊ�գ�');
  SaveMoney:= FADOQuery.FieldByName('Ѻ��').AsFloat+ StrToFloat(Edit2.Text);
  try
    if FADOQuery.State in [dsEdit] then
    begin
      FADOQuery.FieldByName('����').AsString := Trim(Edit1.Text);
      FADOQuery.FieldByName('Ѻ��').AsFloat := SaveMoney;
      FADOQuery.FieldByName('����').AsString := Trim(Edit3.Text);
      FADOQuery.Post;
      ShowMsg('�����ɹ�!');
    end;
    Close;
  finally
  end;
end;

procedure TMemberCardManageForm.FormShow(Sender: TObject);
begin
  inherited;
  btnExecute1.Caption:= '��  ��';
  btnExecute2.Caption:= '��  ��'; 
end;

procedure TMemberCardManageForm.Edit1Change(Sender: TObject);
begin
  inherited;
{  FADOQuery.Close;
  FADOQuery.SQL.Clear;
  FADOQuery.SQL.add('Select * From ��Ա���� Where ����=:Param');
  FADOQuery.Parameters.ParamByName('param').Value := Edit1.Text;
  FADOQuery.Open;

 if FADOQuery.RecordCount<1 then exit;}
end;

procedure TMemberCardManageForm.Edit1Exit(Sender: TObject);
begin
  inherited;
{  if not FADOQuery.Active then Exit;
  if FADOQuery.RecordCount >=1 then
  begin
    Edit2.Text:= '';
    Edit2.Text:= FADOQuery.FieldByName('����').AsString;
  end;}
end;

procedure TMemberCardManageForm.btnContentClick(Sender: TObject);
begin
  inherited;
  ShowMemberInfoForm(FADOQuery);
end;

procedure TMemberCardManageForm.Edit2KeyPress(Sender: TObject;
  var Key: Char);
begin
  inherited;
  //ֻ���������ֺ�С����
  if (Key in ['0'..'9']=false) and (Key<> '.') and (key<>#8) then
    key:=#0
end;

end.
