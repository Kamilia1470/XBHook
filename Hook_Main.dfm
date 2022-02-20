object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 277
  ClientWidth = 407
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 40
    Top = 32
    Width = 75
    Height = 25
    Caption = 'start'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 160
    Top = 32
    Width = 75
    Height = 25
    Caption = 'print'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 280
    Top = 32
    Width = 75
    Height = 25
    Caption = 'stop'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Memo1: TMemo
    Left = 40
    Top = 72
    Width = 315
    Height = 153
    Lines.Strings = (
      'Memo1')
    TabOrder = 3
  end
end
