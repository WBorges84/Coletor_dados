unit UnitDesktop;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  System.Rtti, FMX.Grid.Style, FMX.Controls.Presentation, FMX.ScrollBox, System.JSON,
  FMX.Grid, FMX.StdCtrls, FMX.Memo.Types, FMX.Memo,
  u99Permissions, UnitCamera, UnitPrincipal, FMX.Edit, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, System.Generics.Collections,
  FMX.MediaLibrary.Actions, System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.Objects, FMX.WebBrowser, FMX.Ani
  {$IFDEF ANDROID}
   ,System.Math,Androidapi.Helpers,Androidapi.JNI.GraphicsContentViewText

 {$ENDIF}

  ;

type
  TFrmDesktop = class(TForm)
    LayoutPrincipal: TLayout;
    Memo: TMemo;
    Layout2: TLayout;
    Label1: TLabel;
    Layout3: TLayout;
    Layout4: TLayout;
    lvBancoProduto: TListView;
    Layout5: TLayout;
    Label2: TLabel;
    edtPesquisa: TEdit;
    Layout6: TLayout;
    Label3: TLabel;
    lvProdutosContados: TListView;
    StyleBook1: TStyleBook;
    btnPesquisa: TButton;
    Layout7: TLayout;
    Layout8: TLayout;
    Button2: TButton;
    btnCarregaJSON: TButton;
    Button4: TButton;
    Button5: TButton;
    btnZerarBanco: TButton;
    ActionList1: TActionList;
    actCamera: TTakePhotoFromCameraAction;
    actLibrary: TTakePhotoFromLibraryAction;
    btnScanear: TImage;
    RoundRect1: TRoundRect;
    RoundRect2: TRoundRect;
    RoundRect3: TRoundRect;
    Line1: TLine;
    Line2: TLine;
    Line3: TLine;
    RectMenu: TRectangle;
    AnimationMenu: TFloatAnimation;
    Image5: TImage;
    layCentral: TLayout;
    LayConferi: TLayout;
    Label5: TLabel;
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
    Img_menu: TImage;
    Label9: TLabel;
    Label10: TLabel;
    lblNova: TLabel;
    lblListar: TLabel;
    lblNovoProd: TLabel;
    lblListarProd: TLabel;
    procedure listarProdutos;
    procedure btnCarregarClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnCarregaJSONClick(Sender: TObject);
    procedure btnPesquisaClick(Sender: TObject);
    procedure lvBancoProdutoItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure btnZerarBancoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnScanearClick(Sender: TObject);
    procedure Label11Click(Sender: TObject);
    procedure rectMenuLogoffClick(Sender: TObject);
    procedure Img_menuClick(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure AnimationMenuFinish(Sender: TObject);
    procedure AnimationMenuProcess(Sender: TObject);
  private


    { Private declarations }
  public
     permissao: T99Permissions;
     procedure TrataErroPermissao(Sender: TObject);
     procedure addProdutos(listview: TListView; Codigo, Decricao, EAN : string);
     procedure listarBanco;
     procedure listarBancoContados;
     procedure ZerarBanco;
    { Public declarations }
  end;

var
  FrmDesktop: TFrmDesktop;

implementation

{$R *.fmx}

uses UnitDm, FireDAC.Comp.Client, ClasseInserir;

{ TFrmDesktop }

procedure TFrmDesktop.addProdutos(listview: TListView; Codigo, Decricao, EAN : string);
var
  txtDescricao, txtCodigo, txtEan : TListItemText;

begin
  with  listview.Items.Add do
  begin

    txtDescricao := TListItemText(Objects.FindDrawable('txtdescricao'));
    txtDescricao.Text := Decricao;

    txtCodigo := TListItemText(Objects.FindDrawable('txtCodigo'));
    txtCodigo.Text := Codigo;

    txtEan := TListItemText(Objects.FindDrawable('txtEan'));
    txtEan.Text := Codigo;

  end;

end;

procedure TFrmDesktop.listarBanco;
var
  qry : TFDQuery;
  item : TListViewItem;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := dm.conn;
    qry.SQL.Clear;
    qry.SQL.Add('SELECT * FROM PRODUTOS');
    qry.Open;

    lvBancoProduto.BeginUpdate;

    while not qry.Eof do
    begin
     item := lvBancoProduto.items.Add;

     TListItemText(item.Objects.FindDrawable('txtId')).Text := qry.FieldByName('ID').AsString;
     TListItemText(item.Objects.FindDrawable('txtDescricao')).Text := qry.FieldByName('DESCRICAO').AsString;
     TListItemText(item.Objects.FindDrawable('txtEAN')).Text :=qry.FieldByName('EAN').AsString;
     qry.Next;
     end;

    lvBancoProduto.EndUpdate;
  finally

  qry.DisposeOf;
  end;


end;

procedure TFrmDesktop.listarBancoContados;
var
  qry : TFDQuery;
  item : TListViewItem;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := dm.conn;
    qry.SQL.Clear;
    qry.SQL.Add('SELECT * FROM PRODUTOS_CONTADOS');
    qry.Open;

    lvProdutosContados.BeginUpdate;

    while not qry.Eof do
    begin
     item := lvProdutosContados.items.Add;

     TListItemText(item.Objects.FindDrawable('txtId')).Text := qry.FieldByName('ID').AsString;
     TListItemText(item.Objects.FindDrawable('txtDescricao')).Text := qry.FieldByName('DESCRICAO').AsString;
     TListItemText(item.Objects.FindDrawable('txtEAN')).Text :=qry.FieldByName('EAN').AsString;
     TListItemText(item.Objects.FindDrawable('txtLine')).Text := '---------------------------';
     qry.Next;
    end;

    lvProdutosContados.EndUpdate;
  finally

  qry.DisposeOf;
  end;


end;

procedure TFrmDesktop.listarProdutos;
var

  qry : TFDQuery;
  erro : string;
  img : TStream;
begin
try
  //qry := ser.ListarServico(erro);

  while NOT qry.Eof do
  begin

    addProdutos(lvBancoProduto,qry.FieldByName('ID').AsString,
                                qry.FieldByName('DESCRICAO').AsString,
                                qry.FieldByName('EAN').AsString);

    qry.Next;
  end;

finally
  qry.DisposeOf;
end;

end;

procedure TFrmDesktop.lvBancoProdutoItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin



  frmPrincipal.lblCodigo.Text:= TListItemText(AItem.Objects.FindDrawable('txtEAN')).Text;
  frmPrincipal.lblDescricao.Text := TListItemText(AItem.Objects.FindDrawable('txtDescricao')).Text;
  frmPrincipal.lblContagemAtual.Text := '0';
  frmPrincipal.lblCodigo.TagString := TListItemText(AItem.Objects.FindDrawable('txtId')).Text;

  if NOT Assigned(FrmPrincipal) then
    Application.CreateForm(TFrmPrincipal, FrmPrincipal);

    Application.MainForm := FrmPrincipal;
    FrmPrincipal.Show;
    FrmDesktop.Close;
end;

procedure TFrmDesktop.rectMenuLogoffClick(Sender: TObject);
begin
close;
end;

procedure TFrmDesktop.btnCarregarClick(Sender: TObject);
var
  ArrayProd : TJSONArray;
  EAN, json, DESC, erro, registros, ID : String;
  x : Integer;
  cad : TClasseInserir;
  qry : TFDQuery;

begin
  json := Memo.Lines.Text; // ws...

  ArrayProd := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json) , 0) as TJSONArray;

  for x := 0 to ArrayProd.Size - 1 do
  begin

    ID := ArrayProd.Get(x).GetValue<String>('field1');
    DESC := ArrayProd.Get(x).GetValue<String>('field2');
    EAN := ArrayProd.Get(x).GetValue<String>('field3');

    cad := TClasseInserir.Create(dm.conn);
    cad.ID := ID;
    CAD.DESC := DESC;
    cad.EAN := EAN;

    cad.cadastrar(erro);


  end;



  ArrayProd.DisposeOf;
