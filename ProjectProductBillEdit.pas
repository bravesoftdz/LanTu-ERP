unit ProjectProductBillEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseNormal, ExtCtrls, Grids, DBGridEh, ComCtrls, StdCtrls, Mask,
  DBCtrls, ADODB, Buttons, DB, DBCtrlsEh, DBLookupEh;

type
  TProjectProductBillEditForm = class(TBaseNormalForm)
    Panel1: TPanel;
    Panel2: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DBGridEh1: TDBGridEh;
    DBGridEh2: TDBGridEh;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    DBEditEh1: TDBEditEh;
    DBDateTimeEditEh1: TDBDateTimeEditEh;
    DBEditEh4: TDBEditEh;
    Edit1: TEdit;
    DBEditEh2: TDBEditEh;
    Label6: TLabel;
    DBEditEh3: TDBEditEh;
    ADOQryTmp: TADOQuery;
    Ado_insert: TADOQuery;
    procedure DBGridEh2Columns2EditButtonClick(Sender: TObject;
      var Handled: Boolean);
    procedure DBGridEh1Columns2EditButtonClick(Sender: TObject;
      var Handled: Boolean);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure DBGridEh1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure DBGridEh2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure DBGridEh1Enter(Sender: TObject);
    procedure DBGridEh2Enter(Sender: TObject);
  private
    { Private declarations }

  protected
    ADOMaster, ADOProject, ADOProduct: TADOQuery;
  public
    { Public declarations }
  end;

procedure ShowProjectProductBillEditForm(ADOMaster1, ADOList1, ADOList2: TADOQuery; State1: string);

implementation

uses SysPublic, DataM, ProjectProductBill, ProductSelect, ProjectSelect;

{$R *.dfm}

procedure ShowProjectProductBillEditForm(ADOMaster1, ADOList1, ADOList2: TADOQuery; State1: string);
var
  ProjectProductBillEditForm: TProjectProductBillEditForm;
begin
  ProjectProductBillEditForm:= TProjectProductBillEditForm.Create(Nil);
  ProjectProductBillEditForm.ADOMaster:= ADOMaster1;
  ProjectProductBillEditForm.ADOProject := ADOList1;
  ProjectProductBillEditForm.ADOProduct := ADOList2;
    if State1 = 'dsEdit' then
        ProjectProductBillEditForm.ADOMaster.Edit;

    if State1 = 'dsInsert' then
//      ProductBillEditForm.ADOMaster.Insert;
  IDGen(ProjectProductBillEditForm.ADOMaster, 'XC', '��Ŀ��Ʒ������', '���ݱ��', '¼������', 11, 4);

  ProjectProductBillEditForm.ShowModal;
end;

procedure TProjectProductBillEditForm.DBGridEh2Columns2EditButtonClick(
  Sender: TObject; var Handled: Boolean);
begin
  inherited;
  ShowProductSelectForm(ADOProduct);
end;

procedure TProjectProductBillEditForm.DBGridEh1Columns2EditButtonClick(
  Sender: TObject; var Handled: Boolean);
begin
  inherited;
  ShowProjectSelectForm(ADOProject);
end;

procedure TProjectProductBillEditForm.BitBtn1Click(Sender: TObject);
begin
  inherited;
  ADOMaster.Append;

end;

procedure TProjectProductBillEditForm.BitBtn2Click(Sender: TObject);
Const
  Tab_pre_proj   ='������Ŀ��ϸ��';
  Tab_pre_prod   ='���Ʋ�Ʒ��ϸ��';
  Tab_ServerPack ='������Ŀ��';
  Tab_ServerPack_prod ='��Ʒ���ϰ�';
var
  str_hyid : string;
  str_tmp  : string;    // ���
  str_sql  : string;
  int_num  : double;    //����
  str_packname : string;
  Tmp_ado  : TAdoquery;
