unit MemberManage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseInfo1, PrintForm, DB, ADODB, ExtCtrls, Grids, DBGridEh,
  ComCtrls, ToolWin, StdCtrls, Buttons, PropStorageEh;

type
  TMemberManageForm = class(TBaseInfo1Form)
    QBaseInfoID: TAutoIncField;
    QBaseInfoDSDesigner: TStringField;
    QBaseInfoDSDesigner2: TStringField;
    QBaseInfoDSDesigner3: TDateTimeField;
    QBaseInfoDSDesigner6: TDateTimeField;
    QBaseInfoDSDesigner7: TDateTimeField;
    QBaseInfoDSDesigner8: TStringField;
    QBaseInfoDSDesigner10: TStringField;
    QBaseInfoDSDesigner11: TStringField;
    QBaseInfoDSDesigner12: TStringField;
    QBaseInfoDSDesigner13: TStringField;
    QBaseInfoDSDesigner14: TStringField;
    BitBtn1: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    QBaseInfoDSDesigner4: TBCDField;
    QBaseInfoDSDesigner15: TBCDField;
    QBaseInfoDSDesigner16: TIntegerField;
    QBaseInfoDSDesigner17: TBCDField;
    QBaseInfoDSDesigner19: TBCDField;
    QBaseInfoDSDesigner20: TWideStringField;
    QBaseInfoDSDesigner21: TBCDField;
    QBaseInfoDSDesigner22: TWideStringField;
    QBaseInfoDSDesigner9: TWideStringField;
    QBaseInfoDSDesigner5: TWideStringField;
    QBaseInfoDSDesigner18: TWideStringField;
    procedure QBaseInfoDSDesignerValidate(Sender: TField);
    procedure tbInsClick(Sender: TObject);
    procedure tbEdiClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure tbRefClick(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure QBaseInfoBeforePost(DataSet: TDataSet);
    procedure tbDelClick(Sender: TObject);
    procedure tbFinClick(Sender: TObject);
    procedure tbsFitClick(Sender: TObject);
    procedure tbsPriClick(Sender: TObject);
    procedure tbsSavClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MemberManageForm: TMemberManageForm;

implementation

uses SysPublic, MemberManageEdit, MemberCardManage, SuppleCard, PayOffCard, SumExpense, PassMoney,
  SaveMoney, LoseMoney, PlanOperation;

{$R *.dfm}

procedure TMemberManageForm.QBaseInfoDSDesignerValidate(Sender: TField);
begin
  inherited;
  if not IsUnique('Code',Sender.AsString) then
  begin
    showmessage('��Ա����ظ�������������');
    abort;
  end;
end;

procedure TMemberManageForm.tbInsClick(Sender: TObject);
begin
  inherited;

  if not SysRightLimit('MemberManageForm', lInsert) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  ShowMemberManageEditForm(QBaseInfo, 'dsInsert');
end;

procedure TMemberManageForm.tbEdiClick(Sender: TObject);
begin
  inherited;

  if not SysRightLimit('MemberManageForm', lEdit) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  ShowMemberManageEditForm(QBaseInfo, 'dsEdit');
end;

procedure TMemberManageForm.BitBtn1Click(Sender: TObject);
begin
  inherited;
  ShowMemberCardManageForm(QBaseInfo);
end;

procedure TMemberManageForm.tbRefClick(Sender: TObject);
begin
  inherited;
  QBaseInfo.Close;
  QBaseInfo.SQL.Clear;
  QBaseInfo.SQL.Add('Select * From ��Ա���� Order by ID');  
  QBaseInfo.Open;
end;

procedure TMemberManageForm.BitBtn7Click(Sender: TObject);
begin
  inherited;
  ShowSumExpenseForm(QBaseInfo);
end;

procedure TMemberManageForm.BitBtn6Click(Sender: TObject);
begin
  inherited;
  OpenForm(TPlanOperationForm, PlanOperationForm, Self);
end;

procedure TMemberManageForm.QBaseInfoBeforePost(DataSet: TDataSet);
var
  S: string;
  ADOQryTmp: TADOQuery;
begin
  inherited;
  S:= QBaseInfo.FieldByName('�������').AsString;
  ADOQryTmp:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp);
  ADOQryTmp.Close;
  ADOQryTmp.SQL.Clear;
  ADOQryTmp.SQL.Add('Select * From ��Ա���� where �������=' + QuotedStr(S));
  ADOQryTmp.Open;

  QBaseInfo.FieldByName('��������').AsString := ADOQryTmp.FieldByName('��������').AsString;

  ADOQryTmp.Close;
  ADOQryTmp.Free;
end;

procedure TMemberManageForm.tbDelClick(Sender: TObject);
begin

  if not SysRightLimit('MemberManageForm', lDelete) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  inherited;

end;

procedure TMemberManageForm.tbFinClick(Sender: TObject);
begin

  if not SysRightLimit('MemberManageForm', lFind) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  inherited;

end;

procedure TMemberManageForm.tbsFitClick(Sender: TObject);
begin


  if not SysRightLimit('MemberManageForm', lFilter) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  inherited;

end;

procedure TMemberManageForm.tbsPriClick(Sender: TObject);
begin

  if not SysRightLimit('MemberManageForm', lPrint) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  inherited;

end;

procedure TMemberManageForm.tbsSavClick(Sender: TObject);
begin

  if not SysRightLimit('MemberManageForm', lExport) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  inherited;

end;

end.
