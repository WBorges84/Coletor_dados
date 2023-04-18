program Coletor;



uses
  System.StartUpCopy,
  FMX.Forms,
  UnitPrincipal in 'UnitPrincipal.pas' {frmPrincipal},
  u99Permissions in 'Unit\u99Permissions.pas',
  UnitCamera in 'UnitCamera.pas' {FrmCamera},
  UnitDesktop in 'UnitDesktop.pas' {FrmDesktop},
  UnitDm in 'UnitDm.pas' {dm: TDataModule},
  ClasseInserir in 'Unit\ClasseInserir.pas',
  UnitInicial in 'UnitInicial.pas' {frmInicial},
  UnitImporta in 'UnitImporta.pas' {frmImporta},
  UnitExporta in 'UnitExporta.pas' {frmExporta},
  UnitCadastro in 'UnitCadastro.pas' {frmCadastro},
  UnitConferencia in 'UnitConferencia.pas' {frmConferencia},
  UnitConfiguracoes in 'UnitConfiguracoes.pas' {frmConfig},
  FMX.BitmapHelper in 'Unit\FMX.BitmapHelper.pas',
  AnonThread in 'Unit\AnonThread.pas',
  Unit1 in 'Unit1.pas' {frmEx},
  UnitAtualizaProduto in 'UnitAtualizaProduto.pas' {frmAtualizaProd};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmInicial, frmInicial);
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TfrmConfig, frmConfig);
  Application.CreateForm(TFrmCamera, FrmCamera);
  Application.CreateForm(TfrmEx, frmEx);
  Application.Run;
end.
