unit uImporta;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Mask, Vcl.Samples.Gauges, Vcl.Buttons;

type
  TfrmImporta = class(TForm)
    Panel2: TPanel;
    Panel1: TPanel;
    fdo: TFileOpenDialog;
    edtArquivo: TMaskEdit;
    Label1: TLabel;
    Progresso: TGauge;
    btnEscolhe: TButton;
    labTipoImp: TLabel;
    cboTipoImp: TComboBox;
    cboTipoBusca: TComboBox;
    Label2: TLabel;
    btnSair: TBitBtn;
    btnImporta: TBitBtn;
    procedure btnSairClick(Sender: TObject);
    procedure btnEscolheClick(Sender: TObject);
    procedure btnImportaClick(Sender: TObject);
    procedure cboTipoBuscaChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmImporta: TfrmImporta;

implementation

{$R *.dfm}

uses uDM, uFuncoes, uThreads, uClassePessoa;

procedure TfrmImporta.btnImportaClick(Sender: TObject);
var vEndereco : TStringList;
    vArquivo, vLinha: TStrings;
    qtd: Integer;
    vPessoa : TClassePessoa;
begin
  if not FileExists(edtArquivo.Text) then
  begin
    MessageDlg('Arquivo não encontrado. Verifique!', mtWarning, [mbOK], 0);
    edtArquivo.SetFocus;
    Exit;
  end;

  if UpperCase(ExtractFileExt(edtArquivo.Text)) <> '.CSV' then
  begin
    MessageDlg('Extensão de arquivo inválida. Verifique!', mtWarning, [mbOK], 0);
    edtArquivo.SetFocus;
    Exit;
  end;

  try
    vArquivo := TStringList.Create;
    vArquivo.LoadFromFile(edtArquivo.Text);

    vLinha                 := TStringList.Create;
    vLinha.Delimiter       := ';';
    vLinha.StrictDelimiter := True;
    Progresso.MaxValue := vArquivo.Count -1;
    Progresso.Progress := 0;

    for qtd := 0 to vArquivo.Count - 1 do
    begin
      vLinha.DelimitedText := AnsiUpperCase(vArquivo[qtd]);

      if vLinha[0] = 'NATUREZA' then // pular o cabeçalho
      begin
        Progresso.Progress := Progresso.Progress + 1;
        Continue;
      end;

      vPessoa := TClassePessoa.Create;

      vPessoa.IdPessoa     := 0;
      vPessoa.Natureza     := vLinha[0]; // Natureza
      vPessoa.Documento    := vLinha[1]; // Documento
      vPessoa.Primeiro     := vLinha[2]; // Primeiro Nome
      vPessoa.Segundo      := vLinha[3]; // Segundo Nome
      vPessoa.DataRegistro := StrToDate(vLinha[4]); // Data Registro
      vPessoa.CEP          := vLinha[5];

      if cboTipoBusca.ItemIndex = 1 then // pelo ViaCep
      begin
        if cboTipoImp.ItemIndex = 0 then
          vEndereco := getEnderecoJSON(vPessoa.CEP)
        else
          vEndereco := getEnderecoXML(vPessoa.CEP);

        vEndereco.Text := AnsiUpperCase(vEndereco.Text);

        vPessoa.CEP          := vEndereco[1];
        vPessoa.IdEndereco   := vPessoa.searchEndereco; // IdEndereco
        if vPessoa.IdEndereco = 0 then
          vPessoa.IdEndereco := vPessoa.obtemIDEndereco;

        vPessoa.Logradouro   := vEndereco[2]; // Logradouro
        vPessoa.Bairro       := vEndereco[3]; // Bairro
        vPessoa.Cidade       := vEndereco[4]; // Cidade
        vPessoa.Estado       := vEndereco[5]; // Estado
        vPessoa.Complemento  := vEndereco[6]; // Complemento
      end
      else begin // pelo Arquivo
        vPessoa.CEP          := vLinha[5];
        vPessoa.IdEndereco   := vPessoa.searchEndereco; // IdEndereco
        if vPessoa.IdEndereco = 0 then
          vPessoa.IdEndereco := vPessoa.obtemIDEndereco;

        vPessoa.Logradouro   := vLinha[6];  // Logradouro
        vPessoa.Bairro       := vLinha[7];  // Bairro
        vPessoa.Cidade       := vLinha[8];  // Cidade
        vPessoa.Estado       := vLinha[9]; // Estado
        vPessoa.Complemento  := vLinha[10]; // Complemento
      end;

      if not vPessoa.Gravar then
      begin
        Break;
      end;

      Progresso.Progress := Progresso.Progress + 1;
    end;

    MessageDlg('Arquivo Importado com Sucesso!', mtInformation, [mbOK], 0);
  except
    on e : Exception do
    begin
      MessageDlg('Erro ao Importar o arquivo. Erro: ' + e.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure TfrmImporta.btnSairClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmImporta.cboTipoBuscaChange(Sender: TObject);
begin
  cboTipoImp.Visible := (cboTipoBusca.ItemIndex = 1);
end;

procedure TfrmImporta.btnEscolheClick(Sender: TObject);
begin
  fdo.DefaultFolder := ExtractFilePath(ParamStr(0));
  if fdo.Execute then
  begin
    edtArquivo.Text := fdo.FileName;
  end;
end;

end.
