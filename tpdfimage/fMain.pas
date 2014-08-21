//  Copyright 2011, 2012 Dipl. Ing. Thomas Friedmann.
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
//
// This unit shows how to use the TPDFImage
//
// To allow TImage and TPicture to Load PDF Files just add itfPDFImage to your
// uses clause.
//
// TJPGImage adds several new properties specific to multi page PDF:
//
// PageCount:   after loading a PDF this contains the count of Pages in the PDF
// CurrentPage: Set this to jump to a Page directly. For printing set this after creating
//              a TJPGImage before loading from file / stream so the required page is
//              directly loaded
// Resolution:  Resolution in DPI to render the PDF with. Initial its the screen resolution.
//              for printing set to apropriate value
// Zoom:        zoom changes the resolution given to ghostscript to achieve higher or lower
//              details.
//----------------------------------------------------------------------------------------------------------------------
// New for TPDFImage Version 1.4: several improvements for multithreading (special bitmap handling)
// New for TPDFImage Version 1.3: You can use SynPDF (Freeware with source) to enable
// writing of PDF Files. Download link see itfPDFImage.pas.
// Use compiler define USESYNPDF if SynPDF is in your search path to enable saving as PDF
//----------------------------------------------------------------------------------------------------------------------
unit fMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  jpeg, ExtCtrls, StdCtrls, Buttons,itfPDFImage,Printers;

