object NowaSampleMain: TNowaSampleMain
  Left = 0
  Top = 0
  Caption = 'Nowa Sample'
  ClientHeight = 373
  ClientWidth = 656
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object btnCreatePerson: TButton
    Left = 32
    Top = 272
    Width = 137
    Height = 25
    Caption = 'btnCreatePerson'
    TabOrder = 0
    OnClick = btnCreatePersonClick
  end
  object FDatabaseConnection: TFDConnection
    Params.Strings = (
      'DriverID=SQLite')
    Left = 200
    Top = 80
  end
  object FPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink
    Left = 408
    Top = 56
  end
end
