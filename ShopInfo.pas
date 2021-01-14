unit ShopInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseInfo, PrintForm, DB, ADODB, Grids, DBGridEh, ComCtrls,
  ToolWin;

type
  TShopInfoForm = class(TBaseInfoForm)
    QBaseInfoID: TAutoIncField;
    QBaseInfoDSDesigner: TWideStringField;
    QBaseInfoDSDesigner2: TWideStringField;
    procedure QBaseInfoDSDesignerValidate(Sender: TField);
    procedure tbEdiClick(Sender: TObject);
    procedure tbInsClick(Sender: TObject);
    procedure tbDelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ShopInfoForm: TShopInfoForm;

implementation

uses SysPublic, ShopInfoEdit, Main, Unit2;

{$R *.dfm}

procedure TShopInfoForm.QBaseInfoDSDesignerValidate(Sender: TField);
begin
  inherited;
  if not IsUnique('Code',Sender.AsString) then
  begin
    ShowMsg('���ű���ظ�������������');
    abort;
  end;
end;

procedure TShopInfoForm.tbEdiClick(Sender: TObject);
begin
  inherited;
  ShowShopInfoEditForm(QBaseInfo, 'dsEdit');
end;

procedure TShopInfoForm.tbInsClick(Sender: TObject);
begin
  inherited;
  ShowShopInfoEditForm(QBaseInfo, 'dsInsert');
end;

procedure TShopInfoForm.tbDelClick(Sender: TObject);
var
  sdel:string;
  ADOQryTmp: TADOQuery;
begin
  sdel:= QBaseInfo.Fieldbyname('������').AsString;
  ADOQryTmp:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp);
  with ADOQryTmp do
  begin
    close;
    sql.Clear;
    sql.Add('select count(*) as Rec from �������� where ������='''+sdel+'''');
    open;
  end;
  if ADOQryTmp.FieldByName('Rec').AsInteger>0 then
  begin
    MsgBox('�õ�����ϵͳ�Ѿ�ʹ�ã�����ֱ��ɾ����', MB_OK);
    ADOQryTmp.Close;
    Exit;
  end;
  ADOQryTmp.Free;

  inherited;  
end;

end.
