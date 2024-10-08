unit UPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls,
  System.ImageList, Vcl.ImgList, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.Samples.Spin, Datasnap.DBClient, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,  Datasnap.Provider, Vcl.Imaging.pngimage, UPedido, UItemPedido, System.UITypes;

type
  TfrmPrincipal = class(TForm)
    shpTopo: TShape;
    spbIniciarVenda: TSpeedButton;
    spbFinalizarVenda: TSpeedButton;
    spbCancelarVenda: TSpeedButton;
    lblCodCliente: TLabel;
    lblNomeCliente: TLabel;
    shpCupom: TShape;
    shpFundo: TShape;
    lblCodProduto: TLabel;
    shpDescricaoProduto: TShape;
    lblQuantidade: TLabel;
    lblPrecoTotal: TLabel;
    lblPrecoUnitario: TLabel;
    btnAdicionarProduto: TSpeedButton;
    lblCupom: TLabel;
    lblProduto: TLabel;
    shpTotalVendas: TShape;
    lblTotalPedido: TLabel;
    edtCodCliente: TEdit;
    edtNomeCliente: TEdit;
    edtCodProduto: TEdit;
    spnQuantidade: TSpinEdit;
    edtPrecoTotalItem: TEdit;
    cdsitensVendas: TClientDataSet;
    cdsitensVendascod: TIntegerField;
    cdsitensVendasdescricao: TStringField;
    cdsitensVendasvl_item: TCurrencyField;
    cdsitensVendasTotal_Item: TCurrencyField;
    cdsitensVendasvl_unitario: TCurrencyField;
    cdsitensVendasTotal: TAggregateField;
    dsItensVendas: TDataSource;
    grdVendas: TDBGrid;
    qryProdutos: TFDQuery;
    qryProdutosCODIGO: TFDAutoIncField;
    qryProdutosDESCRICAO: TStringField;
    qryProdutosPRECO_VENDA: TBCDField;
    edtPrecoUnitario: TEdit;
    qryClientes: TFDQuery;
    qryClientesCODIGO: TFDAutoIncField;
    qryClientesNOME: TStringField;
    qryClientesCIDADE: TStringField;
    qryClientesUF: TStringField;
    qryConcluirPedido: TFDQuery;
    qryItemVenda: TFDQuery;
    cdsitensVendasqtd: TIntegerField;
    qryPedido: TFDQuery;
    lblNumPedido: TLabel;
    lblPedido: TLabel;
    qryPedidoCOUNT: TLargeintField;
    lblTotalVendas: TLabel;
    imgProduto: TImage;
    lblInstrucao: TLabel;
    lblInicio: TLabel;
    lblStatusCaixa: TLabel;
    spbCarregar: TSpeedButton;
    edtNumeroPedido: TEdit;
    lblNumeroPedido: TLabel;
    FDQuery: TFDQuery;

    procedure edtCodProdutoChange(Sender: TObject);
    procedure btnAdicionarProdutoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure spnQuantidadeChange(Sender: TObject);
    procedure edtCodClienteChange(Sender: TObject);
    procedure spbFinalizarVendaClick(Sender: TObject);
    procedure spbIniciarVendaClick(Sender: TObject);
    procedure spbCancelarVendaClick(Sender: TObject);
    procedure grdVendasKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure grdVendasColEnter(Sender: TObject);
    procedure grdVendasKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure spbCarregarClick(Sender: TObject);

  private
    { Private declarations }
    procedure DesativaCamposVenda;
    procedure AtivaCamposVenda;
    procedure LimpaCamposVenda;
    procedure PreencheCamposDBGrid;
    procedure AtualizaTotalItem;
    procedure LimpaDadosItensVenda;
    procedure GeraCodigoPedido;
    function ValidaCampos: Boolean;
    function IncluiItemVenda(ItemPedido : TItemPedido): Boolean;

  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;
  Pedido : TPedido;

implementation
uses
  UDm;

{$R *.dfm}

procedure TfrmPrincipal.spbFinalizarVendaClick(Sender: TObject);
var
  itemPedido: TItemPedido;