end;

procedure TFrmDesktop.btnPesquisaClick(Sender: TObject);
var
  qry : TFDQuery;
  item : TListViewItem;


begin


  if Trim(edtPesquisa.Text) = '' then
  begin
    listarBanco;
   // ShowMessage('Digite algum valor para pesquisar!');
    exit;

  end;
  qry := TFDQuery.Create(nil);
  qry.Connection := dm.conn;


  qry.Active := FALSE;
  qry.SQL.Clear;
  qry.SQL.Add('SELECT * FROM PRODUTOS WHERE ID = :ID OR EAN = :EAN');
  QRY.ParamByName('ID').AsString := edtPesquisa.Text;
  QRY.ParamByName('EAN').AsString := edtPesquisa.Text;

  qry.Open;;

  if NOT qry.IsEmpty then
  begin
    lvBancoProduto.Items.Clear;
    item := lvBancoProduto.Items.Add;
    TListItemText(item.Objects.FindDrawable('txtId')).Text := qry.FieldByName('ID').AsString;
    TListItemText(item.Objects.FindDrawable('txtDescricao')).Text := qry.FieldByName('DESCRICAO').AsString;
    TListItemText(item.Objects.FindDrawable('txtEAN')).Text :=qry.FieldByName('EAN').AsString;

  end
  else
  begin
    ShowMessage('Não localizado nenhum produto com o código: ');
  end;

  qry.DisposeOf;
 end;

