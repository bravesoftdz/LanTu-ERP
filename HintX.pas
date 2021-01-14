//������һ��Delphi��Ԫ�Ĵ��룬���ѳ���ͼ�������ʾ��������:

{--���뿪ʼ--} 

unit HintX; 

interface 

uses 
  Windows, Messages, Controls; 

type 
  TIconHintX = class(THintWindow) 
  protected 
    procedure Paint; override; 
  public 
    function CalcHintRect(MaxWidth: Integer; const AHint: string; AData: Pointer): TRect; override; 
  end; 

implementation 

uses Forms; 

{ TIconHintX } 

{-Ϊ�˷���һ��ͼ�꣬���¼�����ʾ������Ĵ�С:-} 
function TIconHintX.CalcHintRect(MaxWidth: Integer; const AHint: string; 
  AData: Pointer): TRect; 
begin 
  Result := inherited CalcHintRect(MaxWidth, AHint, AData);     Result.Right := (Length(AHint) * 5) + Application.Icon.Width; 
  Result.Bottom := (Application.Icon.Height) * 2; 
end; 

procedure TIconHintX.Paint; 
const 
  MARGIN = 5; 
begin 
  inherited; 
  Canvas.Draw(MARGIN, MARGIN * 5, Application.Icon); 
  SendMessage(Handle, WM_NCPAINT, 0, 0); //����ʾ���߿� 
end; 

initialization 
  //�����ǵ���������ΪĬ�ϵ���ʾ����: 
  HintWindowClass := TIconHintX; 


{--�������--} 
end. 
// Ϊ�˿���Ч��, �������Ԫ���������Ӧ�ó�������õ�Ԫ�б��С�

