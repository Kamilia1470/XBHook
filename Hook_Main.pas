unit Hook_Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    isHookInstalled:Boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

  {DLL 中的函数声明}
  function SetHook: Boolean; stdcall;
  function DelHook: Boolean; stdcall;
  procedure PrintHook;stdcall;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{DLL 中的函数实现, 也就是说明来自那里, 原来叫什么名}
function SetHook; external 'KeyboardHook.dll' name 'SetHook';
function DelHook; external 'KeyboardHook.dll' name 'DelHook';
procedure PrintHook; external 'KeyboardHook.dll' name 'PrintHook';

procedure TForm1.Button1Click(Sender: TObject);
begin
   Self.Button1.Enabled:=False;
   Self.Button2.Enabled:=True;
   Self.Button3.Enabled:=True;

   if SetHook then
   begin
     isHookInstalled:=True;
     Self.Memo1.Lines.Add('键盘钩子已安装。。。');
   end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
   PrintHook;
   Self.Memo1.Lines.Add('已打印');
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
   if DelHook then
   begin
    isHookInstalled:=False;
    Self.Memo1.Lines.Add('键盘钩子已撤销！！！');
    Self.Memo1.Lines.Add(' ');
   end;

   Self.Button1.Enabled:=True;
   Self.Button2.Enabled:=False;
   Self.Button3.Enabled:=False;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Self.Button1.Enabled:=True;
  Self.Button2.Enabled:=False;
  Self.Button3.Enabled:=False;
  isHookInstalled:=False;

  Self.Memo1.Color:=clBlack;
  Self.Memo1.Font.Color:=clGreen;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if isHookInstalled then
    DelHook;
end;

end.
