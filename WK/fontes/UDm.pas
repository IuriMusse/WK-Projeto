unit UDm;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, UConfigAcesso, FireDAC.Comp.UI;

type
  TDmDados = class(TDataModule)
    Conexao: TFDConnection;
    FDTransaction: TFDTransaction;
    FDGUIxWaitCursor: TFDGUIxWaitCursor;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
  private
    { Private declarations }
  public
    procedure ConfigurarConexao;
  end;

var
  DmDados: TDmDados;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDmDados }

procedure TDmDados.ConfigurarConexao;
begin
  Conexao := ConfigAcesso.GetConnection;
  FDTransaction := TFDTransaction.Create(nil);
  FDTransaction.Connection := Conexao;
end;

end.

