object dm: Tdm
  OnCreate = DataModuleCreate
  Height = 120
  Width = 341
  object conn: TFDConnection
    Params.Strings = (
      
        'Database=C:\Users\willi\OneDrive\Documentos\Embarcadero\Studio\P' +
        'rojects\Coletor\Android64\Debug\bd\banco.db'
      'User_Name=root'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 24
    Top = 24
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    OnHide = DataModuleCreate
    Left = 160
    Top = 24
  end
  object FDQuery1: TFDQuery
    Connection = conn
    Left = 304
    Top = 72
  end
end
