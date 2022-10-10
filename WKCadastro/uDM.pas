unit uDM;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.PG,
  FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TDM = class(TDataModule)
    fdConexao: TFDConnection;
    fdTransacao: TFDTransaction;
    fd_qryListaEnd: TFDQuery;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    dsListaEnd: TDataSource;
    fd_qryListaPes: TFDQuery;
    dsListaPes: TDataSource;
    fd_qryUpdate: TFDQuery;
    fd_qryListaPesidpessoa: TLargeintField;
    fd_qryListaPesflnatureza: TSmallintField;
    fd_qryListaPesdsdocumento: TWideStringField;
    fd_qryListaPesnmprimeiro: TWideStringField;
    fd_qryListaPesnmsegundo: TWideStringField;
    fd_qryListaPesdtregistro: TDateField;
    fd_qryListaPesdscep: TWideStringField;
    fd_qryListaPesidendereco: TLargeintField;
    fd_qryListaPesdsuf: TWideStringField;
    fd_qryListaPesnmcidade: TWideStringField;
    fd_qryListaPesnmbairro: TWideStringField;
    fd_qryListaPesnmlogradouro: TWideStringField;
    fd_qryListaPesdscomplemento: TWideStringField;
    fd_qryAux: TFDQuery;
    procedure fd_qryListaPesflnaturezaGetText(Sender: TField; var Text: string; DisplayText: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDM.fd_qryListaPesflnaturezaGetText(Sender: TField; var Text: string; DisplayText: Boolean);
begin
  if Sender.Value = '0' then
    Text := 'Física'
  else if Sender.Value = '1' then
    Text := 'Juridica';
end;

end.
