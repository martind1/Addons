unit TestCurveFitForm;

{
Delphi 4 main program form TestCurveFit.pas

Purpose: to provide a simple testbed for the procedure PolyFit

Revision history:

2000 Oct 28  First version
2001 Jan 07  Add UpDown button to demonstrate changing the number of terms
             Add more explanatory comments
             Build without requiring Delphi 4 runtime library

Copyright © David J Taylor, Edinburgh and others listed above
Web site:  www.satsignal.net
E-mail:    davidtaylor@writeme.com
}

interface

// Add unit CurveFit to the Uses clause to gain access to PolyFit
uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,
  CurveFit;

type
  TFormMain = class (TForm)
    MemoResults: TMemo;
    ButtonClose: TButton;
    UpDownNumTerms: TUpDown;
    EditNumTerms: TEdit;
    LabelNumTerms: TLabel;
    procedure FormShow (Sender: TObject);
    procedure ButtonCloseClick (Sender: TObject);
    procedure UpDownNumTermsClick (Sender: TObject; Button: TUDBtnType);
  private
    { Private declarations }
    procedure calculate_fit (const nTerms: integer);
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.DFM}


procedure TFormMain.FormShow (Sender: TObject);
begin
  // On first show, calcuate some results to display...
  Calculate_fit (UpDownNumTerms.Position);
end;


procedure TFormMain.ButtonCloseClick (Sender: TObject);
begin
  // When the Close button is clicked, close the form and application
  Close;
end;


procedure TFormMain.UpDownNumTermsClick(Sender: TObject; Button: TUDBtnType);
begin
  // When the UpDown control is clicked, try
  // a curve fit with a new number of terms
  Calculate_fit (UpDownNumTerms.Position);
end;


procedure TFormMain.calculate_fit (const nTerms: integer);
const
  max_points = 9;
  max_terms = 5;
var
  nPoints: 1..max_points;
  x, y: array [0..max_points-1] of real;
  coef: array [0..max_terms-1] of real;
  correl: real;
var
  i, j: integer;
  xc, yc, delta: real;
  bgtest : real;
begin
  // Sanity check on arguments
  if (nTerms < 1) or (nTerms > max_terms) then Exit;

  // Fill in the X and Y arrays
  nPoints := 9;
  for i := 0 to nPoints - 1 do x [i] := i + 1;
  y [0] := 2.07;
  y [1] := 8.6;
  y [2] := 14.42;
  y [3] := 15.80;
  y [4] := 18.92;
  y [5] := 17.96;
  y [6] := 12.98;
  y [7] := 6.45;
  y [8] := 0.27;

  // Remove any existing display of results
  MemoResults.Clear;

  // Call the PolyFit routine.  The output coeffs array and correl(ation)
  PolyFit (x, y, coef, correl, nPoints, nTerms);

  // Display the results in the lines of a MemoControl
  MemoResults.Lines.Add (' I    X      Y    Ycalc  residual bgPartest');
  for i := 0 to nPoints - 1 do
    begin
    yc := 0.0;
    xc := 1.0;
    for j := 0 to nTerms - 1 do
      begin
      yc := yc + coef [j] * xc;
      xc := xc * x [i];
      end;
    delta := yc - y [i];
    bgtest := coef [2] * sqr(i) + coef [1] * i + coef [0];
    MemoResults.Lines.Add (Format ('%2d   %3f %6.2f %6.2f %6.2f %6.2f',
      [i, x [i], y [i], yc, delta, bgtest]));
    end;

  MemoResults.Lines.Add (' ');
  MemoResults.Lines.Add ('Coefficients');
  MemoResults.Lines.Add (Format ('%.4f  constant term', [coef [0]]));

  for i := 1 to nTerms - 1 do
    MemoResults.Lines.Add (Format ('%.4f   X^%d', [coef [i], i]));
  MemoResults.Lines.Add (Format ('%.4f  correlation coefficient', [correl]));
end;


end.

