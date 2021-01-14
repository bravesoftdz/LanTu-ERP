unit SaveMoney;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseMoney, DB, ADODB, Grids, DBGridEh, ExtCtrls, StdCtrls,
  Buttons;

type
  TSaveMoneyForm = class(TBaseMoneyForm)
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    procedure Edit1Exit(Sender: TObject);
    procedure Edit3Enter(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure btnExecute1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowSaveMoneyForm;

implementation

uses SysPublic, MoneyRecord;

{$R *.dfm}

procedure ShowSaveMoneyForm;
var
  SaveMoneyForm: TSaveMoneyForm;
begin
  SaveMoneyForm:= TSaveMoneyForm.Create(Nil);
  SaveMoneyForm.ShowModal;
end;

procedure TSaveMoneyForm.Edit1Exit(Sender: TObject);
begin
  inherited;
  if not ADOQuery1.Active then Exit;
  if ADOQuery1.RecordCount <1 then exit;
  Edit2.Text:= '';
  Edit2.Text:= ADOQuery1.FieldByName('��Ա���').AsString;
end;

procedure TSaveMoneyForm.Edit3Enter(Sender: TObject);
begin
  inherited;
  if not ADOQuery1.Active then
    Exit
  else
  begin
    ADOQuery2.Close;
    ADOQuery2.SQL.Clear;
    ADOQuery2.SQL.Add('Select * From New��Ա������� where ��Ա��� =:Param1 and ����=''0''');
    ADOQuery2.Parameters.ParamByName('Param1').Value := ADOQuery1.FieldByName('��Ա���').AsString;
    ADOQuery2.Open;
  end;
end;

procedure TSaveMoneyForm.FormShow(Sender: TObject);
begin
  inherited;
  btnExecute1.Caption:= '��  ��';
  btnExecute2.Caption:= '��  ��';
end;

procedure TSaveMoneyForm.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  //ֻ���������ֺ�С����
  if (Key in ['0'..'9']=false) and (Key<> '.') and (key<>#8) then
    key:=#0
end;

procedure TSaveMoneyForm.btnExecute1Click(Sender: TObject);
var
  fEdit, fMoney, fConversion, fTotal: Double;
  ADOQryTmp :TADOQuery;
begin
  inherited;
  if not ADOQuery1.Active then exit;

  if (Trim(Edit3.Text)= '') or (StrToFloat(Trim(Edit3.Text)) <=0) then
  begin
    ShowMsg('�������ֵ�Ƿ���');
    Exit;
  end;

  ADOQryTmp:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp);

  ADOQryTmp.Close;
  ADOQryTmp.SQL.Clear;
  ADOQryTmp.SQL.Add('Select * From �Ż����ñ� Where ID=1');
  ADOQryTmp.Open;

  fMoney:= ADOQryTmp.FieldByName('���').AsFloat;
  fConversion:= ADOQryTmp.FieldByName('ת').AsFloat;

  fEdit:= StrToFloat(Edit3.Text);

  fTotal:= fEdit + trunc(fEdit/fMoney)*fConversion;

  try
  ADOQuery1.Edit;
  ADOQuery1.FieldByName('���').AsFloat:= ADOQuery1.FieldByName('���').AsFloat + fTotal;
  ADOQuery1.FieldByName('�ܴ����').AsFloat:= ADOQuery1.FieldByName('�ܴ����').AsFloat + fTotal;
  ADOQuery1.Post;
  ADOQuery2.Append;
  ADOQuery2.FieldByName('��Ա���').AsString := ADOQuery1.FieldByName('��Ա���').AsString;
  ADOQuery2.FieldByName('��Ա����').AsString := ADOQuery1.FieldByName('��Ա����').AsString;
  ADOQuery2.FieldByName('����').AsDateTime := Now;
  ADOQuery2.FieldByName('���').AsFloat := fTotal;
  ADOQuery2.FieldByName('����Ա���').AsString :=LoginEmployeCode;
  ADOQuery2.FieldByName('����Ա').AsString :=LoginEmployeName;
  ADOQuery2.FieldByName('����').AsString :='0';
  ADOQuery2.Post;
  ShowMsg('���ɹ���');
  Edit1.Text :='';
  Edit2.Text :='';
  Edit3.Text :='';
  except
     ShowMsg('���ʧ�ܣ�');
  end;
end;

procedure TSaveMoneyForm.BitBtn1Click(Sender: TObject);
begin
  inherited;
  ShowMoneyRecordForm(ADOQuery1, 0);
end;

end.
