unit Product;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseInfo1, DB, ADODB, Grids, DBGridEh, ComCtrls, ToolWin,
  PrintForm, BaseInfo, StdCtrls, Buttons, ExtCtrls;

type
  TProductForm = class(TBaseInfo1Form)
    QBaseInfoID: TAutoIncField;
    QBaseInfoDSDesigner: TStringField;
    QBaseInfoDSDesigner2: TStringField;
    QBaseInfoDSDesigner4: TBCDField;
    QBaseInfoDSDesigner5: TStringField;
    QBaseInfoDSDesigner7: TBCDField;
    QBaseInfoDSDesigner8: TIntegerField;
    QBaseInfoDSDesigner9: TIntegerField;
    QBaseInfoDSDesigner12: TStringField;
    QBaseInfoDSDesigner13: TStringField;
    btnPrice: TBitBtn;
    QBaseInfoDSDesigner11: TIntegerField;
    btnpackage: TBitBtn;
    QBaseInfoDSDesigner14: TBooleanField;
    QBaseInfoDSDesigner10: TFloatField;
    QBaseInfoDSDesigner3: TIntegerField;
    QBaseInfoDSDesigner15: TWideStringField;
    QBaseInfoDSDesigner6: TIntegerField;
    procedure tbInsClick(Sender: TObject);
    procedure tbEdiClick(Sender: TObject);
    procedure QBaseInfoDSDesignerValidate(Sender: TField);
    procedure btnPriceClick(Sender: TObject);
    procedure dsBaseInfoDataChange(Sender: TObject; Field: TField);
    procedure btnpackageClick(Sender: TObject);
    procedure QBaseInfoBeforePost(DataSet: TDataSet);
    procedure tbDelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tbFinClick(Sender: TObject);
    procedure tbsFitClick(Sender: TObject);
    procedure tbsPriClick(Sender: TObject);
    procedure tbsSavClick(Sender: TObject);
    procedure QBaseInfoDSDesigner14GetText(Sender: TField;
      var Text: String; DisplayText: Boolean);
    procedure QBaseInfoDSDesigner14SetText(Sender: TField;
      const Text: String);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  ProductForm: TProductForm;

implementation

uses ProductEdit, SysPublic, ProductPrice, ProductPackage;

{$R *.dfm}

{ TProductForm }


procedure TProductForm.tbInsClick(Sender: TObject);
begin
  inherited;

  if not SysRightLimit('ProductForm', lInsert) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  ShowProductEditForm(QBaseInfo, 'dsInsert');
end;

procedure TProductForm.tbEdiClick(Sender: TObject);
begin
  inherited;

  if not SysRightLimit('ProductForm', lEdit) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  ShowProductEditForm(QBaseInfo, 'dsEdit');
end;

procedure TProductForm.QBaseInfoDSDesignerValidate(Sender: TField);
begin
  inherited;
  if not IsUnique('Code',Sender.AsString) then
  begin
    showmessage('��Ʒ����ظ�������������');
    abort;
  end;
end;

procedure TProductForm.btnPriceClick(Sender: TObject);
begin
  inherited;
  OpenForm(TProductPriceForm, ProductPriceForm, Self);
end;

procedure TProductForm.dsBaseInfoDataChange(Sender: TObject;
  Field: TField);
begin
  inherited;
  btnpackage.Enabled:= QBaseInfo.FieldByName('�Ƿ���').AsBoolean;  
end;

procedure TProductForm.btnpackageClick(Sender: TObject);
begin
  inherited;
  OpenForm(TProductPackageForm, ProductPackageForm, Self);
end;

procedure TProductForm.QBaseInfoBeforePost(DataSet: TDataSet);
var
  S: string;
  ADOQryTmp: TADOQuery;
begin
  inherited;
  S:= QBaseInfo.FieldByName('�����').AsString;
  ADOQryTmp:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp);
  ADOQryTmp.Close;
  ADOQryTmp.SQL.Clear;
  ADOQryTmp.SQL.Add('Select * From ��Ʒ��� where ID=' + QuotedStr(S));
  ADOQryTmp.Open;

  QBaseInfo.FieldByName('�������').AsString := ADOQryTmp.FieldByName('�������').AsString;

  ADOQryTmp.Close;
  ADOQryTmp.Free;
end;

procedure TProductForm.tbDelClick(Sender: TObject);
var
  sdel:string;
  ADOQryTmp: TADOQuery;
begin

  if not SysRightLimit('ProductForm', lDelete) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  sdel:= QBaseInfo.Fieldbyname('��Ʒ���').AsString;
  ADOQryTmp:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp);
  with ADOQryTmp do
  begin
    close;
    sql.Clear;
    sql.Add('select count(*) as Rec from ��Ʒ���ϰ� where ���='''+sdel+'''');
    open;
  end;
  if ADOQryTmp.FieldByName('Rec').AsInteger>0 then
  begin
    MsgBox('�ò�Ʒ��ϵͳ�Ѿ�ʹ�ã�����ֱ��ɾ����', MB_OK);
    ADOQryTmp.Close;
    Exit;
  end;
  ADOQryTmp.Free;
  inherited;

end;

procedure TProductForm.FormShow(Sender: TObject);
begin
  inherited;

  //  StrToGridField(DBGridEh1, '��Ʒ���,��Ʒ����,�������','��Ʒ���,��Ʒ����,�������', '165,165,165');
end;

procedure TProductForm.tbFinClick(Sender: TObject);
begin

  if not SysRightLimit('ProductForm', lFind) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  inherited;

end;

procedure TProductForm.tbsFitClick(Sender: TObject);
begin

  if not SysRightLimit('ProductForm', lFilter) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  inherited;

end;

procedure TProductForm.tbsPriClick(Sender: TObject);
begin

  if not SysRightLimit('ProductForm', lPrint) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  inherited;

end;

procedure TProductForm.tbsSavClick(Sender: TObject);
begin

  if not SysRightLimit('ProductForm', lExport) then
  begin
    ShowMsg('�Բ�����û��Ȩ��ʹ�ô˹��ܣ�');
    Exit;
  end;

  inherited;

end;

procedure TProductForm.QBaseInfoDSDesigner14GetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  inherited;
  if sender.AsBoolean= True then 
    text:='��'
  else
    text:='��';
end;

procedure TProductForm.QBaseInfoDSDesigner14SetText(Sender: TField;
  const Text: String);
begin
  inherited;
  if Text ='��' then
    Sender.AsBoolean:= True
  else
    Sender.AsBoolean := False;
end;

end.