type
  TfrmMain = class(TForm)
    pnlControl: TPanel;
    btnLoad: TButton;
    btnPrev: TButton;
    btnNext: TButton;
    btnZoomIn: TButton;
    btnZoomOut: TButton;
    ScrollBox: TScrollBox;
    Image: TImage;
    OpenDialog: TOpenDialog;
    btnClear: TButton;
    edPage: TEdit;
    lblCount: TLabel;
    btnPrint: TButton;
    PrintDialog: TPrintDialog;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    imgLogo: TImage;
    lblAuthor: TLabel;
    lblWeb: TLabel;
    pnlSysInfo: TPanel;
    lblSysInfo: TLabel;
    btnSave: TButton;
    edPageFrom: TEdit;
    edPageTo: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SaveDialog: TSaveDialog;
    chkAppend: TCheckBox;
    procedure btnLoadClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnPrevClick(Sender: TObject);
    procedure btnZoomInClick(Sender: TObject);
    procedure btnZoomOutClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure edPageExit(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    procedure CheckState;
  public
  end;

var
  frmMain: TfrmMain;

implementation

uses cicAppUtil,Math;

{$R *.DFM}


procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Image.Left:=0;
  Image.Top:=0;
  CheckState;

  {$ifdef USESYNPDF}
  SaveDialog.DefaultExt:='*.PDF';
  SaveDialog.Filter:='Portable Document Format (*.pdf)|*.pdf';
  {$else}
  SaveDialog.DefaultExt:='*.BMP';
  SaveDialog.Filter:='Bitmap (*.bmp)|*.bmp';
  {$endif}

  //Test: differing pathes to gsdll and lib and fonts
  //PathToGSDLL:='C:\Temp\';
  //PathToGSLib:='C:\Temp\lib\';
  //PathToGSFonts:='C:\Temp\fonts\';

  lblSysInfo.Caption:='Pfad zur gsdll32.dll : ' + PathToGSDLL + chr(13) + chr(10);
  lblSysInfo.Caption:=lblSysInfo.Caption + 'Pfad zur \lib : ' + PathToGSLib + chr(13) + chr(10);
  lblSysInfo.Caption:=lblSysInfo.Caption + 'Pfad zur \fonts : ' + PathToGSfonts + chr(13) + chr(10);
end;

//Enable / disable Buttons to reflect the current State
procedure TfrmMain.CheckState;
begin
  btnPrev.Enabled:=Assigned(Image.Picture.Graphic) and (Image.Picture.Graphic is TPDFImage) and (TPDFImage(Image.Picture.Graphic).PageCount > 0) and (TPDFImage(Image.Picture.Graphic).CurrentPage > 1);
  btnNext.Enabled:=Assigned(Image.Picture.Graphic) and (Image.Picture.Graphic is TPDFImage) and (TPDFImage(Image.Picture.Graphic).PageCount > 0) and (TPDFImage(Image.Picture.Graphic).CurrentPage < TPDFImage(Image.Picture.Graphic).PageCount);
  btnZoomIn.Enabled:=Assigned(Image.Picture.Graphic) and (Image.Picture.Graphic is TPDFImage) and (TPDFImage(Image.Picture.Graphic).PageCount > 0);
  btnZoomOut.Enabled:=Assigned(Image.Picture.Graphic) and (Image.Picture.Graphic is TPDFImage) and (TPDFImage(Image.Picture.Graphic).PageCount > 0);
  edPage.Enabled:=Assigned(Image.Picture.Graphic) and (Image.Picture.Graphic is TPDFImage) and (TPDFImage(Image.Picture.Graphic).PageCount > 0);
  btnClear.Enabled:=Assigned(Image.Picture.Graphic) and (Image.Picture.Graphic is TPDFImage) and (TPDFImage(Image.Picture.Graphic).PageCount > 0);
  btnPrint.Enabled:=Assigned(Image.Picture.Graphic) and (Image.Picture.Graphic is TPDFImage) and (TPDFImage(Image.Picture.Graphic).PageCount > 0);

  if Assigned(Image.Picture.Graphic) then
  begin
    Image.Width:=Image.Picture.Graphic.Width;
    Image.Height:=Image.Picture.Graphic.Height;
    edPage.Text:=IntToStr(TPDFImage(Image.Picture.Graphic).CurrentPage);
    lblCount.Caption:='of ' + IntToStr(TPDFImage(Image.Picture.Graphic).PageCount);
  end;

  btnSave.Enabled:=Assigned(Image.Picture.Graphic);
  edPageFrom.Enabled:=Assigned(Image.Picture.Graphic);
  edPageTo.Enabled:=Assigned(Image.Picture.Graphic);

  {$ifndef USESYNPDF}
  edPageFrom.Enabled:=FALSE;
  edPageTo.Enabled:=FALSE;
  {$endif}
end;

//Load from file
procedure TfrmMain.btnLoadClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    Image.Picture.LoadFromFile(OpenDialog.FileName);
    CheckState;
    edPageFrom.Text:='1';
    edPageTo.Text:=IntToStr(TPDFImage(Image.Picture.Graphic).PageCount);
  end;
end;

//Show next Page
procedure TfrmMain.btnNextClick(Sender: TObject);
begin
  TPDFImage(Image.Picture.Graphic).NextPage;
  CheckState;
end;

//Show prev Page
procedure TfrmMain.btnPrevClick(Sender: TObject);
begin
  TPDFImage(Image.Picture.Graphic).PreviousPage;
  CheckState;
end;

//Zoom in (Maximum 300%)
procedure TfrmMain.btnZoomInClick(Sender: TObject);
begin
  TPDFImage(Image.Picture.Graphic).Zoom:=Min(300,TPDFImage(Image.Picture.Graphic).Zoom + 25);
  CheckState;
end;

//Zoom out (Minimum 25%)
procedure TfrmMain.btnZoomOutClick(Sender: TObject);
begin
  TPDFImage(Image.Picture.Graphic).Zoom:=Max(25,TPDFImage(Image.Picture.Graphic).Zoom - 25);
  CheckState;
end;

//Clear Image
procedure TfrmMain.btnClearClick(Sender: TObject);
begin
  Image.Picture:=Nil;
  CheckState;
end;

//Direct page input
procedure TfrmMain.edPageExit(Sender: TObject);
Var FPage:Integer;
begin
  Try
    FPage:=StrToInt(edPage.Text);
  except
    FPage:=1;
  end;

  TPDFImage(Image.Picture.Graphic).CurrentPage:=FPage;
  CheckState;
end;

//Print to printer
procedure TfrmMain.btnPrintClick(Sender: TObject);
Var FMinPage,FMaxPage,I:Integer;
    FPicture:TPDFImage;

  //Print current page
  procedure PrintPage;
  Var FHeight,FWidth:Integer;
  begin
    with Printer do
    begin
      Canvas.Lock;
      try
        //Print full page. Check if width or height fits better
        FWidth:=PageWidth;
        FHeight:=Round(PageWidth/FPicture.Width*FPicture.Height);
        if (FHeight > PageHeight) then
        begin
          FHeight:=PageHeight;
          FWidth:=Round(PageHeight/FPicture.Height*FPicture.Width);
        end;
        //paint to printer
        Canvas.StretchDraw(Rect((PageWidth-FWidth) div 2,(PageHeight-FHeight) div 2, FWidth, FHeight),FPicture);
      finally
        Canvas.Unlock;
      end;
    end;
  end;

begin
  PrintDialog.MaxPage:=TPDFImage(Image.Picture.Graphic).PageCount;
  if PrintDialog.Execute then
  begin
    //Get user selected pagerange
    if (PrintDialog.PrintRange = prPageNums) then
    begin
      FMinPage:=PrintDialog.FromPage;
      FMaxPage:=PrintDialog.ToPage;
    end
    else
    begin
      FMinPage:=1;
      FMaxPage:=TPDFImage(Image.Picture.Graphic).PageCount;
    end;

    //Create temporary TPDFImage for printing because of higer resolution needed.
    FPicture:=TPDFImage.Create;
    Try
      FPicture.Resolution:=300;

      //set before load so the first requested page is loaded
      FPicture.CurrentPage:=FMinPage;
      FPicture.LoadFromFile(OpenDialog.FileName);

      //start printing
      Printer.BeginDoc;
      try
        //print requested pages
        For I:=FMinPage to FMaxPage do
        begin
          FPicture.CurrentPage:=I;
          PrintPage;
          if (I < FMaxPage) then Printer.NewPage;
        end;
      finally
        Printer.EndDoc;
      end;
    finally
      FPicture.Free;
    end;
  end;
end;


procedure TfrmMain.btnSaveClick(Sender: TObject);
Var FPicture:TPDFImage;
    FStream:TFileStream;
begin
  if SaveDialog.Execute then
  begin
    //Create temporary TPDFImage to load PDF with higher resolution to get a good
    //quality file.
    FPicture:=TPDFImage.Create;
    Try
      //set resolution and page before load so the first requested page is loaded
      FPicture.Resolution:=300;
      FPicture.CurrentPage:=StrToInt(edPageFrom.Text);
      FPicture.LoadFromFile(OpenDialog.FileName);

      {$ifdef USESYNPDF}
      //Save as PDF
      TPDFImage(FPicture).ExtractPagesToFile(SaveDialog.FileName,StrToInt(edPageFrom.Text),StrToInt(edPageTo.Text),chkAppend.Checked);
      {$else}
      //Save current page as Bitmap
      FStream:=TFileStream.Create(SaveDialog.FileName,fmCreate);
      Try
        TPDFImage(FPicture).SaveToStream(FStream);
      Finally
        FStream.Free;
      end;
      {$endif}

      //To save all pages just use SaveToFile or SaveToStream
      //FPicture.SaveToFile(SaveDialog.FileName);

      //ATTN: if the PDF is searchable (i.e. not scanned) you will loose the possibilty to
      //      search or to show a table of content because the written PDF now contains only a
      //      image.
    finally
      FPicture.Free;
    end;
  end;
end;

end.
