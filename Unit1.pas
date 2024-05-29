unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, NoteUnit, Unit2,
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
    procedure UpdateNote(note: Note);
    procedure InsertNote(body: String);
    procedure ChangeNote(Sender: TObject);
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
  notesList := TList.Create();
  q := TFDQuery.Create(Self);
  q.Connection := FDConnection1;
  q.SQL.Text := 'SELECT * from notes';
  q.Open();
  while not q.Eof do
  begin
    n := Note.Create();
    n.Init(Self, q.FieldByName('id').AsInteger, q.FieldByName('body').AsString);
    n.MyProcEvent := ChangeNote;
    notesList.Add(n);
    q.Next;
  end;
  q.Close();
  for i := 0 to notesList.Count - 1 do
  begin
    Note(notesList[notesList.Count - i - 1]).panel.Parent := ScrollBox2;
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
begin
  InsertNote('����� �������')
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  DeleteNote(sNote);
end;

procedure TForm1.ChangeNote(Sender: TObject);
begin
  if sNote <> nil then
    sNote.panel.ParentBackground := true;
  sNote := Note(Sender);
  Memo1.Text := sNote.body;
  snote.panel.ParentBackground := false;
  sNote.panel.Color := clRed;
end;

procedure TForm1.DeleteNote(note: Note);
var
q: TFDQuery;
begin
  notesList.Remove(note);
  if notesList.Count > 0 then
    ChangeNote(notesList[notesList.Count - 1]);
  ScrollBox2.RemoveControl(note.panel);
  q := TFDQuery.Create(Self);
  q.Connection := FDConnection1;
  q.SQL.Text := Format('DELETE FROM notes WHERE id = %d',[note.id]);
  q.ExecSQL();

end;

procedure TForm1.InsertNote(body: String);
var
q: TFDQuery;
id: integer;
n: Note;
begin
  q := TFDQuery.Create(Self);
  q.Connection := FDConnection1;
  q.SQL.Text := Format('INSERT INTO notes(body) VALUES("%s")',[body]);
  q.ExecSQL();
  id := integer(FDConnection1.GetLastAutoGenValue('notes'));
  q.SQL.Text := Format('SELECT * FROM notes WHERE id = %d', [id]);
  q.Open();
  while not q.Eof do
  begin
    n := Note.Create();
    n.Init(Self, q.FieldByName('id').AsInteger, q.FieldByName('body').AsString);
    n.MyProcEvent := ChangeNote;
    notesList.Add(n);
    n.panel.Parent := ScrollBox2;
    ScrollBox2.Realign();
    q.Next;
  end;
  q.Close();
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin
  UpdateNote(sNote);
end;

procedure TForm1.UpdateNote(note: Note);
var
q: TFDQuery;
s: string;
begin
  note.body := Memo1.Text;
  q := TFDQuery.Create(Self);
  q.Connection := FDConnection1;
  q.SQL.Text := Format('UPDATE notes SET body = "%s" WHERE id = %d',[note.body, note.id]);
  q.ExecSQL();
  note.panel.Caption := note.body;
end;

end.
