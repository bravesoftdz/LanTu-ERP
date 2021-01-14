//�������
//�������ƴ����״̬��ϵͳ��־

unit Base;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, ExtCtrls, Grids, Menus, PrintForm;

type
  TBaseForm = class(TForm)
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    function ReadSaveForm: Boolean;
    function WriteSaveForm: Boolean;
  protected
    bOperateLog: Boolean;
    bReadSaveForm: Boolean;
    bWriteSaveForm: Boolean;

    bReadDBGridEhAutoFitColWidth: Boolean;
    bReadDBGridEhFlat: Boolean;
    bReadDBEditFlat: Boolean;
    iModuleID: Integer;
    sFunctionName: String;

    procedure SetSencondTitle;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  BaseForm: TBaseForm;

implementation

uses SysPublic, DataM;

{$R *.dfm}

procedure TBaseForm.FormShow(Sender: TObject);
begin
  if bReadSaveForm then ReadSaveForm;
  if bReadDBGridEhAutoFitColWidth then ReadDBGridEhAutoFitColWidth(Self);
  if bReadDBGridEhFlat then ReadDBGridEhFlat(Self);
  if bReadDBEditFlat then ReadDBEditFlat(Self);
  SetSencondTitle;
end;

procedure TBaseForm.FormCreate(Sender: TObject);
begin
  bOperateLog := True;
  bReadSaveForm:= True;
  bWriteSaveForm:= True;
  bReadDBGridEhAutoFitColWidth:= True;
  bReadDBGridEhFlat:= True;
  bReadDBEditFlat:= True;
end;

function TBaseForm.ReadSaveForm: Boolean;
var
  sState, sSql: string;
  ADOQryTmp: TADOQuery;
begin
  Result:= False;
  ADOQryTmp := TADOQuery.Create(nil);
  GetConn(ADOQryTmp);
  sSql := ' SELECT * FROM ����״̬�� WHERE ����=''' + Caption + ''' and �û�����='''+LoginEmployeCode+'''';

  ADOQryTmp.Close;
  ADOQryTmp.SQL.Clear;
  ADOQryTmp.SQL.Add(sSql);
  ADOQryTmp.Open;

  if not ADOQryTmp.IsEmpty then
  begin
    sState := ADOQryTmp.FieldByName('״̬').AsString;
    Top := ADOQryTmp.FieldByName('��').AsInteger;
    Left := ADOQryTmp.FieldByName('��').AsInteger;
    if Trim(sState) = 'wsMinimized' then
      Self.WindowState := wsMinimized
    else
      if Trim(sState) = 'wsMaximized' then
        Self.WindowState := wsMaximized
      else
      begin
        Self.WindowState := wsNormal;
        Width := ADOQryTmp.FieldByName('��').AsInteger;
        Height := ADOQryTmp.FieldByName('��').AsInteger;
      end;
  end;
  ADOQryTmp.Close;
  ADOQryTmp.Free;
  Result:= True;
end;

function TBaseForm.WriteSaveForm: Boolean;
var
  sSql, sState: string;
  ADOQryTmp: TADOQuery;
begin
  Result:= False;
  //��̬����ADOQ������ADOConnection
  ADOQryTmp:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp);

  if Self.WindowState = wsNormal then
    sState := 'WsNormal'
  else
    if Self.WindowState = wsMinimized then
      sState := 'wsMinimized'
    else
      if Self.WindowState = wsMaximized then
        sState := 'wsMaximized'
      else
        sState := '';
  sSql := ' SELECT * FROM ����״̬�� WHERE ����=''' + Caption + ''' and �û�����='''+LoginEmployeCode+'''';

  ADOQryTmp.Close;
  ADOQryTmp.SQL.Clear;
  ADOQryTmp.SQL.Add(sSql);
  ADOQryTmp.Open;

  if ADOQryTmp.RecordCount < 1 then
    sSql := 'INSERT INTO ����״̬��(�û�����, ����,��,��,��,��,״̬)'
      + 'VALUES('''+LoginEmployeCode+''', ''' + Caption + ''',' + IntToStr(Top) + ',' + IntToStr(Left) + ',' +
      IntToStr(Width) + ',' + IntToStr(Height) + ',''' + sState + ''')'
  else
  begin
    if Self.WindowState = wsNormal then
      sSql := ' UPDATE ����״̬�� Set ��=' + IntToStr(Top) + ',��=' +
        IntToStr(Left) +
        ',��=' + IntToStr(Width) + ',��=' + IntToStr(Height) +
        ',״̬=''' + sState + ''' Where ����=''' + Caption + ''' and �û�����='''+LoginEmployeCode+''''
    else
      sSql := ' UPDATE ����״̬�� Set ״̬=''' + sState + ''' Where ����=''' + Caption + ''' and �û�����='''+LoginEmployeCode+'''';
   end;
  ADOQryTmp.Close;
  ADOQryTmp.SQL.Clear;
  ADOQryTmp.SQL.Add(sSql);
  ADOQryTmp.ExecSQL;
  ADOQryTmp.Close;
  ADOQryTmp.Free;
  Result:= True;
end;

procedure TBaseForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if bWriteSaveForm then WriteSaveForm;
  if bOperateLog  then SaveOperateLog(Caption);
end;

constructor TBaseForm.Create(AOwner: TComponent);
begin
  inherited;
end;

destructor TBaseForm.Destroy;
begin
  inherited;
end;

procedure TBaseForm.SetSencondTitle;
var
  i: integer;
  ADOQryTmp: TADOQuery;
  S: string;
begin
{  ADOQryTmp:= TADOQuery.Create(Nil);
  GetConn(ADOQryTmp);

  ADOQryTmp.Close;
  ADOQryTmp.SQL.Clear;
  ADOQryTmp.SQL.Add('Select �û����� From �û�����');
  ADOQryTmp.Open;

  S:= ADOQryTmp.FieldByName('�û�����').AsString;}

  S:= '��ͼ���������';

  for i:=0 to ComponentCount-1 do
  begin  { ����Form��� }
      if Components[i] is TPrintForm then
      begin
        (Components[i] as TPrintForm).Title:= '';
        (Components[i] as TPrintForm).Title := S;
      end;
  end;
//  ADOQryTmp.Close;
//  ADOQryTmp.Free;
end;

end.
