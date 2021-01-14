unit SysPublic;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, DBGrids, ExtCtrls, Buttons, Mask, DBCtrls, Db, DBTables,
  Qrctrls, ADODB, DataM, Math, WinSock, ComObj, Variants, qrprntr,
  QuickRpt, DBGridEh, FR_Class, DBGridEhImpExp,
  StrUtils, FR_DBSet, DBCtrlsEh, DBLookupEh;

const
  //���ܴ�
 GENERAL_REGISTER_CODE = 'WSQL-2003-9561-0423-951U-BXRO';
  ROOT_PASSWORD = 'wangchw'; //��������

  sUserPass = 'wangchw';

  //Ȩ����
  lInsert =0;//����
  lEdit =1;//�޸�
  lDelete= 2;//ɾ��
  lFind =3;//����
  lFilter =4;//����
  lPrint =5;//��ӡ
  lExport =6;//����
  lmodule =100;//ģ��Ȩ��

  sEdit= 'dsEdit';
  sInsert ='dsInsert';


var

  bSoftRegister: Boolean = False; //�Ƿ�Ϊע���
  bCygl : Boolean = True;   //�汾����
  sApplication : string;
  SOFTWARE_CAPTION: string;
  G_bAdmin, G_bTakeEffect: Boolean; {�Ƿ񳬼��û�,�����Ƿ�����}
  G_iUserID, G_iDepID: integer; {�û��ڲ�ID,���������ڲ�ID}
  G_sUserCode, G_sUserName, G_sDepName: string; {�û����룬�û���������������}
  G_sPWD: string; {�û�����}
  G_sSpace: string; {������/Զ��}
  G_bAppEnabled: Boolean;{�����Ƿ��ʹ��}

  Str_djid_pub: string;   ///////////2004-11-22  ���ݱ�ʶ
  SYSStartDate: TDateTime; //��½ʱ��ʼʱ��

const
  DBPass= '123456'; //�������ݿ�����
  
//�ı�DBGrid�е���ɫ,ûʲô�ر𣬵��Ǿ�����ɫʦ����ŷ
procedure ChangeDbGridColColor(ojbDbGrid:TDbGrid);

//���������־
function SaveOperateLog(sTitle: string): Boolean;

//�õ���������
function GetLocalHost: string;

//IP��ַ����Ϊ��������
function IPToHost(IPAddr: string): string;

//�õ���ǰ����ؼ�
function GetFocusedComponent(frmForm: TForm): TComponent;

{ ���ؼ�¼������������ʾ������Ƿ�ɹ� }
function DBGridRecordSize(mColumn: TColumn): Boolean;

{ �������������Զ���Ӧ����Ƿ�ɹ� }
function DBGridAutoSize(mDBGrid: TDBGrid; mOffset: Integer = 5): Boolean;

//��ȡSQL Server�������б�
function GetSQLServerList(Combobox :TComBoBox): Boolean;

//DBGrib�е����������Excel��
procedure DeriveToExcel(Title: String; DBGrid: TDBGrid; Total: Boolean);

//// ��������ӡ��
procedure DeriveToPrint(Title: String; DBGrid: TDBGrid; Total: Boolean);

//��Ό������D�Q��Ӣ��
Function RealToTxt(Amount : Real) : String;

