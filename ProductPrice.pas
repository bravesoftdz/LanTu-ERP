unit ProductPrice;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseInfo, PrintForm, DB, ADODB, Grids, DBGridEh, ComCtrls,
  ToolWin;

type
  TProductPriceForm = class(TBaseInfoForm)
    QBaseInfoID: TAutoIncField;
    QBaseInfoDSDesigner: TStringField;
    QBaseInfoDSDesigner2: TStringField;
    QBaseInfoDSDesigner3: TFloatField;
    QBaseInfoDSDesigner4: TFloatField;
    QBaseInfoDSDesigner5: TWideStringField;
    procedure tbInsClick(Sender: TObject);
    procedure tbEdiClick(Sender: TObject);
    procedure QBaseInfoBeforePost(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ProductPriceForm: TProductPriceForm;

implementation

uses SysPublic, ProductPriceEdit, Product;

{$R *.dfm}

procedure TProductPriceForm.tbInsClick(Sender: TObject);
begin
  inherited;
  ShowProductPriceEditForm(QBaseInfo, 'dsInsert');
end;

procedure TProductPriceForm.tbEdiClick(Sender: TObject);
begin
  inherited;
  ShowProductPriceEditForm(QBaseInfo, 'dsEdit');
end;

procedure TProductPriceForm.QBaseInfoBeforePost(DataSet: TDataSet);
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

end.
