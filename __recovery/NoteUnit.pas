unit NoteUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;


type
  TMyProcEvent = procedure(Sender: TObject) of object;
  Note = Class
    private
      FMyProcEvent : TMyProcEvent;
    protected
      procedure DoMyProcEvent(Sender: TObject);
    public
      id: integer;
      body: string;
      panel: TPanel;
      procedure Init(Sender: TObject; _id: integer; _body: string);
      procedure pC(Sender: TObject);
      property MyProcEvent: TMyProcEvent read FMyProcEvent write FMyProcEvent;
end;

implementation

//
procedure Note.DoMyProcEvent(Sender: TObject);
begin
  if Assigned(FMyProcEvent) then
    FMyProcEvent(Sender);
end;

procedure Note.Init(Sender: TObject; _id: integer; _body: string);
begin
  panel := TPanel.Create(TComponent(Sender));
  panel.Anchors := [akTop, akRight, akLeft];
  panel.Align := TAlign.alTop;
  id := _id;
  body := _body;
  panel.Caption := body;
  panel.OnClick := pC;
end;

procedure Note.pC(Sender: TObject);
begin
  DoMyProcEvent(Self);
end;

end.