(*//
����:�ַ���������
˵��:���򡢽���;ʾ�������������
���:Zswang
����:2002-04-27
֧��:wjhu111@21cn.com
//*)

//
function StringGridRowSwap(mStringGrid: TStringGrid;
  mFromRow, mToRow: Integer): Boolean;

//
function StringGridRowSort(mStringGrid: TStringGrid;
  mColIndex: Integer; mDesc: Boolean = False): Boolean;

{
procedure TForm1.StringGrid1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
{$J+}
//const
//  vOldCol: Integer = -1;
{$J-}
//var
//  vCol, vRow: Integer;
//begin
//  if Button = mbRight then Exit;
//  TStringGrid(Sender).MouseToCell(X, Y, vCol, vRow);
//  if (vRow < 0) or (vRow >= TStringGrid(Sender).FixedRows) then Exit;
//  StringGridRowSort(TStringGrid(Sender), vCol, vOldCol = vCol);
//  if vOldCol = vCol then
//    vOldCol := - vOldCol
//  else vOldCol := vCol;
//end;

function StrLeft(const mStr: string; mDelimiter: string): string;

function ListValue(mList: string; mIndex: Integer; mDelimiter: string = ','): string;

function StringGridToText(mStringGrid: TStringGrid;
  mStrings: TStrings): Boolean;

function TextToStringGrid(mStrings: TStrings;
  mStringGrid: TStringGrid): Boolean;

{
procedure TForm1.Button1Click(Sender: TObject);
begin
  StringGridToText(StringGrid1, Memo1.Lines);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  TextToStringGrid(Memo1.Lines, StringGrid1);
end;

}

function repl_substr(sub_old, sub_new, s: string): string; //��sub_old����sub_new,�������á�
function BackupSQLDataBase(connstr_sql,DatabaseName,Backup_FileName:string):Boolean;//���ݿⱸ�ݺ���
//SQL�������ݿⱸ�ݣ�connstr_sql��ADO�ؼ���connectionstring,DatabaseName�����ݿ����ƣ�
//Backup_FileNameҪ���ݵ���Ŀ ���ļ�
function RestoreSQLDataBase(connstr_sql,DatabaseName,Restore_FileName:string):Boolean;//���ݿ�ָ�����
//Restore_FileName��ǰ���ݵ����ݿ��ļ���

//��һ������ҽ���Сдת������ʾ����
function F2C(r: real): string;

//�ؼ�����Ӧ�����С
Procedure CompentAutoSize(FormeSize:TForm;var Form_width,Form_Height:integer);

//����ADOConnection
function GetConn(ADOQry: TADOQuery): Boolean;

//ͬ����Ini�ļ�,�õ�һ�ֶε�ֵ
function GetIniValue(ADOConnet: TADOConnection; sName: string): string;

//��DataSet
function OpenDataSetEx(ADOConnet: TADOConnection; DataSet: TADOQuery; szSql: string): Boolean;

//����ע�������
function MakeComputerCode: string;

//�õ�Ӳ�̵����к�
function GetIDESerial: string;

//�õ��������к�
function GetDiskSerial(sDisk: string): string;

//�õ�0-9,a-b֮��ı�׼�ַ�
function GetStandardStr(sStr: string): string;

//�õ����������
function GetPCName: string;


//����ע���
function MakeRegisterCode(sName, sPcCode: string): string;

//�ַ�������
function StringEncrypt(mStr: string; mKey: string): string;

//ת��Ϊ����ʾ���ܴ�
function StringToDisplay(mString: string): string;

//ͬ����Ini�ļ�,�޸�һ�ֶε�ֵ
function SetIniValue(ADOConnet: TADOConnection; sName, sValue: string): Boolean;
//�������ݿ��Ƿ�Ϊ�ո߼�
function GetDataSetEmptyEx(ADOConnet: TADOConnection; sSql: string): Boolean;

//�߼�ִ��Sql
function ExecSqlEx(ADOConnet: TADOConnection; sSql: string): Boolean;

//�������ݿ�����
function GetDataSetCount(sSql: string): Integer;


//�������ݿ������߼�
function GetDataSetCountEx(ADOConnet: TADOConnection; sSql: string): Integer;

//�ж������Ƿ�ʹ��
function JudgeDataUse(originalityTableName,OriginalityFieldName, presentFieldValue: string): Boolean;


procedure SaveButtonState(RadGro: TRadioGroup);

procedure SetDBGridState(const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState; DBGrid1: TDBGrid);

//����DBGrid����ɫ
procedure SetDBGridColor(DBGridEh1: TDBGridEh; const Rect: TRect; DataCol: Integer; ColumnEh: TColumnEh;
  State: TGridDrawState; Sender: TObject);

//������ʾ�Ի���
procedure RemMsgBox(RemindText: string; Caption: string='');

//MessageBox
function MsgBox(Text: string; Flags: Longint = MB_OK): Integer;


//ShowMessage
procedure ShowMsg(sMsg: string);

//DBGridEh��ҳ
procedure ReadDBGridEhAutoFitColWidth(Form1: TForm);

procedure SaveDBGridEhAutoFitColWidth(CheckBox1: TCheckBox);

//��������
//function SetReportSubTitle: Boolean;

//


function InsCode(IniData: integer; ADOQuery1: TADOQuery; sFieldName, sTable: string): Boolean;

procedure ManipulateControl(WinControl: TControl;
  Shift: TShiftState; X, Y, precision: integer);

procedure TM(Fd:TDBNavigator);
//��MDI���ں���
procedure OpenForm(FormClass: TFormClass; var fm; AOwner:TComponent);
//�򿪴������ACCESS���ݿ⺯��
function LnkAccess(var ADOConnet: TADOConnection; Db, DbPwd: string):Boolean;
//���ӱ�ϵͳ���ݿ⺯��
function LnkLocalAccess: Boolean;

function GridFieldToTitle(GridEh: TDBGridEh; sField: string):  string;


function SaveDataSet(ADOQuery1: TADOQuery; Cached: Boolean): Boolean;


function FindPublic(Grid1: TDBGridEh; var sText: string; var
  lFiled: Integer): Boolean;

procedure DBGridEhExport(DBGridEh: TDBGridEh; Form: TForm);
//�����ֶ�����
function GetFieldType(fField: TField): string;

function FilterPublic(Grid1: TDBGridEh): Boolean;


function CheckEditEmpty(lMsg: Integer; Form1: TForm; AsLabel, AsEdit: array of
  string): Boolean;

//���������գ������������������ӵ��������ɵ��š����ߣ���������2003-080-06��08:41�����
Function GetID(Aqy: TADOQuery; TableName,DHFieldName,DateFieldName, TypeFieldName, TypeValue:String;
BeginPos,StrLen:integer):boolean;

//���������գ���������ӵ��������ɵ���
Function IDGen(Aqy: TADOQuery; DJType, TableName,DHFieldName,DateFieldName:String;
BeginPos,StrLen:integer):boolean;

procedure ConnAccess(AdoConn: TADOConnection; FileName, UserName, Password: string);


//�ֶθ�ֵ���� 2004-11-16
procedure SetField(StrTarget,StrSource: string; ADOQryTarget,
  ADOQrySource: TADOQuery);
//����һ����Ϣ
procedure SendMsg(hWnd, Msg, wParam: Integer; lParam: Integer = 0);

//����������ɣ������ �ַ������ָ��(�ָ�������ǵ����ַ�Ҳ�������ַ�����Ҳ�����Ǻ���)�������� ��һ��Tstringlist���飬������0��ʼ result[0]�ǵ�һ��
function SplitString(const source, ch: string): tstringlist;

//��������Զ��庯��������ȡ��������ָ���֮����ִ���Ŀǰ�ָ���Ϊ','��Ҫע��Ļ���Ŀǰ�������ص��ִ������ָ������������������ָ�������Ļ���������޸�  locate_string:=copy
function locate_string(line_string:string;start_position,end_position:integer):string;

//Stringת��Int
function StrToInt2(s: string): Integer;

//����GRID�ֶ�
function StrToGridField(Grid1: TDBGridEh; sFieldName, sCaption, sWidth: string; sMask: string = ''): Boolean;

//���������
function SetCol(sCaption: string; DBGridEh1: TDBGridEh; lInit: Integer): Boolean;

//�����п�
function SetColWidth(sCaption: string; Grid: TDBGridEh): Boolean;

//ִ��Sql
function ExecSql(sSql: string): Boolean;

//��DataSet(Ĭ��ADOConnet)
function OpenDataSet(DataSet: TADOQuery; szSql: string): Boolean;

//�������Ƿ��ƽ

procedure SaveDBGridEhFlat(CheckBox1: TCheckBox);

//��ȡDBGridEh�Ƿ�Ϊ��ƽ
procedure ReadDBGridEhFlat(Form1: TForm);

procedure SaveDBEditEhFlat(CheckBox3: TCheckBox);

//����EDIT��ƽ
procedure ReadDBEditFlat(Form1: TForm);

//������ʼ��������
function GetDate(var tStartDate, tEndDate: TDateTime): Boolean;

//Stringת��Boolean
function StrToBool2(sStr: string): Boolean;

{
  �������ƣ�FilterStrInBracket
  �������ܣ����[]�е�ֵ
  ʹ��˵����
  �����ˣ�
  �������ڣ�}
  function  FilterStrInBracket(value:string):String;

{
  �������ƣ�EncryptPassword
  �������ܣ�����һ���ַ���
  ʹ��˵����
  �����ˣ�
  �������ڣ�}
  function EncryptPassword(value:string):string;


function SysRightLimit(Form1: string; i: integer): Boolean;

function SetID(sTitle, DHFieldName,TableName:String ; BeginPos,StrLen:integer): string;

//��ʾ�ؼ����ظ�
procedure ShowIDRepeat(sIDName: string);

var
  LoginEmployeName: string;
  LoginEmployeCode : string;

implementation

uses DiskSerialNumber, PrintStructure, Main, FindPublic, FilterPublic, ColSetup, DateForm;

procedure SetDBGridColor(DBGridEh1: TDBGridEh; const Rect: TRect; DataCol: Integer; ColumnEh: TColumnEh;
  State: TGridDrawState; Sender: TObject);
begin
Case DBGridEh1.DataSource.DataSet.RecNo Mod 2 = 0 of
True: DbGridEh1.Canvas.Brush.Color:= clInfoBk; //ż��������ɫ
//False: DbGrid1.Canvas.Brush.Color:= clAqua;//��������ǳ��ɫ
End;
DbGridEh1.Canvas.Pen.Mode:=pmMask;
DbGridEh1.DefaultDrawColumnCell (Rect, DataCol, ColumnEh, State);

{with (Sender as TDBGrid).Canvas do //�� cell �ı߿�
  begin
    Pen.Color := $00ff0000; //���廭����ɫ(��ɫ)
    MoveTo(Rect.Left, Rect.Bottom); //���ʶ�λ
    LineTo(Rect.Right, Rect.Bottom); //����ɫ�ĺ���
    Pen.Color := $0000ff00; //���廭����ɫ(��ɫ)
    MoveTo(Rect.Right, Rect.Top); //���ʶ�λ
    LineTo(Rect.Right, Rect.Bottom); //����ɫ������
  end;}

end;

procedure SetDBGridState(const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState; DBGrid1: TDBGrid);
begin
if ((State = [gdSelected]) or (State=[gdSelected,gdFocused])) then
DbGrid1.Canvas.Brush.color:=clRed; //��ǰ���Ժ�ɫ��ʾ��������ʹ�ñ�����ǳ��ɫ
DbGrid1.Canvas.pen.mode:=pmmask;
DbGrid1.DefaultDrawColumnCell (Rect, DataCol, Column, State);
end;

procedure SaveButtonState(RadGro: TRadioGroup);
var
  sShape: string;
  ADOQryTmp: TADOQuery;
begin
  ADOQryTmp:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp);
  ADOQryTmp.Close;
  ADOQryTmp.SQL.Clear;
  ADOQryTmp.SQL.Add('Select * From SystemTable Where Name = ''Button''');
  ADOQryTmp.Open;

  case RadGro.ItemIndex of
  0: sShape:= 'shCapsule';
  1: sShape:= 'shOval';
  2: sShape:= 'shRectangle';
  3: sShape:= 'shRoundRect';
  end;

  ADOQryTmp.Edit;
  ADOQryTmp.FieldByName('Code').AsString:= sShape;
  ADOQryTmp.Post;

//  ReadButtonState;
end;

procedure ChangeDbGridColColor(ojbDbGrid:TDbGrid);
var
  i:integer;
begin
  for i:= 0 to ojbDbGrid.Columns.Count -1 do
  begin
    case i mod 3 of
      0: ojbDbGrid.Columns.Items[i].Color:=TColor($0023AF82);
      1: ojbDbGrid.Columns.Items[i].Color:=TColor($00339CDB);
      2: ojbDbGrid.Columns.Items[i].Color:=TColor($00C69C6D);
    end;
  end;
end;

function SaveOperateLog(sTitle: string): Boolean;
var
  sSql: string;
begin
  Result := False;
  sSql := 'INSERT INTO ����ϵͳ��־(����,������,����Ա,����) VALUES('''+
  FormatDateTime('yyyy-mm-dd', Date) +''',''' + GetLocalHost + ''',''' +
  LoginEmployeName + ''',''' + sTitle + ''')';
  DataMForm.ADOConnet.Execute(sSql);
  Result := True;
end;

function GetLocalHost: string;
begin
  Result := IPToHost('');
end;

function IPToHost(IPAddr: string): string;
var
  SockAddrIn: TSockAddrIn;
  HostEnt: PHostEnt;
  WSAData: TWSAData;
begin
  WSAStartup($101, WSAData);
  SockAddrIn.sin_addr.s_addr := inet_addr(PChar(IPAddr));
  HostEnt := gethostbyaddr(@SockAddrIn.sin_addr.S_addr, 4, AF_INET);
  if HostEnt <> nil then
  begin
    Result := StrPas(Hostent^.h_name)
  end
  else
  begin
    Result := '';
  end;
end;

function GetFocusedComponent(frmForm: TForm): TComponent;
var
  i: Integer;
begin
  Result := nil;
  with frmForm do
  begin
    for i := 0 to ComponentCount - 1 do
    begin
      if (Components[i] is TWinControl) and TWinControl(Components[i]).Focused then
      begin
        Result := Components[i];
        break;
      end;
    end;
  end;
end;

function DBGridRecordSize(mColumn: TColumn): Boolean;
begin
Result := False;
if not Assigned(mColumn.Field) then Exit;
mColumn.Field.Tag := Max(mColumn.Field.Tag,
TDBGrid(mColumn.Grid).Canvas.TextWidth(mColumn.Field.DisplayText));
Result := True;
end; { DBGridRecordSize }

function DBGridAutoSize(mDBGrid: TDBGrid; mOffset: Integer = 5): Boolean;
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
end; { DBGridAutoSize }

function GetSQLServerList(Combobox :TComBoBox): Boolean;
var
  SQLServer:Variant;
  ServerList:Variant;
  i,nServers:integer;
  sRetValue:String;
begin
  Result := True;
  try
    SQLServer := CreateOleObject('SQLDMO.Application');
    ServerList:= SQLServer.ListAvailableSQLServers;
    nServers:=ServerList.Count;
    for i := 1 to nservers do
    Combobox.Items.Add(ServerList.Item(i));
    SQLServer:=NULL;
    serverList:=NULL;
  except
    Result := False;
  end;
end;

procedure DeriveToExcel(Title: String; DBGrid: TDBGrid; Total: Boolean);
var
  ExcelApp, WorkBook: Variant;
  i, j: Integer;
  Row, Col: Integer;
  FieldName: string;
  DataSet: TDataSet;
  S: String;
begin

  // ���ݷ��͵� Excel
  try
    ExcelApp := CreateOleObject('Excel.Application');
    WorkBook := CreateOleObject('Excel.Sheet');
  except
    Application.MessageBox('��Ļ�����δ��װMicrosoft Excel.     ', '', 32);
    Exit;
  end;

  Application.ProcessMessages;
  WorkBook := ExcelApp.WorkBooks.Add;
  Col := 1;
  ExcelApp.Cells(2, Col) := Title;
  Row := 4;
  DataSet := DBGrid.DataSource.DataSet;
  for I := 0 to DBGrid.Columns.Count - 1 do
  begin
    if DBGrid.Columns[I].Visible then
    begin
      FieldName := DBGrid.Columns[I].Title.Caption;
      ExcelApp.Cells(Row, Col) := FieldName;
      Col := Col + 1;
    end;
  end;

  Row := Row + 1;

  DataSet.First;
  while not DataSet.Eof do
  begin
    Col := 1;
    for J := 0 to DBGrid.Columns.Count - 1 do
    begin
      FieldName := DBGrid.Columns[J].FieldName;
      ExcelApp.Cells(Row, Col) := ' ' + DataSet.FieldByName(FieldName).AsString + ' ';
      Col := Col + 1;
    end;
    Row := Row + 1;
    DataSet.Next;
  end;

  if Total then
  begin
    Col := 1;
    for J := 0 to DBGrid.Columns.Count - 1 do
    begin
      S := Char(64 + ((J+1) mod 26));
      if (J+1) > 26 then
      begin
        S := Char(65+(((J+1)-26) div 26)) + S;
      end;
      if J = 0 then
      begin
        ExcelApp.Cells(Row, Col) := '�ϼ�';
      end
      else if DBGrid.Columns[J].Field.DataType in [ftInteger, ftSmallint, ftFloat, ftBCD] then
      begin
        FieldName := DBGrid.Columns[J].FieldName;
        ExcelApp.Cells(Row, Col) := '=SUM('+S+'4:'+S+IntToStr(Row-1)+')';
      end;
      Col := Col + 1;
    end;
  end;
  ExcelApp.Visible := True;
//    WorkBook.SaveAs(SaveDialog1.FileName);
//    WorkBook.Close;
//    ExcelApp.Quit;
//    ExcelApp := Unassigned;
end;

procedure DeriveToPrint(Title: String; DBGrid: TDBGrid; Total: Boolean);
const
  LeftMargin = 3;
  RightMargin = 3;

var
  I, L: Integer;
  QR: TQuickRep;
  QRLabel: TQRLabel;
  QRShape: TQRShape;
  QRDBText: TQRDBText;
  QRExpr: TQRExpr;
  PageHeader: TQRBand;
  ColumnHeader: TQRBand;
  SummaryBand: TQRBand;
  Detail: TQRBand;
  PageFooter: TQRBand;
  DataSet: TDataSet;
begin
  QR := TQuickRep.Create(Application.MainForm);

  PageHeader := TQRBand.Create(QR);
  PageHeader.Parent := QR;
  PageHeader.BandType := rbPageHeader;
  PageHeader.Height := 80;

  ColumnHeader := TQRBand.Create(QR);
  ColumnHeader.Parent := QR;
  ColumnHeader.BandType := rbColumnHeader;
  ColumnHeader.Height := 24;
  ColumnHeader.Frame.DrawTop := True;
  ColumnHeader.Frame.DrawBottom := False;
  ColumnHeader.Frame.DrawLeft := True;
  ColumnHeader.Frame.DrawRight := True;

  Detail := TQRBand.Create(QR);
  Detail.Parent := QR;
  Detail.BandType := rbDetail;
  Detail.Height := 24;
  Detail.Frame.DrawTop := False;
  Detail.Frame.DrawBottom := False;
  Detail.Frame.DrawLeft := True;
  Detail.Frame.DrawRight := True;

  SummaryBand := nil;
  if Total then
  begin
    SummaryBand := TQRBand.Create(QR);
    SummaryBand.Parent := QR;
    SummaryBand.BandType := rbSummary;
    SummaryBand.Height := 24;
    SummaryBand.Frame.DrawTop := False;
    SummaryBand.Frame.DrawBottom := True;
    SummaryBand.Frame.DrawLeft := True;
    SummaryBand.Frame.DrawRight := True;
  end;

  try
    DataSet := DBGrid.DataSource.DataSet;
    QR.DataSet := DataSet;
    // ������
    if Trim(Title) <> '' then
    begin
      QRLabel := TQRLabel.Create(QR);
      QRLabel.Parent := PageHeader;
      QRLabel.AutoSize := False;
      QRLabel.Top := 30;
      QRLabel.Left := 0;
      QRLabel.Width := PageHeader.Width;
      QRLabel.Alignment := taCenter;
      QRLabel.Caption := Title;
      QRLabel.Font.Name := '����';
      QRLabel.Font.Size := 16;
      QRLabel.Font.Style := [fsBold];
    end;

    QRShape := TQRShape.Create(QR);
    QRShape.Parent := ColumnHeader;
    QRShape.Shape := qrsHorLine;
    QRShape.Width := ColumnHeader.Width;
    QRShape.Left := 0;
    QRShape.Top := ColumnHeader.Height - 1;
    QRShape.Height := 1;

    L := 0;
    for I := 0 to DBGrid.Columns.Count - 1 do
    begin
      QRLabel := TQRLabel.Create(QR);
      QRLabel.Parent := ColumnHeader;
      QRLabel.AutoSize := False;
      QRLabel.Left := L;
      QRLabel.Top := 5;
      QRLabel.Width := DBGrid.Columns[I].Width;
      QRLabel.Alignment := taCenter;
      QRLabel.Caption := DBGrid.Columns[I].Title.Caption;
      QRLabel.Font.Name := '����';
      QRLabel.Font.Size := 9;
      L := L + DBGrid.Columns[I].Width;
      if I < DBGrid.Columns.Count - 1 then
      begin
        if (L + DBGrid.Columns[I+1].Width) > ColumnHeader.Width then
        Break;
      end;
      if I < DBGrid.Columns.Count - 1 then
      begin
        QRShape := TQRShape.Create(QR);
        QRShape.Parent := ColumnHeader;
        QRShape.Shape := qrsVertLine;
        QRShape.Width := 1;
        QRShape.Left := L;
        QRShape.Top := 0;
        QRShape.Height := ColumnHeader.Height;
        L := L + 1;
      end;
    end;

    QRShape := TQRShape.Create(QR);
    QRShape.Parent := Detail;
    QRShape.Shape := qrsHorLine;
    QRShape.Width := Detail.Width;
    QRShape.Left := 0;
    QRShape.Top := Detail.Height - 1;
    QRShape.Height := 1;

    L := 0;
    for I := 0 to DBGrid.Columns.Count - 1 do
    begin
      QRDBText := TQRDBText.Create(QR);
      QRDBText.Parent := Detail;
      QRDBText.AutoSize := False;
      QRDBText.Left := L + LeftMargin;
      QRDBText.Top := 6;
      QRDBText.Width := DBGrid.Columns[I].Width - (LeftMargin + RightMargin);
      QRDBText.Alignment := DBGrid.Columns[I].Alignment;
      QRDBText.DataSet := DataSet;
      QRDBText.DataField := DBGrid.Columns[I].FieldName;
      QRDBText.Font.Name := '����';
      QRDBText.Font.Size := 9;
      L := L + DBGrid.Columns[I].Width;
      if I < DBGrid.Columns.Count - 1 then
      begin
        if (L + DBGrid.Columns[I+1].Width) > Detail.Width then
        Break;
      end;
      if I < DBGrid.Columns.Count - 1 then
      begin
        QRShape := TQRShape.Create(QR);
        QRShape.Parent := Detail;
        QRShape.Shape := qrsVertLine;
        QRShape.Width := 1;
        QRShape.Left := L;
        QRShape.Top := 0;
        QRShape.Height := Detail.Height;
        L := L + 1;
      end;
    end;

    // ���Ӻϼ���
    if Total then
    begin
      L := 0;
      for I := 0 to DBGrid.Columns.Count - 1 do
      begin
        if I = 0 then
        begin
          QRLabel := TQRLabel.Create(QR);
          QRLabel.Parent := SummaryBand;
          QRLabel.AutoSize := False;
          QRLabel.Left := L + LeftMargin;
          QRLabel.Top := 6;
          QRLabel.Width := DBGrid.Columns[I].Width - (LeftMargin + RightMargin);
          QRLabel.Alignment := taCenter;
          QRLabel.Caption := '�ϼ�';
          QRLabel.Font.Name := '����';
          QRLabel.Font.Size := 9;
        end
        else if DBGrid.Columns[I].Field.DataType in [ftInteger, ftSmallint, ftFloat, ftBCD] then
        begin
          QRExpr := TQRExpr.Create(QR);
          QRExpr.Parent := SummaryBand;
          QRExpr.AutoSize := False;
          QRExpr.Left := L + LeftMargin;
          QRExpr.Top := 6;
          QRExpr.Width := DBGrid.Columns[I].Width - (LeftMargin + RightMargin);
          QRExpr.Alignment := DBGrid.Columns[I].Alignment;
          QRExpr.Expression := 'SUM(' + DBGrid.Columns[I].FieldName + ')';
          QRExpr.Font.Name := '����';
          QRExpr.Font.Size := 9;
        end;
        L := L + DBGrid.Columns[I].Width;
        if I < DBGrid.Columns.Count - 1 then
        begin
          if (L + DBGrid.Columns[I+1].Width) > SummaryBand.Width then
          Break;
        end;
        if I < DBGrid.Columns.Count - 1 then
        begin
          QRShape := TQRShape.Create(QR);
          QRShape.Parent := SummaryBand;
          QRShape.Shape := qrsVertLine;
          QRShape.Width := 1;
          QRShape.Left := L;
          QRShape.Top := 0;
          QRShape.Height := SummaryBand.Height;
          L := L + 1;
        end;
      end;
    end;

    // ��ӡҳβ
    PageFooter := TQRBand.Create(QR);
    PageFooter.Parent := QR;
    PageFooter.BandType := rbPageFooter;
    PageFooter.Height := 40;

    QRLabel := TQRLabel.Create(QR);
    QRLabel.Parent := PageFooter;
    QRLabel.Left := 30;
    QRLabel.Top := 4;
    QRLabel.Font.Name := '����';
    QRLabel.Font.Size := 9;
    QRLabel.Caption := '��ӡ���ڣ�' + DateToStr(Date);

    QR.PreviewModal;
  finally
    PageHeader.Free;
    ColumnHeader.Free;
    Detail.Free;
    if Total then
      SummaryBand.Free;
    PageFooter.Free;
    QR.Free;
  end;
end;

Function RealToTxt(Amount : Real) : String;
var
 Num : LongInt;
 Fracture : Integer;

 function Num2Str(Num: LongInt): String;
 Const hundred = 100;
       thousand = 1000;
       million = 1000000;
       billion = 1000000000;
  begin
    if Num >= billion then
      if (Num mod billion) = 0 then
        Num2Str := Num2Str(Num div billion) + ' Billion'
      else
        Num2Str := Num2Str(Num div billion) + ' Billion ' +
                   Num2Str(Num mod billion)
    else
      if Num >= million then
        if (Num mod million) = 0 then
          Num2Str := Num2Str(Num div million) + ' Million'
        else
          Num2Str := Num2Str(Num div million) + ' Million ' +
                     Num2Str(Num mod million)
      else
        if Num >= thousand then
          if (Num mod thousand) = 0 then
            Num2Str := Num2Str(Num div thousand) + ' Thousand'
          else
            Num2Str := Num2Str(Num div thousand) + ' Thousand ' +
                       Num2Str(Num mod thousand)
        else
          if Num >= hundred then
            if (Num mod hundred) = 0 then
              Num2Str := Num2Str(Num div hundred) + ' Hundred'
            else
              Num2Str := Num2Str(Num div  hundred) + ' Hundred ' +
                         Num2Str(Num mod hundred)
          else
          case (Num div 10) of
         6,7,9: if (Num mod 10) = 0 then
                   Num2Str := Num2Str(Num div 10) + 'ty'
                 else
                   Num2Str := Num2Str(Num div 10) + 'ty-' +
                              Num2Str(Num mod 10);
              8: if Num = 80 then
                   Num2Str := 'Eighty'
                 else
                   Num2Str := 'Eighty-' + Num2Str(Num mod 10);
              5: if Num = 50 then
                   Num2Str := 'Fifty'
                 else
                   Num2Str := 'Fifty-' + Num2Str(Num mod 10);
              4: if Num = 40 then
                   Num2Str := 'Forty'
                 else
                   Num2Str := 'Forty-' + Num2Str(Num mod 10);
              3: if Num = 30 then
                   Num2Str := 'Thirty'
                 else
                   Num2Str := 'Thirty-' + Num2Str(Num mod 10);
              2: if Num = 20 then
                   Num2Str := 'Twenty'
                 else
                   Num2Str := 'Twenty-' + Num2Str(Num mod 10);
            0,1: case Num of
                    0: Num2Str := 'Zero';
                    1: Num2Str := 'One';
                    2: Num2Str := 'Two';
                    3: Num2Str := 'Three';
                    4: Num2Str := 'Four';
                    5: Num2Str := 'Five';
                    6: Num2Str := 'Six';
                    7: Num2Str := 'Seven';
                    8: Num2Str := 'Eight';
                    9: Num2Str := 'Nine';
                   10: Num2Str := 'Ten';
                   11: Num2Str := 'Eleven';
                   12: Num2Str := 'Twelve';
                   13: Num2Str := 'Thirteen';
                   14: Num2Str := 'Fourteen';
                   15: Num2Str := 'Fifteen';
                   16: Num2Str := 'Sixteen';
                   17: Num2Str := 'Seventeen';
                   18: Num2Str := 'Eightteen';
                   19: Num2Str := 'Nineteen'
                 end
          end
 end {Num2Str};

begin
 Num:= Trunc(Amount);
 Fracture:= Round(1000*Frac(Amount));
 if Num > 0 then
   Result := Num2Str(Num) + ' and ';
 if Fracture > 0 then
   Result := Result + IntToStr(Fracture) + '/1000'
 else
   Result := Result +  '000/1000';
end;

function StringGridRowSwap(mStringGrid: TStringGrid;
  mFromRow, mToRow: Integer): Boolean;
var
  S: string;
begin
  Result := False;
  if (mToRow = mFromRow) then Exit;
  if not Assigned(mStringGrid) then Exit;
  if (mFromRow < 0) or (mFromRow >= mStringGrid.RowCount) then Exit;
  if (mToRow < 0) or (mToRow >= mStringGrid.RowCount) then Exit;
  try
    S := mStringGrid.Rows[mFromRow].Text;
    mStringGrid.Rows[mFromRow].Text := mStringGrid.Rows[mToRow].Text;
    mStringGrid.Rows[mToRow].Text := S;
  except
    Exit;
  end;
  Result := True;
end; { StringGridRowSwap }
 
function StringGridRowSort(mStringGrid: TStringGrid;
  mColIndex: Integer; mDesc: Boolean = False): Boolean;
var
  I, J: Integer;
begin
  Result := False;
  if not Assigned(mStringGrid) then Exit;
  if (mColIndex < 0) or (mColIndex >= mStringGrid.ColCount) then Exit;
  for I := mStringGrid.FixedRows to mStringGrid.RowCount - 2 do
    for J := I + 1 to mStringGrid.RowCount - 1 do
      if mDesc then
        if mStringGrid.Cells[mColIndex, I] < mStringGrid.Cells[mColIndex, J] then
          StringGridRowSwap(mStringGrid, I, J)
        else
      else if mStringGrid.Cells[mColIndex, I] > mStringGrid.Cells[mColIndex, J] then
        StringGridRowSwap(mStringGrid, I, J);
  Result := True;
end; { StringGridRowSort }
///////End Source

function StrLeft(const mStr: string; mDelimiter: string): string;
begin
  Result := Copy(mStr, 1, Pos(mDelimiter, mStr) - 1);
end; { StrLeft }
 
function ListValue(mList: string; mIndex: Integer; mDelimiter: string = ','): string;
var
  I, L, K: Integer;
begin
  L := Length(mList);
  I := Pos(mDelimiter, mList);
  K := 0;
  Result := '';
  while (I > 0) and (K <> mIndex) do begin
    mList := Copy(mList, I + Length(mDelimiter), L);
    I := Pos(mDelimiter, mList);
    Inc(K);
  end;
  if K = mIndex then Result := StrLeft(mList + mDelimiter, mDelimiter);
end; { ListValue }
 
function StringGridToText(mStringGrid: TStringGrid;
  mStrings: TStrings): Boolean;
var
  I, J: Integer;
  T: string;
begin
  Result := False;
  if (not Assigned(mStringGrid)) or (not Assigned(mStrings)) then Exit;
  with mStringGrid do try
    mStrings.Clear;
    for J := 0 to RowCount - 1 do begin
      T := '';
      for I := 0 to ColCount - 1 do
        T := T + #9 + Cells[I, J];
      Delete(T, 1, 1);
      mStrings.Add(T);
    end;
  except
    Exit;
  end;
  Result := True;
end; { StringGridToText }
 
function TextToStringGrid(mStrings: TStrings;
  mStringGrid: TStringGrid): Boolean;
var
  I, J: Integer;
  T: string;
begin
  Result := False;
  if (not Assigned(mStringGrid)) or (not Assigned(mStrings)) then Exit;
  with mStrings, mStringGrid do try
    for I := 0 to ColCount - 1 do begin
      T := '';
      for J := 0 to Min(RowCount - 1, Count - 1) do
        Cells[I, J] := ListValue(Strings[J], I, #9);
    end;
  except
    Exit;
  end;
  Result := True;
end; { TextToStringGrid }
///////End Source

function repl_substr(sub_old, sub_new, s: string): string;
var
  i: integer;
begin
  repeat
    i := pos(sub_old, s);
    if i > 0 then
    begin
      delete(s, i, Length(sub_old));
      insert(sub_new, s, i);
    end;
  until i < 1;
  Result := s;
end;

function BackupSQLDataBase(connstr_sql,DatabaseName,Backup_FileName:string):Boolean;
var
//����SQL���ݿ�SQL�������ݿⱸ�ݣ�connstr_sql��ADO�ؼ���connectionstring,DatabaseName�����ݿ����ƣ�
//Backup_FileNameҪ���ݵ���Ŀ���ļ�
  ADOQuery:TADOQuery;
begin
  try
    ADOQuery:=TADOQuery.Create(nil);
    ADOQuery.Close;
    ADOQuery.ConnectionString:=connstr_sql;
    ADOQuery.SQL.Clear;
    ADOQuery.SQL.Add('backup database '+DatabaseName+' to disk = ' + '''' + Backup_FileName + ''' with format');
    Try
      Screen.Cursor := crHourGlass;
      ADOQuery.ExecSQL;
      Result:=true;
    Except
      Screen.Cursor := crDefault;
      Result:=false;
      exit;
    end;
  finally
    ADOQuery.Free;
  end;
end;

function RestoreSQLDataBase(connstr_sql,DatabaseName,Restore_FileName:string):Boolean;
var//���ݿ�ָ�������estore_FileName��ǰ���ݵ����ݿ��ļ�
  ADOQuery:TADOQuery;
begin
  try
    ADOQuery:=TADOQuery.Create(nil);
    ADOQuery.Close;//�ָ����ݿⲻ�ܴ����ݿ⣬Ҫ��ϵͳ���ݿ�master���������ַ�����adoconnetion��connectionstring�е����ݿ����ƻ���"master"���ݿ�
    ADOQuery.ConnectionString:=repl_substr(DatabaseName,'master',connstr_sql);
    ADOQuery.SQL.Clear;
    ADOQuery.SQL.Add('RESTORE DATABASE '+DatabaseName+' from disk = ' + '''' + Restore_FileName + '''');
    Try
      Screen.Cursor := crHourGlass;
      ADOQuery.ExecSQL;
      Result:=true;
    Except
      Screen.Cursor := crDefault;
      Result:=false;
      exit;
    end;
  finally
    ADOQuery.Free;
  end;
end;

//����mantousoft�ṩ�Ĵ���,�����˼���ǰ���˴��ʱд������ҽ���Сдת������,���Ǿͷ��˳���.

//���� ZLB��zlb_nj@sina.com��
//�Բ���,�����е���.

function F2C(r: real): string;
var
tmp1,rr :string;  
l,i,j,k:integer;
const n1:array[0..9] of string=('��','Ҽ','��','��','��','��','½','��','��','��');
const n2:array[0..3] of string=('','ʰ','��','Ǫ');
const n3:array[0..2] of string=('Ԫ','��','��');
begin
  tmp1:=FormatFloat('#.00',r);
  l:=length(tmp1);
  rr:='';
  if strtoint(tmp1[l])<>0 then
  begin
    rr:='��';
    rr:=n1[strtoint(tmp1[l])]+rr;
  end;
  
  if strtoint(tmp1[l-1])<>0 then
  begin
    rr:='��'+rr;
    rr:=n1[strtoint(tmp1[l-1])]+rr;
  end;

  i:=l-3;
  j:=0;k:=0;
  while i>0 do
  begin
    if j mod 4=0 then
    begin
      rr:=n3[k]+rr;
      inc(k);if k>2 then k:=1;
      j:=0;
    end;
    if strtoint(tmp1[i])<>0 then
      rr:=n2[j]+rr;
    rr:=n1[strtoint(tmp1[i])]+rr;
    inc(j);
    dec(i);
  end;
  while pos('����',rr)>0 do
    rr:= stringreplace(rr,'����','��',[rfReplaceAll]);
  rr:=stringreplace(rr,'����','����',[rfReplaceAll]);
  while pos('����',rr)>0 do
    rr:= stringreplace(rr,'����','��',[rfReplaceAll]);
  rr:=stringreplace(rr,'����','����',[rfReplaceAll]);
  while pos('����',rr)>0 do
    rr:= stringreplace(rr,'����','��',[rfReplaceAll]);
  rr:=stringreplace(rr,'��Ԫ','Ԫ��',[rfReplaceAll]);
  while pos('����',rr)>0 do
    rr:= stringreplace(rr,'����','��',[rfReplaceAll]);
  rr:=stringreplace(rr,'����','��',[rfReplaceAll]);
  if copy(rr,length(rr)-1,2)='��' then
    rr:=copy(rr,1,length(rr)-2);
  result:=rr;
end;

Procedure CompentAutoSize(FormeSize:TForm;var Form_width,Form_Height:integer);
var i:integer;
    f_Width,f_Height:double;
    comtemp:TComponent;
begin
  f_Width:=FormeSize.Width/Form_Width;
  f_Height:=FormeSize.Height/Form_Height;
//  FormeSize.Font.Size:=Trunc(FormeSize.Font.Size*f_Font);
  for i:=0 to FormeSize.ComponentCount-1 do
    begin
      comtemp:=FormeSize.Components[i];
      if comtemp is TGraphicControl then
        begin
          TGraphicControl(comtemp).Left:=Trunc(TGraphicControl(comtemp).Left*f_Width);
          TGraphicControl(comtemp).Width:=Trunc(TGraphicControl(comtemp).Width*f_Width);
          TGraphicControl(comtemp).Top:=Trunc(TGraphicControl(comtemp).Top*f_Height);
          TGraphicControl(comtemp).Height:=Trunc(TGraphicControl(comtemp).Height*f_Height);
        end
      else if comtemp is TWinControl then
        begin
          TWinControl(comtemp).Left:=Trunc(TWinControl(comtemp).Left*f_Width);
          TWinControl(comtemp).Width:=Trunc(TWinControl(comtemp).Width*f_Width);
          TWinControl(comtemp).Top:=Trunc(TWinControl(comtemp).Top*f_Height);
          TWinControl(comtemp).Height:=Trunc(TWinControl(comtemp).Height*f_Height);
        end
      else if comtemp is TControl then
        begin
          TControl(comtemp).Left:=Trunc(TControl(comtemp).Left*f_Width);
          TControl(comtemp).Width:=Trunc(TControl(comtemp).Width*f_Width);
          TControl(comtemp).Top:=Trunc(TControl(comtemp).Top*f_Height);
          TControl(comtemp).Height:=Trunc(TControl(comtemp).Height*f_Height);
        end;
    end;
  Form_Width:=FormeSize.Width;
  Form_Height:=FormeSize.Height;
end;

function GetConn(ADOQry: TADOQuery): Boolean;
begin
  result := true;
  try
    if ADOQry.Active = true then
      ADOQry.Close;
    ADOQry.Connection := DataMForm.ADOConnet;
  except
    result := false;
  end;
end;

function GetIniValue(ADOConnet: TADOConnection; sName: string): string;
var
  ADOSetTmp: TADOQuery;
  sSql: string;
begin
  Result := '';
  if sName = '' then
    exit;

  ADOSetTmp := TADOQuery.Create(nil);
  ADOSetTmp.LockType := ltReadOnly;
  sSql := ' SELECT * FROM SystemIni where sName=''' + sName + '''';
  OpenDataSetEx(ADOConnet, ADOSetTmp, sSql);
  if ADOSetTmp.IsEmpty then
    Result := ''
  else
    Result := ADOSetTmp.FieldByName('sValue').AsString;
  ADOSetTmp.Close;
  ADOSetTmp.Free;
end;

function OpenDataSetEx(ADOConnet: TADOConnection; DataSet: TADOQuery; szSql:
  string): Boolean;
begin
  result := true;
  try
    if DataSet.Active = true then
      DataSet.Close;
    DataSet.Close;
    DataSet.SQL.Clear;
    DataSet.SQL.Add(szSql);
    DataSet.Connection := ADOConnet;
    DataSet.Open;
  except
    result := false;
  end;
end;

function MakeComputerCode: string;
begin
  Result := Trim(GetIDESerial) + Trim(GetDiskSerial('C:'));
  Result := GetStandardStr(Result);
end;

function GetIDESerial: string;
begin
  Result := GetIdeDiskSerialNumber;
end;

function GetDiskSerial(sDisk: string): string;
var
  dwNum, dwTmp: dword;
begin
  Result := '';
  if GetVolumeInformation(PChar(sDisk + '\'), nil, 0, Addr(dwNum), dwTmp, dwTmp,
    nil, 0) then
    Result := IntToStr(dwNum);
end;

function GetStandardStr(sStr: string): string;
var
  i: Integer;
  s1: string;
begin
  Result := '';
  s1 := '';
  if Trim(sStr) = '' then   Exit;
  for i := 1 to Length(sStr) do
    begin
      s1 := Copy(sStr, i, 1);
      if ((s1 >= '0') and (s1 <= '9')) or ((s1 >= 'a') and (s1 <= 'z')) or ((s1 >=
        'A') and (s1 <= 'Z')) then
        Result := Result + s1;
    end;
  Result := Trim(Result);
end;

function GetPCName: string;
var
  CNameBuffer: PChar;
  fl_loaded: Boolean;
  CLen: ^DWord;
begin
  GetMem(CNameBuffer, 255);
  New(CLen);
  CLen^ := 255;
  fl_loaded := GetComputerName(CNameBuffer, CLen^);
  if fl_loaded then
    Result := StrPas(CNameBuffer)
  else
    Result := '';
  FreeMem(CNameBuffer, 255);
  Dispose(CLen);
  Result := Trim(Result);
end;

function MakeRegisterCode(sName, sPcCode: string): string;
var
  s1, s2: string;
  i: Integer;
begin
  s2 := '';
  s1 := StringEncrypt(Trim(sPcCode) + Trim(sName), #1#7#0#5);
  s1 := GetStandardStr(s1);
  for i := 1 to Length(s1) do
    begin
      s2 := s2 + Copy(s1, i, 1);
      if i mod 4 = 0 then   s2 := s2 + '-';
    end;
  if Copy(s2, Length(s2), 1) = '-' then    s2 := Copy(s2, 1, Length(s2) - 1);
  Result := s2;
end;

function StringEncrypt(mStr: string; mKey: string): string;
var
  I, J: Integer;
begin
  J := 1;
  Result := '';
  for I := 1 to Length(mStr) do
  begin
    Result := Result + Char(Ord(mStr[I]) xor Ord(mKey[J]));
    if J + 1 <= Length(mKey) then
      Inc(J)
    else
      J := 1;
  end;
  { �Լ��Ӳ��� }
  Result := StringToDisplay(Result);
end; { StringEncrypt }

function StringToDisplay(mString: string): string;
var
  I: Integer;
  S: string;
begin
  Result := '';
  S := '';
  for I := 1 to Length(mString) do
    if mString[I] in [#32..#127] then
      S := S + mString[I]
    else
    begin
      if S <> '' then
      begin
        Result := Result + QuotedStr(S);
        S := '';
      end;
      Result := Result + Format('#$%x', [Ord(mString[I])]);
    end;
  if S <> '' then
    Result := Result + QuotedStr(S);
end; { StringToDisplay }

function SetIniValue(ADOConnet: TADOConnection; sName, sValue: string): Boolean;
var
  sSql: string;
begin
  Result := False;
  if (sName = '') then
    exit;
  sSql := ' SELECT * FROM SystemIni where sName=''' + sName + '''';

  if GetDataSetEmptyEx(ADOConnet, sSql) then
    sSql := 'INSERT INTO SystemIni (sName,sValue)VALUES(''' + sName + ''',''' +
      sValue + ''')'
  else
    sSql := ' update SystemIni Set sValue=''' + sValue + ''' Where sName=''' +
      sName + '''';

  Result := ExecSqlEx(ADOConnet, sSql);
end;

function GetDataSetEmptyEx(ADOConnet: TADOConnection; sSql: string): Boolean;
var
  ADOSetTmp: TADOQuery;
begin
  ADOSetTmp := TADOQuery.Create(nil);
  ADOSetTmp.LockType := ltReadOnly;
  OpenDataSetEx(ADOConnet, ADOSetTmp, sSql);
  Result := ADOSetTmp.IsEmpty;
  ADOSetTmp.Close;
  ADOSetTmp.Free;
end;

function ExecSqlEx(ADOConnet: TADOConnection; sSql: string): Boolean;
begin
  Result := True;
  if Trim(sSql) = '' then
  begin
    Result := False;
    exit;
  end;
  try
    ADOConnet.Execute(sSql);
  except
    Result := False;
  end;
end;

function GetDataSetCount(sSql: string): Integer;
begin
  Result := GetDataSetCountEx(DataMForm.ADOConnet, sSql);
end;

function GetDataSetCountEx(ADOConnet: TADOConnection; sSql: string): Integer;
var
  ADOSetTmp: TADOQuery;
begin
  ADOSetTmp := TADOQuery.Create(nil);
  ADOSetTmp.LockType := ltReadOnly;
  OpenDataSetEx(ADOConnet, ADOSetTmp, sSql);
  Result := ADOSetTmp.RecordCount;
  ADOSetTmp.Close;
  ADOSetTmp.Free;
end;

function JudgeDataUse(originalityTableName,OriginalityFieldName, presentFieldValue: string): Boolean;
var
  ADOQryTmp: TADOQuery;
begin
  Result:= True;
  Try
  ADOQryTmp:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp);
  ADOQryTmp.Close;
  ADOQryTmp.SQL.Clear;
  ADOQryTmp.SQL.Add('Select * From ' + originalityTableName + ' Where ' + OriginalityFieldName + '= ' + QuotedStr(presentFieldValue));
  ADOQryTmp.Open;

  if ADOQryTmp.RecordCount>0 then
  begin
    ShowMessage('��������ʹ���С���');
    Abort;
  end;

  except
    Result:= False;
  end;

  ADOQryTmp.Close;
  ADOQryTmp.Free;
end;


procedure RemMsgBox(RemindText: string; Caption: string='');
begin
  if Application.MessageBox(PChar(RemindText), PChar(Caption), MB_ICONQUESTION + MB_YESNO) = IDOK then
end;

function MsgBox(Text: string; Flags: Longint = MB_OK): Integer;
begin
    Result := Application.MessageBox(PChar(Text), '��ʾ', Flags +
      MB_ICONASTERISK);
end;

procedure ShowMsg(sMsg: string);
begin
  MsgBox(sMsg, MB_OK);
end;












procedure ReadDBGridEhAutoFitColWidth(Form1: TForm);
var
  i : integer;
  sCheck: string;
  ADOQryTmp: TADOQuery;
begin
  ADOQryTmp:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp);
  ADOQryTmp.Close;
  ADOQryTmp.SQL.Clear;
  ADOQryTmp.SQL.Add('Select * From SystemTable Where Name=''DBGridEhAutoFitColWidth''');
  ADOQryTmp.Open;

  sCheck:= ADOQryTmp.FieldByName('Code').AsString;

  for i:=0 to Form1.ComponentCount-1 do
    if (Form1.Components[i] is TDBGridEh) then
    begin
      if sCheck= 'True' then
         TDBGridEh(Form1.Components[i]).AutoFitColWidths:= True
         else
           TDBGridEh(Form1.Components[i]).AutoFitColWidths:= False;
    end;
    ADOQryTmp.Close;
    ADOQryTmp.Free;
end;

procedure ReadDBGridEhFlat(Form1: TForm);
var
  i : integer;
  sCheck: string;
  ADOQryTmp: TADOQuery;
begin
  ADOQryTmp:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp);
  ADOQryTmp.Close;
  ADOQryTmp.SQL.Clear;
  ADOQryTmp.SQL.Add('Select * From SystemTable Where Name=''DBGridEhFlat''');
  ADOQryTmp.Open;

  sCheck:= ADOQryTmp.FieldByName('Code').AsString;

  for i:=0 to Form1.ComponentCount-1 do
    if (Form1.Components[i] is TDBGridEh) then
    begin
      if sCheck= 'True' then
         TDBGridEh(Form1.Components[i]).Flat:= True
         else
           TDBGridEh(Form1.Components[i]).Flat:= False;
    end;
    ADOQryTmp.Close;
    ADOQryTmp.Free;