begin
  if grdVendas.DataSource.DataSet.RecordCount <> 0 then
  begin
    try
      qryConcluirPedido.Close;
      qryConcluirPedido.ParamByName('1').Value := Pedido.NUM_PEDIDO;
      qryConcluirPedido.ParamByName('2').Value := edtCodCliente.Text;
      qryConcluirPedido.ParamByName('3').Value := cdsitensVendasTotal.Value;
      qryConcluirPedido.ExecSQL;

      cdsitensVendas.First;
      while not cdsitensVendas.Eof do
      begin
        itemPedido := TItemPedido.Create;
        try
          itemPedido.NUM_PEDIDO := Pedido.NUM_PEDIDO;
          itemPedido.CODIGO_PRODUTO := cdsitensVendascod.Value;
          itemPedido.QUANTIDADE := cdsitensVendasqtd.Value;
          itemPedido.VLR_UNITARIO := cdsitensVendasvl_item.Value;
          itemPedido.VLR_TOTAL := cdsitensVendasTotal_Item.Value;
          IncluiItemVenda(itemPedido);
        finally
          itemPedido.Free;
        end;
        cdsitensVendas.Next;
      end;

      LimpaDadosItensVenda;
      DesativaCamposVenda;
      lblStatusCaixa.Caption := 'CAIXA LIVRE';
      lblStatusCaixa.Font.Color := clGreen;
      lblPedido.Caption := '00000';
      edtCodCliente.Clear;
      edtNomeCliente.Clear;
      LimpaCamposVenda;
      Application.MessageBox('Venda conclu�da com sucesso!', 'Sucesso', MB_OK + MB_ICONINFORMATION);
    except
      on E: Exception do
      begin
        Application.MessageBox(PChar('Erro ao concluir a venda: ' + E.Message), 'Erro', MB_OK + MB_ICONERROR);
      end;
    end;
  end
  else
  begin
    Application.MessageBox('Nenhuma venda para processar!', 'Aviso', MB_OK + MB_ICONWARNING);
  end;

  Pedido.Free;
  LimpaCamposVenda;
  lblTotalPedido.Caption := '0,00';
end;


function TfrmPrincipal.IncluiItemVenda(ItemPedido : TItemPedido): Boolean;
begin
  try
    with qryItemVenda do
    begin
      Close;
      ParamByName('1').Value := ItemPedido.NUM_PEDIDO;
      ParamByName('2').Value := ItemPedido.CODIGO_PRODUTO;
      ParamByName('3').Value := ItemPedido.QUANTIDADE;
      ParamByName('4').Value := ItemPedido.VLR_UNITARIO;
      ParamByName('5').Value := ItemPedido.VLR_TOTAL;
      ExecSQL;
    end;
    Result := true;
  except
    on e: exception do
    begin
      Result := false;
    end;
  end;
end;

procedure TfrmPrincipal.spbIniciarVendaClick(Sender: TObject);
begin
  lblStatusCaixa.Caption := 'OCUPADO';
  lblStatusCaixa.Font.Color := $004949FC;

  if Assigned(dsItensVendas) and Assigned(dsItensVendas.DataSet) then
  begin
    if dsItensVendas.DataSet.Active then
      dsItensVendas.DataSet.Close;

    dsItensVendas.DataSet.Open;
  end;

  spbIniciarVenda.Enabled := False;
  AtivaCamposVenda;

  if Assigned(Pedido) then
    FreeAndNil(Pedido);

  Pedido := TPedido.Create;
  try
    GeraCodigoPedido;
  except
    on E: Exception do
      Application.MessageBox(PChar('Erro ao gerar c�digo do pedido: ' + E.Message), 'Erro', MB_OK + MB_ICONERROR);
  end;
end;

procedure TfrmPrincipal.btnAdicionarProdutoClick(Sender: TObject);
begin
  try
    if ValidaCampos then
    begin
      cdsitensVendas.Append;
      cdsitensVendascod.Value := qryProdutosCODIGO.Value;
      cdsitensVendasdescricao.Value := qryProdutosDESCRICAO.Value;
      cdsitensVendasqtd.Value := spnQuantidade.Value;
      cdsitensVendasvl_item.Value := qryProdutosPRECO_VENDA.Value;
      cdsitensVendasTotal_Item.Value := qryProdutosPRECO_VENDA.Value * spnQuantidade.Value;
      cdsitensVendas.Post;
      lblTotalPedido.Caption := FormatFloat('##,###,##0.00', cdsitensVendasTotal.Value);
      edtCodProduto.SetFocus;
    end
    else
    begin
      Application.MessageBox('Preencha os dados do produto!', 'Campos inv�lidos', MB_OK + MB_ICONERROR);
    end;
  finally
    LimpaCamposVenda;
    imgProduto.Visible := False;
  end;
end;

