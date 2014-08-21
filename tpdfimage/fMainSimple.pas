//  Copyright 2011 Dipl. Ing. Thomas Friedmann.
//
//  The contents of this file are subject to the Mozilla Public License Version 1.1
//  (the "License"); you may not use this file except in compliance with the
//  \License. You may obtain a copy of the License at http://www.mozilla.org/MPL
//
//  Software distributed under the License is distributed on an "AS IS" basis,
//  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for the
//  specific language governing rights and limitations under the License.
//
//  Alternatively, the contents of this file may be used under the terms of the GNU
//  Lesser General Public License (the "LGPL License"), in which case the provisions
//  of the LGPL License are applicable instead of those above. If you wish to allow
//  use of your version of this file only under the terms of the LGPL License and
//  not to allow others to use your version of this file under the MPL, indicate
//  your decision by deleting the provisions above and replace them with the notice
//  and other provisions required by the LGPL License. If you do not delete the
//  provisions above, a recipient may use your version of this file under either the
//  MPL or the LGPL License.
//
//  For more information about the LGPL: <i>http://www.gnu.org/copyleft/lesser.html</i>//
//
// Dipl. Ing. Thomas Friedmann, ITF Ingenieurbüro, www.itf-it.de
//----------------------------------------------------------------------------------------------------------------------
// Parts by Alessandro Briosi (gsapi.pas, gsimage.pas)
//----------------------------------------------------------------------------------------------------------------------

unit fMainSimple;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,itfPDFImage;

type
  TForm1 = class(TForm)
    Image1: TImage;
    btnLoad: TButton;
    btnPrev: TButton;
    btnNext: TButton;
    Label1: TLabel;
    btnZoomIn: TButton;
    btnZoomOut: TButton;
    procedure btnLoadClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnZoomInClick(Sender: TObject);
    procedure btnZoomOutClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnLoadClick(Sender: TObject);
begin
  Image1.Picture.loadFromFile('Manual TPDFImage (EN).pdf');
  Label1.Caption:='Pagecount = ' + IntToStr(TPDFImage(Image1.Picture.Graphic).Pagecount);
end;

procedure TForm1.btnPrevClick(Sender: TObject);
begin
  TPDFImage(Image1.Picture.Graphic).PreviousPage;
end;

procedure TForm1.btnNextClick(Sender: TObject);
begin
  TPDFImage(Image1.Picture.Graphic).NextPage;
end;

procedure TForm1.btnZoomInClick(Sender: TObject);
begin
  TPDFImage(Image1.Picture.Graphic).Zoom:=TPDFImage(Image1.Picture.Graphic).Zoom + 25;
end;

procedure TForm1.btnZoomOutClick(Sender: TObject);
begin
  TPDFImage(Image1.Picture.Graphic).Zoom:=TPDFImage(Image1.Picture.Graphic).Zoom - 25;
end;

end.