end;

procedure ReadDBEditFlat(Form1: TForm);
var
  i : integer;
  sCheck: string;
  ADOQryTmp: TADOQuery;
begin
  ADOQryTmp:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp);
  ADOQryTmp.Close;
  ADOQryTmp.SQL.Clear;
  ADOQryTmp.SQL.Add('Select * From SystemTable Where Name=''DBEditEhFlat''');
  ADOQryTmp.Open;

  sCheck:= ADOQryTmp.FieldByName('Code').AsString;

  for i:=0 to Form1.ComponentCount-1 do
  begin
    if (Form1.Components[i] is TDBEditEh) then
    begin
      if sCheck= 'True' then
         TDBEditEh(Form1.Components[i]).Flat:= True
         else
           TDBEditEh(Form1.Components[i]).Flat:= False;
    end;

    if (Form1.Components[i] is TDBDateTimeEditEh) then
    begin
      if sCheck= 'True' then
         TDBDateTimeEditEh(Form1.Components[i]).Flat:= True
         else
           TDBDateTimeEditEh(Form1.Components[i]).Flat:= False;
    end;

    if (Form1.Components[i] is TDBNumberEditEh) then
    begin
      if sCheck= 'True' then
         TDBNumberEditEh(Form1.Components[i]).Flat:= True
         else
           TDBNumberEditEh(Form1.Components[i]).Flat:= False;
    end;

    if (Form1.Components[i] is TDBComboBoxEh) then
    begin
      if sCheck= 'True' then
         TDBComboBoxEh(Form1.Components[i]).Flat:= True
         else
           TDBComboBoxEh(Form1.Components[i]).Flat:= False;
    end;

    if (Form1.Components[i] is TDBLookupComboboxEh) then
    begin
      if sCheck= 'True' then
         TDBLookupComboboxEh(Form1.Components[i]).Flat:= True
         else
           TDBLookupComboboxEh(Form1.Components[i]).Flat:= False;
    end;

    if (Form1.Components[i] is TDBCheckBoxEh) then
    begin
      if sCheck= 'True' then
         TDBCheckBoxEh(Form1.Components[i]).Flat:= True
         else
           TDBCheckBoxEh(Form1.Components[i]).Flat:= False;
    end;

  end;


    ADOQryTmp.Close;
    ADOQryTmp.Free;
