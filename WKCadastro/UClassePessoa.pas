unit UClassePessoa;

interface

uses uFuncoes, udm, Winapi.Messages, System.SysUtils, System.Variants, Vcl.Dialogs, System.Classes;

type
  TClassePessoa = class

  private
    FIdPessoa: Integer;
    FNatureza: String;
    FDocumento: String;
    FPrimeiro: String;
    FSegundo: String;
    FDataRegistro: TDate;

    FIdEndereco: Integer;
    FCEP: String;
    FLogradouro: String;
    FBairro: String;
    FCidade: String;
    FEstado: String;
    FComplemento: String;

    procedure SetDocumento(const Value: String);
    procedure SetNatureza(const Value: String);
  protected
  public
    property IdPessoa     :Integer read FIdPessoa     write FIdPessoa;
    property Natureza     :String  read FNatureza     write SetNatureza;
    property Documento    :String  read FDocumento    write SetDocumento;
    property Primeiro     :String  read FPrimeiro     write FPrimeiro;
    property Segundo      :String  read FSegundo      write FSegundo;
    property DataRegistro :TDate   read FDataRegistro write FDataRegistro;

    property IdEndereco   :Integer read FIdEndereco  write FIdEndereco;
    property CEP          :String  read FCEP         write FCEP;
    property Logradouro   :String  read FLogradouro  write FLogradouro;
    property Bairro       :String  read FBairro      write FBairro;
    property Cidade       :String  read FCidade      write FCidade;
    property Estado       :String  read FEstado      write FEstado;
    property Complemento  :String  read FComplemento write FComplemento;

    // poderia ter feito uma classe para estes, mais preferi centralizar
    function Gravar: Boolean;
    function searchPessoa: Integer;
    function searchEndereco: Integer;
    function obtemIDPessoa: Integer;
    function obtemIDEndereco: Integer;
    function executeSQL(pSQL: String): Boolean;
  published

  end;

implementation

{ TClassePessoa }

procedure TClassePessoa.SetDocumento(const Value: String);
begin
  if Value <> EmptyStr then
  begin
    if FNatureza = '0' then
    begin
      if isCPF(Value) then
      begin
        FDocumento := Value;
        Exit;
      end;
    end
    else begin
      if isCNPJ(Value) then
      begin
        FDocumento := Value;
        Exit;
      end;
    end;

    MessageDlg('Documento ' + QuotedStr(Value) + ' inválido!', mtWarning, [mbOK], 0);
  end;
end;

procedure TClassePessoa.SetNatureza(const Value: String);
begin
  if UpperCase(Value) = 'FISICA' then
    FNatureza := '0'
  else
    FNatureza := '1'
end;

