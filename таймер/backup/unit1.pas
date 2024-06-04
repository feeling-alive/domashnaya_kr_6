unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls, BASS;

type

  { TForm1 }

  TForm1 = class(TForm)
    stop: TBitBtn;
    start: TButton;
    sec: TEdit;
    min: TEdit;
    hour: TEdit;
    hour2: TLabel;
    min2: TLabel;
    sec2: TLabel;
    cifritimera: TMemo;
    Timer1: TTimer;
    procedure stopClick(Sender: TObject);
    procedure startClick(Sender: TObject);
    procedure secChange(Sender: TObject);
    procedure minChange(Sender: TObject);
    procedure hourChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public
        StreamHandle: HSTREAM;
  end;

var
  Form1: TForm1;
  h,m,s : integer;
  p: BASS_DX8_PARAMEQ;

implementation

{$R *.lfm}

{ TForm1 }



procedure TForm1.hourChange(Sender: TObject);
begin
  h := StrToIntDef(hour.Text, 0);
  if h > 24 then
    h := 24;
  hour.Text := IntToStr(h);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  if not  BASS_Init(-1, 44100, 0, Handle, nil) then
  exit();

end;
var
  IsSoundPlayed: Boolean = False;
  start1: Boolean = False;
procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if s > 0 then
  begin
    s := s - 1;
  end
  else
  begin
    if m > 0 then
    begin
      m := m - 1;
      s := 59;
    end
    else
    begin
      if h > 0 then
      begin
        h := h - 1;
        m := 59;
        s := 59;
      end
    end;
  end;
  Timer1.Enabled := False;
  if start.Enabled = False then
  begin
  Timer1.Enabled := True;
  end;
  cifritimera.Lines.Clear;
  cifritimera.Lines.Add(Format('%2.2d:%2.2d:%2.2d', [h, m, s]));
  if (s=0) and Timer1.Enabled = True and IsSoundPlayed = False then
   StreamHandle := BASS_StreamCreateFile(False, PChar('C:\dima.mp3'), 0, 0, 0 {$IFDEF UNICODE} or BASS_UNICODE {$ENDIF});
    if StreamHandle <> 0 then
    begin
      BASS_ChannelSetAttribute(StreamHandle, BASS_ATTRIB_VOL, 10);
      BASS_ChannelPlay(StreamHandle, False);
      IsSoundPlayed := True;
    end;
  end;

procedure TForm1.minChange(Sender: TObject);
begin
  m := StrToIntDef(min.Text, 0);
  if m > 60 then
    m := 60;
  min.Text := IntToStr(m);
end;

procedure TForm1.secChange(Sender: TObject);
begin
  s := StrToIntDef(sec.Text, 0);
  if s > 60 then
    s := 60;
  sec.Text := IntToStr(s);
end;

procedure TForm1.startClick(Sender: TObject);
begin
  h := StrToIntDef(hour.Text, 0);
  m := StrToIntDef(min.Text, 0);
  s := StrToIntDef(sec.Text, 0);

    Timer1.Enabled := True;
    start.Enabled := False;
    sec.Enabled := False;
    min.Enabled := False;
    hour.Enabled := False;
end;

procedure TForm1.stopClick(Sender: TObject);
begin
  BASS_ChannelStop(StreamHandle);
  BASS_StreamFree(StreamHandle);
  Timer1.Enabled := False;
  start.Enabled := True;
  sec.Enabled := True;
  min.Enabled := True;
  hour.Enabled := True;

  end;

end.

