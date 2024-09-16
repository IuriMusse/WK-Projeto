unit UConfigAcesso;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Comp.Client, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.Comp.DataSet, FireDAC.Phys.MySQL, FireDAC.Phys.MySQLDef,
  System.IniFiles, System.Types, System.IOUtils;

type
  TConfigAcesso = class
  private
    FConnection: TFDConnection;
    procedure LoadConfig;
  public
    constructor Create;
    destructor Destroy; override;
    function GetConnection: TFDConnection;
  end;

var
  ConfigAcesso: TConfigAcesso;

implementation

{ TConfigAcesso }

constructor TConfigAcesso.Create;
begin
  inherited Create;
  FConnection := TFDConnection.Create(nil);
  FConnection.DriverName := 'MySQL';
  LoadConfig;
end;

destructor TConfigAcesso.Destroy;
begin
  FConnection.Free;
  inherited Destroy;
end;

procedure TConfigAcesso.LoadConfig;
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(TPath.Combine(ExtractFilePath(ParamStr(0)), 'Config.ini'));
  try
    FConnection.Params.Clear;
    FConnection.Params.DriverID := 'MySQL';
    FConnection.Params.Database := IniFile.ReadString('Database', 'Database', '');
    FConnection.Params.UserName := IniFile.ReadString('Database', 'UserName', '');
    FConnection.Params.Password := IniFile.ReadString('Database', 'Password', '');
    FConnection.Params.Add('Server=' + IniFile.ReadString('Database', 'Server', 'localhost'));
    FConnection.Params.Add('Port=' + IniFile.ReadString('Database', 'Port', '3306')); // MySQL default port
    FConnection.Params.Add('DriverID=MySQL');
    FConnection.Connected := True;
  finally
    IniFile.Free;
  end;
end;

function TConfigAcesso.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;

initialization
  ConfigAcesso := TConfigAcesso.Create;

finalization
  ConfigAcesso.Free;

end.

