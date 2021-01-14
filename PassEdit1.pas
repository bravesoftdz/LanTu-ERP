unit PassEdit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseNormal, StdCtrls, Buttons, ADODB;

type
  TPassEdit1Form = class(TBaseNormalForm)
    Edit1: TEdit;
    Label1: TLabel;
    bbOk: TBitBtn;
    bbNo: TBitBtn;
    procedure bbNoClick(Sender: TObject);
    procedure bbOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FADOQryTmp: TADOQuery;
  public
    { Public declarations }
  end;

procedure ShowPassEdit1Form(ADOQryTmp: TADOQuery);

implementation

uses SysPublic;

{$R *.dfm}

procedure ShowPassEdit1Form(ADOQryTmp: TADOQuery);
var
  PassEdit1Form: TPassEdit1Form;
begin
  PassEdit1Form:= TPassEdit1Form.Create(Nil);
  PassEdit1Form.FADOQryTmp:= ADOQryTmp;
  PassEdit1Form.ShowModal;
end;

procedure TPassEdit1Form.bbNoClick(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TPassEdit1Form.bbOkClick(Sender: TObject);
begin
  inherited;
  try
    FADOQryTmp.Edit;
    FADOQryTmp.FieldByName('Ա������').AsString := EncryptPassword(Trim(Edit1.Text));
    FADOQryTmp.Post;
    ShowMsg('�����޸ĳɹ���');
    Close;
  except
  end;
end;

procedure TPassEdit1Form.FormCreate(Sender: TObject);
begin
  inherited;
  bOperateLog:= False;
end;

end.
