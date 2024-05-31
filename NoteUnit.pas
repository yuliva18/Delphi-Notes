unit NoteUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, NoteFrameUnit;


type
  TSelectEvent = procedure(Sender: TObject) of object;
  Note = Class
    private
      FSelectEvent : TSelectEvent;
      procedure Click(Sender: TObject);
    protected
      procedure DoSelectEvent(Sender: TObject);
    public
      id: integer;
      body: string;
      date: string;
      noteFrame: TNoteFrame;
      procedure Init(Sender: TObject; _id: integer; _body: string; _date: string);
      property SelectEvent: TSelectEvent read FSelectEvent write FSelectEvent;
end;

implementation

procedure Note.DoSelectEvent(Sender: TObject);
begin
  if Assigned(FSelectEvent) then
    FSelectEvent(Sender);
end;

procedure Note.Init(Sender: TObject; _id: integer; _body: string; _date: string);
begin
  noteFrame := TNoteFrame.Create(nil);
  id := _id;
  body := _body;
  date := _date;
  noteFrame.BodyLabel.Caption := body.Split([chr(13)])[0];
  noteFrame.DateLabel.Caption := date;
  noteFrame.ClickEvent := Click;
end;

procedure Note.Click(Sender: TObject);
begin
  DoSelectEvent(Self);
end;

end.
