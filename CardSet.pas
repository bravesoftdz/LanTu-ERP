unit CardSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseInfo, PrintForm, DB, ADODB, Grids, DBGridEh, ComCtrls,
  ToolWin, FR_Desgn;

type
  TCardSetForm = class(TBaseInfoForm)
    QBaseInfoID: TAutoIncField;
    QBaseInfoDSDesigner2: TWideStringField;
    QBaseInfoDSDesigner3: TFloatField;
    QBaseInfoDSDesigner4: TFloatField;
    QBaseInfoDSDesigner5: TWideStringField;
    QBaseInfoDSDesigner6: TBCDField;
    QBaseInfoDSDesigner7: TBCDField;
    QBaseInfoDSDesigner: TWideStringField;
    QBaseInfoDSDesigner8: TIntegerField;
    QBaseInfoDSDesigner9: TIntegerField;
    QBaseInfoDSDesigner10: TBooleanField;
    QBaseInfoDSDesigner11: TBooleanField;
    QBaseInfoDSDesigner12: TBooleanField;
    QBaseInfoDSDesigner13: TBooleanField;
    QBaseInfoDSDesigner14: TBooleanField;
    QBaseInfoDSDesigner15: TBooleanField;
    QBaseInfoDSDesigner16: TBooleanField;
    QBaseInfoDSDesigner17: TBooleanField;
    procedure QBaseInfoDSDesignerValidate(Sender: TField);
    procedure tbInsClick(Sender: TObject);
    procedure tbEdiClick(Sender: TObject);
    procedure tbDelClick(Sender: TObject);
    procedure tbFinClick(Sender: TObject);
    procedure tbsFitClick(Sender: TObject);
    procedure tbsPriClick(Sender: TObject);
    procedure tbsSavClick(Sender: TObject);
    procedure QBaseInfoBeforePost(DataSet: TDataSet);
    procedure QBaseInfoDSDesigner10GetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure QBaseInfoDSDesigner11SetText(Sender: TField;
      const Text: String);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CardSetForm: TCardSetForm;

implementation

uses SysPublic, CardSetEdit;

{$R *.dfm}

procedure TCardSetForm.QBaseInfoDSDesignerValidate(Sender: TField);
begin
  inherited;
  if not IsUnique('Code',Sender.AsString) then
  begin
    showmessage('��������ظ�������������');
    abort;
  end;
end;

procedure TCardSetForm.tbInsClick(Sender: TObject);
begin
  inherited;
  if not SysRightLimit('CardSetForm', lInsert) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  ShowCardSetEditForm(QBaseInfo, 'dsInsert');
end;

procedure TCardSetForm.tbEdiClick(Sender: TObject);
begin
  inherited;
  if not SysRightLimit('CardSetForm', lEdit) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  ShowCardSetEditForm(QBaseInfo, 'dsEdit');
end;

procedure TCardSetForm.tbDelClick(Sender: TObject);
var
  sdel:string;
  ADOQryTmp1, ADOQryTmp2: TADOQuery;
begin
  if not SysRightLimit('CardSetForm', lDelete) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  sdel:= QBaseInfo.Fieldbyname('�������').AsString;
  ADOQryTmp1:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp1);
  with ADOQryTmp1 do
  begin
    close;
    sql.Clear;
    sql.Add('select count(*) as Rec from ��Ŀ�����۸� where �������='''+sdel+'''');
    open;
  end;
  if ADOQryTmp1.FieldByName('Rec').AsInteger>0 then
  begin
    MsgBox('�ÿ����������Ŀ���Ѿ�ʹ�ã�����ֱ��ɾ����', MB_OK);
    ADOQryTmp1.Close;
    Exit;
  end;
  ADOQryTmp1.Free;

  ADOQryTmp2:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp2);
  with ADOQryTmp2 do
  begin
    close;
    sql.Clear;
    sql.Add('select count(*) as Rec from ��Ʒ�����۸� where �������='''+sdel+'''');
    open;
  end;
  if ADOQryTmp2.FieldByName('Rec').AsInteger>0 then
  begin
    MsgBox('�ÿ�������ڲ�Ʒ���Ѿ�ʹ�ã�����ֱ��ɾ����', MB_OK);
    ADOQryTmp2.Close;
    Exit;
  end;
  ADOQryTmp2.Free;
  inherited;

end;

procedure TCardSetForm.tbFinClick(Sender: TObject);
begin
  if not SysRightLimit('CardSetForm', lFind) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  inherited;

end;

procedure TCardSetForm.tbsFitClick(Sender: TObject);
begin

  if not SysRightLimit('CardSetForm', lFilter) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;
  inherited;

end;

procedure TCardSetForm.tbsPriClick(Sender: TObject);
begin
  if not SysRightLimit('CardSetForm', lPrint) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;
  inherited;

end;

procedure TCardSetForm.tbsSavClick(Sender: TObject);
begin
  if not SysRightLimit('CardSetForm', lExport) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;
  inherited;

end;

procedure TCardSetForm.QBaseInfoBeforePost(DataSet: TDataSet);
begin
  inherited;
  if (QBaseInfo.FieldByName('����').AsBoolean= False) and
    (QBaseInfo.FieldByName('Ԥ�����ܴ���').AsBoolean= False) and
    (QBaseInfo.FieldByName('���ֻ���Ʒ').AsBoolean= False) and
    (QBaseInfo.FieldByName('�����Ż�').AsBoolean= False) and
    (QBaseInfo.FieldByName('���ѷ���').AsBoolean= False) and
    (QBaseInfo.FieldByName('����/����').AsBoolean= False) and
    (QBaseInfo.FieldByName('�������').AsBoolean= False) and
    (QBaseInfo.FieldByName('��Ա����').AsBoolean= False) then
    begin
      ShowMsg('����ѡ��һ��Ӫ������');
      Abort;
    end;
end;

procedure TCardSetForm.QBaseInfoDSDesigner10GetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  inherited;
  if sender.AsBoolean= True then
    text:='��'
  else
    text:='��';
end;

procedure TCardSetForm.QBaseInfoDSDesigner11SetText(Sender: TField;
  const Text: String);
begin
  inherited;
  if Text ='��' then
    Sender.AsBoolean:= True
  else
    Sender.AsBoolean := False;
end;

end.
