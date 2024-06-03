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
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.Grids, Vcl.DBGrids, System.Generics.Defaults;


type
  TForm1 = class(TForm)
    ScrollBox2: TScrollBox;
    Button1: TButton;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    Memo1: TMemo;
    Button2: TButton;
    Edit1: TEdit;
    ComboBox1: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure DeleteNote(note: Note);
    procedure ChangeNote(Sender: TObject);
    procedure AddNote(n: Note);
    procedure Sort();
    procedure NotesToScrollBox();
    procedure ScrollBox2MouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ScrollBox2MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
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
  Edit1.Text := '';
  ComboBox1.Items.Add('�-�');
  ComboBox1.Items.Add('�-�');
  ComboBox1.Items.Add('������� �����');
  ComboBox1.Items.Add('������� ������');
  ComboBox1.Style:=csDropDownList;
  notesList := TList.Create();
  q := TFDQuery.Create(Self);
  q.Connection := FDConnection1;
  q.SQL.Text := 'SELECT * from notes';
  Combobox1.ItemIndex := 2;
  Sort();
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
    Note(notesList[i]).noteFrame.Parent := ScrollBox2;
  end;
  if notesList.Count > 0 then
    ChangeNote(notesList[0])
  else
    begin
      Memo1.Enabled := false;
      Edit1.Enabled := false;
    end;
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
  Memo1.Enabled := true;
  Edit1.Text := sNote.model.title;
  Edit1.Enabled := true;
  snote.noteFrame.ParentBackground := false;
  sNote.noteFrame.Color := RGB(220, 220, 220);
end;

function idlr(Item1 : Pointer; Item2 : Pointer) : Integer;
var
  l, r : Note;
begin
  l := Note(Item1);
  r := Note(Item2);
  result := l.model.id - r.model.id;
end;

function idrl(Item1 : Pointer; Item2 : Pointer) : Integer;
begin
  result := idlr(Item1, Item2) * -1;
end;

function titlelr(Item1 : Pointer; Item2 : Pointer) : Integer;
var
  l, r : Note;
begin
  l := Note(Item1);
  r := Note(Item2);
  if l.model.title > r.model.title then
    result := 1
  else if l.model.title < r.model.title then
    result := -1
  else
    result := 0;
end;

function titlerl(Item1 : Pointer; Item2 : Pointer) : Integer;
begin
  result := titlelr(Item1, Item2) * -1;
end;

procedure TForm1.NotesToScrollBox();
var
i: integer;
begin
  ScrollBox2.DestroyComponents();
  ScrollBox2.DisableAlign();
  for i := 0 to notesList.Count - 1 do
  begin
    Note(notesList[i]).noteFrame.Parent := ScrollBox2;
  end;
  ScrollBox2.EnableAlign();
end;

procedure TForm1.Sort();
var
  i: Integer;
begin
  for i := 0 to notesList.Count - 1 do
  begin
    Note(notesList[i]).noteFrame.Parent := nil;
  end;
  if ComboBox1.ItemIndex = 0 then
    notesList.Sort(titlelr)
  else if ComboBox1.ItemIndex = 1 then
    notesList.Sort(titlerl)
  else if ComboBox1.ItemIndex = 2 then
    notesList.Sort(idrl)
  else if ComboBox1.ItemIndex = 3 then
    notesList.Sort(idlr);
  NotesToScrollbox();
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  Sort();
end;

procedure TForm1.AddNote(n: Note);
begin
  n.SelectEvent := ChangeNote;
  notesList.Add(n);
  Sort();
  ChangeNote(n);
end;

procedure TForm1.DeleteNote(note: Note);
begin
  notesList.Remove(note);
  if notesList.Count > 0 then
    ChangeNote(notesList[notesList.Count - 1])
  else
    begin
      sNote := nil;
      Memo1.Text := '';
      Memo1.Enabled := false;
      Edit1.Text := '';
      Edit1.Enabled := false;
    end;
  ScrollBox2.RemoveControl(note.noteFrame);
  note.model.Delete();
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  if sNote <> nil then
    sNote.model.title := Edit1.Text;
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin
  if sNote <> nil then
    sNote.model.body := Memo1.Text;
end;

end.
