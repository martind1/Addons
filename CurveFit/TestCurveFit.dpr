program TestCurveFit;

uses
  Forms,
  TestCurveFitForm in 'TestCurveFitForm.pas' {FormMain},
  CurveFit in 'CurveFit.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
