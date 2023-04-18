unit UnitConferencia;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

type
  TfrmConferencia = class(TForm)
    LayoutPrincipal: TLayout;
    Layout2: TLayout;
    Label1: TLabel;
    Img_menu: TImage;
    Layout5: TLayout;
    Label2: TLabel;
    Layout8: TLayout;
    lvBancoProduto: TListView;
    lblPendentes: TLabel;
    lblProdutos: TLabel;
    ProdTodos: TLayout;
    ProdPendentes: TLayout;
    StyleBook1: TStyleBook;
    procedure FormCreate(Sender: TObject);
    procedure Img_menuClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ProdPendentesClick(Sender: TObject);
    procedure ProdTodosClick(Sender: TObject);
    procedure lvBancoProdutoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private
    procedure listConferencia;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConferencia: TfrmConferencia;

implementation

{$R *.fmx}

uses ClasseInserir, u99Permissions, UnitDm, UnitInicial, FireDAC.Comp.Client,
  FMX.DialogService, UnitAtualizaProduto;

procedure TfrmConferencia.FormCreate(Sender: TObject);
var
  qry: TFDQuery;
  item : TListViewItem;
begin
try
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conn;

  qry.SQL.Clear;
  qry.SQL.Add('SELECT * FROM PRODUTOS');
  qry.Open;

  lvBancoProduto.BeginUpdate;
  lvBancoProduto.Items.Clear;

  while NOT qry.Eof do
  begin
   item := lvBancoProduto.items.Add;

   TListItemText(item.Objects.FindDrawable('txtCod')).Text := 'Cód: '+qry.FieldByName('ID').AsString;
   TListItemText(item.Objects.FindDrawable('txtNome')).Text := 'Nome: '+qry.FieldByName('DESCRICAO').AsString;
   TListItemText(item.Objects.FindDrawable('txtBarras')).Text :='Barras: '+qry.FieldByName('EAN').AsString;
   TListItemText(item.Objects.FindDrawable('txtQnt')).Text :='Qtde: ' + qry.FieldByName('QUANTIDADE').AsString;

   if qry.FieldByName('QUANTIDADE').Value > 0  then
   begin
    TListItemText(item.Objects.FindDrawable('ok')).Text := 'OK';

   end
   else
   begin
   TListItemText(item.Objects.FindDrawable('okN')).Text := 'NULL';
   end;
   qry.Next;


  end;

  lvBancoProduto.EndUpdate;

finally
  qry.DisposeOf;
end;

end;

procedure TfrmConferencia.FormShow(Sender: TObject);
var
  reg, sum : Integer;
begin
  reg := dm.ContarRegistros;
  sum := dm.pendentes;

  listConferencia;

  lblProdutos.Text := 'Produtos: ' + IntToStr(reg);
  lblPendentes.Text := 'Pendentes: ' + IntToStr(sum);

end;

procedure TfrmConferencia.Img_menuClick(Sender: TObject);
begin
frmInicial.atualizaLBL;
close;
end;

procedure TfrmConferencia.lvBancoProdutoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  TDialogService.MessageDialog('Deseja fazer a edição desse item?',
                TMsgDlgType.mtConfirmation,
                FMX.Dialogs.mbYesNo,
                TMsgDlgBtn.mbNo,
                0,
      procedure(const AResult: System.UITypes.TModalResult)
      begin
        if AResult = mrYES Then
        begin
        //listConferencia;
        frmInicial.ID_COD := AItem.TagString;
            Application.CreateForm(TfrmAtualizaProd, frmAtualizaProd);
            //Application.MainForm := frmExporta;
            frmAtualizaProd.Show;



        end
        else if AResult = mrNo Then
         exit;

      end);
end;

procedure TfrmConferencia.listConferencia;
var
  qry: TFDQuery;
  item : TListViewItem;
begin
try
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conn;

  qry.SQL.Clear;
  qry.SQL.Add('SELECT * FROM PRODUTOS');
  qry.Open;

  lvBancoProduto.BeginUpdate;
  lvBancoProduto.Items.Clear;

  while NOT qry.Eof do
  begin

   item := lvBancoProduto.items.Add;
   item.TagString := qry.FieldByName('ID').AsString;
   TListItemText(item.Objects.FindDrawable('txtCod')).Text := 'Cód: '+qry.FieldByName('ID').AsString;
   TListItemText(item.Objects.FindDrawable('txtNome')).Text := 'Nome: '+qry.FieldByName('DESCRICAO').AsString;
   TListItemText(item.Objects.FindDrawable('txtBarras')).Text :='Barras: '+qry.FieldByName('EAN').AsString;
   TListItemText(item.Objects.FindDrawable('txtQnt')).Text :='Qtde: ' + qry.FieldByName('QUANTIDADE').AsString;

   if qry.FieldByName('QUANTIDADE').Value > 0  then
   begin
    TListItemText(item.Objects.FindDrawable('ok')).Text := 'OK';

   end
   else
   begin
   TListItemText(item.Objects.FindDrawable('okN')).Text := 'NULL';
   end;
   qry.Next;


  end;

  lvBancoProduto.EndUpdate;

finally
  qry.DisposeOf;
end;


end;

procedure TfrmConferencia.ProdTodosClick(Sender: TObject);
begin
  listConferencia;
end;

procedure TfrmConferencia.ProdPendentesClick(Sender: TObject);
var
  qry: TFDQuery;
  item : TListViewItem;
begin
try
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conn;

  qry.SQL.Clear;
  qry.SQL.Add('SELECT * FROM PRODUTOS');
  qry.SQL.Add('WHERE QUANTIDADE = 0');
  qry.Open;

  lvBancoProduto.BeginUpdate;
  lvBancoProduto.Items.Clear;

  while NOT qry.Eof do
  begin
   item := lvBancoProduto.items.Add;
   item.TagString :=  qry.FieldByName('ID').AsString;

   TListItemText(item.Objects.FindDrawable('txtCod')).Text := 'Cód: '+qry.FieldByName('ID').AsString;
   TListItemText(item.Objects.FindDrawable('txtNome')).Text := 'Nome: '+qry.FieldByName('DESCRICAO').AsString;
   TListItemText(item.Objects.FindDrawable('txtBarras')).Text :='Barras: '+qry.FieldByName('EAN').AsString;
   TListItemText(item.Objects.FindDrawable('txtQnt')).Text :='Qtde: ' + qry.FieldByName('QUANTIDADE').AsString;

   if qry.FieldByName('QUANTIDADE').Value > 0  then
   begin
    TListItemText(item.Objects.FindDrawable('ok')).Text := 'OK';

   end
   else
   begin
   TListItemText(item.Objects.FindDrawable('okN')).Text := 'NULL';
   end;
   qry.Next;


  end;

  lvBancoProduto.EndUpdate;

finally
  qry.DisposeOf;
end;
end;

end.
