unit UnitDm;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.FMXUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,System.IOUtils,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, FMX.Types, FMX.Controls, FireDAC.Comp.UI, FMX.ListView;


type
  Tdm = class(TDataModule)
    conn: TFDConnection;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDQuery1: TFDQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure listarBanco(lv : TListView);
    function pesquisaBanco(cod: String): Boolean;
    procedure AtualizaBanco(cod,saldo : String);
    procedure ZerarCOnferencia;
    function ContarRegistros: Integer;
    function SomarQuantidades : Integer;
    function pendentes: Integer;

    { Public declarations }
  end;

var
  dm: Tdm;

implementation

uses
  FMX.ListView.Appearances, FMX.ListView.Types;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}



procedure Tdm.AtualizaBanco(cod, saldo: String);
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := conn;

    qry.SQL.Clear;
    qry.SQL.Add('UPDATE PRODUTOS SET QUANTIDADE = :SALDO');
    qry.SQL.Add('WHERE ID = :COD');
    qry.ParamByName('SALDO').AsString := saldo;
    qry.ParamByName('COD').AsString := cod;
    qry.ExecSQL;

  finally

  end;

end;

function Tdm.ContarRegistros: Integer;
var
  qry :TFDQuery;
  reg: Integer;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := conn;

    qry.SQL.Clear;
    qry.SQL.Add('SELECT COUNT(id) AS SOMA FROM PRODUTOS');
    qry.Open;

    reg := qry.FieldByName('SOMA').AsInteger;

    Result := reg;


  finally
    qry.DisposeOf;
  end;


end;

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  with conn do
  begin
       Params.Values['DriveID'] := 'SQLite';

      {$IFDEF MSWINDOWS}
      Params.Values['Database'] := System.SysUtils.GetCurrentDir + '\bd\banco.db';
      {$ELSE}
      Params.Values['Database'] := TPath.Combine(TPath.GetDocumentsPath, 'banco.db');
      {$ENDIF}

      try
      Connected := true;

      except on E:Exception do
                raise Exception.Create('Erro de conexão com o banco' + E.Message);
      end;

  end;




end;

procedure Tdm.listarBanco(lv: TListView);
var
  qry: TFDQuery;
  item : TListViewItem;
begin
 try
  qry := TFDQuery.Create(nil);
  qry.Connection := conn;

  qry.SQL.Clear;
  qry.SQL.Add('SELECT * FROM PRODUTOS');
  QRY.Open;

  lv.BeginUpdate;
  lv.Items.Clear;
  while NOT qry.Eof do
  begin

   item := lv.items.Add;
   item.TagString := qry.FieldByName('ID').AsString;

   TListItemText(item.Objects.FindDrawable('txtCod')).Text := 'Cód: '+qry.FieldByName('ID').AsString;
   TListItemText(item.Objects.FindDrawable('txtNome')).Text := 'Nome: '+qry.FieldByName('DESCRICAO').AsString;
   TListItemText(item.Objects.FindDrawable('txtBarras')).Text :='Barras: '+qry.FieldByName('EAN').AsString;
   TListItemText(item.Objects.FindDrawable('txtQnt')).Text :='Qtde: ' + qry.FieldByName('QUANTIDADE').AsString;
   qry.Next;


  end;

  lv.EndUpdate;


 finally
  qry.DisposeOf;

 end;

end;

function Tdm.pendentes: Integer;
var
  qry : TFDQuery;
  pen : Integer;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := conn;

    qry.SQL.Clear;
    qry.SQL.Add('SELECT COUNT(ID) AS SOMA FROM PRODUTOs WHERE QUANTIDADE <= 0');
    qry.Open;

    pen := qry.FieldByName('SOMA').AsInteger;

    Result := pen;

  finally
    qry.DisposeOf;
  end;


//SELECT COUNT(ID) FROM PRODUTOs WHERE QUANTIDADE <= 0
end;

function Tdm.pesquisaBanco(cod: String): Boolean;
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := conn;
    qry.SQL.Clear;
    qry.SQL.Add('SELECT * FROM PRODUTOS WHERE ID = :ID OR EAN = :EAN OR DESCRICAO = :NOME');
    qry.ParamByName('ID').AsString := cod;
    qry.ParamByName('EAN').AsString := cod;
    qry.ParamByName('NOME').AsString := cod;
    qry.Open;

    if qry.Eof then
    begin
      result:= false;
    end
    else
    begin
      result := true;
    end;



  finally
    qry.DisposeOf;
  end;


end;

function Tdm.SomarQuantidades: Integer;
var
  qry :TFDQuery;
  sum : Integer;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := conn;

    qry.SQL.Clear;
    qry.SQL.Add('SELECT SUM(QUANTIDADE) AS SOMA FROM PRODUTOS');
    qry.Open;

   if qry.FieldByName('SOMA').IsNull then
   begin
     sum := 0;
   end
   else
   begin

    sum := qry.FieldByName('SOMA').AsInteger;

   end;
    Result := sum;


  finally
    qry.DisposeOf;
  end;

end;

procedure Tdm.ZerarCOnferencia;
var
  qry : TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := conn;

    qry.SQL.Clear;
    qry.SQL.Add('DELETE FROM PRODUTOS' );
    qry.ExecSQL;


  finally

    qry.DisposeOf;

  end;

end;

end.
