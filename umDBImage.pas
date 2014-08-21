{***************************************************************************
 umDBImage: data-aware TImage component. Automatically recognize the image
 format of BLOB field and shows pictures in BMP and JPG formats.
 It also able to display GIF-images but only if you have installed Anders
 Melander's GIFImage (see http://www.melander.dk/delphi/index.html).

 umDBImage v1.0: FREEWARE, but not supported by author
 Copyright (c) 2001, Utilmind Solutions
 WWW: http://www.appcontrols.com
      http://www.utilmind.com
***************************************************************************}

(*
  02.01.08 MD  JPG beginnt mit FF D8
  06.03.14 md  TPdfImage
*)

// Uncomment next line to let it to support Anders Melander's TGIFImage
// {$DEFINE USEGIF}

// Uncomment next line to let it to support Thomas Friedmann's TPDFImage
{$DEFINE USEPDF}

unit umDBImage;

interface

uses
  Windows, Messages, Classes, Controls,
  ExtCtrls, DB, DBCtrls;

type
  TumDBImage = class(TImage)
  private
    FDataLink: TFieldDataLink;
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;

    procedure DataChange(Sender: TObject);
  protected
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;

    procedure LoadPicture; virtual;    
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;

    property Field: TField read GetField;
  published
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
  end;

procedure Register;

implementation
//{$R umDBImage.dcr}
uses
  Graphics, {$IFDEF USEGIF} GIFImage, {$ENDIF} {$IFDEF USEPDF} itfPDFImage, {$ENDIF}
  JPEG, SysUtils;

{ TumDBImage }
constructor TumDBImage.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  ControlStyle := ControlStyle + [csReplicatable];
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
end;

destructor TumDBImage.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

procedure TumDBImage.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then DataChange(Self);
end;

procedure TumDBImage.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and (FDataLink <> nil) and
    (AComponent = DataSource) then DataSource := nil;
end;

function TumDBImage.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

procedure TumDBImage.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  if Value <> nil then Value.FreeNotification(Self);
end;

function TumDBImage.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

procedure TumDBImage.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

function TumDBImage.GetField: TField;
begin
  Result := FDataLink.Field;
end;

procedure TumDBImage.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

procedure TumDBImage.DataChange(Sender: TObject);
begin
  if (FDataLink.Field <> nil) and not FDataLink.Field.IsNull then  //MD IsNull
    LoadPicture
  else
    Picture.Graphic := nil;
end;

//<<<MD SMH Cam Axis2120

function CharN(S: string): char;
begin
  if length(S) >= 1 then
    result := S[length(S)] else
    result := #0;
end;

function ValidDir(S: string): string;
begin
  if (S <> '') and (CharN(S) <> '\') then
    result := S + '\' else
    result := S;
end;

function TempDir: string;
var
  Buffer: array[0..250] of char;
begin
  GetTempPath(sizeof(Buffer), Buffer);
  result := ValidDir(StrPas(Buffer));
end;

procedure TumDBImage.LoadPicture;
var
  IsJPG: Boolean;
  MS: TMemoryStream;
  JPG: TJPEGImage;
  IsPDF: Boolean;  //%PDF
{$IFDEF USEGIF}
  GIF: TGIFImage;
{$ENDIF}
{$IFDEF USEPDF}
  PDF: TPDFImage;
{$ENDIF}
begin
  if not Field.IsBlob then
   begin
    Picture.Graphic := nil;
    Exit;
   end;

  IsPDF := false;
  with Field as TBlobField do
  begin
    IsJPG := (Pos('JFIF', Copy(AsString, 1, 10)) <> 0) or
             (Copy(AsAnsiString, 1, 2) = #$FF#$D8);
    if not IsJPG then                   // if not JPG
    begin
      if Copy(AsString, 1, 4) = '%PDF' then
      begin
        IsPDF := True;
      end else
      if Copy(AsString, 1, 3) <> 'GIF' then // and not GIF
      begin
        try
          Picture.Assign(Field);           // this is BMP ??
          Exit;
        except
          //<<<MD SMH Cam Axis2120
          IsJPG := true;
          {TBlobField(Field).SaveToFile(TempDir + Field.FieldName + '.um.jpg');
          Picture.LoadFromFile(TempDir + TBlobField(Field).FieldName + '.um.jpg');}
          //<<<MD
        end;
      end;
    end;
  end;

  MS := TMemoryStream.Create;
  try
    TBlobField(Field).SaveToStream(MS);
    MS.Seek(soFromBeginning, 0);

    if IsJPG then
    begin
      JPG := TJPEGImage.Create;
      try
        JPG.LoadFromStream(MS);
        Picture.Assign(JPG);
      finally
        JPG.Free;
      end;
    end else
{$IFDEF USEPDF}
    if IsPDF then
    begin
      PDF := TPDFImage.Create;
      try
        PDF.LoadFromStream(MS);
        Picture.Bitmap.Assign(PDF);
      finally
        PDF.Free;
      end;
    end else
{$ENDIF}
    begin
{$IFDEF USEGIF}
      GIF := TGIFImage.Create;
      try
        GIF.LoadFromStream(MS);
        Picture.Assign(GIF);
      finally
        GIF.Free;
      end;
{$ELSE}
      Picture.Graphic := nil;
{$ENDIF}
    end;
  finally
    MS.Free;
  end;
end;

procedure Register;
begin
  RegisterComponents('Addons', [TumDBImage]);
end;

end.
