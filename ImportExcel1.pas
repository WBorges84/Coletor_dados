unit ImportExcel1;

interface

uses
  System.SysUtils, System.Classes, uImportExcel;

type
  TImportExcel1 = class(TImportExcel)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Samples', [TImportExcel1]);
end;

end.
