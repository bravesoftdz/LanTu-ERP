unit PayOffCard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseCard, Buttons, StdCtrls, ADODB, DB, BaseEdit, BaseSingleEdit;

type
  TPayOffCardForm = class(TBaseCardForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    procedure Edit1Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnExecute1Click(Sender: TObject);
    procedure btnContentClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowPayOffCardForm;

implementation

uses SysPublic, MemberInfo, MemberManage;

{$R *.dfm}

procedure ShowPayOffCardForm;
var
  PayOffCardForm: TPayOffCardForm;
begin
  PayOffCardForm:= TPayOffCardForm.Create(Nil);
  PayOffCardForm.ShowModal;
end;


procedure TPayOffCardForm.Edit1Change(Sender: TObject);
begin
  inherited;
  FADOQuery.Close;
  FADOQuery.SQL.Clear;
  FADOQuery.SQL.Add('Select * From ��Ա���� where ���� =:Param');
  FADOQuery.Parameters.ParamByName('Param').Value := Edit1.Text;
  FADOQuery.Open;

  if not FADOQuery.Active then exit;
end;

procedure TPayOffCardForm.FormShow(Sender: TObject);
begin
  inherited;
  btnExecute1.Caption:= '��  ��';
  btnExecute2.Caption:= '��  ��';
end;

procedure TPayOffCardForm.btnExecute1Click(Sender: TObject);
begin
  inherited;
  if FADOQuery.IsEmpty then
  begin
    ShowMsg('ϵͳ��û�д˿��ţ�');
    Exit;
  end;
  if FADOQuery.FieldByName('����').AsString = Edit2.Text then
  begin
    FADOQuery.Edit;
    FADOQuery.FieldByName('����').AsString :='';
    FADOQuery.Post;
    ShowMsg('��Ա�˿��ɹ���');
    Close;
  end
  else
    ShowMsg('������󣬻�Ա�˿�ʧ�ܣ�');
end;

procedure TPayOffCardForm.btnContentClick(Sender: TObject);
begin
  inherited;
  ShowMemberInfoForm(FADOQuery);
end;

end.
