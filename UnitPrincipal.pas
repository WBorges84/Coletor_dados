unit UnitPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Objects, FMX.Layouts, u99permissions, FMX.Media;

type
  TfrmPrincipal = class(TForm)
    Layout1: TLayout;
    btnScanear: TImage;
    lblCodigo: TLabel;
    btnAdd: TImage;
    btnFinalizar: TImage;
    MediaPlayer: TMediaPlayer;
    lblDescricao: TLabel;
    Layout2: TLayout;
    Layout3: TLayout;
    Label1: TLabel;
    Layout4: TLayout;
    Label2: TLabel;
    lblContagemAtual: TLabel;
    btnVoltar: TButton;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnScanearClick(Sender: TObject);
    procedure btnFinalizarClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnVoltarClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    permissao : T99Permissions;
    procedure StartSom(som: String);
    procedure playsom;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;


implementation

{$R *.fmx}

uses UnitCamera, UnitDesktop, FMX.DialogService, FireDAC.Comp.Client, UnitDm;

procedure TfrmPrincipal.StartSom(som : String);
var
  arq : String;
begin
 (*   {$IFDEF MSWINDOWS}
        arq := System.SysUtils.GetCurrentDir + '\' + som;
            {$ELSE}
                arq := TPath.Combine(TPath.GetDocumentsPath, som);
                    {$ENDIF}

                        MediaPlayer.Clear;
                            MediaPlayer.FileName := arq;*)
end;

procedure TfrmPrincipal.playsom();
Begin
  if MediaPlayer.State = TMediaState.Playing then
    MediaPlayer.Stop;

  if MediaPlayer.Media <> nil then
    MediaPlayer.Play;
End;


procedure TfrmPrincipal.btnVoltarClick(Sender: TObject);
begin

  TDialogService.MessageDialog('A ação irá descartar a contagem.',
                TMsgDlgType.mtConfirmation,
                FMX.Dialogs.mbYesNo,
                TMsgDlgBtn.mbNo,
                0,
      procedure(const AResult: System.UITypes.TModalResult)
      begin
        if AResult = mrYES Then
        begin
          //ShowMessage('Yes was selected');
            Application.CreateForm(TFrmDesktop, FrmDesktop);
            Application.MainForm := FrmDesktop;
            FrmDesktop.Show;
            FrmDesktop.listarBanco;
            Close;

        end
        else if AResult = mrNo Then
         // ShowMessage('No was selected');
         exit;

      end);


end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
permissao := T99Permissions.Create;
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
permissao.DisposeOf;
end;

procedure TfrmPrincipal.Image1Click(Sender: TObject);
VAR
  est : double;

begin

  est := StrToFloat(lblContagemAtual.Text ) - 1;
  lblContagemAtual.Text := FloatToStr(est);

end;

procedure TfrmPrincipal.btnScanearClick(Sender: TObject);
VAR
  est : double;
begin

{$IFDEF MSWINDOWS}

   lblCodigo.Text := '789456';

 {$ELSE}

       if NOT permissao.VerifyCameraAccess then
        permissao.Camera(nil, nil)
    else
    begin
        FrmCamera.ShowModal(procedure(ModalResult: TModalResult)
        begin
          if FrmCamera.codigo = lblCodigo.Text then
          begin
            lblCodigo.Text := FrmCamera.codigo;
            est := StrToFloat(lblContagemAtual.Text ) + 1;
            lblContagemAtual.Text := FloatToStr(est);
          end
          else
          begin
            ShowMessage('O produto lido: ' + FrmCamera.codigo + ' é diferente do produto em contagem: ' + lblCodigo.Text );
          end;


        end);
    end;

 {$ENDIF}




end;

procedure TfrmPrincipal.btnAddClick(Sender: TObject);
VAR
  est : double;

begin

  est := StrToFloat(lblContagemAtual.Text ) + 1;
  lblContagemAtual.Text := FloatToStr(est);




end;

procedure TfrmPrincipal.btnFinalizarClick(Sender: TObject);
var
  saldo : Double;
  descricao, EAN, codigo, ID : String;
  qry : TFDQuery;

begin
  saldo := StrToFloat(lblContagemAtual.Text);
  descricao := lblDescricao.Text;
  EAN := lblCodigo.Text;
  ID := lblCodigo.TagString;

   TDialogService.MessageDialog('A contagem total do produto ' + descricao + ' É: '+ FloatToStr(saldo),
                TMsgDlgType.mtConfirmation,
                FMX.Dialogs.mbYesNo,
                TMsgDlgBtn.mbNo,
                0,
      procedure(const AResult: System.UITypes.TModalResult)
      begin
        if AResult = mrYES Then
        begin
          qry := TFDQuery.Create(nil);
          qry.Connection := dm.conn;

          qry.SQL.Clear;
          qry.SQL.Add('INSERT INTO PRODUTOS_CONTADOS (ID, DESCRICAO, SALDO, EAN)');
          qry.SQL.Add('VALUES(:ID, :DESCRICAO, :SALDO, :EAN)');
          qry.ParamByName('ID').VALUE:= StrToInt(ID);
          qry.ParamByName('DESCRICAO').AsString := descricao;
          qry.ParamByName('SALDO').AsFloat := SALDO;
          qry.ParamByName('EAN').AsString := EAN;
          qry.ExecSQL;

          qry.SQL.Clear;
          qry.SQL.Add('DELETE FROM PRODUTOS');
          qry.SQL.Add('WHERE ID = :Id');
          qry.ParamByName('ID').VALUE:= StrToInt(ID);
          qry.ExecSQL;

          FrmDesktop.listarBanco;
          FrmDesktop.listarBancoContados;

          Application.CreateForm(TFrmDesktop, FrmDesktop);
          Application.MainForm := FrmDesktop;
          FrmDesktop.Show;
          FrmDesktop.listarBanco;
          FrmDesktop.listarBancoContados;
          Close;

        end
        else if AResult = mrNo Then
         // ShowMessage('No was selected');
         exit;

      end);

   qry.DisposeOf;

end;

end.
