unit UnitCamera;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Media, System.IOUtils,
  ZXing.ScanManager,
  Zxing.ReadResult,
  ZXing.BarcodeFormat,
  FMX.Platform, System.Math.Vectors, FMX.Layouts, FMX.Controls3D, FMX.Layers3D;

type
  TFrmCamera = class(TForm)
    CameraComponent: TCameraComponent;
    lblErro: TLabel;
    imgCamera: TImage;
    imgClose: TImage;
    Layout3D1: TLayout3D;
    Layout1: TLayout;
    procedure CameraComponentSampleBufferReady(Sender: TObject;
      const ATime: TMediaTime);
    procedure FormShow(Sender: TObject);
    procedure imgCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure processarImagem;
    //procedure executarAudio;
    //procedure StartSom(som: String);
    //procedure playsom;
    { Private declarations }
  public
    codigo : String;
    FScanManager : TScanManager;
    FScanInProgress : Boolean;
    FFrameTake : Integer;
    //procedure executarAudio;
    procedure playsom;
    procedure StartSom(som: String);
    { Public declarations }
  end;

var
  FrmCamera: TFrmCamera;

implementation

{$R *.fmx}

uses u99Permissions, UnitDesktop, UnitPrincipal;

procedure TFrmCamera.StartSom(som : String);
var
  arq : String;
begin
  (*  {$IFDEF MSWINDOWS}
    arq := System.SysUtils.GetCurrentDir + '\' + som;
    {$ELSE}
    arq := TPath.Combine(TPath.GetDocumentsPath, som);
    {$ENDIF}

    MediaPlayer.Clear;
    MediaPlayer.FileName := arq;   *)
end;

procedure TFrmCamera.playsom();
Begin

End;


procedure TFrmCamera.FormCreate(Sender: TObject);
begin
 FScanManager := TScanManager.Create(TBarcodeFormat.Auto, nil);
end;

procedure TFrmCamera.FormDestroy(Sender: TObject);
begin
FScanManager.DisposeOf;
end;

procedure TFrmCamera.FormShow(Sender: TObject);
begin
 FFrameTake := 0;
 CameraComponent.Active := false;
 CameraComponent.Kind := TCameraKind.BackCamera;
 CameraComponent.FocusMode := TFocusMode.ContinuousAutoFocus;
 CameraComponent.Quality := TVideoCaptureQuality.MediumQuality;

 CameraComponent.Active := TRUE;
end;

procedure TFrmCamera.imgCloseClick(Sender: TObject);
begin
  CameraComponent.Active := false;
  close;

end;

procedure TFrmCamera.processarImagem;
var
  bmp : TBitmap;
  ReadResult : TReadResult;
begin
  CameraComponent.SampleBufferToBitmap(imgCamera.Bitmap, true);

  if FScanInProgress then
     exit;

  inc(FFrameTake);

  if FFrameTake mod 20 <> 0 then
    exit;

  bmp := TBitmap.Create;
  bmp.Assign(imgCamera.Bitmap);
  ReadResult := nil;

  TRY
    FScanInProgress := true;

    try
      ReadResult := FScanManager.Scan(bmp);

      if ReadResult <> nil then
      begin
          CameraComponent.Active := false;
          codigo := ReadResult.text;
          close;

      end;

    except on ex:exception do
      lblErro.Text := ex.Message;

    end;

  FINALLY
    ReadResult.DisposeOf;
    bmp.DisposeOf;
    FScanInProgress := false;
  END;


end;

procedure TFrmCamera.CameraComponentSampleBufferReady(Sender: TObject;
  const ATime: TMediaTime);
begin
  processarImagem;
end;

end.
