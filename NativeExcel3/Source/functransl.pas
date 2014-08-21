unit functransl;
interface
uses xlshash;

type
  TXLSFunctionTranslator = class
  private
    FHash: THashWideString;
  public
    constructor Create; 
    destructor Destroy; override;
    function Translate(name: widestring): widestring;
    procedure Add(NameEnglish: widestring; NameLocal: widestring);
    procedure Init; virtual;
  end;


function GetFunctionTranslator(CountryCode: integer): TXLSFunctionTranslator;

implementation


type

  TXLSFunctionTranslatorDe = class (TXLSFunctionTranslator)
  public
    procedure Init; override;
  end;




function GetFunctionTranslator(CountryCode: integer): TXLSFunctionTranslator;
begin
  case CountryCode of 
     $31: {German}
          Result := TXLSFunctionTranslatorDe.Create;
     else Result := nil; 
  end;
end;


constructor TXLSFunctionTranslator.Create;
begin
  inherited Create;
  FHash := nil;
  Init;
end;

destructor TXLSFunctionTranslator.Destroy;
begin
  if Assigned(FHash) then FHash.Free;
  inherited Destroy;
end;

function TXLSFunctionTranslator.Translate(name: widestring): widestring;
begin
  if Assigned(FHash) then begin
     Result := FHash[name];
     if Result = '' then Result := name;
  end else begin
     Result := name;
  end;
end;

procedure TXLSFunctionTranslator.Add(NameEnglish: widestring; NameLocal: widestring);
begin
  if not(Assigned(FHash)) then begin
     FHash := THashWideString.Create;
  end;
  FHash[NameLocal] := NameEnglish;
end;

procedure TXLSFunctionTranslator.Init;
begin
end;


procedure TXLSFunctionTranslatorDe.Init;
begin
  Add('ACCRINT',     'AUFGELZINS');
  Add('ACCRINTM',    'AUFGELZINSF');   
  Add('AMORDEGRC',   'AMORDEGRK');  
  Add('AMORLINC',    'AMORLINEARK');   
  Add('BIN2DEC',     'BININDEZ');
  Add('BIN2HEX',     'BININHEX');
  Add('BIN2OCT',     'BININOKT');
  Add('COMPLEX',     'KOMPLEXE');
  Add('CONVERT',     'UMWANDELN');
  Add('COUPDAYBS',   'ZINSTERMTAGVA'); 
  Add('COUPDAYS',    'ZINSTERMTAGE');  
  Add('COUPDAYSNC',  'ZINSTERMTAGNZ'); 
  Add('COUPNCD',     'ZINSTERMNZ');  
  Add('COUPNUM',     'ZINSTERMZAHL');
  Add('COUPPCD',     'ZINSTERMVZ');  
  Add('CUMIPMT',     'KUMZINSZ');
  Add('CUMPRINC',    'KUMKAPITAL');
  Add('DEC2BIN',     'DEZINBIN');
  Add('DEC2HEX',     'DEZINHEX');
  Add('DEC2OCT',     'DEZINOKT');
  Add('DELTA',       'DELTA');
  Add('DISC',        'DISAGIO');
  Add('DOLLARDE',    'NOTIERUNGDEZ');
  Add('DOLLARFR',    'NOTIERUNGBRU');
  Add('DURATION',    'DURATION');
  Add('EDATE',       'EDATUM');
  Add('EFFECT',      'EFFEKTIV');
  Add('EOMONTH',     'MONATSENDE');
  Add('ERF',         'GAUSSFEHLER');
  Add('ERFC',        'GAUSSFKOMPL');
  Add('FACTDOUBLE',  'ZWEIFAKULTAT');
  Add('FVSCHEDULE',  'ZW2');
  Add('GCD',         'GGT');
  Add('GESTEP',      'GGANZZAHL');
  Add('HEX2BIN',     'HEXINBIN');
  Add('HEX2DEC',     'HEXINDEZ');
  Add('HEC2OCT',     'HEXINOKT');
  Add('IMABS',       'IMABS');
  Add('IMAGINARY',   'IMAGINARTEIL');
  Add('IMARGUMENT',  'IMARGUMENT');
  Add('IMCONJUGATE', 'IMKONJUGIERTE');
  //Add('IMCOS',       'IMCOS');
  //Add('IMDIV',       'IMDIV');
  //Add('IMEXP',       'IMEXP');
  //Add('IMLN',        'IMLN');
  //Add('IMLOG10',     'IMLOG10');
  //Add('IMLOG2',      'IMLOG2');
  Add('IMPOWER',     'IMAPOTENZ');
  Add('IMPRODUCT',   'IMPRODUKT');
  Add('IMREAL',      'IMREALTEIL');
//Add('IMSIN',       'IMSIN');
  Add('IMSQRT',      'IMWURZEL');
//Add('IMSUB',       'IMSUB');
  Add('IMSUM',       'IMSUMME');
  Add('INTRATE',     'ZINSSATZ');
//Add('ISEVEN',      'ISEVEN');
  Add('ISODD',       'ISTUNGERADE');
  Add('LCM',         'KGV');
//  Add('MDURATION',   'MDURATION');
  Add('MROUND',      'VRUNDEN');
  Add('MULTINOMIAL', 'POLYNOMIAL');
  Add('NETWORKDAYS', 'NETTOARBEITSTAGE');
//  Add('NOMINAL',     'NOMINAL');
  Add('OCT2BIN',     'OKTINBIN');
  Add('OCT2DEC',     'OKTINDEZ');
  Add('OCT2HEX',     'OKTINHEX');
  Add('ODDFPRICE',   'UNREGER.KURS');
  Add('ODDFYIELD',   'UNREGER.REND');
  Add('ODDLPRICE',   'UNREGLE.KURS');
  Add('ODDLYIELD',   'UNREGLE.REND');
  Add('PRICE',       'KURS');
  Add('PRICEDISC',   'KURSDISAGIO');
  Add('PRICEMAT',    'KURSFALLIG');
//  Add('QUOTIENT',    'QUOTIENT');
  Add('RANDBETWEEN', 'ZUFALLSBEREICH');
  Add('RECEIVED',    'AUSZAHLUNG');
  Add('SERIESSUM',   'POTENZREIHE');
  Add('SQRTPI',      'WURZELPI');
  Add('TBILLEQ',     'TBILLAQUIV');
  Add('TBILLPRICE',  'TBILLKURS');
  Add('TBILLYIELD',  'TBILLRENDITE');
  Add('WEEKNUM',     'KALENDERWOCHE');
  Add('WORKDAY',     'ARBEITSTAG');
  Add('XIRR',        'XINTZINSFUSS');
  Add('XNPV',        'XKAPITALWERT');
  Add('YEARFRAC',    'BRTEILJAHRE');
  Add('YIELD',       'RENDITE');
  Add('YIELDDISC',   'RENDITEDIS');
  Add('YIELDMAT',    'RENDITEFALL');
end;                 


end.