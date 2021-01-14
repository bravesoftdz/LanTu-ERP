unit ShopDepartEmployeeInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BaseMdi, ComCtrls, ADODB;

type
  TShopDepartEmployeeInfoForm = class(TBaseMdiForm)
    TreeView1: TTreeView;
    procedure FormShow(Sender: TObject);
    procedure TreeView1GetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure TreeView1GetSelectedIndex(Sender: TObject; Node: TTreeNode);
  private
    procedure ShowTreeviewData;
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowShopDepartEmployeeInfoForm(sSelf: TComponent);

implementation

uses DataM, SysPublic;

{$R *.dfm}

procedure ShowShopDepartEmployeeInfoForm(sSelf: TComponent);
var
  ShopDepartEmployeeInfoForm: TShopDepartEmployeeInfoForm;
begin
  OpenForm(TShopDepartEmployeeInfoForm, ShopDepartEmployeeInfoForm, sSelf);
end;

procedure TShopDepartEmployeeInfoForm.ShowTreeviewData;
var
  mytreenode1,mytreenode2,mytreenode3, mytreenode4:ttreenode;
  ADOQryTmp, ADOQryTmp1, ADOQryTmp2, ADOQryTmp3: TADOQuery;
  sTop: string;
begin

  ADOQryTmp:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp);

  ADOQryTmp1:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp1);

  ADOQryTmp2:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp2);

  ADOQryTmp3:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp3);

  ADOQryTmp.Close;
  ADOQryTmp.SQL.Clear;
  ADOQryTmp.SQL.Add('Select �û����� From �û�����');
  ADOQryTmp.Open;

  sTop:= ADOQryTmp.FieldByName('�û�����').AsString;

  treeview1.items.clear;
  with treeview1.items do
  begin
    MyTreeNode1:=add(nil, sTop);

    ADOQryTmp1.Close;
    ADOQryTmp1.SQL.Clear;
    ADOQryTmp1.SQL.Add('Select * From �������� Order by ID');
    ADOQryTmp1.Open; 

    ADOQryTmp1.first;
    while not ADOQryTmp1.Eof do
    begin
      with treeview1.Items do
      begin
        mytreenode2:= addchild(mytreenode1,trim(ADOQryTmp1.fieldbyname('��������').asstring));

        //���ҵ�λ�µĲ���
        with ADOQryTmp2 do
        begin
          close;
          sql.clear;
          sql.add('select * from �������� where ������=:������');
          Parameters.ParamByName('������').value :=trim(ADOQryTmp1.fieldbyname('������').asstring);
          open;
        end;
        ADOQryTmp2.first;
        while not ADOQryTmp2.eof  do
        begin
          mytreenode3:=addchild(mytreenode2,trim(ADOQryTmp2.fieldbyname('��������').asstring));

          with ADOQryTmp3 do
          begin
          close;
          sql.clear;
          sql.add('select * from Ա������ where ���ű��=:���ű��');
          Parameters.ParamByName('���ű��').value :=trim(ADOQryTmp2.fieldbyname('���ű��').asstring);
          open;
          end;
          ADOQryTmp3.First;
          while not ADOQryTmp3.Eof do
          begin
            mytreenode4:=addchild(mytreenode3,trim(ADOQryTmp3.fieldbyname('Ա������').asstring));
            ADOQryTmp3.Next; 
          end;
          ADOQryTmp2.Next;
        end;

      end;
      ADOQryTmp1.next;
    end;
  end;

  ADOQryTmp.Close;
  ADOQryTmp.Free;
  ADOQryTmp1.Close;
  ADOQryTmp1.Free;
  ADOQryTmp2.Close;
  ADOQryTmp2.Free;
  ADOQryTmp3.Close;
  ADOQryTmp3.Free;
end; 
procedure TShopDepartEmployeeInfoForm.FormShow(Sender: TObject);
begin
  inherited;
  ShowTreeviewData;
end;

procedure TShopDepartEmployeeInfoForm.TreeView1GetImageIndex(
  Sender: TObject; Node: TTreeNode);
begin
  inherited;
  if Node.HasChildren then
    if Node.Expanded then
      Node.ImageIndex := 17
    else
      Node.ImageIndex := 16
  else
    Node.ImageIndex := 16;
end;

procedure TShopDepartEmployeeInfoForm.TreeView1GetSelectedIndex(
  Sender: TObject; Node: TTreeNode);
begin
  inherited;
  Node.SelectedIndex := Node.ImageIndex;
end;

end.
