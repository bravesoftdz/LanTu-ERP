unit publicUn;          //������Ԫ

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Dialogs,StdCtrls,AdoDb;
  //�������������
  Function check_data(str_tmp : string) : Boolean;

  //��ȡ��Ա��Ϣ
  Function Get_hy_info(str_tmp:string; var sRet : Array of string) : Boolean;             //ȡ��Ա��š�����

  //��̨����̨����
  Procedure insert_data(str_id,str_name,str_seat,str_number,str_note,str_type : string);  //��̨  ��  ��̨

  //��ȡ ��̨�б�
  procedure ini_dtbase(Combobox : TCombobox);

implementation

uses SysPublic;

Const
  Tab_hy  ='��Ա����';
  Tab_dt  ='̨λ���ϱ�';
  Tab_dtyy='̨λӪҵ��';


// str_tmp Ϊ�������Ŀ��� ; ���ػ�Ա��š�����
Function Get_hy_info(str_tmp:string; var sRet : Array of string) : Boolean;
var
  Tmp_Ado : TAdoquery;
  str_sql : string;
  i,j     : integer;
begin
  Result:=true;
  Tmp_ado:=nil;
  i:=low(sRet);
  j:=high(sRet);
  str_sql:=''''+str_tmp+'''';
  try
    Tmp_ado:=TAdoquery.Create(nil);
    GetConn(Tmp_ado);
    with Tmp_ado do
    begin
      sql.Add(format('select ��Ա���,��Ա���� from %s where ����=%s',[Tab_hy,str_sql]));
      sql.add(' and ��״̬ is null');
      open;
      if recordcount<1 then
      begin
        sRet[i] :='';
        sRet[j]:='';
        close;
      end
      else
      begin
        sRet[i] :=trim(fieldvalues['��Ա���']);
        sRet[j]:=trim(fieldvalues['��Ա����']);
        close;
      end;
    end;
  finally
    Tmp_Ado.Free;
  end;
end;


//===========================�������================================
procedure insert_data(str_id,str_name,str_seat,str_number,str_note,str_type : string);         //��̨  ��  ��̨
var
  Tmp_Ado  : TAdoquery;
  str_list : string;
  str_val  : string;
  str_tmp  : string;
begin
  Tmp_ado:=nil;
  try
    Tmp_ado:=TAdoquery.create(nil);
    Getconn(Tmp_ado);
    with Tmp_ado do
    begin
      str_list:='��Ա���,��Ա����,̨��,̨������,����,��ע,����Ա,״̬';
      str_val:=''''+str_id+''''+',';                       //��Ա���

      str_val:=str_val+''''+str_name+''''+',';             //��Ա����

      str_val:=str_val+''''+trim(copy(str_seat,1,pos('|',str_seat)-1))+''''+',';  //̨λ���
      str_val:=str_val+''''+trim(copy(str_seat,pos('|',str_seat)+1,length(str_seat)))+''''+','; //̨λ����

      if trim(str_number)='' then                          //����
      str_val:=str_val+'0'+','
      else
      str_val:=str_val+str_number+',';

      str_val:=str_val+''''+str_note+''''+',';             //��ע

      str_val:=str_val+''''+LoginEmployeName+''''+',';     //������

      str_val:=str_val+''''+str_type+'''';                 //��̨����̨

      sql.Add(format('insert into %s (%s) values (%s)',[Tab_dtyy,str_list,str_val]));
      execsql;
      close;

      //���� ��̨���ϱ�
      str_val:=''''+trim(copy(str_seat,1,pos('|',str_seat)-1))+'''';
      if str_type='��̨' then
      str_tmp:=''''+'Ӫҵ'+''''
      else
      str_tmp:=''''+'Ԥ��'+'''';

      sql.Clear;
      sql.Add(format('update %s set Ӫҵ״̬=%s where ���=%s',[Tab_dt,str_tmp,str_val]));
      execsql;
      close;

      if str_type='��̨' then
      showmessage('��̨���!')
      else
      showmessage('��̨���!');
    end;
  finally
    Tmp_ado.free;
  end;
end;


Function check_data(str_tmp : string) : Boolean;
begin
  Result:=true;
  if trim(str_tmp)='' then
  begin
    showmessage('��ѡ��̨��!');
    Result:=false;
  end;
end;


//��ȡ��̨�б�
procedure ini_dtbase(Combobox : TCombobox);
var
  Tmp_Ado : TAdoquery;
  str_val : string;
  str_id,str_name : string;
begin
  Tmp_ado:=nil;
  str_val:=''''+'''';
  combobox.Clear;
  try
    Tmp_Ado:=TAdoquery.Create(nil);
    GetConn(Tmp_ado);
    with Tmp_ado do
    begin
      SQL.Clear;
      SQL.Add(format('SELECT * FROM %s where Ӫҵ״̬=%s',[Tab_dt,str_val]));
      Open;
      while not eof do
      begin
        str_id  :=trim(fieldbyname('���').AsString);
        str_name:=trim(fieldbyname('����').AsString);
        while length(str_id)<10 do
        str_id:=str_id+' ';
        str_val:=str_id+'|'+str_name;
        combobox.Items.Add(str_val);
        next;
      end;
    end;
    Tmp_ado.Close;
  finally
    Tmp_ado.Close;
    Tmp_ado.Free;
  end;
end;


end.
