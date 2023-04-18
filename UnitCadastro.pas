unit UnitCadastro;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Objects, FMX.StdCtrls, FMX.ListView, FMX.Controls.Presentation,
  FMX.Layouts, FMX.Edit;

type
  TfrmCadastro = class(TForm)
    LayoutPrincipal: TLayout;
    Layout2: TLayout;
    Label1: TLabel;
    Img_menu: TImage;
    Layout4: TLayout;
    Line2: TLine;
    Layout8: TLayout;
    btnCadastrar: TButton;
    RoundRect2: TRoundRect;
    Layout1: TLayout;
    Label2: TLabel;
    edtCodigoBarras: TEdit;
    Layout3: TLayout;
    Label3: TLabel;
    edtNome: TEdit;
    Layout5: TLayout;
    Label4: TLabel;
    edtQuantidade: TEdit;
    Layout6: TLayout;
    btnCancelar: TButton;
    RoundRect1: TRoundRect;
    procedure Img_menuClick(Sender: TObject);
    procedure RoundRect1Click(Sender: TObject);
    procedure btnCadastrarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    { Private declarations }
  public
    barras, cad, qnd : string;
    { Public declarations }
  end;

var
  frmCadastro: TfrmCadastro;

implementation

{$R *.fmx}

uses UnitDm, ClasseInserir, u99Permissions, UnitCamera, UnitInicial;

procedure TfrmCadastro.btnCadastrarClick(Sender: TObject);
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
     cad.ID := edtCodigoBarras.Text;
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
   cad.cadastrar(erro);

   if erro = '' then
   begin
    ShowMessage('Cadastrado com Sucesso!');
    dm.listarBanco(frmInicial.lvBancoProduto);
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

procedure TfrmCadastro.btnCancelarClick(Sender: TObject);
begin
    frmInicial.edtBarras.Text := '';
    frmInicial.edtQuantidadeinicial.Text := '0';
close;
end;

procedure TfrmCadastro.FormShow(Sender: TObject);
begin
if cad = 'I' then
begin
edtCodigoBarras.Text := frmInicial.codigo;
edtQuantidade.Text := qnd;
end;

end;

procedure TfrmCadastro.Img_menuClick(Sender: TObject);
begin
    frmInicial.edtBarras.Text := '';
    frmInicial.edtQuantidadeinicial.Text := '0';
close;
end;

procedure TfrmCadastro.RoundRect1Click(Sender: TObject);
begin
close;
end;

end.
