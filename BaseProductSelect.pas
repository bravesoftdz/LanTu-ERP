unit BaseProductSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseInfoSelect, PrintForm, DB, ADODB, Grids, DBGridEh, ComCtrls,
  ToolWin;

type
  TBaseProductSelectForm = class(TBaseInfoSelectForm)
    procedure tbSelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowBaseProductSelectForm(ADOQryTmp: TADOQuery);

implementation

uses SysPublic;

{$R *.dfm}

procedure ShowBaseProductSelectForm(ADOQryTmp: TADOQuery);
var
  BaseProductSelectForm: TBaseProductSelectForm;
begin
  BaseProductSelectForm:= TBaseProductSelectForm.Create(Nil);
  BaseProductSelectForm.ADOQrySel:= ADOQryTmp;
  BaseProductSelectForm.ShowModal;
end;

procedure TBaseProductSelectForm.tbSelClick(Sender: TObject);
begin
  inherited;
  SetField('���,��Ʒ����,�����,�������,���ۼ�,��Ʒ����,������,�ɱ���,��������,ȱ������,��Ʒ�ۿ�,���û���,�Ƿ���,��ע,״̬',
  '��Ʒ���,��Ʒ����,�����,�������,���ۼ�,��Ʒ����,������,�ɱ���,��������,ȱ������,��Ʒ�ۿ�,���û���,�Ƿ���,��ע,״̬',
  ADOQrySel, QBaseInfo);
  Close;
end;

end.
