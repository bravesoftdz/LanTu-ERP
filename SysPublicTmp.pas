unit SysPublicTmp;

interface

uses Windows;

implementation

end.
{
������ʾ����
procedure TForm1.FormCreate(Sender: TObject);
begin
  AnimateWindow(Handle,2000{�ٶȣ�2��}//,AW_BLEND);
{ AW_HOR_POSITIVE = $00000001;
  AW_HOR_NEGATIVE = $00000002;
  AW_VER_POSITIVE = $00000004;
  AW_VER_NEGATIVE = $00000008;
  AW_CENTER = $00000010;
  AW_HIDE = $00010000;
  AW_ACTIVATE = $00020000;
  AW_SLIDE = $00040000;
  AW_BLEND = $00080000;
end;}

{
 ֻ������һ���Ӵ����MDI����
 procedure OpenChildForm(FormClass: TFormClass; var Fm; AOwner:TComponent);
var
  I: Integer;
  Child: TForm;
begin
  for I := 0 to Screen.FormCount - 1 do
    if Screen.Forms[I].ClassType = FormClass then
    begin
      Child := Screen.Forms[I];
      if Child.WindowState = wsMinimized then
        ShowWindow(Child.Handle, SW_SHOWNORMAL)
      else
        ShowWindow(Child.handle,SW_SHOWNA);
      if (not Child.Visible) then Child.Visible := True;
        Child.BringToFront;
        Child.Setfocus;
        TForm(Fm) := Child;
        Exit;
    end;
  Child := TForm(FormClass.NewInstance);
  TForm(Fm) := Child;
  Child.Create(AOwner);
end; 

}

{
���������Զ���Ӧ���
˵��:ʹ��DBGrid���ɲ���

///////Begin Source
uses
Math;

function DBGridRecordSize(mColumn: TColumn): Boolean;
{ ���ؼ�¼������������ʾ������Ƿ�ɹ�
begin
Result := False;
if not Assigned(mColumn.Field) then Exit;
mColumn.Field.Tag := Max(mColumn.Field.Tag,
TDBGrid(mColumn.Grid).Canvas.TextWidth(mColumn.Field.DisplayText));
Result := True;
end; 

function DBGridAutoSize(mDBGrid: TDBGrid; mOffset: Integer = 5): Boolean;
// �������������Զ���Ӧ����Ƿ�ɹ�
var
I: Integer;
begin
Result := False;
if not Assigned(mDBGrid) then Exit;
if not Assigned(mDBGrid.DataSource) then Exit;
if not Assigned(mDBGrid.DataSource.DataSet) then Exit;
if not mDBGrid.DataSource.DataSet.Active then Exit;
for I := 0 to mDBGrid.Columns.Count - 1 do begin
if not mDBGrid.Columns[I].Visible then Continue;
if Assigned(mDBGrid.Columns[I].Field) then
mDBGrid.Columns[I].Width := Max(mDBGrid.Columns[I].Field.Tag,
mDBGrid.Canvas.TextWidth(mDBGrid.Columns[I].Title.Caption)) + mOffset
else mDBGrid.Columns[I].Width :=
mDBGrid.Canvas.TextWidth(mDBGrid.Columns[I].Title.Caption) + mOffset;
mDBGrid.Refresh;
end;
Result := True;
end;

procedure TForm1.DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
DBGridRecordSize(Column);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
DBGridAutoSize(DBGrid1);
end;
}

{TDBGrid����Enter����Tab����
procedure TForm1.FormKeyPress(Sender: TObject; var Key: 
Char);
begin
  if Key = #13 then //�����һ��Enter����
  begin
    if not (ActiveControl is TDBGrid) then  //�����ǰ�Ŀؼ�����TDBGrid
    begin 
       Key := #0; 
       Perform(WM_NEXTDLGCTL, 0, 0);
    end
    else if (ActiveControl is TDBGrid) then //��TDBGrid��
    begin
       with TDBGrid(ActiveControl) do
       begin
         if selectedindex < (fieldcount -1) then //����������һ���ֶ�
            selectedindex := selectedindex +1
         else
            selectedindex := 0;
       end;
   end;
end; 
end;

}

{

����������������ΰ�Delphi�е����ݼ�����Excel�У������ṩ��һ��ʵ�֡�


������Ŀʱ���ܶ�����£��ͻ���Ҫ�Գ��������ݼ��ټӹ��������ã��籨��
��ʱ������Ҫ��DataSet���뵽һ���ͻ��Ƚ���Ϥ�ĸ�ʽ��ȥ��Excel����ѡ�ˡ�

�ó�����Delphi4,5�±���ͨ�����ѱ����ڶ����Ŀ�С����������ڱ�����д��һ��С���TDBNavigateButton��

 

{-------------------------------------------------------------------------------------------------
��Ԫ��uExcelTools
���ߣ�  Bear
���ܣ��������ݼ�����TTable,TQuery,TClientDataSet��ΪExcel�ļ���
          �������⣬����ֻ��һ�����ֶε���
           ��һ��ͨ������DataSet��Ҫ�������ֶε�Tagֵ����ĳһ��ֵ������
ԭ������ Microsoft Excel Ole����
���÷�ʽ��  
                 Function DataSetToExcel(
                     DataSet:TDataSet;FieldTagMax:Integer;
                      Visible:Boolean;ExcelFileName:String=''): Boolean;
--------------------------------------------------------------------------------------------------

unit UExcelTools;

interface

uses
  classes, comctrls, stdctrls, windows, Dialogs, controls, SysUtils,
  Db,forms,DBClient,ComObj;

//�����ݼ�����ExcelSheet�ĺ��ĺ���
function DataSetToExcelSheet
            (
             DataSet     :TDataSet;
             FieldTagMax :Integer;   // �ֶε�Tagֵ����������ֵ���Ͳ�������Excel
             Sheet       :OleVariant
             ): Boolean;

//ʵ��ʹ�õĺ������ڲ�������DataSetToExcelSheet�����������UI�ӿںʹ�����
function DataSetToExcel
            (
             DataSet     :TDataSet;   // Ҫת�������ݼ�
             FieldTagMax :Integer;  // �ֶε�Tagֵ����������ֵ���Ͳ�������Excel
             Visible     :Boolean;      // �Ƿ�����ת��������Excel�ɼ�
             ExcelFileName:String='' // Excel�ļ�����*.xls
             ): Boolean;

implementation

Function DataSetToExcelSheet(DataSet:TDataSet;FieldTagMax:Integer;Sheet:OleVariant): Boolean;
var
   Row,Col,FieldIndex :Integer;
   BK:TBookMark;
begin
   Result := False;
   if not Dataset.Active then exit;
   BK:=DataSet.GetBookMark;
   DataSet.DisableControls;

   Sheet.Activate;
   try

     // �б���
     Row:=1;
     Col:=1;
     for FieldIndex:=0 to DataSet.FieldCount-1 do
         begin
         if DataSet.Fields[FieldIndex].Tag <= FieldTagMax then
            begin
            Sheet.Cells(Row,Col)  :=DataSet.Fields[FieldIndex].DisplayLabel;
            Inc(Col);
            end;
         end;
     // ������
     DataSet.First;
     while Not DataSet.Eof do
        begin
        Row:=Row+1;
        Col:=1;
        for FieldIndex:=0 to DataSet.FieldCount-1 do
            begin
            if DataSet.Fields[FieldIndex].Tag <= FieldTagMax then
               begin
               Sheet.Cells(Row,Col):=DataSet.Fields[FieldIndex].AsString;
               Inc(Col);
               end;
            end;
        DataSet.Next;
        end;

     Result := True;
     finally
       DataSet.GotoBookMark(BK);
       DataSet.EnableControls;
    end;

  
end;
Function DataSetToExcel(
                  DataSet:TDataSet;FieldTagMax:Integer;
                  Visible:Boolean;ExcelFileName:String=''): Boolean;
var
   ExcelObj, Excel, WorkBook, Sheet: OleVariant;
    OldCursor:TCursor;
   SaveDialog:TSaveDialog;
begin
   Result := False;
   if not Dataset.Active then exit;

   OldCursor:=Screen.Cursor;
   Screen.Cursor:=crHourGlass;

   try
      ExcelObj := CreateOleObject('Excel.Sheet');
      Excel := ExcelObj.Application;
      Excel.Visible := Visible ;
      WorkBook := Excel.Workbooks.Add ;
      Sheet:= WorkBook.Sheets[1];
   except
      MessageBox(GetActiveWindow,'�޷�����Mircorsoft Excel! '+chr(13)+chr(10)+
                    '�����Ƿ�װ��Mircorsoft Excel��','��ʾ',MB_OK+MB_ICONINFORMATION);
      Screen.Cursor:=OldCursor;
      Exit;
   end;

   Result:=DataSetToExcelSheet(DataSet,FieldTagMax,Sheet) ;
   if Result then
      if Not Visible then
         begin
         if ExcelFileName<>''
            then WorkBook.SaveAs(FileName:=ExcelFileName)
            else begin
                 SaveDialog:=TSaveDialog.Create(Nil);
                 SaveDialog.Filter := 'Microsoft Excel �ļ�|*.xls';
                 Result:=SaveDialog.Execute;
                 UpdateWindow(GetActiveWindow);
                 if Result then
                    WorkBook.SaveAs(FileName:=SaveDialog.FileName);
                 SaveDialog.Free;
                 end;
         Excel.Quit;
         end;
   Screen.Cursor:=OldCursor;
end;

 

end.

}

{
��δ���͸������
procedure TForm1.FormCreate(Sender: TObject); 
var 
  FullRgn, ClientRgn, ButtonRgn: THandle; 
  Margin, X, Y: Integer; 
begin 
  Margin := (Width - ClientWidth) div 2; 
  FullRgn := CreateRectRgn(0, 0, Width, Height); 
  X := Margin; 
  Y := Height - ClientHeight - Margin; 
  ClientRgn := CreateRectRgn(X, Y, X + ClientWidth, Y + ClientHeight); 
  CombineRgn(FullRgn, FullRgn, ClientRgn, RGN_DIFF); 
  X := X + Button1.Left; 
  Y := Y + Button1.Top; 
  ButtonRgn := CreateRectRgn(X, Y, X + Button1.Width, Y + Button1.Height); 
  CombineRgn(FullRgn, FullRgn, ButtonRgn, RGN_OR); 
  SetWindowRgn(Handle, FullRgn, True); 
end;

}

{
	
	
	���ʵ����MS Access���ݿ���ͼ��Ĵ洢����ʾ
һ�� ԭ����ܡ�����ʽ���ݵ����ͼ���Ӧ��
��Dephi���ṩ��TStream��֧�ֶ���ʽ���ݵĲ�����TStream������֮Դ������������һ�������࣬�ʲ��ܱ�ֱ��ʹ�ã���Ҫʹ������Ӧ�����࣬�磺TFileStream ��TStringStream��TMemoryStream��TBlobStream��TWinSocketStream��TOleStream��TStream�ṩ��ͳһ�����ķ������������ݵĶ�д��
  1.)SaveToStream(Stream: TStream ); ���ã������е�����д��Stream�ĵ�ǰλ���� 
  2.)LoadFromStream(Stream: TStream); ���ã��ӵ�ǰλ�ö���Stream������� 
  ʵ��ʹ��ʱ���ǻ�����ֻҪʹ���������������Ϳ����ˡ� 
���������������⼰��Ӧ�Ľ������
Ϊ�˽�ʡͼ��Ĵ洢�ռ��ʹ�ø��ӷ��㣬��������JPEG����ͼ���ʽ��
��һ��������������
��һ����Delphi 5�н��л�ͼ���õ��������TImage�������ɵ�ͼ��ĸ�ʽΪBMP��ʽ����Ϊ�˽�ʡͼ��Ĵ洢�ռ䣬ͼ�������ݿ���洢�ĸ�ʽ��ΪJPEG��ʽ�������Ͳ�����ͼ���ʽת�������󣻶�TImage������ֱ���ṩ������ͼ���ʽ֮���ת����
�ڶ����������洢��Microsoft Access���ݿ��е�ͼ��ȡ��������ʾ��������Delphi 5�У����ṩ���ֹ��ܵ������TDBImage���������ȴ������һ���ܴ��ȱ�ݣ���������ʾ��ͼ������ֻ����һЩͼ���ļ���Ԫ�ļ���BMP�ļ���������֧��JPEG��ʽ��ͼ���ڸ�����е���ʾ��������ʵ����Ҫ����Microsoft Access���ݿ������洢��ͼ������ȴ����JPEG��ʽ����ġ�
��������Ӧ�Ľ������
Ϊ�˽�������������⣬���Բ���Ŀǰ���ݿ���һ����Ϊ����ֶ���BLOB����Binary Large Object����������������ĳЩ�����ʽ�����ݵġ�BLOB�����ݿ�ı���ʵ�������Զ��������ݵ���ʽ��ŵġ�
Ϊ�˴���BLOB�ֶΣ����Խ��һЩ���ӵ��������ݿ�ķ��������������ѡ����ͨ���ڴ����ķ�ʽ����ɣ�ʹ���ڴ������ɼ��ٴ��̲���������������Ч�ʡ�
����Ĺ��̺���صĳ���������£�
1�����ʵ����Microsoft Access���ݿ��е�ͼ��洢��
����������TStream������TMemoryStream��Microsoft Access���ݿ��д洢ͼ��ġ��������δ������ڰ��ˡ����桱��ť֮�����������¼��������
procedure TForm1.Button1Click(Sender: TObject);
var 
MyJPEG : TJPEGImage;
MS: TMemoryStream;
begin
MyJPEG := TJPEGImage.Create;
 try
    with MyJPEG do
    begin
      Assign(Image.Picture.Graphic);
      MS:=TMemoryStream.create;
      SaveToStream(MS);
      MS.Position:=0;
                Table1.Edit;
                 TBlobField(Table1.FieldbyName('Image')).LoadFromStream(MS);
                 Table1.Post;
                 messagebox(getactivewindow(),'ͼ�񱣴���ϣ�','����',mb_ok);          
    end;
  finally
    MyJPEG.Free;
  end;
end;
����δ�����TStream������TMemoryStream�����ڴ������˽�BMP��ʽת��ΪJPEG��ʽ���м����������á�
2����ν�ͼ���Microsoft Access���ݿ���ȡ������ʾ������
�������δ������ڰ��ˡ��鿴ͼ�񡱰�ť֮�����������¼��������
procedure TForm1.Button1Click(Sender: TObject);
var tempstream:TStringStream;
   tempjpeg:TJPEGImage; 
begin
   try
        tempstream:=TStringStream.Create(' ');     
        TBlobField(Query1.FieldByName('Image')).SaveToStream(tempstream);            
        tempstream.Position:=0;
        tempjpeg:=TJPEGImage.Create;
        tempjpeg.LoadFromStream(tempstream);
        DBImage1.Picture.Bitmap.Assign(tempjpeg);
  finally
        tempstream.Free;
        tempjpeg.Free;
  end;
end;
��δ������Ҫ�����ǣ����Ƚ���ѯ����е�JPEGͼ���ʽ���ݱ��浽TStringStream��ȥ��Ȼ����������ָ����TStringStream�е�λ��Ϊ0�����Ŵ�TStringStream�ж���������ݣ��������Ǹ���TDBImage.Picture.Bitmap������һ����ʵ���˽����ݿ������洢��JPEG��ʽ������ת��ΪBMP��ʽ������TDBImage�н�ͼ����ʾ���������TStringStream��TJPEGImage�����������ͷŵ����ر�Ҫע����ǲ�������ƽ׶�����TDBImage��DataField���ԣ���ֻ��ͨ��д�������ʽ�����н׶ΰ�������ʽ������ת���������¸�ʽ��ͼ�����ݸ���TDBImage.Picture.Bitmap��
}

{��SQL���ݿ�����ʾ���
select IDENTITY(int,1,1)as id,��̨����,����˵�� into #1 from ����̨����Ϣ��
select * from #1 
drop  table  #1--�ŵ����������
}

{
���⣺SQL Server2000�У���ô�õ�datetime�����ֶε����ڲ��ֺ�ʱ�䲿�֣� ( ���֣�50, �ظ���8, �Ķ���38 )
���ࣺ���ݿ�-C/S�� ( ������qince, luyear )  
���ԣ�nywjx, ʱ�䣺2004-8-23 10:01:00, ID��2774290 [��ʾ��С���� | ������]  
���⣬һ���ֶ���datetime���ͣ�����õ��������ڲ��֣�����2004-08-23;
����õ�����ʱ�䲿�֣�����10:12:45��
��ô���������˰�����û�ҵ�
 
 
���ԣ�KervenLee, ʱ�䣺2004-8-23 10:09:17, ID��2774306 
ת�����ַ������Ӻ���ȡ10���ַ���
��������
 
 
���ԣ�shineYu, ʱ�䣺2004-8-23 10:09:18, ID��2774307 
convert(char(8),[datetime],102)   --->2004.08.23
convert(char(8),[datetime],108)   --->HH:MM:SS
 
 
���ԣ�TYZhang, ʱ�䣺2004-8-23 10:10:01, ID��2774309 
Select Convert(char(10),D,121) from T  //2004-08-23
Select Right(Convert(char(19),D,121),8) from T  //10:12:45


 
 
���ԣ�nywjx, ʱ�䣺2004-8-23 10:12:15, ID��2774317 
����Ҫ����ʱ�����֮��ıȽ�ʱ�����ǻ�Ҫ���ַ�ת����datetime����û�и��õİ취��
 
 
���ԣ�bluedna, ʱ�䣺2004-8-23 10:12:38, ID��2774319 
select convert(varchar(10),getdate(),120)as ����
select convert(varchar(10),getdate(),108)as ʱ��
 
 
���ԣ�TYZhang, ʱ�䣺2004-8-23 10:16:21, ID��2774331 
Select Floor(D) from T  //2004-08-23
Select D-Floor(D) from T  //10:12:45

 
 
���ԣ�meteor007, ʱ�䣺2004-8-23 10:17:04, ID��2774334 
DATEPART
���ش���ָ�����ڵ�ָ�����ڲ��ֵ�������
var:
 stryourdate:string;
 yourdate:TDateTime;

stryourdate:=FormatDateTime('yyyy/mm/dd',Yourdate);
stryourdate��������Ҫ��
���ɵõ������,��

�﷨
DATEPART ( datepart , date ) 
year��datetime��ȡ��
month(datetime)ȡ��
day��datetime��ȡ��


 
 

}

{
SQL��䣬����ת���� 
sTable.db
��λ  ������ �����
1     0101     50
1     0102     60
1     0103     50
2     0101     90
2     0103     100
2     0111     30
3     0101     120
3     0102     110
4     0101     11
 
ֻ�г����п�λΪ1��2��3�����ݣ���ʽ����:

������  ��λ1  ��λ2  ��λ3
0101      50     90     120
0102      60            110
0103      50     100
0111             30
������һ��sql�����ôʵ�֣�

select a.�����ţ�sum(b.�����)��sum(c.�����)��sum(d.�����)
from stable  a 
left join (select �����ţ� ����� from stable where ��λ=1)b on a.�����ţ�b������
left join (select �����ţ� ����� from stable where ��λ=2)c on a.�����ţ�c��������
left join (select �����ţ� ����� from stable where ��λ=3)c on a.�����ţ�d��������
group by a.������
//��������������������������������������������������������������������������������//

}

{
��editֻ�������ֺ�С���㣿
д��onkeypress�¼�����
if not (key in ['0'..'9',#8])  then
   begin
      if (key='.') and (pos('.',Tedit(sender).Text)=0) then exit;
      key:=#0;
      Messagebeep(0);
   end;

��KeyPress�������ô�������ƣ�
���Ctrl+C,Ctrl+V��ô�죿
����Ҽ�������ճ���أ�
����ֻ����OnChange�¼��в������ƿ��ƣ�
procedure TForm.EditChange(Sender: TObject);
begin
  try
    StrToFloat((Sender as TEdit).Text);
  except
    (Sender as TEdit).Text:=Copy((Sender as TEdit).Text,1,
      Length((Sender as TEdit).Text)-1);
    (Sender as TEdit).SelStart:=Length((Sender as TEdit).Text);
  end;
end; 


}

{
Format('x=%d', [12]); //'x=12' //����ͨ
Format('x=%3d', [12]); //'x= 12' //ָ�����
Format('x=%f', [12.0]); //'x=12.00' //������
Format('x=%.3f', [12.0]); //'x=12.000' //ָ��С��
Format('x=%.*f', [5, 12.0]); //'x=12.00000' //��̬����
Format('x=%.5d', [12]); //'x=00012' //ǰ�油��0
Format('x=%.5x', [12]); //'x=0000C' //ʮ������
Format('x=%1:d%0:d', [12, 13]); //'x=1312' //ʹ������
Format('x=%p', [nil]); //'x=00000000' //ָ��
Format('x=%1.1e', [12.0]); //'x=1.2E+001' //��ѧ������
Format('x=%%', []); //'x=%' //�õ�"%"
S := Format('%s%d', [S, I]); //S := S + StrToInt(I); //�����ַ��� 

}

{

һ��Thread��Ĵ�����

unit Thread;
//           �߳���Ĵ���
//  ���뻷��: Windows 2003 Sever  Delphi 7.0 Enterprise

interface
uses classes,sysutils,StdCtrls;
type
  TB = class(TThread)
  private
    i :integer;
    Fedt :TEdit;
    procedure Update ;
  public
    procedure execute;override;
    constructor create(IsSuspended :Boolean;edt :TEdit);
  end;
implementation
uses MainForm;

procedure TB.Update;
begin
  Fedt.Text :=inttostr(i);
end;

constructor TB.create(IsSuspended: Boolean; edt: TEdit);
begin
  inherited create(IsSuspended);
  Fedt := edt;
end;

procedure TB.execute;
begin
  i:=0;
  while(not Terminated) do
  begin
    Synchronize(Update);
    inc(i);
  end;
end;
end.

����Thread���ʹ�ã�

unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,Thread;

type
  TfrmMain = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ButtonClick(Sender: TObject);
  private
//    { Private declarations }
//  public
//    { Public declarations }
//  end;


{var
  frmMain: TfrmMain;
  a,b:TB;
implementation }

{$R *.dfm}

{procedure TfrmMain.FormCreate(Sender: TObject);
begin
  a:=TB.create(true,edit1);
  b:=TB.create(True,edit2);
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  freeandnil(a);freeandnil(b);
end;

procedure TfrmMain.ButtonClick(Sender: TObject);
var c :TB;
begin
  if sender = Button1 then c :=a
  else c:=b;
  if c.Suspended then begin
    c.Resume ; (sender as TButton).Caption :='��ͣ';
  end else begin
    c.Suspend ;(Sender as TButton).Caption :='��ʼ';
  end;
end;

end.


}

{
¥ס�����⻹û�н����?
�Ҽ򵥵�д��һ��,�Ѿ���ʵ����Ĺ���;
unit CustomDBGridEX;

interface

uses
  SysUtils, windows, Classes, Controls, Grids, DBGrids, Graphics;

type
  TCustomDBGridEX = class(TCustomDBGrid)
  private

  protected

    procedure DrawColumnCell(const Rect: TRect; DataCol: Integer;
      Column: TColumn; State: TGridDrawState); override;
  public

    property Canvas;
    property SelectedRows;
  published

    property Align;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Columns stored False; //StoreColumns;
    property Constraints;
    property Ctl3D;
    property DataSource;
    property DefaultDrawing;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FixedColor;
    property Font;
    property ImeMode;
    property ImeName;
    property Options;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property TitleFont;
    property Visible;
    property OnCellClick;
    property OnColEnter;
    property OnColExit;
    property OnColumnMoved;
    property OnDrawDataCell;
    property OnDrawColumnCell;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditButtonClick;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnTitleClick;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TCustomDBGridEX]);
end;



procedure TCustomDBGridEX.DrawColumnCell(const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  inherited;
  if DataSource.DataSet.RecNo mod 2 = 0 then
    Canvas.Brush.Color := clred
  else
    Canvas.Brush.Color := clAqua;
  DefaultDrawColumnCell(Rect, DataCol, Column, State);
end;

end.

������Ĺ����޸�Ϊ�������õ�! �Ǻ�!
procedure TCustomDBGridEX.DrawColumnCell(const Rect: TRect;
  DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  inherited;
  if DataSource.DataSet.RecNo mod 2 = 0 then
  begin
    Canvas.Brush.Color := clYellow;
    Canvas.Font.Color := clBlack;
    Canvas.TextRect(Rect, Rect.Left, Rect.Top, Column.Field.AsString);
  end
  else
  begin
    Canvas.Brush.Color := clWindow;
    Canvas.Font.Color := clBlack;
    Canvas.TextRect(Rect, Rect.Left, Rect.Top, Column.Field.AsString);
  end;
end;  

}

{

����ж�һ�������Ƿ��Ѿ�ʵ������
�Ұ�һ������Free��Ϊʲô (���� = nil) Ϊ False��  

function GetM():TMyClass;
var r: TMyClass;
begin
  r := TMyClass.Create;
  Result := r;
end;

}

{
������ȶ���һ������
//����Ϊ�����࣬����ʵ��
TBase=class
  public
    procedure push(num:double);
    function pop:double; virtual; abstract;
    function top:double;  virtual; abstract;
    function count:integer;  virtual; abstract;
  end;

Tfloatstack=class(TBase)
  private
    farr:array of double;
  public
    procedure push(num:double);override;
    function pop:double;override;
    function top:double;override;
    function count:integer;override;
  end;

  Tstringstack=class(TBase)
  private
    farr:array of string;
  public
    procedure push(num:string);override;
    function pop:string;override;
    function top:string;override;
    function count:integer;override;
  end;

}

{
�����и���̬����dxDBGrid�еĺ�����Ҳ������е����ã�
procedure StoreGridColumn(const TableID: Word; DataGrid: TdxDBGrid);
var
  i: Word;
  aType: TdxSummaryType;
  ColQuery: TSQLQuery;
begin
  ColQuery := TSQLQuery.Create(Nil);
  try
    ColQuery.SQLConnection := dmMaster.ConnDB;
    ColQuery.SQL.Text := 'select * from qps_column_note where (table_id = ' + IntToStr(TableID) +
      ') and (col_show = 1) order by col_show_id,auto_id';
    for i := 0 to DataGrid.ColumnCount - 1 do
      DataGrid.Columns[0].Destroy;
    i := 0;
    with ColQuery do begin
      Open;
      while not Eof do begin
        if FieldByName('col_field_type').AsInteger = 0 then
          DataGrid.CreateColumn(TdxDBGridColumn)
        else if FieldByName('col_field_type').AsInteger = 1 then
          DataGrid.CreateColumn(TdxDBGridDateColumn)
        else if FieldByName('col_field_type').AsInteger = 2 then
          DataGrid.CreateColumn(TdxDBGridCheckColumn)
        else if FieldByName('col_field_type').AsInteger = 3 then
          DataGrid.CreateColumn(TdxDBGridCurrencyColumn);
        if FieldByName('col_has_foot').AsInteger > 0 then begin
          aType := cstNone;
          case FieldByName('col_foot_type').AsInteger of
            0: aType := cstAvg;
            1: atype := cstCount;
            2: aType := cstMax;
            3: aType := cstMin;
            4: aType := cstNone;
            5: aType := cstSum;
          end;
          DataGrid.Columns[i].SummaryFooterType := aType;
          DataGrid.Columns[i].SummaryFooterField := Trim(FieldByName('col_foot_field').AsString);
          DataGrid.Columns[i].SummaryFooterFormat := Trim(FieldByName('col_foot_format').AsString);
        end;
        if FieldByName('col_display_format').AsString <> '' then
          (DataGrid.Columns[i] as TdxDBGridCurrencyColumn).DisplayFormat := FieldByName('col_display_format').AsString;
        DataGrid.Columns[i].BandIndex := 0;
        DataGrid.Columns[i].FieldName := Trim(FieldByName('col_field_name').AsString);
        DataGrid.Columns[i].Caption := Trim(FieldByName('col_text').AsString);
        DataGrid.Columns[i].ReadOnly := FieldByName('col_read_only').AsInteger > 0;
        DataGrid.Columns[i].Width := FieldByName('col_width').AsInteger;
        Next;
        Inc(i);
      end;
    end;
    ColQuery.Close;
  finally
    ColQuery.Free;
  end;
end;  

}

{

�ο��ҵĴ���

//����ؼ�����UIStyle���ԣ���������ֵ
//UIStyle����Ϊö������
function SetComponentUIStyle(AComponent :TComponent; AUIStyle : TUIStyle) :Boolean;
var
  PropInfo :PPropInfo;
  FStyle :String;
begin
  Result := False;
  PropInfo := GetPropInfo(AComponent.ClassInfo, 'UIStyle');
  if PropInfo <> nil then
  begin
    if PropInfo^.PropType^.Kind= tkEnumeration then
    begin
      FStyle := GetEnumName(TypeInfo(TsuiUIStyle), Integer(AUIStyle));
      SetEnumProp(AComponent, PropInfo, FStyle);
      Result := True;
    end;
  end;
end;

function SetComponentFileTheme(AComponent :TComponent; AFileTheme: TFileTheme) :Boolean;
var
  PropInfo :PPropInfo;
begin
  Result := False;
  PropInfo := GetPropInfo(AComponent.ClassInfo, 'FileTheme');
  if PropInfo <> nil then
  begin
    if PropInfo^.PropType^.Kind= tkClass then
    begin
      SetObjectProp(AComponent, PropInfo, AFileTheme);
      Result := True;
    end;
  end;
end;  

}

{

д��һ�����������Կ�
function CheckEditInt(AEdit:TEdit;Min,Max:Integer;CanNull:Boolean;Info:string):Integer;
  TempInt:integer;
  TempStr:string;
begin
  try
  if CanNull=True then
  begin
    if Trim(AEdit.Text)='' then
    begin
      Result:=0;
      exit;
    end;
  end
  else
    if Trim(AEdit.Text)='' then
    begin
      Result:=1;
      ShowMessage(Info+'����Ϊ�գ�');
      AEdit.SetFocus;
      exit;
    end;
  TempInt:=StrToInt(AEdit.Text);
  if (TempInt<Min) or (TempInt>Max) then
  begin
    if Min=Max then
      TempStr:=IntToStr(Min)+'!'
    else
      TempStr:=IntToStr(Min)+'��'+IntToStr(Max)+'֮��!';
    ShowMessage(Info+'����Ϊ'+TempStr);
    Result:=2;
    exit;
  end;
    Result:=0;
Except
  ShowMessage(Info+'ӦΪ���֣�');
  AEdit.SetFocus;
  Result:=1;
end;
end;  

}


{

procedure TForm1.Button1Click(Sender: TObject);
var
  I: Integer;
  Temp: TComponent;
begin
  for I := 0 to ComponentCount - 1 do
  begin
    Temp := Components[I];
    if Temp is TEdit then
    begin
      TEdit(Temp).ReadOnly := true;
    end;
  end;
end;

���ߣ�
procedure TForm1.Button1Click(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to ControlCount - 1 do
  begin
    if Controls[I] is TEdit then
    begin
      TEdit(Controls[I]).ReadOnly := true;
    end;
  end;
end; 


}

{

frreport1.LoadFromFile(extractfilepath(application.exename)+'1.frf');
FrReport1.PrepareReport;
FrReport1.PrintPreparedReport('1',1,True,frAll);   .//ֱ�Ӵ�ӡ
frreport1.ShowReport;                               //����Ԥ������
frreport1.DesignReport; 
}

{
���⣺��������ݿ⶯̬���ɲ˵��Ĵ��� ( ���֣�50, �ظ���8, �Ķ���145 )
���ࣺ���ݿ�-�ļ��� ( ������hbezwwl, bubble )  
���ԣ�oupj, ʱ�䣺2004-9-5 13:19:00, ID��2794454 [��ʾ��С���� | ������]  

���ݿ�ṹΪ

MenuName Caption   SetID
��������������������������������
wrer     �ļ�       10
jhjt          �ļ�1     1010
hj     �ļ�2     1012
fh     -     1011
u     �༭     11
ry     �༭1     1110
hjkhhg     �༭2       111011
g     ����       12

���������������ݿ��������²˵�

�ļ�        �༭       ����
 |_�ļ�1     |_�༭1    
 |_�ļ�2        |_�༭2  


���ԣ�dlwzp, ʱ�䣺2004-9-6 12:50:43, ID��2795314
1)select * from your db order by setid
2)��SetID��λ�������˵���
��ʵ�˵���һ�����νṹ�����ܰѱ�ԭ���������ܶ�̬���ɲ˵���  


���ԣ�oupj, ʱ�䣺2004-9-8 12:39:58, ID��2798232
���Լ���һ����������ȱ�㣬��λ���ְ�æ����
procedure TFrm_Main.LoadMainMenu;
var
    curID: String;
    ImageIndex: Integer;
    level: Integer;
    MainMenuItem, MenuItem: TMenuItem;
    //MenuItem: Array[0..9] of TMenuItem;
    //MenuItem: TMenuItem;
begin
  //��ʼ������
  level:=0 ;
  curID:= '';
  //�������ݱ����ñ����ֶμ�¼������ɣ��������
  with CDS_Sys_Menu do
  begin
    try
      Close;
      CommandText:= 'Select * from Sys_Menu where SeptID Like '+ QuotedStr(CurID+'%')
                 +' and Len(SeptID)='+ (IntToStr(Length(curID)+2)) +' order by SeptID';
      Open;
      First;
      while not eof do
      begin
        curID:=Trim(FieldByName('SeptID').AsString);
        begin
          if Not FieldByName('ImageIndex').IsNull then
            ImageIndex:= FieldByName('ImageIndex').AsInteger;
          MainMenuItem:= TMenuItem.Create(MainMenu1);
          MainMenuItem.Name:= Trim(FieldByName('MenuName').AsString);
          MainMenuItem.Caption:= Trim(FieldByName('Caption').AsString);
          MainMenu1.Items.Add(MainMenuItem);
        end;
          LoadMainItem(MainMenuItem, curID);
          Next;
      end;
    finally;
      close;
    end;
  end;
end;


Function TFrm_Main.LoadMainItem(MainMenuItem: TMenuItem;curID: String) :Integer;
var
  MenuItem: TMenuItem;
begin
        with CDS_Tmp do
        begin
          Close;
          CommandText:= 'Select * from Sys_Menu where SeptID Like '+ QuotedStr(CurID+'%')
                 +' and Len(SeptID)='+ (IntToStr(Length(curID)+2)) +' order by SeptID';
          Open;

          while not eof do
          begin
            MenuItem:= TMenuItem.Create(MainMenu1);
            MenuItem.Name:= Trim(FieldByName('MenuName').AsString);
            MenuItem.Caption:= Trim(FieldByName('Caption').AsString);
            MainMenuItem.Add(MenuItem);
            LoadMainItem(MenuItem, Trim(CDS_Tmp.FieldByName('SeptID').AsString));
            Next;    
          end;
        end;

end;
  


���ԣ�flamboyant, ʱ�䣺2004-9-8 13:19:26, ID��2798318
procedure TFrm_Main.LoadMainMenu;
var
    curID: String;
    level: Integer;
     MenuItem: TMenuItem;
begin
  //��ʼ������
  level:=-1 ;
  curID:= '';
  //�������ݱ����ñ����ֶμ�¼������ɣ��������
  with CDS_Sys_Menu do
  begin
    try
      Close;
      CommandText:= 'Select * from Sys_Menu order by SeptID';
      Open;
      First;
       while not eof do
      begin
        MainMenuItem:= TMenuItem.Create(MainMenu1);

        begin
          if length(FieldByName('SeptID').AsString)=2 then
          begin
            curID:=Trim(FieldByName('SeptID').AsString);
            level:=level+1
            MainMenuItem.Name:= Trim(FieldByName('MenuName').AsString);
            MainMenuItem.Caption:= Trim(FieldByName('Caption').AsString);
            MainMenu1.Items.Add(MainMenuItem);
          end
          else
          begin
            if curid=left(Trim(FieldByName('MenuName').AsString),2) then
            begin
              MainMenuItem.Name:= Trim(FieldByName('MenuName').AsString);
              MainMenuItem.Caption:= Trim(FieldByName('Caption').AsString);
              MainMenu1.Items[level].Add(MainMenuItem);
            end;
          end;
        end;
      end;
    finally;
      close;
    end;
  end;
end;

end;

û�ԣ���Ÿ����¡��Բ����Ϲ涥�ļ�¼û�д���  


���ԣ�hongxing_dl, ʱ�䣺2004-9-8 13:34:47, ID��2798341
������⻹û����𣿣�������ǰ�����ģ���ʱ��д���˶�û����ȥ�Ͷ����ˣ������ٷ���

���ȷ�һ��MainMenu�ڴ����ϣ�
procedure TForm1.FormCreate(Sender: TObject);
var
  mi,mi_sub:tmenuitem;
  mi_name:string;
begin
  dataset.close;
  //���ｫ���ݲ�ѯ����//����dataset������,������dlwzp˵���Ÿ���
  dataset.open;
  while not dataset.eof do
  begin
    mi_sub:=tmenuitem.create(self);
    mi_sub.caption:=dataset.fieldbyname('caption').asstring;
    mi_sub.name:='Menu_'+dataset.fieldbyname('SetID').asstring;
    mi_name:=copy(mi_sub.name,1,length(mi_sub.name)-2);
    mi:=nil;
    if findcomponent(mi_name)<>nil then
      mi:= findcomponent(mi_name) as tmenuitem;
    if mi=nil then//��ʾû�и���˵�������ӵ����˵���������ӵ���Ӧ�Ĳ˵�����
        mainmenu1.Items.Add(mi)
    else
        mi.add(mi_sub);
    dataset.next;//��һ��˵�
  end;
end;
���ܲ��Ǻ�ȫ�棬¥���Լ���ǿ��һ�°ɣ��� �Ѿ��ܼ���  


���ԣ�oupj, ʱ�䣺2004-9-8 15:24:06, ID��2798563
��л����2λ���ѵİ���
���ܿ�ϧ�������У�����  


���ԣ�zhfree, ʱ�䣺2004-9-8 15:36:21, ID��2798578
�����ٶ�Ӹ��ֶΣ��������ƣ�id����id��name����������
Ŀ¼��ļ�¼��id��Ϊ�㣬�����¼�ĸ�id��¼�ϼ���¼��id��
���һ��select��䣬һ��ѭ������ϲ˵���Ĵ����������  


���ԣ�flamboyant, ʱ�䣺2004-9-9 15:39:58, ID��2800177
procedure TFrm_Main.LoadMainMenu;
var
    curID: String;
    level: Integer;
     MenuItem: TMenuItem;
begin
  //��ʼ������
  level:=-1 ;
  curID:= '';
  //�������ݱ����ñ����ֶμ�¼������ɣ��������
  with CDS_Sys_Menu do
  begin
    try
      Close;
      CommandText:= 'Select * from Sys_Menu order by SeptID';
      Open;
      First;
      while not eof do
      begin
        MenuItem:= TMenuItem.Create(self);

        begin
          if length(trim(FieldByName('SeptID').AsString))=2 then
          begin
            curID:=Trim(FieldByName('SeptID').AsString);
            level:=level+1;
            MenuItem.Name:= Trim(FieldByName('MenuName').AsString);
            MenuItem.Caption:= Trim(FieldByName('Caption').AsString);
            MainMenu1.Items.Add(MenuItem);
          end
          else
          begin
            if curid=leftstr(Trim(FieldByName('SeptID').AsString),2) then
            begin
              MenuItem.Name:= Trim(FieldByName('MenuName').AsString);
              MenuItem.Caption:= Trim(FieldByName('Caption').AsString);
              MainMenu1.Items[level].Add(MenuItem);
            end;
          end;
        end;
        next;
      end;
    finally;
      close;
    end;
  end;
end;
����Թ��ˣ������ų��˼����ͼ�����¥��Ӧ���е�̽�������Լ������֣�  


���ԣ�oupj, ʱ�䣺2004-9-10 8:28:06, ID��2800976
¥�ϵ����������
����������������Ĵ��벻�����ɶ༶�˵�  


}

{

���� protected �������ı������������������ǿ��ŵģ����������ǲ��ܷ��ʵġ�

}
