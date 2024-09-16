object DmDados: TDmDados
  Height = 533
  Width = 695
  object Conexao: TFDConnection
    Params.Strings = (
      'User_Name=root'
      'Server=localhost'
      'Database=wk_teste'
      'Password=mssql'
      'DriverID=MySQL')
    TxOptions.Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    LoginPrompt = False
    Left = 80
    Top = 56
  end
  object FDTransaction: TFDTransaction
    Options.Params.Strings = (
      'read_committed'
      'rec_version'
      'nowait')
    Connection = Conexao
    Left = 104
    Top = 128
  end
  object FDGUIxWaitCursor: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 192
    Top = 120
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 'D:\NOVO\WK\libmysql.dll'
    Left = 328
    Top = 88
  end
end
