
{*******************************************************}
{                                                       }
{ XML-RPC Library for Delphi, Kylix and DWPL (DXmlRpc)  }
{ Test project                                          }
{                                                       }
{ for Delphi 6, 7                                       }
{ Release 2.0.0                                         }
{ Copyright (c) 2001-2003 by Team-DelphiXml-Rpc         }
{ e-mail: team-dxmlrpc@dwp42.org                        }
{ www: http://sourceforge.net/projects/delphixml-rpc/   }
{                                                       }
{ The initial developer of the code is                  }
{   Clifford E. Baeseman, codepunk@codepunk.com         }
{                                                       }
{ This file may be distributed and/or modified under    }
{ the terms of the GNU Lesser General Public License    }
{ (LGPL) version 2.1 as published by the Free Software  }
{ Foundation and appearing in the included file         }
{ license.txt.                                          }
{                                                       }
{*******************************************************}
{
  $Header: /cvsroot/delphi/ADDONS/dxmlrpc/tests/coversmethod/Project2.dpr,v 1.1 2011/01/25 16:39:53 cvs Exp $
  ----------------------------------------------------------------------------

  $Log: Project2.dpr,v $
  Revision 1.1  2011/01/25 16:39:53  cvs
  2011

  Revision 1.1.1.1  2003/12/03 22:37:51  iwache
  Initial import of release 2.0.0

  ----------------------------------------------------------------------------
}
program Project2;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
