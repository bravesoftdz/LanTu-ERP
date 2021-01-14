unit SumExpense;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseSingleEdit, Buttons, StdCtrls, Mask, DBCtrls, ADODB, DB,
  BaseEdit;

type
  TSumExpenseForm = class(TBaseSingleEditForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Label4: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    bbCard: TBitBtn;
    bbNO: TBitBtn;
    Edit4: TEdit;
    procedure Edit1Change(Sender: TObject);
    procedure bbCardClick(Sender: TObject);
    procedure Edit3Exit(Sender: TObject);
    procedure bbNOClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowSumExpenseForm(ADOQuery: TADOQuery);

implementation

uses SysPublic, MemberManage;

{$R *.dfm}

procedure ShowSumExpenseForm(ADOQuery: TADOQuery);
var
  SumExpenseForm: TSumExpenseForm;
begin
  SumExpenseForm:= TSumExpenseForm.Create(Nil);
  SumExpenseForm.FADOQuery:= ADOQuery;
  SumExpenseForm.FADOQuery.Edit;
  SumExpenseForm.ShowModal;
end;

procedure TSumExpenseForm.Edit1Change(Sender: TObject);
begin
  inherited;
  FADOQuery.Close;
  FADOQuery.SQL.Clear;
  FADOQuery.SQL.Add('Select * From ��Ա���� where ���� like :Param');
  FADOQuery.Parameters.ParamByName('Param').Value := '%'+Trim(Edit1.Text)+'%';
  FADOQuery.Open;
end;

procedure TSumExpenseForm.bbCardClick(Sender: TObject);
begin
  inherited;
  if FADOQuery.IsEmpty then
  begin
    ShowMsg('ϵͳ��û�д˿��ţ�');
    Exit;
  end;
  if (Trim(Edit4.Text)='') or (StrToFloat(Trim(Edit4.Text ))<=0) then
  begin
    ShowMsg('�������ѻ��ֲ��Ϸ���');
    Exit;
  end;
  if FADOQuery.FieldByName('����').AsString = Trim(Edit2.Text) then
  begin
    FADOQuery.Edit;
    FADOQuery.FieldByName('����').AsFloat := FADOQuery.FieldByName('����').AsFloat- StrToFloat(Edit4.Text);
    FADOQuery.Post;
    ShowMsg('�������ѳɹ���');
    Close;
  end
  else
    ShowMsg('������󣬻�Ա�˿�ʧ�ܣ�');
end;

procedure TSumExpenseForm.Edit3Exit(Sender: TObject);
begin
  inherited;
  Edit3.Text := FloatToStr(FADOQuery.FieldByName('����').AsFloat);
end;

procedure TSumExpenseForm.bbNOClick(Sender: TObject);
begin
  inherited;
  Close;
end;

end.
