//----------------------------------------------------------------------------------------------------------------------
//
// TPDFImage component, inherits from TBitmap and registers as TGraphic class for the PDF fileextension.
//
// Dipl. Ing. Thomas Friedmann, ITF Ingenieurbüro, www.itf-it.de
//
// Version 1.4         29.05.2012
//
// Sourcecode included, Demo included
//----------------------------------------------------------------------------------------------------------------------
This component allows to open PDF Files in Delphi with multiple pages using Ghostscript API as renderer (gsdll32.dll) 
and treat them like bitmaps. Additional properties are added to take care of multi page PDF files.

There is no need for Acrobat Reader to be installed. You only need to distribute gsdll32.dll for that purpose with
yout application or component based on this source.

Developed in Delphi 5 Enterprise but should run in most Delphi versions.

This component is FREEWARE for private AND commercial use. You are allowed to modify and/or improve the sourcecode
for your needs without any restriction. 


Usage:

  1.) Copy all files to a folder

  2.) Include itfPDFImage to your uses clause and add the folder to the searchpath

  3.) Use TImage / TPicture with LoadFromFile or LoadFromStream to load a PDF. 

  4.) The first Page is shown. For PDF with a lot of pages this may take some seconds due to the need to
      count available pages.

  5.) Use PageCount to query number of Pages.

  6.) use CurrentPage to navigate to another page (or use FirstPage, NextPage, PreviousPage and LastPage Methods)
      To do this cast Graphic to TPDFImage like this: TPDFImage(Image1.Picture.Graphic).CurrentPage:=2;

  7.) Use Resolution and Zoom to change rendering result. Resolution is in DPI. Default ist taken from TScreen. For
      printing chose apropriate resolution, for example 300 DPI.

  8.) Look at PDFDemo.prj for a comprehensive demonstration including printing.


You may exchange gsdll32.dll with a newer one if there is one available (usually included in Ghostscript setup)

If you like this component, for comments and requests or to claim copyrights please send a mail to info@itf-it.de.



