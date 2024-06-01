unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, NoteUnit, NoteFrameUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.Grids, Vcl.DBGrids;


type
  TForm1 = class(TForm)
    ScrollBox2: TScrollBox;
    Button1: TButton;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    Memo1: TMemo;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure DeleteNote(note: Note);
    procedure ChangeNote(Sender: TObject);
    procedure AddNote(n: Note);
    procedure ScrollBox2MouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ScrollBox2MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    sNote: Note;
  public
    notesList: TList;
  end;

var
  Form1: TForm1;


implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
s, i: INTEGER;
n: Note;
q: TFDQuery;
begin
  Memo1.Text := '';
  notesList := TList.Create();
  q := TFDQuery.Create(Self);
  q.Connection := FDConnection1;
  q.SQL.Text := 'SELECT * from notes';
  q.Open();
  while not q.Eof do
  begin
    n := Note.Create(self, q);
    AddNote(n);
    q.Next;
  end;
  q.Close();
  for i := 0 to notesList.Count - 1 do
  begin
    Note(notesList[notesList.Count - i - 1]).noteFrame.Parent := ScrollBox2;
  end;
  if notesList.Count > 0 then
    ChangeNote(notesList[0]);
end;

{$REGION 'ScrollEvents'}

procedure TForm1.ScrollBox2MouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  Scrollbox2.VertScrollBar.Position:= Scrollbox2.VertScrollBar.Position + 10;
end;

procedure TForm1.ScrollBox2MouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  Scrollbox2.VertScrollBar.Position:= Scrollbox2.VertScrollBar.Position - 10;
end;

{$ENDREGION}

procedure TForm1.Button1Click(Sender: TObject);
var n: Note;
begin
  n := Note.Create(Self, FDConnection1, '����� �������');
  AddNote(n);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if sNote <> nil then
    DeleteNote(sNote);
end;

procedure TForm1.ChangeNote(Sender: TObject);
begin
  if sNote <> nil then
    sNote.noteFrame.ParentBackground := true;
  sNote := Note(Sender);
  Memo1.Text := sNote.model.body;
  snote.noteFrame.ParentBackground := false;
  sNote.noteFrame.Color := RGB(220, 220, 220);
end;

procedure TForm1.AddNote(n: Note);
begin
  notesList.Add(n);
  n.SelectEvent := ChangeNote;
  n.noteFrame.Parent := ScrollBox2;
  ScrollBox2.Realign();
end;

procedure TForm1.DeleteNote(note: Note);
begin
  notesList.Remove(note);
  if notesList.Count > 0 then
    ChangeNote(notesList[notesList.Count - 1])
  else
    sNote := nil;
  ScrollBox2.RemoveControl(note.noteFrame);
  note.model.Delete();
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin
  if sNote <> nil then
    sNote.model.body := Memo1.Text;
end;

end.
