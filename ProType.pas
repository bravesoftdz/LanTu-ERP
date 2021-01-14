unit ProType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseInfo, PrintForm, DB, ADODB, Grids, DBGridEh, ComCtrls,
  ToolWin;

type
  TProTypeForm = class(TBaseInfoForm)
    QBaseInfoID: TAutoIncField;
    QBaseInfoDSDesigner: TWideStringField;
    QBaseInfoDSDesigner2: TWideStringField;
    QBaseInfoDSDesigner3: TWideStringField;
    procedure QBaseInfoDSDesignerValidate(Sender: TField);
    procedure tbInsClick(Sender: TObject);
    procedure tbEdiClick(Sender: TObject);
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
  ProTypeForm: TProTypeForm;

implementation

{$R *.dfm}

uses SysPublic, ProTypeEdit;

procedure TProTypeForm.QBaseInfoDSDesignerValidate(Sender: TField);
begin
  inherited;
  if not IsUnique('Code',Sender.AsString) then
  begin
    showmessage('������ظ�������������');
    abort;
  end;
end;

procedure TProTypeForm.tbInsClick(Sender: TObject);
begin
  inherited;
  if not SysRightLimit('ProTypeForm', lInsert) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  ShowProTypeEditForm(QBaseInfo, 'dsInsert');
end;

procedure TProTypeForm.tbEdiClick(Sender: TObject);
begin
  inherited;
  if not SysRightLimit('ProTypeForm', lEdit) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  ShowProTypeEditForm(QBaseInfo, 'dsEdit');
end;

procedure TProTypeForm.tbDelClick(Sender: TObject);
var
  sdel:string;
  ADOQryTmp: TADOQuery;
begin
  if not SysRightLimit('ProTypeForm', lDelete) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  sdel:= QBaseInfo.Fieldbyname('�����').AsString;
  ADOQryTmp:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp);
  with ADOQryTmp do
  begin
    close;
    sql.Clear;
    sql.Add('select count(*) as Rec from ������Ŀ where �����='''+sdel+'''');
    open;
  end;
  if ADOQryTmp.FieldByName('Rec').AsInteger>0 then
  begin
    MsgBox('���������ϵͳ�Ѿ�ʹ�ã�����ֱ��ɾ����', MB_OK);
    ADOQryTmp.Close;
    Exit;
  end;
  ADOQryTmp.Free;
  inherited;

end;

procedure TProTypeForm.tbFinClick(Sender: TObject);
begin
  if not SysRightLimit('ProTypeForm', lFind) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  inherited;

end;

procedure TProTypeForm.tbsFitClick(Sender: TObject);
begin

  if not SysRightLimit('ProTypeForm', lFilter) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;
  inherited;

end;

procedure TProTypeForm.tbsPriClick(Sender: TObject);
begin
  if not SysRightLimit('ProTypeForm', lPrint) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  inherited;

end;

procedure TProTypeForm.tbsSavClick(Sender: TObject);
begin
  if not SysRightLimit('ProTypeForm', lExport) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;
  inherited;

end;

end.
