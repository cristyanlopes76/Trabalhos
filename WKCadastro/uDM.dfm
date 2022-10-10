object DM: TDM
  OldCreateOrder = False
  Height = 581
  Width = 893
  object fdConexao: TFDConnection
    Params.Strings = (
      'User_Name=postgres'
      'password=postgres'
      'Database=ds_teste'
      'DriverID=PG')
    Connected = True
    LoginPrompt = False
    Transaction = fdTransacao
    Left = 40
    Top = 16
  end
  object fdTransacao: TFDTransaction
    Connection = fdConexao
    Left = 72
    Top = 16
  end
  object fd_qryListaEnd: TFDQuery
    Connection = fdConexao
    SQL.Strings = (
      'select * from public.endereco_integracao')
    Left = 56
    Top = 144
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    VendorHome = 'D:\Fontes\Trabalhos\Trabalhos\WKCadastro\Win32\Debug'
    Left = 144
    Top = 40
  end
  object dsListaEnd: TDataSource
    DataSet = fd_qryListaEnd
    Left = 88
    Top = 144
  end
  object fd_qryListaPes: TFDQuery
    Connection = fdConexao
    SQL.Strings = (
      'select '
      '  pes.*,'
      '  lig.dscep,'
      '  log.* '
      'from '
      '  public.pessoa pes'
      '  inner join public.endereco lig on lig.idpessoa = pes.idpessoa'
      
        '  inner join public.endereco_integracao log on log.idendereco = ' +
        'lig.idendereco')
    Left = 56
    Top = 192
    object fd_qryListaPesidpessoa: TLargeintField
      DisplayLabel = 'C'#243'digo'
      FieldName = 'idpessoa'
      Origin = 'idpessoa'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object fd_qryListaPesflnatureza: TSmallintField
      DisplayLabel = 'Natureza'
      FieldName = 'flnatureza'
      Origin = 'flnatureza'
      OnGetText = fd_qryListaPesflnaturezaGetText
    end
    object fd_qryListaPesdsdocumento: TWideStringField
      DisplayLabel = 'Documento'
      FieldName = 'dsdocumento'
      Origin = 'dsdocumento'
    end
    object fd_qryListaPesnmprimeiro: TWideStringField
      DisplayLabel = 'Nome'
      FieldName = 'nmprimeiro'
      Origin = 'nmprimeiro'
      Size = 100
    end
    object fd_qryListaPesnmsegundo: TWideStringField
      DisplayLabel = 'Sobrenome'
      FieldName = 'nmsegundo'
      Origin = 'nmsegundo'
      Size = 100
    end
    object fd_qryListaPesdtregistro: TDateField
      DisplayLabel = 'Data Registro'
      FieldName = 'dtregistro'
      Origin = 'dtregistro'
    end
    object fd_qryListaPesdscep: TWideStringField
      AutoGenerateValue = arDefault
      DisplayLabel = 'CEP'
      FieldName = 'dscep'
      Origin = 'dscep'
      Size = 15
    end
    object fd_qryListaPesnmlogradouro: TWideStringField
      AutoGenerateValue = arDefault
      DisplayLabel = 'Logradouro'
      FieldName = 'nmlogradouro'
      Origin = 'nmlogradouro'
      Size = 100
    end
    object fd_qryListaPesnmbairro: TWideStringField
      AutoGenerateValue = arDefault
      DisplayLabel = 'Bairro'
      FieldName = 'nmbairro'
      Origin = 'nmbairro'
      Size = 50
    end
    object fd_qryListaPesdscomplemento: TWideStringField
      AutoGenerateValue = arDefault
      DisplayLabel = 'Complemento'
      FieldName = 'dscomplemento'
      Origin = 'dscomplemento'
      Size = 100
    end
    object fd_qryListaPesnmcidade: TWideStringField
      AutoGenerateValue = arDefault
      DisplayLabel = 'Cidade'
      FieldName = 'nmcidade'
      Origin = 'nmcidade'
      Size = 100
    end
    object fd_qryListaPesdsuf: TWideStringField
      AutoGenerateValue = arDefault
      DisplayLabel = 'Estado'
      FieldName = 'dsuf'
      Origin = 'dsuf'
      Size = 50
    end
    object fd_qryListaPesidendereco: TLargeintField
      AutoGenerateValue = arDefault
      DisplayLabel = 'C'#243'digo Endere'#231'o'
      FieldName = 'idendereco'
      Origin = 'idendereco'
    end
  end
  object dsListaPes: TDataSource
    DataSet = fd_qryListaPes
    Left = 88
    Top = 192
  end
  object fd_qryUpdate: TFDQuery
    Connection = fdConexao
    SQL.Strings = (
      'select * from public.pessoa')
    Left = 72
    Top = 96
  end
  object fd_qryAux: TFDQuery
    Connection = fdConexao
    SQL.Strings = (
      'select * from public.pessoa')
    Left = 204
    Top = 160
  end
end
