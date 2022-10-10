unit uThreads;

interface

uses Windows, Messages, SysUtils, Variants, Classes, Controls, Dialogs, StdCtrls, Xml.XMLDoc, Xml.XMLIntf,
     IdHTTP, ActiveX, System.JSON, REST.Client, IPPeerClient;

type
  TFuncaoPegaCep = class(TThread)

  private

  protected
    procedure Execute; override;
  public
    constructor Create();
    destructor Destroy; override;
  end;

var pCep: string;

function getEnderecoXML(pCep: String): TStringList;
function getEnderecoJSON(pCep: String): TStringList;

implementation

uses uFuncoes, uPessoas;

constructor TFuncaoPegaCep.Create();
begin
  inherited Create(True);
  Priority := tpLower;
  FreeOnTerminate := True;
  Resume;
end;

destructor TFuncaoPegaCep.Destroy;
begin
  inherited;
end;

procedure TFuncaoPegaCep.Execute;
var vEndereco: TStringList;
begin
  inherited;

  try
    CoInitialize(nil);

    try
      vEndereco := TStringList.Create;
      pCep      := OnlyDigit(frmPessoas.edtCep.Text);

      if frmPessoas.cboTipoImp.ItemIndex = 0 then
        vEndereco := getEnderecoJSON(pCep)
      else
        vEndereco := getEnderecoXML(pCep);

      if vEndereco.Count > 0 then
      begin
        // frmPessoas.edtCep.Text      := vEndereco[1];
        frmPessoas.edtCodigoEnd.Text   := vEndereco[0];
        frmPessoas.edtLogradouro.Text  := vEndereco[2];
        frmPessoas.edtBairro.Text      := vEndereco[3];
        frmPessoas.edtCidade.Text      := vEndereco[4];
        frmPessoas.edtEstado.Text      := vEndereco[5];
        frmPessoas.edtComplemento.Text := vEndereco[6];
      end
      else begin
        MessageDlg('CEP não foi encontrado!', mtWarning, [mbOK],0);
        frmPessoas.edtCep.SetFocus;
      end;
    except
      on e: Exception do
        MessageDlg('Erro ao consultar o CEP!' + #13#10 + 'Erro: ' + e.Message, mtError, [mbOK],0);
    end;
  Finally
    CoUninitialize;
  end;

  Terminate;
end;

function getEnderecoXML(pCep: String): TStringList;
var
  XMLBuscaCep: TXMLDocument;
  IdHTTP: TIdHTTP;
  vEndereco: TStringList;
  node: IXMLNode;
begin
  IdHTTP    := TIdHTTP.Create(nil);
  vEndereco := TStringList.Create;

  try
    IdHTTP.Request.ContentEncoding := 'utf-8';
    IdHTTP.Request.AcceptCharSet   := 'utf-8';

    XMLBuscaCep          := TXMLDocument.Create(frmPessoas);
    XMLBuscaCEP.FileName := 'https://viacep.com.br/ws/' + OnlyDigit(pCep) + '/xml/';
    XMLBuscaCEP.Active   := true;
    XMLBuscaCEP.Encoding := 'iso-8859-1';
    // XMLBuscaCEP.SaveToFile('D:\temp\teste.xml');

    node := XMLBuscaCEP.Node.ChildNodes.FindNode('xmlcep');
    if Assigned(node) then
    begin
      with node.ChildNodes do
      begin
        with vEndereco do
        begin
          if Assigned(FindNode('ibge')) then
            Add(FindNode('ibge').Text);

          if Assigned(FindNode('cep')) then
            Add(FindNode('cep').Text);

          if Assigned(FindNode('logradouro')) then
            Add(FindNode('logradouro').Text);

          if Assigned(FindNode('bairro')) then
            Add(FindNode('bairro').Text);

          if Assigned(FindNode('localidade')) then
            Add(FindNode('localidade').Text);

          if Assigned(FindNode('uf')) then
            Add(FindNode('uf').text);

          if Assigned(FindNode('complemento')) then
            Add(FindNode('complemento').text);

          if Assigned(FindNode('uf')) then
            Add(FindNode('uf').Text);
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      MessageDlg('Não foi possível localizar o endereço com o CEP informado!', mtInformation, [mbOK],0);
    end;
  end;

  FreeAndNil(XMLBuscaCep);
  IdHTTP.Destroy;
  Result := vEndereco;
end;

function getEnderecoJSON(pCep: String): TStringList;
var
  pObjeto: TJSONObject;
  pClient: TRESTClient;
  pRequest: TRESTRequest;
  pResponse: TRESTResponse;
  vEndereco: TStringList;
begin
  pClient   := TRESTClient.Create(nil);
  pRequest  := TRESTRequest.Create(nil);
  pResponse := TRESTResponse.Create(nil);

  pRequest.Client   := pClient;
  pRequest.Response := pResponse;
  pClient.BaseURL   := 'https://viacep.com.br/ws/' + OnlyDigit(pCep) + '/json/';
  pRequest.Execute;

  pObjeto   := pResponse.JSONValue as TJSONObject;
  vEndereco := TStringList.Create;

  try
    if Assigned(pObjeto) then
    begin
      if pObjeto.Count <> 0 then
      begin
        if Assigned(pObjeto.Values['ibge']) then
          vEndereco.Add(pObjeto.Values['ibge'].Value);

        if Assigned(pObjeto.Values['cep']) then
          vEndereco.Add(pObjeto.Values['cep'].Value);

        if Assigned(pObjeto.Values['logradouro']) then
          vEndereco.Add(pObjeto.Values['logradouro'].Value);

        if Assigned(pObjeto.Values['bairro']) then
          vEndereco.Add(pObjeto.Values['bairro'].Value);

        if Assigned(pObjeto.Values['localidade']) then
          vEndereco.Add(pObjeto.Values['localidade'].Value);

        if Assigned(pObjeto.Values['uf']) then
          vEndereco.Add(pObjeto.Values['uf'].Value);

        if Assigned(pObjeto.Values['complemento']) then
          vEndereco.Add(pObjeto.Values['complemento'].Value);

        if Assigned(pObjeto.Values['uf']) then
          vEndereco.Add(pObjeto.Values['uf'].Value);
      end;
    end;
  except
    on E: Exception do
    begin
      MessageDlg('Não foi possível localizar o endereço com o CEP informado!', mtInformation, [mbOK],0);
    end;
  end;

  FreeAndNil(pObjeto);
  Result := vEndereco;
end;

end.