end;


procedure SaveDBGridEhAutoFitColWidth(CheckBox1: TCheckBox);
var
  sCheck: string;
  ADOQryTmp: TADOQuery;
begin
  ADOQryTmp:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp);
  ADOQryTmp.Close;
  ADOQryTmp.SQL.Clear;
  ADOQryTmp.SQL.Add('Select * From SystemTable Where Name = ''DBGridEhAutoFitColWidth''');
  ADOQryTmp.Open;

  if CheckBox1.Checked then
    sCheck:= 'True'
  else
    sCheck:= 'False';

  ADOQryTmp.Edit;
  ADOQryTmp.FieldByName('Code').AsString:= sCheck;
  ADOQryTmp.Post;

end;


procedure SaveDBGridEhFlat(CheckBox1: TCheckBox);
var
  sCheck: string;
  ADOQryTmp: TADOQuery;
begin
  ADOQryTmp:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp);
  ADOQryTmp.Close;
  ADOQryTmp.SQL.Clear;
  ADOQryTmp.SQL.Add('Select * From SystemTable Where Name = ''DBGridEhFlat''');
  ADOQryTmp.Open;

  if CheckBox1.Checked then
    sCheck:= 'True'
  else
    sCheck:= 'False';

  ADOQryTmp.Edit;
  ADOQryTmp.FieldByName('Code').AsString:= sCheck;
  ADOQryTmp.Post;

