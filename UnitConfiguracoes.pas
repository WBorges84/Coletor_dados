unit UnitConfiguracoes;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Objects, FMX.StdCtrls, FMX.ListView, FMX.Controls.Presentation,
  FMX.Layouts;

type
  TfrmConfig = class(TForm)
    LayoutPrincipal: TLayout;
    Layout2: TLayout;
    Label1: TLabel;
    Img_menu: TImage;
    Layout4: TLayout;
    Line2: TLine;
    Layout8: TLayout;
    btnSalvar: TButton;
    RoundRect2: TRoundRect;
    Layout1: TLayout;
    Label2: TLabel;
    SwitchJSON: TSwitch;
    Layout3: TLayout;
    Layout5: TLayout;
    SwitchTXT: TSwitch;
    Label3: TLabel;
    Label4: TLabel;
    procedure Img_menuClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure SwitchJSONClick(Sender: TObject);
    procedure SwitchTXTClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConfig: TfrmConfig;

implementation

uses
  FireDAC.Comp.Client, UnitDm;

{$R *.fmx}

procedure TfrmConfig.btnSalvarClick(Sender: TObject);
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := dm.conn;

    if SwitchJSON.IsChecked then
    begin
      qry.SQL.Clear;
      qry.SQL.Add('UPDATE CONFIG SET TIPO_IMPORT =:TIPO');
      QRY.ParamByName('TIPO').AsString := 'J';
      qry.ExecSQL;
    end
    else
    begin
      qry.SQL.Clear;
      qry.SQL.Add('UPDATE CONFIG SET TIPO_IMPORT = :TIPO');
      QRY.ParamByName('TIPO').AsString := 'T';
      qry.ExecSQL;
    end;

     ShowMessage('Configurações salvas!');

  finally
    qry.DisposeOf;
  end;


end;

procedure TfrmConfig.FormCreate(Sender: TObject);
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
       SwitchJSON.IsChecked := true;
       SwitchTXT.IsChecked := false;
    end
    else
    begin
       SwitchJSON.IsChecked := false;
       SwitchTXT.IsChecked := true;
    end;




  finally
    qry.DisposeOf;
  end;


end;

procedure TfrmConfig.Img_menuClick(Sender: TObject);
begin
close;
end;

procedure TfrmConfig.SwitchJSONClick(Sender: TObject);
begin
  if SwitchJSON.IsChecked then
  begin
    SwitchTXT.IsChecked := false;
  end
  else
  begin
    SwitchTXT.IsChecked := true;
  end;

end;

procedure TfrmConfig.SwitchTXTClick(Sender: TObject);
begin
  if SwitchTXT.IsChecked then
  begin
    SwitchJSON.IsChecked := false;
  end
  else
  begin
    SwitchJSON.IsChecked := true;
  end;

end;

end.