begin
  inherited;
   if ADOMaster.State in [dsEdit, dsInsert] then
    ADOMaster.Post;

  if ADOProject.State in [dsEdit, dsInsert] then
    ADOProject.Post;

  if ADOProduct.State in [dsEdit, dsInsert] then
    ADOProduct.Post;

 //----------------------------------------------------------------------------
    Tmp_ado:=nil;
    str_hyid:=''''+trim(DBEditEh2.Field.Text)+'''';
    try
      Tmp_ado:=TAdoquery.Create(nil);
      Getconn(Tmp_ado);
      if Adoproject.RecordCount>0 then
      begin
      while not Adoproject.eof do
      begin
        str_tmp:=''''+trim(Adoproject.fieldbyname('��Ŀ���').AsString)+'''';      //�����
        str_packname:=''''+trim(Adoproject.fieldbyname('��Ŀ����').AsString)+''''; //������
        int_num:=Adoproject.fieldbyname('����').AsFloat;      //����
        Tmp_ado.close;
        Tmp_ado.SQL.clear;
        Tmp_ado.sql.Add(format('select * from %s where ��Ŀ���=%s',[Tab_ServerPack,str_tmp]));
        Tmp_ado.Open;
        while not Tmp_ado.eof do
        begin
          str_sql:=format('insert into %s (��Ա���,��Ŀ���,��Ŀ����,���ѷ�ʽ,��,���,ʣ��,���������,����������,�����,�������) values(',[Tab_pre_proj]);
          str_sql:=str_sql+str_hyid+',';
          str_sql:=str_sql+''''+Tmp_ado.fieldbyname('���').asstring+''''+',';       // ��ϸ��Ŀ��Ŀ���
          str_sql:=str_sql+''''+Tmp_ado.fieldbyname('��Ŀ����').asstring+''''+',';   // ��ϸ��Ŀ��Ŀ����
          str_sql:=str_sql+''''+Tmp_ado.fieldbyname('���ѷ�ʽ').asstring+''''+',';   // ��ϸ��Ŀ���ѷ�ʽ
          str_sql:=str_sql+floattostr(Tmp_ado.fieldbyname('����').AsFloat*int_num)+',';
          str_sql:=str_sql+floattostr(Tmp_ado.fieldbyname('����').AsFloat*int_num)+',';
          str_sql:=str_sql+floattostr(Tmp_ado.fieldbyname('����').AsFloat*int_num)+',';

          str_sql:=str_sql+''''+Tmp_ado.fieldbyname('��Ŀ���').asstring+''''+',';// ���������
          str_sql:=str_sql+str_packname+',';                                      // ����������
          str_sql:=str_sql+''''+Tmp_ado.fieldbyname('�����').asstring+''''+',';
          str_sql:=str_sql+''''+Tmp_ado.fieldbyname('�������').asstring+'''';
          str_sql:=str_sql+')';

       //   showmessage(str_sql);

          Ado_insert.Close;
          Ado_insert.SQL.Clear;
          Ado_insert.SQL.add(str_sql);
          Ado_insert.ExecSQL;
          Tmp_ado.Next;
        end;
        Adoproject.Next;
      end;  //       > 0 end
      end;


      //��Ʒ��
      if ADOProduct.RecordCount>0 then
      while not ADOProduct.eof do
      begin
        str_tmp:=''''+trim(ADOProduct.fieldbyname('��Ʒ���').AsString)+'''';      //�����
        str_packname:=''''+trim(ADOProduct.fieldbyname('��Ʒ����').AsString)+''''; //������
        int_num:=ADOProduct.fieldbyname('����').AsFloat;      //����
        Tmp_ado.close;
        Tmp_ado.SQL.clear;
        Tmp_ado.sql.Add(format('select * from %s where ��Ʒ���=%s',[Tab_ServerPack_prod,str_tmp]));

 //       showmessage(Tmp_ado.SQL.Text);

        Tmp_ado.Open;
        while not Tmp_ado.eof do
        begin
          str_sql:=format('insert into %s (��Ա���,��Ʒ���,��Ʒ����,��,���,ʣ��,���������,����������,�����,�������) values(',[Tab_pre_prod]);
          str_sql:=str_sql+str_hyid+',';
          str_sql:=str_sql+''''+Tmp_ado.fieldbyname('���').asstring+''''+',';       // ��ϸ��Ŀ��Ŀ���
          str_sql:=str_sql+''''+Tmp_ado.fieldbyname('��Ʒ����').asstring+''''+',';   // ��ϸ��Ŀ��Ŀ����
//          str_sql:=str_sql+''''+Tmp_ado.fieldbyname('���ѷ�ʽ').asstring+''''+',';   // ��ϸ��Ŀ���ѷ�ʽ
          str_sql:=str_sql+floattostr(Tmp_ado.fieldbyname('����').AsFloat*int_num)+',';
          str_sql:=str_sql+floattostr(Tmp_ado.fieldbyname('���ۼ�').AsFloat*int_num)+',';
          str_sql:=str_sql+floattostr(Tmp_ado.fieldbyname('����').AsFloat*int_num)+',';

          str_sql:=str_sql+''''+Tmp_ado.fieldbyname('��Ʒ���').asstring+''''+',';// ���������
          str_sql:=str_sql+str_packname+',';                                      // ����������
          str_sql:=str_sql+''''+Tmp_ado.fieldbyname('�����').asstring+''''+',';
          str_sql:=str_sql+''''+Tmp_ado.fieldbyname('�������').asstring+'''';
          str_sql:=str_sql+')';

 //         showmessage(str_sql);

          Ado_insert.Close;
          Ado_insert.SQL.Clear;
          Ado_insert.SQL.add(str_sql);
          Ado_insert.ExecSQL;
          Tmp_ado.Next;
        end;
        Adoproduct.Next;
      end;

    finally
      Tmp_ado.Free;
    end;
  //----------------------------------------------------------------------------



  Close;
end;

procedure TProjectProductBillEditForm.BitBtn3Click(Sender: TObject);
begin
  inherited;
  Close;
end;

procedure TProjectProductBillEditForm.DBGridEh1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_F1 then
  ShowProjectSelectForm(ADOProject);
end;

procedure TProjectProductBillEditForm.DBGridEh2KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_F1 then
  ShowProductSelectForm(ADOProduct);
end;

procedure TProjectProductBillEditForm.Edit1Change(Sender: TObject);
begin
  inherited;

  with ADOQryTmp do
  begin
    Close;
    SQL.Clear;
    SQL.Add('Select * From ��Ա���� where ����= :Param');
    Parameters.ParamByName('Param').Value := Trim(Edit1.Text);
    Open;
    Edit;
  end;
end;

procedure TProjectProductBillEditForm.Edit1Exit(Sender: TObject);
begin
  inherited;
  if not ADOQryTmp.Active  then Exit;

  if ADOQryTmp.RecordCount>0 then
  begin
    ADOMaster.Edit;
    ADOMaster.FieldByName('��Ա���').AsString := ADOQryTmp.FieldByName('��Ա���').AsString;
    ADOMaster.FieldByName('��Ա����').AsString := ADOQryTmp.FieldByName('��Ա����').AsString
  end
  else
  begin
    ShowMsg('�˻�Ա������!');
    Edit1.SetFocus;
//    Exit;
  end;
end;

procedure TProjectProductBillEditForm.DBGridEh1Enter(Sender: TObject);
begin
  inherited;
  if ADOMaster.Modified then
    ADOMaster.Post;

end;

procedure TProjectProductBillEditForm.DBGridEh2Enter(Sender: TObject);
begin
  inherited;
  if ADOMaster.Modified then
    ADOMaster.Post;
end;

end.
