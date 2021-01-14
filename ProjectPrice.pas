unit ProjectPrice;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseInfo, PrintForm, DB, ADODB, Grids, DBGridEh, ComCtrls,
  ToolWin;

type
  TProjectPriceForm = class(TBaseInfoForm)
    QBaseInfoID: TAutoIncField;
    QBaseInfoDSDesigner: TStringField;
    QBaseInfoDSDesigner3: TFloatField;
    QBaseInfoDSDesigner4: TFloatField;
    QBaseInfoDSDesigner2: TStringField;
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
  ProjectPriceForm: TProjectPriceForm;

implementation

uses SysPublic, ProjectPriceEdit;

{$R *.dfm}

procedure TProjectPriceForm.tbInsClick(Sender: TObject);
begin
  inherited;
  ShowProjectPriceEditForm(QBaseInfo, 'dsInsert');
end;

procedure TProjectPriceForm.tbEdiClick(Sender: TObject);
begin
  inherited;
  ShowProjectPriceEditForm(QBaseInfo, 'dsEdit');
end;

procedure TProjectPriceForm.QBaseInfoBeforePost(DataSet: TDataSet);
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