procedure TfrmPrincipal.spbCancelarVendaClick(Sender: TObject);
begin
  if MessageDlg('Deseja cancelar a venda?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    Pedido.Free;
    LimpaDadosItensVenda;
    spbFinalizarVenda.Enabled := False;
    lblStatusCaixa.Caption := 'CAIXA LIVRE';
    lblStatusCaixa.Font.Color := clGreen;
    lblPedido.Caption := '00000';
    edtCodCliente.Clear;
    edtNomeCliente.Clear;
    LimpaCamposVenda;
    lblTotalPedido.Caption := '0,00';
    DesativaCamposVenda;
  end;
end;

procedure TfrmPrincipal.spbCarregarClick(Sender: TObject);
var
  NumeroPedido: Integer;
  Query: TFDQuery;
begin
  try
    if TryStrToInt(edtNumeroPedido.Text, NumeroPedido) then
    begin
      Query := TFDQuery.Create(nil);
      try
        Query.Connection := DmDados.Conexao;
        Query.SQL.Text := 'SELECT pedidos_produtos.*, produtos.descricao ' +
                          'FROM pedidos_produtos ' +
                          'INNER JOIN produtos ON produtos.codigo = pedidos_produtos.codigo_produto ' +
                          'INNER JOIN pedidos_dados_gerais ON pedidos_dados_gerais.num_pedido = pedidos_produtos.num_pedido ' +
                          'WHERE pedidos_produtos.Num_Pedido = :NumeroPedido';
        Query.ParamByName('NumeroPedido').AsInteger := NumeroPedido;
        Query.Open;
        cdsitensVendas.EmptyDataSet;
        while not Query.Eof do
        begin
          cdsitensVendas.Append;
          cdsitensVendascod.Value := Query.FieldByName('codigo_produto').AsInteger;
          cdsitensVendasdescricao.Value := Query.FieldByName('descricao').AsString;
          cdsitensVendasqtd.Value := Query.FieldByName('Quantidade').AsInteger;
          cdsitensVendasvl_item.Value := Query.FieldByName('Vlr_Unitario').AsCurrency;
          cdsitensVendasTotal_Item.Value := Query.FieldByName('Vlr_Total').AsCurrency;
          cdsitensVendas.Post;
          Query.Next;
        end;
        lblTotalPedido.Caption := FormatFloat('##,###,##0.00', cdsitensVendasTotal.Value);
      finally
        Query.Free;
      end;
    end
    else
    begin
      Application.MessageBox('N�mero de pedido inv�lido. Por favor, insira um n�mero v�lido.', 'Aviso', MB_OK + MB_ICONWARNING);
    end;
  except
    on E: Exception do
      Application.MessageBox(PChar('Erro ao carregar dados: ' + E.Message), 'Erro', MB_OK + MB_ICONERROR);
  end;
end;

procedure TfrmPrincipal.edtCodClienteChange(Sender: TObject);
begin
  if edtCodCliente.Text <> '' then
  begin
    try
      with qryClientes do
      begin
        Close;
        ParamByName('cod').Value := edtCodCliente.Text;
        Open;
        FetchAll;
      end;
      if qryClientes.RecordCount > 0 then
      begin
        edtNomeCliente.Text := string(qryClientesNOME.Value);
      end
      else
      begin
        edtNomeCliente.Text := 'CLIENTE N�O CADASTRADO...';
      end;
    except
      on E: Exception do
      begin
        Application.MessageBox(PChar('Erro ao buscar cliente: ' + E.Message), 'Erro', MB_OK + MB_ICONERROR);
        edtNomeCliente.Text := '';
      end;
    end;
  end
  else
  begin
    LimpaCamposVenda;
  end;
end;

procedure TfrmPrincipal.edtCodProdutoChange(Sender: TObject);
begin
  if edtCodProduto.Text <> '' then
  begin
    with qryProdutos do
    begin
      Close;
      ParamByName('cod').Value := edtCodProduto.Text;
      Open;
    end;

    if not qryProdutos.IsEmpty then
    begin
      spnQuantidade.Value := 0;
      lblProduto.Caption := qryProdutosDESCRICAO.AsString;
      imgProduto.Visible := True;
      edtPrecoUnitario.Text := FormatFloat('##,###,##0.00', qryProdutosPRECO_VENDA.AsFloat);
      AtualizaTotalItem;
    end
    else
    begin
      LimpaCamposVenda;
      lblProduto.Caption := 'PRODUTO N�O ENCONTRADO...';
    end;
  end
  else
  begin
    LimpaCamposVenda;
  end;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  cdsitensVendas.CreateDataSet;
  DesativaCamposVenda;
  lblInicio.Caption := Format('Hoje � %s e s�o %s', [DateToStr(Date), TimeToStr(Time)]);
end;

procedure TfrmPrincipal.GeraCodigoPedido;
begin
  try
    with qryPedido do
    begin
      Close;
      Open;

      if IsEmpty then
        Pedido := TPedido.Create
      else
      begin
        Pedido := TPedido.Create;
        Pedido.NUM_PEDIDO := qryPedidoCOUNT.Value + 1;
      end;

      lblPedido.Caption := Format('%5.5d', [Pedido.NUM_PEDIDO]);
    end;
  except
    on E: Exception do
    begin
      Application.MessageBox(PChar('Erro ao gerar c�digo do pedido: ' + E.Message), 'Erro', MB_OK + MB_ICONERROR);
      if Assigned(Pedido) then
        FreeAndNil(Pedido);
    end;
  end;
end;

procedure TfrmPrincipal.grdVendasColEnter(Sender: TObject);
begin
  PreencheCamposDBGrid;
end;

procedure TfrmPrincipal.grdVendasKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = VK_DELETE) and (cdsitensVendas.RecordCount > 0) then
  begin
    if cdsitensVendas.State in [dsBrowse] then
    begin
      if MessageDlg('Deseja realmente excluir o item selecionado?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        try
          cdsitensVendas.Delete;
        except
          on E: Exception do
          begin
            Application.MessageBox(PChar('Erro ao excluir item: ' + E.Message), 'Erro', MB_OK + MB_ICONERROR);
            Exit;
          end;
        end;

        lblTotalPedido.Caption := FormatFloat('##,###,##0.00', cdsitensVendasTotal.Value);

        LimpaCamposVenda;
      end;
    end;
  end;
end;

procedure TfrmPrincipal.grdVendasKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  PreencheCamposDBGrid;
end;

procedure TfrmPrincipal.AtivaCamposVenda;
begin
  edtCodCliente.Enabled := True;
  edtNomeCliente.Enabled := True;
  edtCodProduto.Enabled := True;
  edtPrecoUnitario.Enabled := True;
  edtPrecoTotalItem.Enabled := True;
  spnQuantidade.Enabled := True;
  btnAdicionarProduto.Enabled := True;
  spbCancelarVenda.Enabled := True;
  spbFinalizarVenda.Enabled := True;
  spbIniciarVenda.Enabled := False;
  spbCarregar.Enabled := True;
end;

procedure TfrmPrincipal.DesativaCamposVenda;
begin
  LimpaCamposVenda;
  edtCodProduto.Enabled := False;
  edtCodCliente.Enabled := False;
  edtNomeCliente.Enabled := False;
  edtPrecoUnitario.Enabled := False;
  edtPrecoTotalItem.Enabled := False;
  spnQuantidade.Enabled := False;
  btnAdicionarProduto.Enabled := False;
  spbFinalizarVenda.Enabled := False;
  spbCancelarVenda.Enabled := False;
  spbIniciarVenda.Enabled := True;
  spbCarregar.Enabled := False;
end;

procedure TfrmPrincipal.spnQuantidadeChange(Sender: TObject);
begin
  AtualizaTotalItem;
end;

function TfrmPrincipal.ValidaCampos: Boolean;
begin
  Result := (edtCodProduto.Text <> '') and
            (spnQuantidade.Value > 0) and
            (edtPrecoUnitario.Text <> '');
  if not Result then
  begin
    Application.MessageBox('Por favor, preencha todos os campos obrigat�rios.', 'Campos inv�lidos', MB_OK + MB_ICONWARNING);
  end;
end;

procedure TfrmPrincipal.LimpaCamposVenda;
begin
  spnQuantidade.Value := 0;
  edtCodProduto.Text := '';
  edtPrecoUnitario.Clear;
  edtPrecoTotalItem.Clear;
  edtNumeroPedido.Text := '';
end;

procedure TfrmPrincipal.LimpaDadosItensVenda;
begin
    with cdsitensVendas do
    begin
      Open;
      EmptyDataSet;
      Close;
    end;
    cdsitensVendas.Open;
end;

procedure TfrmPrincipal.PreencheCamposDBGrid;
begin
   edtCodProduto.Text := cdsitensVendascod.AsString;
   spnQuantidade.Value := cdsitensVendasqtd.Value;
   AtualizaTotalItem;
end;

procedure TfrmPrincipal.AtualizaTotalItem;
var
  PrecoUnitario: Double;
begin
  if (spnQuantidade.Value > 0) and
     (TryStrToFloat(edtPrecoUnitario.Text, PrecoUnitario)) and
     (PrecoUnitario > 0) then
  begin
    try
      edtPrecoTotalItem.Text := FormatFloat('##,###,##0.00', PrecoUnitario * spnQuantidade.Value);
    except
      on E: Exception do
        Application.MessageBox(PChar('Erro ao calcular o total do item: ' + E.Message), 'Erro', MB_OK + MB_ICONERROR);
    end;
  end
  else
  begin
    edtPrecoTotalItem.Text := '0.00';
  end;
end;

end.
