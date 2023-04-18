unit UnitAtualizaProduto;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation, FMX.Layouts;

type
  TfrmAtualizaProd = class(TForm)
    LayoutPrincipal: TLayout;
    Layout2: TLayout;
    Label1: TLabel;
    Img_menu: TImage;
    Layout4: TLayout;
    Line2: TLine;
    Layout1: TLayout;
    Label2: TLabel;
    edtCodigoBarras: TEdit;
    Layout3: TLayout;
    Label3: TLabel;
    edtNome: TEdit;
    Layout5: TLayout;
    Label4: TLabel;
    Layout6: TLayout;
    edtQuantidade: TEdit;
    Layout8: TLayout;
    btnCadastrar: TButton;
    RoundRect2: TRoundRect;
    btnCancelar: TButton;
    RoundRect1: TRoundRect;
    procedure FormCreate(Sender: TObject);
    procedure Img_menuClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnCadastrarClick(Sender: TObject);
  private
    { Private declarations }
  public
    cod,descrcao,barras,saldo : String;
    { Public declarations }
  end;

var
  frmAtualizaProd: TfrmAtualizaProd;

implementation

{$R *.fmx}

uses UnitDm, FireDAC.Comp.Client, UnitInicial, ClasseInserir, UnitConferencia;

procedure TfrmAtualizaProd.btnCadastrarClick(Sender: TObject);
VAR
  erro : string;
  cad : TClasseInserir;
begin
   cad := TClasseInserir.Create(dm.conn);

   if (trim(edtCodigoBarras.Text) = '') or (trim(edtNome.Text) = '') then
   begin
     ShowMessage('Preencha os campos vazios.');
     exit;
   end
   else
   begin
     cad.ID := frmInicial.ID_COD;
     cad.DESC := edtNome.Text;
     cad.EAN := edtCodigoBarras.Text;
   end;


   if edtQuantidade.Text = '' then
   begin
     cad.QND := 0;
   end
   else
   begin
     cad.QND := StrToFloat(edtQuantidade.Text);
   end;

   cad.cadastro := '0';
   cad.atualizar(erro);

   if erro = '' then
   begin
    ShowMessage('Atualizado com Sucesso!');
    dm.listarBanco(frmConferencia.lvBancoProduto);
    frmInicial.atualizaLBL;
    frmInicial.edtBarras.Text := '';
    frmInicial.edtQuantidadeinicial.Text := '0';
    close;
   end
   else
   begin
     ShowMessage('Erro no cadastro!');
   end;

end;

procedure TfrmAtualizaProd.btnCancelarClick(Sender: TObject);
begin
close;
end;

procedure TfrmAtualizaProd.FormCreate(Sender: TObject);
var
  qry :TFdquery;
begin
  cod := frmInicial.ID_COD;
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := dm.conn;

    qry.SQL.Clear;
    qry.SQL.Add('SELECT * FROM PRODUTOS WHERE ID= :ID');
    qry.ParamByName('ID').AsString := cod;
    qry.Open;

    edtNome.Text := qry.FieldByName('DESCRICAO').AsString;
    edtCodigoBarras.Text := qry.FieldByName('EAN').AsString;
    edtQuantidade.Text := qry.FieldByName('QUANTIDADE').AsString;

  finally
    qry.DisposeOf;
  end;


end;

procedure TfrmAtualizaProd.Img_menuClick(Sender: TObject);
begin
close;
end;

end.


uses ClasseInserir;


uses UnitDm;