unit UnitInicial;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Layouts,
  System.Rtti, FMX.Grid.Style, FMX.Controls.Presentation, FMX.ScrollBox, System.JSON,
  FMX.Grid, FMX.StdCtrls, FMX.Memo.Types, FMX.Memo,
  u99Permissions, UnitCamera, UnitPrincipal, FMX.Edit, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, System.Generics.Collections,
  FMX.MediaLibrary.Actions, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.Objects, FMX.WebBrowser, FMX.Ani, FMX.Menus, FMX.MultiView
  {$IFDEF ANDROID}
   ,System.Math,Androidapi.Helpers,Androidapi.JNI.GraphicsContentViewText

 {$ENDIF}

  ;


type
  TfrmInicial = class(TForm)
    RectMenu: TRectangle;
    AnimationMenu: TFloatAnimation;
    Image5: TImage;
    layCentral: TLayout;
    LayConferi: TLayout;
    Label5: TLabel;
    lblNova: TLabel;
    lblListar: TLabel;
    layExpor: TLayout;
    Label6: TLabel;
    LayImport: TLayout;
    Label4: TLabel;
    layConfig: TLayout;
    Label7: TLabel;
    rectMenuLogoff: TLayout;
    Label11: TLabel;
    LayProd: TLayout;
    Label8: TLabel;
    lblNovoProd: TLabel;
    lblListarProd: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    LayoutPrincipal: TLayout;
    Layout2: TLayout;
    Label1: TLabel;
    Img_menu: TImage;
    Layout3: TLayout;
    Layout4: TLayout;
    lvBancoProduto: TListView;
    Line2: TLine;
    Layout5: TLayout;
    Label2: TLabel;
    Layout8: TLayout;
    edtBarras: TEdit;
    Label12: TLabel;
    Label13: TLabel;
    Layout1: TLayout;
    Layout9: TLayout;
    edtQuantidadeinicial: TEdit;
    BtnMais: TImage;
    btnMenos: TImage;
    lblProdutos: TLabel;
    lblQuantidades: TLabel;
    btnScanear: TImage;
    Layout6: TLayout;
    btnPesquisa: TImage;
    Layout7: TLayout;
    layNovaConf: TLayout;
    layListarConf: TLayout;
    layNovoProd: TLayout;
    layListarProd: TLayout;
    Layout12: TLayout;
    StyleBook1: TStyleBook;
    MultiView1: TMultiView;
    procedure LayImportClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Img_menuClick(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure AnimationMenuFinish(Sender: TObject);
    procedure AnimationMenuProcess(Sender: TObject);
    procedure Label11Click(Sender: TObject);
    procedure layExporClick(Sender: TObject);
    procedure rectMenuLogoffClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnScanearClick(Sender: TObject);
    procedure BtnMaisClick(Sender: TObject);
    procedure btnMenosClick(Sender: TObject);
    procedure layListarConfClick(Sender: TObject);
    procedure layNovaConfClick(Sender: TObject);
    procedure layNovoProdClick(Sender: TObject);
    procedure layListarProdClick(Sender: TObject);
    procedure btnPesquisaClick(Sender: TObject);
    procedure layConfigClick(Sender: TObject);
    procedure lvBancoProdutoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
  private

    { Private declarations }
  public

  permissao: T99Permissions;
   codigo : string;
    ID_COD : String;
   procedure atualizaLBL;


    { Public declarations }
  end;

var
  frmInicial: TfrmInicial;

implementation

{$R *.fmx}

uses UnitImporta, UnitDm, UnitExporta, FireDAC.Comp.Client, FMX.Dialogs,
  FMX.DialogService, UnitCadastro, ClasseInserir, UnitConferencia,
  UnitConfiguracoes, UnitAtualizaProduto;

procedure TfrmInicial.AnimationMenuFinish(Sender: TObject);
begin
LayoutPrincipal.Enabled := AnimationMenu.Inverse;
AnimationMenu.Inverse := NOT AnimationMenu.Inverse;
end;

procedure TfrmInicial.AnimationMenuProcess(Sender: TObject);
begin
LayoutPrincipal.Margins.Right := -225 - RectMenu.Margins.Left;
//LayoutPrincipal.Margins.Right := -200;
end;

procedure TfrmInicial.atualizaLBL;
begin
lblProdutos.Text := 'Produtos: '+ IntToStr(dm.ContarRegistros);
lblQuantidades.Text := 'Quantidades: ' +IntToStr(dm.SomarQuantidades);

end;

procedure TfrmInicial.BtnMaisClick(Sender: TObject);
var
  num : Double;
begin
  num := StrToFloat(edtQuantidadeinicial.Text) + 1;
  edtQuantidadeinicial.Text := FloatToStr(num);
end;

procedure TfrmInicial.btnMenosClick(Sender: TObject);
var
  num : Double;
begin
 if StrToFloat(edtQuantidadeinicial.Text) > 0 then
 begin
  num := StrToFloat(edtQuantidadeinicial.Text) - 1;
  edtQuantidadeinicial.Text := FloatToStr(num);
 end
 else
 begin
   ShowMessage('Número negativo não é permitido.');
 end;

end;

procedure TfrmInicial.btnPesquisaClick(Sender: TObject);
var
  saldo : double;
  cod : string;
  qry : TFDQuery;

begin

if Trim(edtBarras.Text) = '' then
begin
  ShowMessage('Necessário algum valor para a pesquisa.');
  edtBarras.Text:= '';
  edtBarras.SetFocus;
  exit;
end;

 if edtQuantidadeinicial.Text = '0' then
 begin
   ShowMessage('É necessário informar uma quantidade positiva');
   edtQuantidadeinicial.SetFocus;
   exit;
 end;

 try
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conn;
  qry.SQL.Clear;
  qry.SQL.Add('SELECT * FROM PRODUTOS WHERE ID = :ID OR EAN = :EAN');
  QRY.ParamByName('ID').AsString := edtBarras.Text;
  QRY.ParamByName('EAN').AsString := edtBarras.Text;
  qry.Open;

  if not qry.Eof then
  begin
   saldo := StrToFloat(edtQuantidadeinicial.Text) + qry.FieldByName('QUANTIDADE').AsFloat;

    dm.AtualizaBanco(edtBarras.Text, FloatToStr(saldo));
    dm.listarBanco(lvBancoProduto);
    edtBarras.Text := '';
    edtQuantidadeinicial.Text := '0';
  end
  else
  begin
     TDialogService.MessageDialog('Produto '+ codigo +' não localizado, deseja Cadastrar?',
                TMsgDlgType.mtConfirmation,
                FMX.Dialogs.mbYesNo,
                TMsgDlgBtn.mbNo,
                0,
      procedure(const AResult: System.UITypes.TModalResult)
      begin
        if AResult = mrYES Then
        begin
          //ShowMessage('Yes was selected');
            Application.CreateForm(TfrmCadastro, frmCadastro);
            frmCadastro.cad := 'I';
            codigo := edtBarras.Text;
            frmCadastro.qnd := edtQuantidadeinicial.Text;
            frmCadastro.Show;


        end
        else if AResult = mrNo Then
         // ShowMessage('No was selected');
         edtBarras.Text := '';
         edtQuantidadeinicial.Text := '0';
         exit;

      end);
   end;


 finally
   qry.DisposeOf;
 end;

end;

procedure TfrmInicial.btnScanearClick(Sender: TObject);
var
 saldo  : String;
  quant, quantTela : Double;
  qry : TFDQuery;
begin
  quantTela := StrToFloat(edtQuantidadeinicial.Text);
{$IFDEF MSWINDOWS}
   codigo := '7898232031267';

  if codigo = '' then
 begin
 ShowMessage('Código Vazio');
   exit;
 end;

   if dm.pesquisaBanco(codigo) = true then
   begin
    try
      qry := TFDQuery.Create(nil);
      qry.Connection := dm.conn;
      qry.SQL.Add('SELECT * FROM PRODUTOS WHERE ID = :COD OR EAN = :COD');
      qry.ParamByName('COD').AsString := codigo;
      qry.Open;

      if quantTela = 0 then
      begin
      quant := (qry.FieldByName('quantidade').AsFloat) + 1;
      saldo := FloatToStr(quant) ;
      end
      else
      begin
      quant := (qry.FieldByName('quantidade').AsFloat) + quantTela;
      saldo := FloatToStr(quant) ;
      end;
      dm.AtualizaBanco(codigo,saldo);
      dm.listarBanco(lvBancoProduto);


    finally
     qry.DisposeOf;

    end;



   end
   else
   begin
    TDialogService.MessageDialog('Produto não localizado, deseja Cadastrar?',
                TMsgDlgType.mtConfirmation,
                FMX.Dialogs.mbYesNo,
                TMsgDlgBtn.mbNo,
                0,
      procedure(const AResult: System.UITypes.TModalResult)
      begin
        if AResult = mrYES Then
        begin
          //ShowMessage('Yes was selected');
            Application.CreateForm(TfrmCadastro, frmCadastro);
            frmCadastro.cad := 'I';
            frmCadastro.Show;



        end
        else if AResult = mrNo Then
         // ShowMessage('No was selected');
         exit;

      end);
   end;


 {$ELSE}


  if NOT permissao.VerifyCameraAccess then
        permissao.Camera(nil, nil)
  else
  begin
        FrmCamera.ShowModal(procedure(ModalResult: TModalResult)
        begin
          codigo := FrmCamera.codigo;

           if codigo = '' then
           begin
             exit;
           end;

      if dm.pesquisaBanco(codigo) = true then
   begin
    try
      qry := TFDQuery.Create(nil);
      qry.Connection := dm.conn;
      qry.SQL.Add('SELECT * FROM PRODUTOS WHERE ID = :COD OR EAN = :COD');
      qry.ParamByName('COD').AsString := codigo;
      qry.Open;

      if quantTela = 0 then
      begin
      quant := (qry.FieldByName('quantidade').AsFloat) + 1;
      saldo := FloatToStr(quant) ;
      end
      else
      begin
      quant := (qry.FieldByName('quantidade').AsFloat) + quantTela;
      saldo := FloatToStr(quant) ;
      end;
      edtQuantidadeinicial.Text := '0';
      dm.AtualizaBanco(codigo,saldo);
      dm.listarBanco(lvBancoProduto);
      atualizaLBL;


    finally
     qry.DisposeOf;

    end;



   end
   else
   begin
    TDialogService.MessageDialog('Produto '+ codigo +' não localizado, deseja Cadastrar?',
                TMsgDlgType.mtConfirmation,
                FMX.Dialogs.mbYesNo,
                TMsgDlgBtn.mbNo,
                0,
      procedure(const AResult: System.UITypes.TModalResult)
      begin
        if AResult = mrYES Then
        begin
          //ShowMessage('Yes was selected');
            Application.CreateForm(TfrmCadastro, frmCadastro);
            frmCadastro.cad := 'I';
            frmCadastro.Show;


        end
        else if AResult = mrNo Then
         // ShowMessage('No was selected');
         exit;

      end);
   end;
           //end;


        end);
    end;

 {$ENDIF}

end;

procedure TfrmInicial.FormCreate(Sender: TObject);
begin
  permissao := T99Permissions.Create;
  RectMenu.Margins.Left := -225;
  RectMenu.Align := TAlignLayout.Left;
  RectMenu.Visible := true;

end;

procedure TfrmInicial.FormDestroy(Sender: TObject);
begin
permissao.DisposeOf;
end;

procedure TfrmInicial.FormShow(Sender: TObject);
var
qry : TFDQuery;
begin

dm.listarBanco(lvBancoProduto);
atualizaLBL;
end;

procedure TfrmInicial.Image5Click(Sender: TObject);
begin
 AnimationMenu.Start;
end;

procedure TfrmInicial.Img_menuClick(Sender: TObject);
begin
 AnimationMenu.Start;
end;

procedure TfrmInicial.Label11Click(Sender: TObject);
begin
Close;
end;

procedure TfrmInicial.layConfigClick(Sender: TObject);
begin
    Application.CreateForm(TfrmConfig, frmConfig);
    frmConfig.Show;
    AnimationMenu.Start;
    //close;
end;

procedure TfrmInicial.layExporClick(Sender: TObject);
begin
     //if NOT Assigned(TfrmImporta) then
    Application.CreateForm(TfrmExporta, frmExporta);
    Application.MainForm := frmExporta;
    frmExporta.Show;
    close;
end;

procedure TfrmInicial.LayImportClick(Sender: TObject);
begin
  //fdsa
 // if NOT Assigned(TfrmImporta) then
    Application.CreateForm(TfrmImporta, frmImporta);
    Application.MainForm := frmImporta;
    frmImporta.Show;
    close;

end;

procedure TfrmInicial.layListarConfClick(Sender: TObject);
begin


  Application.CreateForm(TfrmConferencia, frmConferencia);
    //Application.MainForm := frmExporta;
   AnimationMenu.Start;
   frmConferencia.Show;
end;

procedure TfrmInicial.layListarProdClick(Sender: TObject);
begin

dm.listarBanco(lvBancoProduto);
AnimationMenu.Start;


end;

procedure TfrmInicial.layNovaConfClick(Sender: TObject);
begin
  TDialogService.MessageDialog('Deseja iniciar uma nova conferência?' +#13+ ' Isto ira zerar a conferência feita.',
                TMsgDlgType.mtConfirmation,
                FMX.Dialogs.mbYesNo,
                TMsgDlgBtn.mbNo,
                0,
      procedure(const AResult: System.UITypes.TModalResult)
      begin
        if AResult = mrYES Then
        begin
          dm.ZerarCOnferencia;
          dm.listarBanco(lvBancoProduto);
          AnimationMenu.Start;

        end
        else if AResult = mrNo Then
         AnimationMenu.Start;
         exit;

      end);

end;

procedure TfrmInicial.layNovoProdClick(Sender: TObject);
begin
    Application.CreateForm(TfrmCadastro, frmCadastro);
    //Application.MainForm := frmExporta;
    AnimationMenu.Start;
    frmCadastro.Show;

end;

procedure TfrmInicial.lvBancoProdutoItemClick(const Sender: TObject;
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
         ID_COD := AItem.TagString;

            Application.CreateForm(TfrmAtualizaProd, frmAtualizaProd);
            //Application.MainForm := frmExporta;
            frmAtualizaProd.Show;



        end
        else if AResult = mrNo Then
         exit;

      end);
end;

procedure TfrmInicial.rectMenuLogoffClick(Sender: TObject);
begin
close;
end;

end.
