unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  System.Actions, FMX.ActnList, FMX.StdActns,
  FMX.MediaLibrary.Actions, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.BitmapHelper;

type
  TfrmEx = class(TForm)
    Image1: TImage;
    rectShareImage: TRectangle;
    Label1: TLabel;
    rectShareTexto: TRectangle;
    Label2: TLabel;
    ActionList1: TActionList;
    ActShare: TShowShareSheetAction;
    procedure FormShow(Sender: TObject);
    procedure rectShareImageClick(Sender: TObject);
    procedure rectShareTextoClick(Sender: TObject);
  private

    { Private declarations }
  public
  procedure exportar(msg: string);
    { Public declarations }
  end;

var
  frmEx: TfrmEx;

implementation

{$R *.fmx}

procedure TfrmEx.FormShow(Sender: TObject);
begin
    Image1.Bitmap.LoadFromUrl('https://yt3.ggpht.com/ytc/AKedOLTLwmDOYOGQC0pA_JX5KTWhVlMy703zMZewNnqz=s900-c-k-c0x00ffffff-no-rj');
end;

procedure TfrmEx.rectShareImageClick(Sender: TObject);
begin
    ActShare.Bitmap := Image1.Bitmap;
    ActShare.TextMessage := '';
    ActShare.Execute;
end;

procedure TfrmEx.exportar(msg: string);
var
    msg2 : string;
begin
    msg2 := msg;

    (*msg := 'Pedido #58500' + sLineBreak + sLineBreak;
    msg := msg + '01 x Coca-Cola (R$ 4,50)' + sLineBreak;
    msg := msg + '01 x Sorvete (R$ 6,00)' + sLineBreak;
    msg := msg + '------------------------' + sLineBreak;
    msg := msg + 'Total: R$ 10,50';   *)

    ActShare.Bitmap := nil;
    ActShare.TextMessage := msg;
    ActShare.Execute;
end;


procedure TfrmEx.rectShareTextoClick(Sender: TObject);
var
    msg : string;
begin
    msg := 'Pedido #58500' + sLineBreak + sLineBreak;
    msg := msg + '01 x Coca-Cola (R$ 4,50)' + sLineBreak;
    msg := msg + '01 x Sorvete (R$ 6,00)' + sLineBreak;
    msg := msg + '------------------------' + sLineBreak;
    msg := msg + 'Total: R$ 10,50';

    ActShare.Bitmap := nil;
    ActShare.TextMessage := msg;
    ActShare.Execute;
end;

end.
