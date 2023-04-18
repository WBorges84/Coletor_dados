unit ClasseInserir;

interface

uses FireDAC.comp.Client, FireDAC.DApt, System.SysUtils, FMX.Graphics, FireDAC.Stan.Param,
  UnitDesktop;

type
    TClasseInserir = Class

    private
    Fconn : TFDConnection;
    FID : String;
    FDESC : STRING;
    FEAN : String;
    FQND : Double;


    public
    cadastro : String;
    constructor Create(Conn : TFDConnection);
    property ID : String read FID write FID;
    property DESC : String read FDESC write FDESC;
    property EAN : String read FEAN write FEAN;
    property QND : Double read FQND write FQND;
    function cadastrar(out erro: string): Boolean;
    function atualizar(out erro: string): Boolean;



    End;


implementation

uses UnitConferencia;

constructor TClasseInserir.Create(Conn: TFDConnection);
begin
 Fconn := conn;
end;

function TClasseInserir.cadastrar(out erro: string): Boolean;
var
  qry : TFDQuery;

begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Fconn;

    if cadastro = '0' then
    begin
      with qry do
      begin
        Active := false;

        sql.Clear;
          SQL.Add('INSERT INTO PRODUTOS(ID, DESCRICAO, EAN, QUANTIDADE)');
          SQL.Add('VALUES(:ID, :DESCRICAO, :EAN, :QUANTIDADE)');
          ParamByName('ID').AsString := FID;
          ParamByName('DESCRICAO').AsString := FDESC;
          ParamByName('EAN').AsString := FEAN;
          ParamByName('QUANTIDADE').AsFloat := FQND;

          ExecSQL;


      end;
      Result := true;

      erro := '';
      exit;
    end;
    except on ex:exception do

    begin
    Result := false;
    erro:= 'Erro ao cadastrar o cliente: ' + ex.Message;
   end;


  end;


end;

function TClasseInserir.atualizar(out erro: string): Boolean;
var
  qry : TFDQuery;

begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Fconn;

    if cadastro = '0' then
    begin
      with qry do
      begin
        Active := false;

        sql.Clear;
          SQL.Add('UPDATE PRODUTOS SET DESCRICAO = :DESCRICAO, EAN = :EAN, QUANTIDADE = :QUANTIDADE');
          SQL.Add('WHERE ID = :ID');
          ParamByName('ID').AsString := FID;
          ParamByName('DESCRICAO').AsString := FDESC;
          ParamByName('EAN').AsString := FEAN;
          ParamByName('QUANTIDADE').AsFloat := FQND;
          ExecSQL;


      end;
      Result := true;

      erro := '';
      exit;
    end;
    except on ex:exception do

    begin
    Result := false;
    erro:= 'Erro ao atualizar o o produto: ' + ex.Message;
   end;


  end;


end;

end.
