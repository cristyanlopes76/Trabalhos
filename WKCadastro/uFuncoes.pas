unit uFuncoes;

interface

uses SysUtils, Messages, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons, DBCtrls,
     Mask, DBGrids, DB, ExtCtrls, Menus, IniFiles, Provider, SqlExpr, DBClient, DateUtils, ShellApi, CheckLst,
     Wininet, printers, Variants, StrUtils, Types, XSBuiltIns, Tlhelp32, SOAPHTTPClient, Registry, ComOBJ, Math,
     ComCtrls, DBXcommon, TypInfo, Xml.XMLDoc, IdHTTP, Xml.XMLIntf;

function isCNPJ(CNPJ: string): boolean;
function isCPF(CPF: string): boolean;
function mascaraCNPJ(CNPJ: string): string;
function mascaraCPF(CPF: string): string;
function OnlyDigit(InString: string): string;
function pegaMascaraDoc(pTipo: Integer): String;

implementation

uses uDM;

function isCNPJ(CNPJ: string): boolean;
var dig13, dig14: string;
  sm, i, r, peso: integer;
begin
  CNPJ := OnlyDigit(CNPJ);

  if ((CNPJ = '00000000000000') or (CNPJ = '11111111111111') or (CNPJ = '22222222222222') or (CNPJ = '33333333333333') or
      (CNPJ = '44444444444444') or (CNPJ = '55555555555555') or (CNPJ = '66666666666666') or (CNPJ = '77777777777777') or
      (CNPJ = '88888888888888') or (CNPJ = '99999999999999') or (length(CNPJ) <> 14)) then
  begin
    isCNPJ := false;
    exit;
  end;

  try
    sm   := 0;
    peso := 2;

    for i := 12 downto 1 do
    begin
      sm   := sm + (StrToInt(CNPJ[i]) * peso);
      peso := peso + 1;

      if (peso = 10) then
        peso := 2;
    end;

    r := sm mod 11;
    if ((r = 0) or (r = 1)) then
      dig13 := '0'
    else
      str((11-r):1, dig13);

    sm   := 0;
    peso := 2;
    for i := 13 downto 1 do
    begin
      sm   := sm + (StrToInt(CNPJ[i]) * peso);
      peso := peso + 1;

      if (peso = 10) then
        peso := 2;
    end;

    r := sm mod 11;
    if ((r = 0) or (r = 1)) then
      dig14 := '0'
    else
      str((11-r):1, dig14);

    isCNPJ := ((dig13 = CNPJ[13]) and (dig14 = CNPJ[14]));
  except
    isCNPJ := false
  end;
end;

function isCPF(CPF: string): boolean;
var  dig10, dig11: string;
    s, i, r, peso: integer;
begin
  CPF := OnlyDigit(CPF);

  if ((CPF = '00000000000') or (CPF = '11111111111') or (CPF = '22222222222') or (CPF = '33333333333') or
      (CPF = '44444444444') or (CPF = '55555555555') or (CPF = '66666666666') or (CPF = '77777777777') or
      (CPF = '88888888888') or (CPF = '99999999999') or (length(CPF) <> 11)) then
  begin
    isCPF := false;
    exit;
  end;

  try
    s    := 0;
    peso := 10;

    for i := 1 to 9 do
    begin
      s    := s + (StrToInt(CPF[i]) * peso);
      peso := peso - 1;
    end;

    r := 11 - (s mod 11);
    if ((r = 10) or (r = 11)) then
      dig10 := '0'
    else
      str(r:1, dig10);

    s    := 0;
    peso := 11;

    for i := 1 to 10 do
    begin
      s    := s + (StrToInt(CPF[i]) * peso);
      peso := peso - 1;
    end;

    r := 11 - (s mod 11);

    if ((r = 10) or (r = 11)) then
      dig11 := '0'
    else
      str(r:1, dig11);

    if ((dig10 = CPF[10]) and (dig11 = CPF[11])) then
      isCPF := true
    else
      isCPF := false;
  except
    isCPF := false
  end;
end;

function mascaraCPF(CPF: string): string;
begin
  Result := copy(CPF, 1, 3) + '.' + copy(CPF, 4, 3) + '.' + copy(CPF, 7, 3) + '-' + copy(CPF, 10, 2);
end;

function mascaraCNPJ(CNPJ: string): string;
begin
  result := copy(CNPJ, 1, 2) + '.' + copy(CNPJ, 3, 3) + '.' + copy(CNPJ, 6, 3) + '.' + copy(CNPJ, 9, 4) + '-' + copy(CNPJ, 13, 2);
end;

function OnlyDigit(InString: string): string;
var
  I: Integer;
  Tmp: string;

  function IsDigit(Campo: string): Boolean;
  begin
    IsDigit := Pos(Campo, '0123456789') > 0;
  end;
begin
  Tmp := '';

  for I := 1 to Length(InString) do
  begin
    if IsDigit(InString[I]) then
      Tmp := Tmp + InString[I];
  end;

  OnlyDigit := Tmp;
end;

function pegaMascaraDoc(pTipo: Integer): String;
begin
  if pTipo = 0 then // Fisica
    Result := '999.999.999-99;1;_'
  else
    Result := '99.999.999/9999-99;1;_';
end;

end.
