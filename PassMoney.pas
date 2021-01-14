unit PassMoney;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseCard, Buttons, ExtCtrls, StdCtrls, DB, ADODB, BaseEdit,
  BaseSingleEdit;

type
  TPassMoneyForm = class(TBaseCardForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    Edit5: TEdit;
    Label6: TLabel;
    Edit6: TEdit;
    ADOQryOut: TADOQuery;
    ADOQryIn: TADOQuery;
    procedure Edit1Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnExecute1Click(Sender: TObject);
    procedure Edit6KeyPress(Sender: TObject; var Key: Char);
    procedure btnContentClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowPassMoneyForm;

implementation

uses SysPublic, DataM, MemberInfo;

{$R *.dfm}

procedure ShowPassMoneyForm;
var
  PassMoneyForm: TPassMoneyForm;
begin
  PassMoneyForm:= TPassMoneyForm.Create(Nil);
  PassMoneyForm.ShowModal;
end;

procedure TPassMoneyForm.Edit1Change(Sender: TObject);
begin
  inherited;
  ADOQryOut.Close;
  ADOQryOut.SQL.Clear;
  ADOQryOut.SQL.Add('Select * From ��Ա���� where ���� like :Param');
  ADOQryOut.Parameters.ParamByName('Param').Value := '%'+Trim(Edit1.Text)+'%';
  ADOQryOut.Open;
  Edit2.Text:= ADOQryOut.FieldByName('��Ա���').AsString;
end;

procedure TPassMoneyForm.Edit4Change(Sender: TObject);
begin
  inherited;
  ADOQryIn.Close;
  ADOQryIn.SQL.Clear;
  ADOQryIn.SQL.Add('Select * From ��Ա���� where ���� like :Param');
  ADOQryIn.Parameters.ParamByName('Param').Value := '%'+Trim(Edit4.Text)+'%';
  ADOQryIn.Open;
  Edit5.Text:= ADOQryIn.FieldByName('��Ա���').AsString;
end;

procedure TPassMoneyForm.FormShow(Sender: TObject);
begin
  inherited;
  btnExecute1.Caption :='ת  ��';
  btnExecute2.Caption:='��  ��';
end;

procedure TPassMoneyForm.btnExecute1Click(Sender: TObject);
var
  DMoney: Currency;
begin
  inherited;

 if not ADOQryOut.Active then
  begin
    ShowMsg('������ת����Ա����!');
    Exit;
  end;

  if not ADOQryIn.Active then
  begin
    ShowMsg('������ת���Ա����!');
    Exit;
  end;

  if ADOQryOut.FieldByName('��Ա���').AsString ='' then
  begin
    ShowMsg('û��ת����Ա!');
    Exit;
  end;

  if ADOQryIn.FieldByName('��Ա���').AsString ='' then
  begin
    ShowMsg('û��ת���Ա!');
    Exit;
  end;


  if Edit3.Text <> ADOQryOut.FieldByName('����').AsString then
  begin
    ShowMsg('�����������');
    Exit;
  end;
  if (Trim(Edit6.Text)='') or (StrToFloat(Trim(Edit6.Text))<=0) then
  begin
    ShowMsg('�������ݲ��Ϸ���');
    Exit;
  end;
  try
    DMoney:= StrToFloat(Edit6.Text);
    ADOQryOut.Edit;
    ADOQryOut.FieldByName('���').AsFloat:= ADOQryOut.FieldByName('���').AsFloat
      -DMoney;
    ADOQryOut.Post;
    ADOQryIn.Edit;
    ADOQryIn.FieldByName('���').AsFloat :=ADOQryIn.FieldByName('���').AsFloat
      + DMoney;
    ADOQryIn.Post;
      ShowMsg('ת�ʳɹ���');
    Close;
  except
    ShowMsg('ת��ʧ�ܣ�');
  end;

//  if
end;

procedure TPassMoneyForm.Edit6KeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  //ֻ���������ֺ�С����
  if (Key in ['0'..'9']=false) and (Key<> '.') and (key<>#8) then
    key:=#0
end;

procedure TPassMoneyForm.btnContentClick(Sender: TObject);
begin
  inherited;
  ShowMemberInfoForm(ADOQryOut);
end;

end.