procedure TFrmDesktop.btnScanearClick(Sender: TObject);
VAR
  est : double;
begin

{$IFDEF MSWINDOWS}

   ShowMessage('Não suportado no Windows');

 {$ELSE}

       if NOT permissao.VerifyCameraAccess then
        permissao.Camera(nil, nil)
    else
    begin
        FrmCamera.ShowModal(procedure(ModalResult: TModalResult)
        begin

         edtPesquisa.Text :=  FrmCamera.codigo;




        end);
    end;

 {$ENDIF}


end;

procedure TFrmDesktop.AnimationMenuFinish(Sender: TObject);
begin
LayoutPrincipal.Enabled := AnimationMenu.Inverse;
AnimationMenu.Inverse := NOT AnimationMenu.Inverse;
end;

procedure TFrmDesktop.AnimationMenuProcess(Sender: TObject);
begin
LayoutPrincipal.Margins.Right := -270 - RectMenu.Margins.Left;

end;

procedure TFrmDesktop.btnCarregaJSONClick(Sender: TObject);
var
  ArrayProd : TJSONArray;
  EAN, json, DESC, erro, registros, ID: String;
  x : Integer;
  cad : TClasseInserir;
  qry : TFDQuery;
  item : TListViewItem;

begin
  ZerarBanco;
  json := Memo.Lines.Text; // ws...

  {$IFDEF MSWINDOWS}



 {$ELSE}

      // if NOT permissao.VerifyCameraAccess then
       // permissao.Camera(nil, nil);

 {$ENDIF}



  ArrayProd := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json) , 0) as TJSONArray;

  for x := 0 to ArrayProd.Size - 1 do
  begin

    ID := ArrayProd.Get(x).GetValue<String>('field3');
    DESC := ArrayProd.Get(x).GetValue<String>('field2');
    EAN := ArrayProd.Get(x).GetValue<String>('field1');


    cad := TClasseInserir.Create(dm.conn);
    cad.cadastro := '0';
    cad.ID := ID;
    CAD.DESC := DESC;
    cad.EAN := EAN;
    cad.cadastrar(erro);


  end;

   listarBanco;
   ArrayProd.DisposeOf;


end;


procedure TFrmDesktop.btnZerarBancoClick(Sender: TObject);

begin
ZerarBanco;
end;

procedure TFrmDesktop.FormCreate(Sender: TObject);
begin
  RectMenu.Margins.Left := -265;
  RectMenu.Align := TAlignLayout.Left;
  RectMenu.Visible := true;
permissao := T99Permissions.Create;
end;

procedure TFrmDesktop.FormDestroy(Sender: TObject);
begin
permissao.DisposeOf;
end;

procedure TFrmDesktop.Image5Click(Sender: TObject);
begin
 AnimationMenu.Start;
end;

procedure TFrmDesktop.Img_menuClick(Sender: TObject);
begin
 AnimationMenu.Start;
end;

procedure TFrmDesktop.Label11Click(Sender: TObject);
begin
close;
end;

procedure TFrmDesktop.SpeedButton1Click(Sender: TObject);
var
  ArrayProd : TJSONArray;
  json, DESC, erro, registros, ID : String;
  x, EAN : Integer;
  cad : TClasseInserir;
  qry : TFDQuery;

begin
  json := Memo.Lines.Text; // ws...

  ArrayProd := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(json) , 0) as TJSONArray;

  for x := 0 to ArrayProd.Size - 1 do
  begin

    ID := ArrayProd.Get(x).GetValue<String>('field1');
    DESC := ArrayProd.Get(x).GetValue<String>('field2');

    cad := TClasseInserir.Create(dm.conn);
    cad.ID := ID;
    CAD.DESC := DESC;

    cad.cadastrar(erro);

  end;



  ArrayProd.DisposeOf;
end;

procedure TFrmDesktop.TrataErroPermissao(Sender: TObject);
begin
  ShowMessage('Você não possui acesso ao recurso.');
end;

procedure TFrmDesktop.ZerarBanco;
var
  qry : TFDQuery;
  item : TListViewItem;
  i : integer;
begin
    try
    qry := TFDQuery.Create(nil);
    qry.Connection := dm.conn;
    qry.SQL.Clear;
    qry.SQL.Add('DELETE FROM PRODUTOS');
    qry.ExecSQL;

    lvBancoProduto.Items.Clear;

     {for I := 0 to lvBancoProduto.Controls.Count-1 do
           begin
                   lvBancoProduto.Items[I].Text := '';
                         end;}

    finally

      qry.DisposeOf;
    end;

end;

end.
