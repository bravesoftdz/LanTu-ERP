unit DBTreeView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Base, ComCtrls, ADODB, DB, ImgList, StdCtrls, Buttons;

type
  TDBTreeViewForm = class(TBaseForm)
    TreeView1: TTreeView;
    ADOQuery1: TADOQuery;
    BitBtn1: TBitBtn;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    GroupBox2: TGroupBox;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure TreeView1GetImageIndex(Sender: TObject; Node: TTreeNode);
    procedure TreeView1GetSelectedIndex(Sender: TObject; Node: TTreeNode);
    procedure TreeView1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    function LoadCode(ADOQueryTmp : TDataSet):Integer;
    function GetLevel(sFormat,sCode:String):Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DBTreeViewForm: TDBTreeViewForm;

const
  SCodeFormat = '322222';   //��Ŀ����ṹ
  SFirstNodeTxt = '�ֽ������ʻ�';   //�׽ڵ���ʾ������

implementation

uses DataM, SysPublic;

{$R *.dfm}

procedure TDBTreeViewForm.FormCreate(Sender: TObject);
begin
  inherited;
  ADOQuery1.Close;
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('Select * From DBTreeView');
  ADOQuery1.Open;
  LoadCode(ADOQuery1);
end;

function TDBTreeViewForm.GetLevel(sFormat, sCode: String): Integer;
var
  i,Level,iLen:Integer;
begin
  Level:=-1;//������벻���ϱ�׼���򷵻�-1
  iLen:=0;
  if (sFormat<>'')and(sCode<>'')then
  for i:=1 to Length(sFormat) do
  begin
    iLen:=iLen+StrToInt(sFormat[i]);
    if Length(sCode)=iLen then
    begin
      Level:=i;
      Break;
    end;
  end;
  Result:=Level;
end;
//���溯���Ĺ����Ƿ���һ����ļ���

//���º����Ǳ��ĵ��ص㲿�֣�����Ҫ��������һѭ����Code.db���е�
//��Ŀ����Ϳ�Ŀ����������ʾ����
function TDBTreeViewForm.LoadCode(ADOQueryTmp: TDataSet): Integer;
var
  NowID,sName,ShowTxt:String;
  i,Level:Integer;
  MyNode:array[0..6]of TTreeNode;
  //��������ڵ㣬�֧��6��(�ص�)
begin
  Screen.Cursor:=crHourGlass;
  Level:=0;
  With ADOQueryTmp do
  begin
    try
    if not ADOQueryTmp.Active then Open;
    First;
    TreeView1.Items.Clear;
    //���������ӵ�һ��
    MyNode[Level]:=TreeView1.Items.Add(TreeView1.TopItem,SFirstNodeTxt);
//    MyNode[Level].ImageIndex:=0;
//    MyNode[Level].SelectedIndex:=0;
    //���������ӵ�һ��
    While Not ADOQueryTmp.Eof do
    begin
      NowID:=Trim(FieldByName('aCode').AsString);
      ShowTxt:=NowID+' '+FieldByName('aName').AsString;
      Level:=GetLevel(SCodeFormat,NowID);
      //���ش���ļ���
      //��������������
      //��������һ���ڵ�Ϊ���ڵ�����ӽڵ�
      if Level>0 then//ȷ��������ϱ�׼
      begin
        MyNode[Level]:=TreeView1.Items.AddChild(MyNode[Level-1],ShowTxt);
//        MyNode[Level].ImageIndex:=1;
//        MyNode[Level].SelectedIndex:=2;
      end;
    //��������������
      Next;
    end;
    finally
     Close;
    end;
  end;
  MyNode[0].Expand(False);//���׽ڵ�չ��
  Screen.Cursor:=crDefault;
end;
//���Ϻ�����Code.db���еĿ�Ŀ����Ϳ�Ŀ����������ʾ����

procedure TDBTreeViewForm.TreeView1GetImageIndex(Sender: TObject;
  Node: TTreeNode);
begin
  inherited;
 if Node.HasChildren then
        if Node.Expanded then
            Node.ImageIndex := 17   //�ڵ����ӽڵ�ʱ�򿪵�ͼ��
        else
            Node.ImageIndex := 16   //�ڵ����ӽڵ�ʱ��������ͼ��
    else Node.ImageIndex := 16;     //�ڵ�û���ӽڵ�ʱͼ��
end;

procedure TDBTreeViewForm.TreeView1GetSelectedIndex(Sender: TObject;
  Node: TTreeNode);
begin
  inherited;
  Node.SelectedIndex := Node.ImageIndex;   //�ڵ�ѡ���ʹ�õ�ͼ��
end;

procedure TDBTreeViewForm.TreeView1Click(Sender: TObject);
var
  s, sID, sSql, sFirst, sLast, sCode : string;
  Llevel, iID : integer;
  ADOQryTmp: TADOQuery;
begin
  inherited;
  //ѡȡ�ڵ��TEXT
  s := TreeView1.Selected.Text;
  //ȡ�����
  sID := Trim(Copy(s, 0, Pos(' ', s)-1));
  //Ȣ��ŵĳ���
  Llevel:= Length(sID);

  sFirst:= Copy(sID, 1, Length(sID)-2);


  if lLevel = 3 then
    sSql:= 'Select Max(aCode) as acode From DBTreeView where len(acode)='+IntToStr(Llevel)
  else
    sSql:= 'Select Max(aCode) as aCode From DBTreeView Where aCode like '+QuotedStr(sFirst+'__');

  //�Ѵ˱�ų��ȵ����ֵ
  ADOQryTmp:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp);
  ADOQryTmp.Close;
  ADOQryTmp.SQL.Clear;
  ADOQryTmp.SQL.Add(sSql);
  ADOQryTmp.Open;

  sCode:= ADOQryTmp.FieldByName('aCode').AsString;

  Edit2.Text := sFirst;

  sLast:= Copy(sCode, Length(sCode)-1, Length(sCode));

  Edit3.Text:= formatfloat('00',StrToInt(sLast)+1);

  ADOQryTmp.Close;
  ADOQryTmp.Free;
end;

procedure TDBTreeViewForm.BitBtn1Click(Sender: TObject);
var
  ADOQryTmp: TADOQuery;
  s: string;
begin
  inherited;
  s:= Trim(Edit2.Text) + Trim(Edit3.Text);
  ADOQryTmp:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp);
  ADOQryTmp.Close;
  ADOQryTmp.SQL.Clear;
  ADOQryTmp.SQL.Add('Insert Into DBTreeView(aCode, aName) Values(:aCode, :aName)');
  ADOQryTmp.Parameters.ParamByName('aCode').Value := Trim(s);
  ADOQryTmp.Parameters.ParamByName('aName').Value := Trim(Edit4.Text);
  ADOQryTmp.ExecSQL;

  ADOQuery1.Close;
  ADOQuery1.SQL.Clear;
  ADOQuery1.SQL.Add('Select * From DBTreeView');
  ADOQuery1.Open;
  LoadCode(ADOQuery1);

end;

end.
