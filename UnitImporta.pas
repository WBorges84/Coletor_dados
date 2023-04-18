unit UnitImporta;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, FMX.Edit, FMX.Objects, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Layouts, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, u99Permissions,
  System.Actions, FMX.ActnList, FMX.StdActns, FMX.MediaLibrary.Actions;

type
  TfrmImporta = class(TForm)
    LayoutPrincipal: TLayout;
    Layout2: TLayout;
    Label1: TLabel;
    Img_menu: TImage;
    Layout4: TLayout;
    lvBancoProduto: TListView;
    Line2: TLine;
    Layout8: TLayout;
    btnImportar: TButton;
    RoundRect2: TRoundRect;
    StyleBook1: TStyleBook;
    Layout1: TLayout;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Memo1: TMemo;
    Image1: TImage;
    memo: TMemo;
    btnImporTXT: TButton;
    RoundRect1: TRoundRect;
    procedure Img_menuClick(Sender: TObject);
    procedure btnImportarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnImporTXTClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
  permissao: T99Permissions;
    procedure TrataErroPermissao(Sender: TObject);
    { Private declarations }
  public

    { Public declarations }
  end;

var
  frmImporta: TfrmImporta;

implementation

{$R *.fmx}

uses UnitDm, UnitDesktop, UnitInicial, System.JSON, ClasseInserir,
  FireDAC.Comp.Client;

procedure TfrmImporta.btnImportarClick(Sender: TObject);
var
  ArrayProd : TJSONArray;
  EAN, json, DESC, erro, registros, ID: String;
  x : Integer;
  cad : TClasseInserir;
  qry : TFDQuery;
  item : TListViewItem;

begin
  dm.ZerarCOnferencia;
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
    cad.QND := 0;
    cad.cadastrar(erro);


  end;
   ShowMessage('Foram importados: ' + IntToStr(x) + ' Produtos.');
   dm.listarBanco(frmInicial.lvBancoProduto);
   ArrayProd.DisposeOf;

end;

procedure TfrmImporta.btnImporTXTClick(Sender: TObject);
begin
 ////--

end;

procedure TfrmImporta.TrataErroPermissao(Sender: TObject);
begin
  ShowMessage('Você não possui acesso ao recurso.');
end;


procedure TfrmImporta.Button1Click(Sender: TObject);
begin
   FrmDesktop.Show;
end;

procedure TfrmImporta.FormCreate(Sender: TObject);
var
  qry : TFDQuery;

begin
permissao := T99Permissions.Create;

  try
    qry := TFDQuery.Create(nil);
    qry.Connection := dm.conn;

    qry.SQL.Clear;
    qry.SQL.Add('SELECT * FROM CONFIG WHERE TIPO_IMPORT = :TIPO');
    QRY.ParamByName('TIPO').AsString := 'J';
    QRY.Open;

    if NOT qry.IsEmpty then
    begin
      btnImportar.Visible := true;
    end
    else
    begin
      btnImporTXT.Visible := true;
    end;




  finally
    qry.DisposeOf;
  end;

end;

procedure TfrmImporta.Img_menuClick(Sender: TObject);
begin
    Application.CreateForm(TfrmInicial, frmInicial);

    Application.MainForm := frmInicial;
    frmInicial.Show;
     close;
end;


end.


uses u99Permissions;