function TClassePessoa.Gravar: Boolean;
var vSQL, vSQLEnd, vSQLInt: String;
begin
  try
    // buscar se ja existe a pessoa
    FIdPessoa := searchPessoa;

    if FIdPessoa <> 0 then
    begin
      // update
      vSQL := 'UPDATE public.pessoa SET ' +
        ' flnatureza = ' + FNatureza + ',' +
        ' dsdocumento = ' + QuotedStr(FDocumento) + ',' +
        ' nmprimeiro = ' + QuotedStr(FPrimeiro) + ',' +
        ' nmsegundo = ' + QuotedStr(FSegundo) + ',' +
        ' dtregistro = ' + QuotedStr(DateToStr(FDataRegistro)) +
        ' WHERE idpessoa = ' + IntToStr(FIdPessoa);
    end
    else begin // insert
      FIdPessoa := obtemIDPessoa;
      vSQL := 'INSERT INTO public.pessoa(idpessoa, flnatureza, dsdocumento, nmprimeiro, nmsegundo, dtregistro' +
        ')VALUES(' +
        IntToStr(FIdPessoa) + ',' +
        QuotedStr(FNatureza) + ',' +
        QuotedStr(FDocumento) + ',' +
        QuotedStr(FPrimeiro) + ',' +
        QuotedStr(FSegundo) + ',' +
        'CURRENT_DATE) ';
    end;

    // verifica se existe o endereço cadastrado
    if searchEndereco = 0 then
    begin
      FIdEndereco := obtemIDEndereco;
      vSQLInt := 'INSERT INTO public.endereco_integracao(idendereco, dsuf, nmcidade, nmbairro, nmlogradouro, dscomplemento ' +
        ') VALUES ( ' +
        IntToStr(FIdEndereco) + ', ' +
        QuotedStr(FEstado) + ', ' +
        QuotedStr(FCidade) + ', ' +
        QuotedStr(FBairro) + ', ' +
        QuotedStr(FLogradouro) + ', ' +
        QuotedStr(FComplemento) + ')';

      vSQLEnd := 'INSERT INTO public.endereco(idendereco, idpessoa, dscep' +
        ') VALUES (' +
        IntToStr(FIdEndereco) +
        ',' + IntToStr(FIdPessoa) +
        ',' + QuotedSTR(FCEP) + ') ';
    end
    else begin
      vSQLEnd := 'UPDATE public.endereco SET ' +
        '  idendereco = ' + IntToStr(FIdEndereco) +
        ', dscep = ' + QuotedStr(FCEP) +
        ' WHERE idpessoa = ' + IntToStr(FIdPessoa);
    end;

    if not executeSQL(vSQL) then
      Exit;

    if not executeSQL(vSQLEnd) then
      Exit;

    if vSQLInt <> EmptyStr then
    begin
      if not executeSQL(vSQLInt) then
        Exit;
    end;

    Result := True;
  except
    on e: Exception do
    begin
      MessageDlg('Erro ao gravar o registro! ' + chr(13) + 'Erro: ' + e.Message, mtError, [mbOK], 0);
      Result := False;
    end;
  end;
end;

function TClassePessoa.searchPessoa: Integer;
begin
  with dm.fd_qryAux do
  begin
    sql.Clear;
    sql.Add('select idpessoa as id from public.pessoa	where dsdocumento = :dsdocumento ');
    ParamByName('dsdocumento').AsString := FDocumento;
    open;
    if FieldByName('id').AsString <> EmptyStr then
      Result := FieldByName('id').AsInteger
    else
      Result := 0;
    Close;
  end;
end;

function TClassePessoa.searchEndereco: Integer;
begin
  with dm.fd_qryAux do
  begin
    sql.Clear;
    sql.Add('select idendereco as id from public.endereco where dscep = :cep ');
    ParamByName('cep').AsString := FCep;
    open;
    if FieldByName('id').AsString <> EmptyStr then
      Result := FieldByName('id').AsInteger
    else
      Result := 0;
    Close;
  end;
end;

function TClassePessoa.obtemIDPessoa: Integer;
begin
  with dm.fd_qryAux do
  begin
    sql.Clear;
    sql.Add('select coalesce(max(idpessoa), 0)+1 as id from public.pessoa	');
    open;
    result := FieldByName('ID').AsInteger;
    Close;
  end;
end;

function TClassePessoa.obtemIDEndereco: Integer;
begin
  with dm.fd_qryAux do
  begin
    sql.Clear;
    sql.Add('select coalesce(max(idendereco), 0)+1 as id from public.endereco	');
    open;
    result := FieldByName('ID').AsInteger;
    Close;
  end;
end;

function TClassePessoa.executeSQL(pSQL: String): Boolean;
begin
  Result := False;
  try
    with dm.fd_qryUpdate do
    begin
      sql.Clear;
      sql.Add(pSQL);
      ExecSQL;
    end;
    Result := True;
  except
    on e: Exception do
      MessageDlg('Erro ao gravar o registro! ' + chr(13) + 'Erro: ' + e.Message, mtError, [mbOK], 0);
  end;
end;

end.
