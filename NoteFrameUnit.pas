unit NoteFrameUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

//Это "плашка" заметки, которая отображается в списке всех заметок
type
  TClickEvent = procedure(Sender: TObject) of object;
  TNoteFrame = class(TFrame)
    BodyLabel: TLabel;
    DateLabel: TLabel;
    TitleLabel: TLabel;
    procedure DoClickEvent(Sender: TObject);
  private
    FClickEvent : TClickEvent;
  public
    property ClickEvent: TClickEvent read FClickEvent write FClickEvent;
  end;

implementation

{$R *.dfm}


procedure TNoteFrame.DoClickEvent(Sender: TObject);
begin
  if Assigned(FClickEvent) then
    FClickEvent(Sender);
end;


end.