end;

procedure SaveDBEditEhFlat(CheckBox3: TCheckBox);
var
  sCheck: string;
  ADOQryTmp: TADOQuery;
begin
  ADOQryTmp:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp);
  ADOQryTmp.Close;
  ADOQryTmp.SQL.Clear;
  ADOQryTmp.SQL.Add('Select * From SystemTable Where Name = ''DBEditEhFlat''');
  ADOQryTmp.Open;

  if CheckBox3.Checked then
    sCheck:= 'True'
  else
    sCheck:= 'False';

  ADOQryTmp.Edit;
  ADOQryTmp.FieldByName('Code').AsString:= sCheck;
  ADOQryTmp.Post;

end;




function InsCode(IniData: integer; ADOQuery1: TADOQuery; sFieldName, sTable: string): Boolean;
var
  ADOQryTmp: TADOQuery;
begin
  ADOQryTmp:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp);

  ADOQryTmp.Close;
  ADOQryTmp.SQL.Clear;
  ADOQryTmp.SQL.Add('Select Max('''+sFieldName+''') as sFieldName From '+sTable);
  ADOQryTmp.Open;

  ADOQuery1.Edit;

  if ADOQryTmp.IsEmpty then
  ADOQuery1.FieldByName(sFieldName).AsInteger:= IniData + 1
  else
  ADOQuery1.FieldByName('''+QuotedStr(sFieldName)+''').AsInteger:= ADOQryTmp.FieldByName(sFieldName).AsInteger + 1;
end;


{
����ʱ
procedure TForm1.Edit1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  ManipulateControl(edit1,Shift,X,Y,2);
end;  

}
procedure ManipulateControl(WinControl: TControl;
  Shift: TShiftState; X, Y, precision: integer);

var
  SC_MANIPULATE: Word;
begin
  //����ڿؼ��������
  if (X<=Precision) and (Y>Precision) and (Y<WinControl.Height-Precision) then
  begin
    SC_MANIPULATE  := $F001;
    WinControl.Cursor := crSizeWE;
  end
  else
    //����ڿؼ������Ҳ�
    if (X>=WinControl.Width-Precision) and (Y>Precision) and (Y<WinControl.Height-Precision) then
    begin
      SC_MANIPULATE  := $F002;
      WinControl.Cursor := crSizeWE;
    end
    else
      //����ڿؼ������ϲ�
      if (X>Precision) and (X<WinControl.Width-Precision) and (Y<=Precision) then
      begin
        SC_MANIPULATE  := $F003;
        WinControl.Cursor := crSizeNS;
      end
      else
        //����ڿؼ������²�
        if (X>Precision) and (X<WinControl.Width-Precision) and (Y>=WinControl.Height-Precision) then
        begin
          SC_MANIPULATE  := $F006;
          WinControl.Cursor := crSizeNS;
        end
        else
          //����ڿؼ������Ͻ�
          if (X<=Precision) and (Y<=Precision) then
          begin
            SC_MANIPULATE  := $F004;
            WinControl.Cursor := crSizeNWSE;
          end
          else
            //����ڿؼ������Ͻ�
            if (X>=WinControl.Width-Precision) and (Y<=Precision) then
            begin
              SC_MANIPULATE  := $F005;
              WinControl.Cursor := crSizeNESW ;
            end
            else
              //����ڿؼ������½�
              if (X<=Precision) and (Y>=WinControl.Height-Precision) then
              begin
                SC_MANIPULATE  := $F007;
                WinControl.Cursor := crSizeNESW;
              end
              else
                //����ڿؼ������½�
                if (X>=WinControl.Width-Precision) and (Y>=WinControl.Height-Precision) then
                begin
                  SC_MANIPULATE  := $F008;
                  WinControl.Cursor := crSizeNWSE;
                end
                else
                  //����ڿؼ��Ŀͻ������ƶ������ؼ���
                  if (X>5) and (Y>5) and (X<WinControl.Width-5) and
                        (Y<WinControl.Height-5) then
                  begin
                    SC_MANIPULATE  := $F009;
                    WinControl.Cursor := crSizeAll;
                  end
                  else
                  begin
                    SC_MANIPULATE := $F000;
                    WinControl.Cursor := crDefault;
                  end;
  if Shift=[ssLeft] then
  begin
    ReleaseCapture;
    WinControl.Perform(WM_SYSCOMMAND, SC_MANIPULATE, 0);
  end;

end;

procedure TM(Fd:TDBNavigator);
var
  i   : Integer;
  x   : Integer;
  sl  :Tstringlist;
begin
  sl:=Tstringlist.Create;
  sl.Add('����');
  sl.Add('ǰһ��');
  sl.Add('��һ��');
  sl.Add('βһ��');
  sl.Add('����');
  sl.Add('ɾ��');
  sl.Add('�༭');
  sl.Add('�ύ');
  sl.Add('ȡ��');
  sl.Add('ˢ��');
  try
    begin
      for i :=  Fd.ControlCount - 1 downto 0 do
      begin
        Tnavbutton(Fd.Controls[i]).Caption:=sl.Strings[i];
        x:= Fd.Left + Fd.Controls[i].Left;
        with Fd.Controls[i] do
        begin
          Parent  :=  Fd.Parent;
          Left    :=  x;
          Top     :=  Fd.Top;
        end;
      end;
      Fd.Visible  :=  False;
      Fd.Flat:=true;
    end;
  finally
    sl.Free;
  end;
end;

procedure OpenForm(FormClass: TFormClass; var fm; AOwner:TComponent);
var
  i, j: integer;
  Child:TForm;
begin

  for i := 0 to Screen.FormCount -1 do
      if Screen.Forms[i].ClassType=FormClass then
      begin
        Child:=Screen.Forms[i];
        if Child.WindowState=wsMinimized then
           ShowWindow(Child.handle,SW_SHOWNORMAL)
        else
           ShowWindow(Child.handle,SW_SHOWNA);
        if (not Child.Visible) then Child.Visible:=True;
        Child.BringToFront;
        Child.Setfocus;
        TForm(fm):=Child;
        exit;
      end;
  Child:=TForm(FormClass.NewInstance);
  TForm(fm):=Child;
  Child.Create(AOwner);

  //�����Ӵ���λ��
{    for j := 0 to MainForm.MDIChildCount -1 do
    begin
      MainForm.MDIChildren[j].Left := 0;
      MainForm.MDIChildren[j].Top := 0;
    end; }

end;

Function LnkAccess(Var ADOConnet: TADOConnection; Db, DbPwd: String):Boolean;
Begin
  if ADOConnet = Nil then
    ADOConnet := TadoConnection.Create(nil);
  if ADOConnet.Connected then
    ADOConnet.Close;
  ADOConnet.LoginPrompt := False;
  ADOConnet.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;'+
                              'Data Source='+Db+';'+
                              'Jet OLEDB:Database Password='+DbPwd;

  Try
    ADOConnet.Open;
    Result := True;
//    ShowMsg('���ӳɹ���');
  Except
    Result := False;
    ShowMsg('����ʧ�ܣ�');
    Application.Terminate;
  End;
End;

function LnkLocalAccess: Boolean;
begin
  Result:= LnkAccess(DataMForm.ADOConnet, 'Data\MainDB.mdb', DBPass);
end;

function GridFieldToTitle(GridEh: TDBGridEh; sField: string):
  string;
var
  i: Integer;
begin
  Result := '';
  for i := 0 to GridEh.Columns.Count - 1 do
  begin
    if Trim(GridEh.Columns[i].FieldName) = sField then
    begin
      Result := GridEh.Columns[i].Title.Caption;
      Break;
    end;
  end;
end;

function SaveDataSet(ADOQuery1: TADOQuery; Cached: Boolean): Boolean;
begin
  Result := True;
  if Cached = false then
  begin
    if (ADOQuery1.State = dsEdit) or (ADOQuery1.State = dsInsert) then
      ADOQuery1.Post;
  end
  else
  begin
    if (ADOQuery1.State = dsEdit) or (ADOQuery1.State = dsInsert) then
      ADOQuery1.Post;
    try
      ADOQuery1.UpdateBatch;
    except
      Result := False;
    end;
  end;
end;

function FindPublic(Grid1: TDBGridEh; var sText: string; var
  lFiled: Integer): Boolean;
begin
  Result := FindPublicShow(Grid1, sText, lFiled);
end;

procedure DBGridEhExport(DBGridEh: TDBGridEh; Form: TForm);
//��������
var
  ExpClass:TDBGridEhExportClass;
  Ext, sSave:String;
  SaveDialog: TSaveDialog;
begin
  SaveDialog:= TSaveDialog.Create(Nil);
  SaveDialog.FileName:= Form.Caption;
  SaveDialog.Filter:='Text files (*.txt)|*.TXT|Comma separated values (*.csv)|*.CSV|HTML file (*.htm)|*.HTM|Rich Text Format (*.rtf)|*.RTF|Microsoft Excel Workbook (*.xls)|*.XLS';
  sSave := Trim(ExtractFilePath(Application.ExeName)) + 'Save';

  if not DirectoryExists(sSave) then
  begin
    if not CreateDir(sSave) then
    begin
      raise Exception.Create('�����½�Ŀ¼,���ֹ��½���Ŀ¼��' + #13 + sSave);
    end;
  end;
  SaveDialog.InitialDir:= sSave;

  if SaveDialog.Execute then
  begin
    case SaveDialog.FilterIndex of
      1:  begin ExpClass  :=  TDBGridEhExportAsText;  Ext :=  'txt';  end;
      2:  begin ExpClass  :=  TDBGridEhExportAsCSV;   Ext :=  'csv';  end;
      3:  begin ExpClass  :=  TDBGridEhExportAsHTML;  Ext :=  'htm';  end;
      4:  begin ExpClass  :=  TDBGridEhExportAsRTF;   Ext :=  'rtf';  end;
      5:  begin ExpClass  :=  TDBGridEhExportAsXLS;   Ext :=  'xls';  end;
    else
      ExpClass := nil; Ext := '';
    end;
    if ExpClass <> nil then
    begin
      if UpperCase(Copy(SaveDialog.FileName,Length(SaveDialog.FileName)-2,3)) <>
         UpperCase(Ext) then
        SaveDialog.FileName := SaveDialog.FileName + '.' + Ext;
      SaveDBGridEhToExportFile(ExpClass,DBGridEh,SaveDialog.FileName,not DBGridEh.CheckCopyAction);
    end;
  end;
end;

function GetFieldType(fField: TField): string;
var
  s1: string;
begin
  case fField.DataType of
    ftSmallint, ftInteger, ftWord, ftFloat, ftCurrency, ftBCD: s1 := 'Int';
    ftBoolean: s1 := 'Bool';
    ftDate, ftTime, ftDateTime: s1 := 'Date';
    ftWideString, ftString: s1 := 'Str';
    ftUnknown: s1 := 'Unk';
  end;
  Result := s1;
end;

function FilterPublic(Grid1: TDBGridEh): Boolean;
begin
  Result := FilterPublicShow(Grid1);
end;


function CheckEditEmpty(lMsg: Integer; Form1: TForm; AsLabel, AsEdit: array of
  string): Boolean;
var
  i: Integer;
  sCaption, sText: string;
begin
  Result := False;
  for i := 0 to Length(AsLabel) - 1 do
  begin
    if (Trim(AsLabel[i]) <> '') and (Form1.FindComponent(AsLabel[i]) is
      TLabel) and
      (Trim(AsEdit[i]) <> '') and (Form1.FindComponent(AsEdit[i]) is
      TCustomDBEditEh) and
      (TCustomDBEditEh(Form1.FindComponent(AsEdit[i])).Visible = True) then
    begin
      sCaption := TLabel(Form1.FindComponent(AsLabel[i])).Caption;
      sText := TCustomDBEditEh(Form1.FindComponent(AsEdit[i])).Text;
      if (lMsg > 0) and (Trim(sText) = '') then
      begin
        if Pos(':', sCaption) > 0 then
          sCaption := Copy(sCaption, 0, Pos(':', sCaption) - 1)
        else if Pos('��', sCaption) > 0 then
          sCaption := Copy(sCaption, 0, Pos('��', sCaption) - 1);
        MsgBox(sCaption + '����Ϊ�գ�',  MB_OK);
        exit;
      end
      else if (lMsg = 0) and (Trim(sText) <> '') then
        exit;
    end;
  end;
  Result := True;
end;

Function GetID(Aqy: TADOQuery; TableName,DHFieldName,DateFieldName,TypeFieldName,TypeValue:String;
BeginPos,StrLen:integer):boolean;
var
  ls_tkdh, TypeName:string;
  ADOQryTmp: TADOQuery;
begin
  TypeName:=copy(TypeValue,1,2);  //���ݽ��⡢�������͵õ����ݺ�ǰ׺
  try
    ADOQryTmp:= TADOQuery.Create(Nil);
    GetConn(ADOQryTmp);
    with  ADOQryTmp do
    begin
      Close;
      Sql.Clear;
      Sql.Add('select SubString('+DHFieldName+',:BeginPos,:StrLen) from ' +TableName);
      Sql.Add('where '+DateFieldName+' =:date_1');
      Sql.Add('And '+TypeFieldName+' =:TypeFieldName');
      Parameters.ParamByName('BeginPos').Value :=BeginPos;
      Parameters.ParamByName('StrLen').Value :=StrLen;
      Parameters.ParamByName('date_1').Value :=date;
      Parameters.ParamByName('TypeFieldName').Value :=TypeValue;
      open;
    end;
    ls_tkdh:=ADOQryTmp.Fields[0].AsString;
    if ls_tkdh = ''  then//���û��������Ϊ��һ��
      ls_tkdh :=TypeName+FormatDateTime('YYYYMMDD',Date)+'0001'
    else//����ȡ����һ�����ݲ�������ż� 1
      ls_tkdh :=TypeName+FormatDateTime('YYYYMMDD',Date)+FormatFloat('0000',StrToInt(ADOQryTmp.Fields[0].value)+1);
    Aqy.Open ;//�򿪽�����
    Aqy.Insert;//����һ��������
    Aqy.FieldByName(DateFieldName).AsDateTime :=date;  //д ʱ�� �ֶ�
    Aqy.FieldByName(DHFieldName).AsString:=ls_tkdh;    //д ���� �ֶ�
    Aqy.FieldByName(TypeFieldName).AsString :=TypeValue;
//    Aqy.Post ;                                         //����
    Result:=True;                                      //���� ��
  except
    Result:=False;                                     //����д��򷵻� ��
  end;
  ADOQryTmp.Close;
  ADOQryTmp.Free; 
end;

Function IDGen(Aqy: TADOQuery; DJType, TableName,DHFieldName,DateFieldName:String ;BeginPos,StrLen:integer):boolean;
Var
  ls_tkdh, CodeName:string;
  ADOQryTmp: TADOQuery;
begin
  ADOQryTmp:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp);

  CodeName:= Copy(DJType, 1, 2);
//  CodeName:=copy(TableName,1,2);  //�������ݿ�����Ƶõ����ݺ�ǰ׺
  try
    with  ADOQryTmp do
    begin
      Close;
      Sql.Clear;
      Sql.Add('select MAX(SubString('+DHFieldName+',:BeginPos,:StrLen)) from ' +TableName);
      Sql.Add('where '+DateFieldName+' =:date_1');
      Parameters.ParamByName('BeginPos').Value :=BeginPos;
      Parameters.ParamByName('StrLen').Value :=StrLen;
      Parameters.ParamByName('date_1').Value :=date;
      open;
    end;
    ls_tkdh:=ADOQryTmp.Fields[0].AsString;
    if ls_tkdh = ''  then//���û��������Ϊ��һ��
      ls_tkdh :=CodeName+FormatDateTime('YYYYMMDD',Date)+'0001'
    else//����ȡ����һ�����ݲ�������ż� 1
      ls_tkdh :=CodeName+FormatDateTime('YYYYMMDD',Date)+FormatFloat('0000',StrToInt(ADOQryTmp.Fields[0].value)+1);
    Aqy.Open ;//�򿪽�����
    Aqy.Insert;//����һ��������
    Aqy.FieldByName(DateFieldName).AsDateTime :=date;  //д ʱ�� �ֶ�
    Aqy.FieldByName(DHFieldName).AsString:=ls_tkdh;    //д ���� �ֶ�
    Aqy.Post ;                                         //����
    Result:=True;                                      //���� ��
  except
    Result:=False;                                     //����д��򷵻� ��
  end;
  ADOQryTmp.Close;
  ADOQryTmp.Free; 
end;

procedure ConnAccess(AdoConn: TADOConnection; FileName, UserName, Password: string);
begin
  AdoConn.Close;
  AdoConn.LoginPrompt := False;
  AdoConn.ConnectionString:=
    'Provider=MSDASQL.1;Password=' + Password +
    ';Persist Security Info=False;User ID=' + UserName +
    ';Extended Properti' + 'es="DSN=MS Access Database;DBQ=' + FileName +
    ';DefaultDir=' + ExtractFilePath(FileName) +
    ';DriverId=281;FIL=MS Access;MaxBufferSize=2048;PageTimeout=5;UID=admin;"';
  AdoConn.Open;
end; 

procedure SetField(StrTarget,StrSource: string; ADOQryTarget,
  ADOQrySource: TADOQuery);
var
  S1, S2, S11, S22: string;
begin
  S1:= StrTarget + ',';
  S11:= StrSource + ',';
  ADOQryTarget.Edit;
  while pos(',', S1) <>0 do
  begin
    //��ȡ��֮ǰ���ַ���
    S2:= Copy(S1, 0, Pos(',', S1)-1);
    S22:= Copy(S11, 0, Pos(',', S11)-1);
    //��ȡ��֮����ַ���
    S1 := Copy(S1, pos(',', S1) + 1, Length(S1));
    S11:= Copy(S11, Pos(',', S11)+1, Length(S11));
    ADOQryTarget.FieldByName(S2).AsString := ADOQrySource.FieldByName(S22).AsString;
  end;
  ADOQryTarget.Post;
  ADOQryTarget.Edit; 
end;

procedure SendMsg(hWnd, Msg, wParam: Integer; lParam: Integer = 0);
begin
  //Handle,WM_KEYDOWN,VK_TAB
  SendMessage(hWnd, Msg, wParam, lParam);
end;

function SplitString(const source, ch: string): tstringlist;
//�ֽ��ַ���,ch---�ָ��
var
  temp: string;
  i: integer;
begin
  result := tstringlist.Create;
  temp := source;
  i := pos(ch, source);
  while i <> 0 do
  begin
    if copy(temp, 0, i - 1) <> '' then
      result.Add(copy(temp, 0, i - 1));
    delete(temp, 1, i);
    i := pos(ch, temp);
  end;
  if temp <> '' then
    result.Add(temp);
end;

function locate_string(line_string:string;start_position,end_position:integer):string;
var
  start_pos,end_pos,total_pos,n,key_pos:integer;
  temp_string,split:string;
begin
  split:=',';
  n:=0;
  total_pos:=0;
  temp_string:=line_string;
  while n<start_position do
  begin
    key_pos:=pos(split,temp_string);
    if key_pos>0 then
    begin
      n:=n+1;
      delete(temp_string,1,key_pos);
      total_pos:=total_pos+key_pos;
    end;
  end;
  start_pos:=total_pos;

  n:=0;
  total_pos:=0;
  temp_string:=line_string;
  while n<end_position do
  begin
    key_pos:=pos(split,temp_string);
    if key_pos>0 then
    begin
      n:=n+1;
      delete(temp_string,1,key_pos);
      total_pos:=total_pos+key_pos;
    end;
  end;
  end_pos:=total_pos;
  locate_string:=copy(line_string,start_pos,end_pos-start_pos+1);
end;

function StrToInt2(s: string): Integer;
var
  i, lB, lE: Integer;
  s1, c: string;
begin
  Result := 0;
  if Trim(s) = '' then
    Exit;

  s1 := s + '!';
  for i := 1 to Length(s1) do
  begin
    if Copy(s1, i, 1) <> ' ' then
      break;
  end;
  lB := i;

  for i := lB to Length(s1) do
  begin
    c := Copy(s1, i, 1);
    if (c < '0') or (c > '9') then
      break;
  end;
  lE := i;

  if lb >= lE then
    Result := 0
  else
    Result := StrToInt(Copy(s1, lB, lE - lB));
end;

function StrToGridField(Grid1: TDBGridEh; sFieldName, sCaption, sWidth: string;
  sMask: string = ''):
  Boolean;
var
  s1, s2: string;
  lCol: Integer;
begin
  Result := False;
  if (sFieldName = '') or (sCaption = '') then
    Exit;
  //��ʾGRID�����ֶ�
  Grid1.Columns.Clear;
  s1 := sFieldName + ',';
  lCol := 0;
  while pos(',', s1) <> 0 do
  begin
    s2 := copy(s1, 0, pos(',', s1) - 1);
    s1 := copy(s1, pos(',', s1) + 1, Length(s1));
    if Trim(s2) <> '' then
    begin
      Grid1.Columns.Add;
      Grid1.Columns[lCol].FieldName := Trim(s2);
      Grid1.Columns[lCol].Visible := False;
      inc(lCol);
    end;
  end;
  //��ʾGRID�����ֶα���
  s1 := sCaption + ',';
  lCol := 0;
  while pos(',', s1) <> 0 do
  begin
    s2 := copy(s1, 0, pos(',', s1) - 1);
    s1 := copy(s1, pos(',', s1) + 1, Length(s1));
    if Trim(s2) <> '' then
    begin
      Grid1.Columns[lCol].Title.Caption := Trim(s2);
      Grid1.Columns[lCol].Visible := True;
      inc(lCol);
    end;
  end;
  //��ʾGRID�����ֶο��
  if sWidth <> '' then
  begin
    s1 := sWidth + ',';
    lCol := 0;
    while pos(',', s1) <> 0 do
    begin
      s2 := copy(s1, 0, pos(',', s1) - 1);
      s1 := copy(s1, pos(',', s1) + 1, Length(s1));
      if Trim(s2) <> '' then
      begin
        Grid1.Columns[lCol].Width := StrToInt2(Trim(s2));
        inc(lCol);
      end;
    end;
  end;
  //������ʾ��ʽ
{  if sMask <> '' then
  begin
    s1 := sMask + ',';
    lCol := 0;
    while pos(',', s1) <> 0 do
    begin
      s2 := copy(s1, 0, pos(',', s1) - 1);
      s1 := copy(s1, pos(',', s1) + 1, Length(s1));
      if Trim(s2) <> '' then
      begin
        if Trim(s2) = '$' then
          ChangColumnType(Grid1, Grid1.Columns[lCol], TdxDBGridCurrencyColumn);
        inc(lCol);
      end;
    end;
  end;}
  Result := True;
end;

function SetCol(sCaption: string; DBGridEh1: TDBGridEh; lInit: Integer): Boolean;
begin
  Result := ColSetupFormShow(sCaption, DBGridEh1, lInit);
end;

function SetColWidth(sCaption: string; Grid: TDBGridEh): Boolean;
begin
  Result := SaveColWidth(sCaption, Grid);
end;

function ExecSql(sSql: string): Boolean;
begin
  Result := ExecSqlEx(DataMForm.ADOConnet, sSql);
end;

function OpenDataSet(DataSet: TADOQuery; szSql: string): Boolean;
begin
  Result := OpenDataSetEx(DataMForm.ADOConnet, DataSet, szSql);
end;

function GetDate(var tStartDate, tEndDate: TDateTime): Boolean;
begin
  Result := DateFormShow(tStartDate, tEndDate);
end;

function StrToBool2(sStr: string): Boolean;
begin
  Result := False;
  if Trim(sStr) = '' then
    Exit;
  try
    Result := StrToBool(sStr);
  except
    Exit;
  end;
end;

function  FilterStrInBracket(value:string):String;  //��ȡ[]�е��ַ���
var
  vbegin,vend:integer;
begin
  vbegin:=Pos('[',Value);
  vend  :=Pos(']',Value);
  if (vbegin<>0) and (vend<>0) then
    Result:=Copy(Value,vbegin+1,vend-vbegin-1)
  else
    Result:='';
end;

function EncryptPassword(value:string):string;
var
  I,vLength:integer;
  vStr:string;
begin
  vStr:='';
  vLength:=length(value);
  for i:=1 to vLength do
  begin
    vStr:=vStr+inttostr(ord(value[i])+50);
  end;
  result:=vStr;
end;

function SysRightLimit(Form1: string; i: integer): Boolean;
var
  ADOQryTmp: TADOQuery;
  S: string;
begin
  case i of
  lInsert:
    S:= '����';
  lEdit:
    S:= '�޸�';
  lDelete:
    S:= 'ɾ��';
  lFind:
    S:='����';
  lFilter:
    S:='����';
  lPrint:
    S:='��ӡ';
  lExport:
    S:='����';
  lModule:
    S:='ģ��Ȩ��';
  end;

  try
    ADOQryTmp:= TADOQuery.Create(Nil);
    GetConn(ADOQryTmp);

    with ADOQryTmp do
    begin
      Close;
      SQL.Clear;
      SQL.Add('Select * From Ȩ������ Where Ա�����='+QuotedStr(LoginEmployeCode)+'and ��������='+QuotedStr(Form1));
      Open;
    end;

    if not ADOQryTmp.FieldByName(S).AsBoolean then
      Result:= False
    else
      Result:=True;

  finally
    ADOQryTmp.Close;
    ADOQryTmp.Free;
  end;
end;

function SetID(sTitle, DHFieldName,TableName:String ; BeginPos,StrLen:integer): string;
Var
  Code, ls_tkdh:string;
  l: integer;
  ADOQryTmp: TADOQuery;
begin
  Code:=sTitle;
  try
  ADOQryTmp:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp);

  l:= Length(Code);
  with ADOQryTmp do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select MAX(MID('+DHFieldName+',:BeginPos,:StrLen)) from ' +TableName + ' where Left('+DHFieldName+', '+IntToStr(l)+')=:str');
    Parameters.ParamByName('BeginPos').Value :=BeginPos;
    Parameters.ParamByName('StrLen').Value :=StrLen;
    Parameters.ParamByName('str').Value := Code; 
    open;
  end;
  ls_tkdh:= ADOQryTmp.Fields[0].AsString ;
  if ls_tkdh ='' then
    ls_tkdh :=Code + '0001'
  else
    ls_tkdh :=Code + FormatFloat('0000',StrToInt(ADOQryTmp.Fields[0].Value)+1);
    Result:=ls_tkdh;
  finally
    ADOQryTmp.Close;
    ADOQryTmp.Free;
 end;
end;

procedure ShowIDRepeat(sIDName: string);
var
  S1, S: string;
begin
  S1:= '�ظ������������룡';
  S:= '*'+sIDName+'*' + S1;
  ShowMsg(S);
end;

end.
