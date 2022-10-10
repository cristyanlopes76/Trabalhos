unit uPessoas;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.Mask, uThreads, Xml.xmldom, Xml.XMLIntf, Xml.XMLDoc, Vcl.Buttons;

type
  TfrmPessoas = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    pgcPrincipal: TPageControl;
    tabCadastro: TTabSheet;
    tabListagem: TTabSheet;
    grdLista: TDBGrid;
    Panel3: TPanel;
    cboTipoPesquisa: TComboBox;
    edtPesquisar: TMaskEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtCodigo: TMaskEdit;
    Label3: TLabel;
    edtDocumento: TMaskEdit;
    Label6: TLabel;
    cboNatureza: TComboBox;
    Label7: TLabel;
    dtDataRegistro: TDateTimePicker;
    Label8: TLabel;
    GroupBox1: TGroupBox;
    Label9: TLabel;
    edtLogradouro: TMaskEdit;
    Label10: TLabel;
    edtCEP: TMaskEdit;
    edtCodigoEnd: TMaskEdit;
    Label11: TLabel;
    Panel4: TPanel;
    Label12: TLabel;
    edtBairro: TMaskEdit;
    edtCidade: TMaskEdit;
    Label13: TLabel;
    Label15: TLabel;
    edtEstado: TMaskEdit;
    edtNome: TMaskEdit;
    Label4: TLabel;
    edtSobrenome: TMaskEdit;
    Label5: TLabel;
    edtComplemento: TMaskEdit;
    Label14: TLabel;
    cboTipoImp: TComboBox;
    Label16: TLabel;
    btnIncluir: TBitBtn;
    btnSair: TBitBtn;
    btnGravar: TBitBtn;
    btnExcluir: TBitBtn;
    btnCancelar: TBitBtn;
    procedure btnSairClick(Sender: TObject);
    procedure grdListaDblClick(Sender: TObject);
    procedure btnIncluirClick(Sender: TObject);
    procedure edtPesquisarChange(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure edtCEPExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cboNaturezaChange(Sender: TObject);
    procedure edtDocumentoExit(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure cboTipoPesquisaChange(Sender: TObject);
  private
    { Private declarations }
    procedure clearCampos;
    function deleteRegistro: Boolean;
    procedure openLista;
  public
    { Public declarations }
  end;

var
  frmPessoas: TfrmPessoas;
  procuraCep: TFuncaoPegaCep;

implementation

{$R *.dfm}

uses uDM, uFuncoes, uClassePessoa;

procedure TfrmPessoas.btnCancelarClick(Sender: TObject);
begin
  btnIncluir.Enabled := True;
  clearCampos;
  pgcPrincipal.ActivePage := tabListagem;
end;

procedure TfrmPessoas.btnExcluirClick(Sender: TObject);
begin
  if edtCodigo.Text <> '0' then
  begin
    if deleteRegistro then
    begin
      btnIncluir.Enabled := True;
      openLista;
      pgcPrincipal.ActivePage := tabListagem;
    end;
  end;
end;

function TfrmPessoas.deleteRegistro: Boolean;
begin
  deleteRegistro := False;

  if StrToInt(edtCodigo.Text) <= 0 then
    Exit;

  if MessageDlg('Deseja realmente excluir este registro?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  try
    with dm.fd_qryUpdate do
    begin
      sql.Clear;
      sql.Add('delete from public.pessoa where idpessoa = ' + edtCodigo.Text);
      ExecSQL;
      deleteRegistro := True;
    end;
  except
    on e: Exception do
      MessageDlg('Erro ao excluir o registro! ' + chr(13) + 'Erro: ' + e.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmPessoas.btnGravarClick(Sender: TObject);
var vSQL, vSQLEnd, vSQLInt, vID: String;
  vPessoa: TClassePessoa;
begin
  try
    if StrToInt(edtCodigoEnd.Text) <= 0 then
    begin
      MessageDlg('É necessário cadastrar um endereço! ', mtWarning, [mbOK], 0);
      Exit;
    end;

    vPessoa := TClassePessoa.Create;

    vPessoa.IdPessoa     := StrToInt(edtCodigo.Text);
    vPessoa.Natureza     := AnsiUpperCase(cboNatureza.Text);
    vPessoa.Documento    := edtDocumento.Text;
    vPessoa.Primeiro     := edtNome.Text;
    vPessoa.Segundo      := edtSobrenome.Text;
    vPessoa.DataRegistro := dtDataRegistro.Date;

    vPessoa.CEP          := edtCEP.Text;
    vPessoa.IdEndereco   := StrToInt(edtCodigoEnd.Text);
    vPessoa.Logradouro   := edtLogradouro.Text;
    vPessoa.Bairro       := edtBairro.Text;
    vPessoa.Cidade       := edtCidade.Text;
    vPessoa.Estado       := edtEstado.Text;
    vPessoa.Complemento  := edtComplemento.Text;

    if vPessoa.Gravar then
    begin
      MessageDlg('Gravado com Sucesso!', mtInformation, [mbOK], 0);
      clearCampos;
      btnIncluir.Enabled := True;
      pgcPrincipal.ActivePage := tabListagem;
      openLista;
    end;
  except
    on e: Exception do
      MessageDlg('Erro ao gravar o registro! ' + chr(13) + 'Erro: ' + e.Message, mtError, [mbOK], 0);
  end;
end;

procedure TfrmPessoas.btnIncluirClick(Sender: TObject);
begin
  pgcPrincipal.ActivePage := tabCadastro;
  clearCampos;
  cboNatureza.SetFocus;
  btnIncluir.Enabled := False;
  btnGravar.Enabled  := True;
  btnExcluir.Enabled := False;
end;

procedure TfrmPessoas.cboNaturezaChange(Sender: TObject);
begin
  edtDocumento.EditMask := pegaMascaraDoc(cboNatureza.ItemIndex);

  if edtDocumento.Text <> EmptyStr then
    edtDocumento.Clear;

  edtDocumento.SetFocus;
end;

procedure TfrmPessoas.cboTipoPesquisaChange(Sender: TObject);
begin
  edtPesquisar.Clear;
  edtPesquisar.SetFocus;
end;

procedure TfrmPessoas.clearCampos;
begin
  edtCodigo.Text := '0';
  cboNatureza.ItemIndex := -1;
  dtDataRegistro.Date := Date;
  edtDocumento.Clear;
  edtNome.Clear;
  edtSobrenome.Clear;

  // endereco
  edtCEP.Clear;
  edtCodigoEnd.Clear;
  edtLogradouro.Clear;
  edtBairro.Clear;
  edtCidade.Clear;
  edtEstado.Clear;
  edtComplemento.Clear;
end;

procedure TfrmPessoas.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPessoas.grdListaDblClick(Sender: TObject);
begin
  if DM.fd_qryListaPes.RecordCount = 0 then
    Exit;

  btnIncluir.Click;

  with DM.fd_qryListaPes do
  begin
    edtCodigo.Text        := FieldByName('idpessoa').AsString;
    cboNatureza.ItemIndex := FieldByName('flnatureza').AsInteger;
    edtDocumento.Text     := FieldByName('dsdocumento').AsString;
    edtNome.Text          := FieldByName('nmprimeiro').AsString;
    edtSobrenome.Text     := FieldByName('nmsegundo').AsString;
    dtDataRegistro.Date   := StrTODate(FieldByName('dtregistro').AsString);
    edtCodigoEnd.Text     := FieldByName('idendereco').AsString;
    edtCEP.Text           := FieldByName('dscep').AsString;
    edtEstado.Text        := FieldByName('dsuf').AsString;
    edtCidade.Text        := FieldByName('nmcidade').AsString;
    edtBairro.Text        := FieldByName('nmbairro').AsString;
    edtLogradouro.Text    := FieldByName('nmlogradouro').AsString;
    edtComplemento.Text   := FieldByName('dscomplemento').AsString;
  end;

  btnGravar.Enabled  := True;
  btnExcluir.Enabled := True;
  pgcPrincipal.ActivePage := tabCadastro;
end;

procedure TfrmPessoas.edtCEPExit(Sender: TObject);
begin
  if edtCEP.Text <> EmptyStr then
  begin
    if MessageDlg('Deseja pesquisar o Cep informado na base de dados?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      procuraCep := TFuncaoPegaCep.Create();
  end;
end;

procedure TfrmPessoas.edtDocumentoExit(Sender: TObject);
begin
  if edtDocumento.Text <> EmptyStr then
  begin
    if Length(edtDocumento.Text) = 14 then
    begin
      if isCPF(edtDocumento.Text) then
        Exit;
    end
    else begin
      if isCNPJ(edtDocumento.Text) then
        Exit;
    end;

    MessageDlg('Documento Inválido!', mtWarning, [mbOK], 0);
    edtDocumento.SetFocus;
  end;
end;

procedure TfrmPessoas.edtPesquisarChange(Sender: TObject);
begin
  openLista;
end;

procedure TfrmPessoas.openLista;
var vWhere: String;
begin
  if edtPesquisar.Text <> EmptyStr then
  begin
    if cboTipoPesquisa.ItemIndex = 0 then
      vWhere := ' AND PES.IDPESSOA = ' + edtPesquisar.Text
    else if cboTipoPesquisa.ItemIndex = 1 then
      vWhere := ' AND PES.DSDOCUMENTO LIKE ' + QuotedStr('%' + edtPesquisar.Text + '%')
    else if cboTipoPesquisa.ItemIndex = 2 then
      vWhere := ' AND PES.NMPRIMEIRO LIKE ' + QuotedStr('%' + edtPesquisar.Text + '%')
    else if cboTipoPesquisa.ItemIndex = 3 then
      vWhere := ' AND PES.NMSEGUNDO LIKE ' + QuotedStr('%' + edtPesquisar.Text + '%');
  end;

  with dm.fd_qryListaPes do
  begin
    close;
    SQL.Clear;
    SQL.Add(
      'select ' +
      '  pes.*, ' +
      '  lig.dscep, ' +
      '  log.* ' +
      'from ' +
      '  public.pessoa pes ' +
      '  left join public.endereco lig on lig.idpessoa = pes.idpessoa ' +
      '  left join public.endereco_integracao log on log.idendereco = lig.idendereco ' +
      'where 1=1 ' + vWhere
    );
    open;
  end;
end;

procedure TfrmPessoas.FormShow(Sender: TObject);
begin
  tabCadastro.TabVisible := False;
  tabListagem.TabVisible := False;
  openLista;
  pgcPrincipal.ActivePage := tabListagem;
end;

end.
