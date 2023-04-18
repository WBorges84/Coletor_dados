unit UnitExporta;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Memo.Types, FMX.Objects, FMX.StdCtrls, FMX.ScrollBox, FMX.Memo,
  FMX.ListView, FMX.Controls.Presentation, FMX.Layouts,
  FMX.MediaLibrary.Actions, System.Actions, FMX.ActnList, FMX.StdActns;

type
  TfrmExporta = class(TForm)
    LayoutPrincipal: TLayout;
    Layout2: TLayout;
    Label1: TLabel;
    Img_menu: TImage;
    Layout4: TLayout;
    lvBancoProduto: TListView;
    Layout1: TLayout;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Image1: TImage;
    Line2: TLine;
    Layout8: TLayout;
    btnExportaTXT: TButton;
    RoundRect2: TRoundRect;
    StyleBook1: TStyleBook;
    ActionList1: TActionList;
    ActShare1: TShowShareSheetAction;
    btnExportJSON: TButton;
    RoundRect1: TRoundRect;
    procedure Img_menuClick(Sender: TObject);
    procedure ActShareBeforeExecute(Sender: TObject);
    procedure btnExportJSONClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure contador;
    { Private declarations }
  public
  count :Integer;
    { Public declarations }
  end;

var
  frmExporta: TfrmExporta;


implementation

{$R *.fmx}

uses UnitInicial, FMX.BitmapHelper, AnonThread, Unit1, FireDAC.Comp.Client,
  UnitDm;

procedure TfrmExporta.btnExportJSONClick(Sender: TObject);
var
  qry : TFDQuery;
  memo : TMemo;
  msg, msgFull, msgFim, ID, DESCRICAO, EAN : String;
  QUANTIDADE, c, s : Integer;

begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := dm.conn;
    memo := TMemo.Create(nil);

    qry.SQL.Clear;
    qry.SQL.Add('SELECT * FROM PRODUTOS');
    qry.Open;

    while NOT qry.Eof do
    begin
       contador;

      if count = 1 then
      begin
      msgFull:= '';
      end
      else
      begin
        msgFull := msgFull + ',';
      end;


      msg := '{"field1":"'+ qry.FieldByName('ID').AsString+ '","field2":"'+qry.FieldByName('DESCRICAO').AsString+
                                                            '","field3":"'+qry.FieldByName('EAN').AsString+
                                                            '","field4":"'+IntToStr(qry.FieldByName('QUANTIDADE').AsInteger)+'"}';
      msgFull := msgFull + msg;
      qry.Next;
    end;

    msgFim:= '[' +msgFull+ ']';
    frmEx.exportar(msgFim);
  finally
    qry.DisposeOf;
  end;
end;

procedure TfrmExporta.contador;
begin
 count := count + 1;

end;

procedure TfrmExporta.FormCreate(Sender: TObject);
var
  qry : TFDQuery;

begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := dm.conn;

    qry.SQL.Clear;
    qry.SQL.Add('SELECT * FROM CONFIG WHERE TIPO_IMPORT = :TIPO');
    QRY.ParamByName('TIPO').AsString := 'J';
    QRY.Open;

    if NOT qry.IsEmpty then
    begin
      btnExportJSON.Visible := true;
    end
    else
    begin
      btnExportaTXT.Visible := true;
    end;




  finally
    qry.DisposeOf;
  end;

end;

procedure TfrmExporta.ActShareBeforeExecute(Sender: TObject);
var
  qry : TFDQuery;
  memo : TMemo;
  msg, msgFull, msgFim, ID, DESCRICAO, EAN : String;
  QUANTIDADE, c, s : Integer;

begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := dm.conn;
    memo := TMemo.Create(nil);

    qry.SQL.Clear;
    qry.SQL.Add('SELECT * FROM PRODUTOS');
    qry.Open;

    while NOT qry.Eof do
    begin
    (*
    // EXPORTA JSON

      contador;

      if count = 1 then
      begin
      msgFull:= '';
      end
      else
      begin
        msgFull := msgFull + ',';
      end;


      msg := '{"field1":"'+ qry.FieldByName('ID').AsString+ '","field2":"'+qry.FieldByName('DESCRICAO').AsString+
                                                            '","field3":"'+qry.FieldByName('EAN').AsString+
                                                            '","field4":"'+IntToStr(qry.FieldByName('QUANTIDADE').AsInteger)+'"}';
      msgFull := msgFull + msg;
      qry.Next; *)


    //EXPORTA TXT
     msg := qry.FieldByName('ID').AsString + '|'+qry.FieldByName('DESCRICAO').AsString+'|'
            +qry.FieldByName('EAN').AsString+'|'+IntToStr(qry.FieldByName('QUANTIDADE').AsInteger) + sLineBreak;

     msgFull := msgFull + msg;
     qry.Next;
    end;

    msgFim:= msgFull;
     frmEx.exportar(msgFim);
  finally
    memo.DisposeOf;
    qry.DisposeOf;
  end;

  // CODIGO | DESCRICAO | EAN | QUANTIDADE



  (*msg := 'Pedido #58500' + sLineBreak + sLineBreak;
  msg := msg + '01 x Coca-Cola (R$ 4,50)' + sLineBreak;
  msg := msg + '01 x Sorvete (R$ 6,00)' + sLineBreak;
  msg := msg + '------------------------' + sLineBreak;
  msg := msg + 'Total: R$ 10,50';
  frmEx.exportar(msg);

  (*ActShare1.Bitmap := nil;
  ActShare1.TextMessage := msg;
  ActShare1.Execute; *)

end;

procedure TfrmExporta.Img_menuClick(Sender: TObject);
begin
    Application.CreateForm(TfrmInicial, frmInicial);

    Application.MainForm := frmInicial;
    frmInicial.Show;
     close;
end;

end.
