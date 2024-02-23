object DMConnection: TDMConnection
  OldCreateOrder = False
  Height = 190
  Width = 356
  object FDConn: TFDConnection
    Params.Strings = (
      'Database=DBMarcelo'
      'User_Name=sa'
      'Password=mix'
      'Server=localhost,50025'
      'DriverID=MSSQL')
    ConnectedStoredUsage = [auDesignTime]
    LoginPrompt = False
    Left = 64
    Top = 40
  end
  object FDPhysMSSQLDriverLink: TFDPhysMSSQLDriverLink
    Left = 120
    Top = 89
  end
end
