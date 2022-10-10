unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus,  StdCtrls, Grids;

type
  TfrmPrincipal = class(TForm)
    MainMenu1: TMainMenu;
    Cadastro1: TMenuItem;
    Importao1: TMenuItem;
    Pessoas1: TMenuItem;
    Sair1: TMenuItem;
    procedure Sair1Click(Sender: TObject);
    procedure Pessoas1Click(Sender: TObject);
    procedure Importao1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses uPessoas, uImporta;

procedure TfrmPrincipal.Importao1Click(Sender: TObject);
begin
  Application.CreateForm(TfrmImporta, frmImporta);
  try
    frmImporta.ShowModal;
  finally
    FreeAndNil(frmImporta);
  end;
end;

procedure TfrmPrincipal.Pessoas1Click(Sender: TObject);
begin
  Application.CreateForm(TFrmPessoas, frmPessoas);
  try
    frmPessoas.ShowModal;
  finally
    FreeAndNil(frmPessoas);
  end;
end;

procedure TfrmPrincipal.Sair1Click(Sender: TObject);
begin
  Close;
end;

end.
