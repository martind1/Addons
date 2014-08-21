
// << MD 
// 19.10.2009 MD Delphi 2010 (VER210)
// MD >>

{.$define PSOFT_JPEG}

{$define PSOFT_QREPORT}
{.$define PSOFT_DEMO}
{$define PSOFT_BARCODE_DB}
{.$define PSOFT_PRAGNAAN}
{.$DEFINE BARCODE_OCX}
{$define PSOFT_PDF417}
{.$define PSOFT_RAVE}
{.$define PSOFT_ACE}
{.$define PSOFT_RB}

{.$define PSOFT_CLX}





// *********************************************************************
// ***************  PLEASE, DON'T MODIFY LINES BELOW   *****************
// *********************************************************************

{$ifdef MSWINDOWS}
	{$IFDEF VER100} {Borland Delphi 3.0 }
	  {$DEFINE PSOFT_D3}
	{$ENDIF}

	{$IFDEF VER110} { Borland C++Builder 3.0 }
	  {$DEFINE PSOFT_CBUILDER3}
	{$ENDIF}

	{$IFDEF VER120} {Borland Delphi 4.0 }
	  {$DEFINE PSOFT_D3}
	  {$DEFINE PSOFT_D4}
	{$ENDIF}

	{$IFDEF VER125} {Borland C++ Builder 4.0 }
	  {$DEFINE PSOFT_CBUILDER4}
	{$ENDIF}

	{$IFDEF VER130} {Borland Delphi 5.0 }
	    {$ifdef BCB}
        	{$DEFINE PSOFT_BCB5}
	        {$ObjExportAll On}
	    {$else}
	        {$DEFINE PSOFT_D5}
	    {$endif}
	{$ENDIF}

	{$IFDEF VER140} {Borland Delphi 6.0 }
	  {$DEFINE PSOFT_D3}
	  {$DEFINE PSOFT_D4}
	  {$DEFINE PSOFT_D5}
	  {$define PSOFT_D6}
          {$ifdef BCB}
                {$define PSOFT_BCB6}
          {$endif}
	{$endif}

	{$IFDEF VER150} {Borland Delphi 7.0 }
	  {$DEFINE PSOFT_D3}
	  {$DEFINE PSOFT_D4}
	  {$DEFINE PSOFT_D5}
	  {$define PSOFT_D6}
	  {$define PSOFT_D7}
	{$endif}

	{$IFDEF VER210} {Borland Delphi 2010 }
	  {$DEFINE PSOFT_D3}
	  {$DEFINE PSOFT_D4}
	  {$DEFINE PSOFT_D5}
	  {$define PSOFT_D6}
	  {$define PSOFT_D7}
	{$endif}

	{$IFDEF VER220} {Borland Delphi XE2 }
	  {$DEFINE PSOFT_D3}
	  {$DEFINE PSOFT_D4}
	  {$DEFINE PSOFT_D5}
	  {$define PSOFT_D6}
	  {$define PSOFT_D7}
	{$endif}
	{$IFDEF VER230} {Borland Delphi XE3 }
	  {$DEFINE PSOFT_D3}
	  {$DEFINE PSOFT_D4}
	  {$DEFINE PSOFT_D5}
	  {$define PSOFT_D6}
	  {$define PSOFT_D7}
	{$endif}
	{$IFDEF VER240} {Borland Delphi XE4 }
	  {$DEFINE PSOFT_D3}
	  {$DEFINE PSOFT_D4}
	  {$DEFINE PSOFT_D5}
	  {$define PSOFT_D6}
	  {$define PSOFT_D7}
	{$endif}
	{$IFDEF VER250} {Borland Delphi XE5 }
	  {$DEFINE PSOFT_D3}
	  {$DEFINE PSOFT_D4}
	  {$DEFINE PSOFT_D5}
	  {$define PSOFT_D6}
	  {$define PSOFT_D7}
	{$endif}
	{$IFDEF VER260} {Borland Delphi XE6 }
	  {$DEFINE PSOFT_D3}
	  {$DEFINE PSOFT_D4}
	  {$DEFINE PSOFT_D5}
	  {$define PSOFT_D6}
	  {$define PSOFT_D7}
	{$endif}
	{$IFDEF VER270} {Borland Delphi XE7 }
	  {$DEFINE PSOFT_D3}
	  {$DEFINE PSOFT_D4}
	  {$DEFINE PSOFT_D5}
	  {$define PSOFT_D6}
	  {$define PSOFT_D7}
	{$endif}
	{$IFDEF VER280} {Borland Delphi XE8 }
	  {$DEFINE PSOFT_D3}
	  {$DEFINE PSOFT_D4}
	  {$DEFINE PSOFT_D5}
	  {$define PSOFT_D6}
	  {$define PSOFT_D7}
	{$endif}
	{$IFDEF VER290} {Borland Delphi XE9 }
	  {$DEFINE PSOFT_D3}
	  {$DEFINE PSOFT_D4}
	  {$DEFINE PSOFT_D5}
	  {$define PSOFT_D6}
	  {$define PSOFT_D7}
	{$endif}
	{$IFDEF VER300} {Borland Delphi X?? }
	  {$DEFINE PSOFT_D3}
	  {$DEFINE PSOFT_D4}
	  {$DEFINE PSOFT_D5}
	  {$define PSOFT_D6}
	  {$define PSOFT_D7}
	{$endif}

{$endif}

{$ifdef LINUX}
        {$DEFINE PSOFT_CLX}
{$endif}


{$ifdef PSOFT_CLX}
        {$UNDEF PSOFT_QREPORT}
{$endif}
