unit BaseProjectSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseInfoSelect, PrintForm, DB, ADODB, Grids, DBGridEh, ComCtrls,
  ToolWin;

type
  TBaseProjectSelectForm = class(TBaseInfoSelectForm)
    QBaseInfoID: TAutoIncField;
    QBaseInfoDSDesigner: TWideStringField;
    QBaseInfoDSDesigner2: TWideStringField;
    QBaseInfoDSDesigner3: TIntegerField;
    QBaseInfoDSDesigner4: TWideStringField;
    QBaseInfoDSDesigner5: TWideStringField;
    QBaseInfoDSDesigner6: TBCDField;
    QBaseInfoDSDesigner7: TFloatField;
    QBaseInfoDSDesigner8: TBCDField;
    QBaseInfoDSDesigner9: TFloatField;
    QBaseInfoDSDesigner10: TFloatField;
    QBaseInfoDSDesigner11: TIntegerField;
    QBaseInfoDSDesigner12: TBooleanField;
    QBaseInfoDSDesigner13: TWideStringField;
    QBaseInfoDSDesigner14: TWideStringField;
    procedure tbSelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowBaseProjectSelectForm(ADOQryTmp: TADOQuery);

implementation

uses SysPublic;

{$R *.dfm}

procedure ShowBaseProjectSelectForm(ADOQryTmp: TADOQuery);
var
  BaseProjectSelectForm: TBaseProjectSelectForm;
begin
  BaseProjectSelectForm:= TBaseProjectSelectForm.Create(Nil);
  BaseProjectSelectForm.ADOQrySel:= ADOQryTmp;
  BaseProjectSelectForm.ShowModal;
end;

procedure TBaseProjectSelectForm.tbSelClick(Sender: TObject);
begin
  inherited;
  SetField('���,��Ŀ����,�����,�������,��Ŀ����,����,��Ŀ�ۿ�,���Ϸ���,���ϵ���,��׼��ʱ,���û���,�Ƿ���,��ע,״̬',
  '��Ŀ���,��Ŀ����,�����,�������,��Ŀ����,����,��Ŀ�ۿ�,���Ϸ���,���ϵ���,��׼��ʱ,���û���,�Ƿ���,��ע,״̬',
  ADOQrySel, QBaseInfo);
  Close;
end;

end.
