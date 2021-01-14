unit ProPackage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseInfo, PrintForm, DB, ADODB, Grids, DBGridEh, ComCtrls,
  ToolWin, StdCtrls;

type
  TProPackageForm = class(TBaseInfoForm)
    QBaseInfoID: TAutoIncField;
    QBaseInfoDSDesigner: TWideStringField;
    QBaseInfoDSDesigner2: TStringField;
    QBaseInfoDSDesigner12: TWideStringField;
    QBaseInfoDSDesigner14: TIntegerField;
    QBaseInfoDSDesigner3: TWideStringField;
    QBaseInfoDSDesigner4: TWideStringField;
    QBaseInfoDSDesigner5: TWideStringField;
    QBaseInfoDSDesigner6: TBCDField;
    QBaseInfoDSDesigner7: TBCDField;
    QBaseInfoDSDesigner8: TBCDField;
    QBaseInfoDSDesigner9: TBCDField;
    QBaseInfoDSDesigner10: TBCDField;
    QBaseInfoDSDesigner11: TIntegerField;
    QBaseInfoDSDesigner13: TBooleanField;
    QBaseInfoDSDesigner15: TWideStringField;
    QBaseInfoDSDesigner16: TWideStringField;
    QBaseInfoDSDesigner17: TWideStringField;
    procedure tbInsClick(Sender: TObject);
    procedure tbEdiClick(Sender: TObject);
    procedure tbsExiClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ProPackageForm: TProPackageForm;

implementation

uses ProPackageEdit, Project;

{$R *.dfm}

procedure TProPackageForm.tbInsClick(Sender: TObject);
begin
  inherited;
    ShowProPackageEditForm(QBaseInfo, 'dsInsert');
end;

procedure TProPackageForm.tbEdiClick(Sender: TObject);
begin
  inherited;
  ShowProPackageEditForm(QBaseInfo, 'dsEdit');
end;

procedure TProPackageForm.tbsExiClick(Sender: TObject);
var
  AColumn: TColumnEh;
  t: TStringField;
begin
  inherited;

  //��̬���������ֶ�,wangchw��2004-11-11���
{  QBaseInfo.Close;
  t := TStringField.Create(QBaseInfo);
  t.FieldKind := fkLookup;
  t.FieldName := '��Ŀ�ۿ�';
  t.Size := 20;
  t.LookupDataSet := adoquery1;
  t.LookupKeyFields := '��Ŀ���';
  t.KeyFields := '��Ŀ���';
  t.LookupResultField := '��Ŀ�ۿ�';
  t.DisplayLabel := '��Ŀ�ۿ�';
  t.DataSet := QBaseInfo;
  QBaseInfo.Open;

  AColumn := DBGridEh1.Columns.Add;
  AColumn.FieldName := QBaseInfo.FieldByName('��Ŀ�ۿ�').FieldName; }

end;

end.
