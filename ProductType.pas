unit ProductType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, Grids, DBGridEh, ComCtrls, ToolWin, BaseInfo, BaseEdit,
  PrintForm;

type
  TProductTypeForm = class(TBaseInfoForm)
    QBaseInfoID: TAutoIncField;
    QBaseInfoDSDesigner: TStringField;
    QBaseInfoDSDesigner2: TStringField;
    QBaseInfoDSDesigner3: TStringField;
    procedure tbInsClick(Sender: TObject);
    procedure tbEdiClick(Sender: TObject);
    procedure QBaseInfoDSDesignerValidate(Sender: TField);
    procedure tbDelClick(Sender: TObject);
    procedure tbFinClick(Sender: TObject);
    procedure tbsFitClick(Sender: TObject);
    procedure tbsPriClick(Sender: TObject);
    procedure tbsSavClick(Sender: TObject);
    procedure QBaseInfoNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
  protected

  public
    { Public declarations }
  end;

var
  ProductTypeForm: TProductTypeForm;

implementation

uses SysPublic, ProductTypeEdit;

{$R *.dfm}

procedure TProductTypeForm.tbInsClick(Sender: TObject);
begin
  inherited;

  if not SysRightLimit('ProductTypeForm', lInsert) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  ShowProductTypeEditForm(QBaseInfo, 'dsInsert');
end;

procedure TProductTypeForm.tbEdiClick(Sender: TObject);
begin
  inherited;

  if not SysRightLimit('ProductTypeForm', lEdit) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  ShowProductTypeEditForm(QBaseInfo, 'dsEdit');
end;

procedure TProductTypeForm.QBaseInfoDSDesignerValidate(Sender: TField);
begin
  inherited;
  if not IsUnique('Code',Sender.AsString) then
  begin
    showmessage('������ظ�������������');
    abort;
  end;
end;

procedure TProductTypeForm.tbDelClick(Sender: TObject);
var
  sdel:string;
  ADOQryTmp: TADOQuery;
begin

  if not SysRightLimit('ProductTypeForm', lDelete) then
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
    sql.Add('select count(*) as Rec from ��Ʒ���� where �����='''+sdel+'''');
    open;
  end;
  if ADOQryTmp.FieldByName('Rec').AsInteger>0 then
  begin
    MsgBox('�ò�Ʒ�����ϵͳ�Ѿ�ʹ�ã�����ֱ��ɾ����', MB_OK);
    ADOQryTmp.Close;
    Exit;
  end;
  ADOQryTmp.Free;
  inherited;

end;

procedure TProductTypeForm.tbFinClick(Sender: TObject);
begin

  if not SysRightLimit('ProductTypeForm', lFind) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  inherited;

end;

procedure TProductTypeForm.tbsFitClick(Sender: TObject);
begin

  if not SysRightLimit('ProductTypeForm', lFilter) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  inherited;

end;

procedure TProductTypeForm.tbsPriClick(Sender: TObject);
begin

  if not SysRightLimit('ProductTypeForm', lPrint) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  inherited;

end;

procedure TProductTypeForm.tbsSavClick(Sender: TObject);
begin

  if not SysRightLimit('ProductTypeForm', lExport) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  inherited;

end;

procedure TProductTypeForm.QBaseInfoNewRecord(DataSet: TDataSet);
begin
  inherited;
  QBaseInfo.FieldByName('�����').AsString:= SetID('cp','�����', '��Ʒ���', 3,6);
end;

end.
