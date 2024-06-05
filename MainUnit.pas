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
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.Grids, Vcl.DBGrids, System.Generics.Defaults,
  Vcl.ComCtrls, System.ImageList, Vcl.ImgList;


type
  TForm1 = class(TForm)
    ScrollBox2: TScrollBox;
    Button1: TButton;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    Button2: TButton;
    Edit1: TEdit;
    ComboBox1: TComboBox;
    ButtonBold: TButton;
    RichEdit1: TRichEdit;
    ButtonItalic: TButton;
    ButtonUnderline: TButton;
    ButtonStrikeOut: TButton;
    ButtonTaLeft: TButton;
    ImageList1: TImageList;
    ButtonTaCenter: TButton;
    ButtonTaRight: TButton;
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
    procedure RichEdit1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ButtonBoldClick(Sender: TObject);
    procedure ButtonItalicClick(Sender: TObject);
    procedure ButtonUnderlineClick(Sender: TObject);
    procedure ButtonStrikeOutClick(Sender: TObject);
    procedure ButtonTaLeftClick(Sender: TObject);
    procedure ButtonTaCenterClick(Sender: TObject);
    procedure ButtonTaRightClick(Sender: TObject);
  private
    sNote: Note;
  public
    notesList: TList;
  end;

var
  Form1: TForm1;


implementation

{$R *.dfm}

function TStringsToString(ln: TStrings):string;
var
  ts: TStringStream;
begin
  ts := TStringStream.Create();
  ln.SaveToStream(ts);
  result := ts.DataString;
end;

procedure LoadStringToRE(s :string; re :TRichEdit);
var
  ts: TStringStream;
  ss: string;
begin
  ts := TStringStream.Create();
  ts.WriteString(s);
  re.PlainText := false;
  ts.Position := 0;
  re.Lines.LoadFromStream(ts);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
s, i: INTEGER;
n: Note;
q: TFDQuery;
begin
  RichEdit1.Text := '';
  Edit1.Text := '';
  ComboBox1.Items.Add('А-Я');
  ComboBox1.Items.Add('Я-А');
  ComboBox1.Items.Add('Сначала новые');
  ComboBox1.Items.Add('Сначала старые');
  ComboBox1.Style:=csDropDownList;
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
    Note(notesList[i]).noteFrame.Parent := ScrollBox2;
  end;
  Combobox1.ItemIndex := 2;
  Sort();
  if notesList.Count > 0 then
    ChangeNote(notesList[0])
  else
    begin
      RichEdit1.Enabled := false;
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
  n := Note.Create(Self, FDConnection1, 'Новая заметка');
  AddNote(n);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if sNote <> nil then
    DeleteNote(sNote);
end;

{$REGION 'StyleButtonsEvents'}

procedure TForm1.ButtonBoldClick(Sender: TObject);
var
  i: integer;
  Bold: Boolean;
const
  FS: array [0..0, Boolean] of TFontStyles = (([],[fsBold]));
begin
  i := RichEdit1.SelLength;
  RichEdit1.SelLength := 1;
  Bold := RichEdit1.SelAttributes.Bold;
  RichEdit1.SelLength := i;
  RichEdit1.SelAttributes.Bold := not Bold;
end;

procedure TForm1.ButtonItalicClick(Sender: TObject);
var
  i: integer;
  Italic: Boolean;
begin
  i := RichEdit1.SelLength;
  RichEdit1.SelLength := 1;
  Italic := RichEdit1.SelAttributes.Italic;
  RichEdit1.SelLength := i;
  RichEdit1.SelAttributes.Italic := not Italic;
end;

procedure TForm1.ButtonUnderlineClick(Sender: TObject);
var
  i: integer;
  Underline: Boolean;
begin
  i := RichEdit1.SelLength;
  RichEdit1.SelLength := 1;
  Underline := RichEdit1.SelAttributes.Underline;
  RichEdit1.SelLength := i;
  RichEdit1.SelAttributes.Underline := not Underline;
end;

procedure TForm1.ButtonStrikeOutClick(Sender: TObject);
var
  i: integer;
  StrikeOut: Boolean;
begin
  i := RichEdit1.SelLength;
  RichEdit1.SelLength := 1;
  StrikeOut := RichEdit1.SelAttributes.StrikeOut;
  RichEdit1.SelLength := i;
  RichEdit1.SelAttributes.StrikeOut := not StrikeOut;
end;

procedure TForm1.ButtonTaCenterClick(Sender: TObject);
begin
  RichEdit1.Paragraph.Alignment := taCenter;
end;

procedure TForm1.ButtonTaLeftClick(Sender: TObject);
begin
  RichEdit1.Paragraph.Alignment := taLeftJustify;
end;

procedure TForm1.ButtonTaRightClick(Sender: TObject);
begin
  RichEdit1.Paragraph.Alignment := taRightJustify;
end;

{$ENDREGION}

procedure TForm1.ChangeNote(Sender: TObject);
begin
  if sNote <> nil then
    sNote.noteFrame.ParentBackground := true;
  sNote := Note(Sender);
  LoadStringToRE(sNote.model.body, RichEdit1);
//  RichEdit1.SelectAll;
//  RichEdit1.Paragraph.FirstIndent := 100;
//  RichEdit1.Paragraph.LeftIndent := 0;
//  RichEdit1.Paragraph.RightIndent := 100;
//  RichEdit1.SelLength := 0;
  RichEdit1.Enabled := true;
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

procedure TForm1.NotesToScrollBox;
var
  i: Integer;
begin
  for i := 0 to notesList.Count - 1 do
    Note(notesList[i]).noteFrame.Parent := ScrollBox2;
  ScrollBox2.EnableAlign();
  ScrollBox2.Realign();
end;

procedure TForm1.Sort;
var
  i: Integer;
begin
  ScrollBox2.Visible := false;
  ScrollBox2.DisableAlign();
  for i := 0 to notesList.Count - 1 do
  begin
    Note(notesList[i]).noteFrame.Parent := nil;
    Note(notesList[i]).CreateFrame();
  end;
  case ComboBox1.ItemIndex of
    0: notesList.Sort(titlelr);
    1: notesList.Sort(titlerl);
    2: notesList.Sort(idrl);
    3: notesList.Sort(idlr);
  end;
  NotesToScrollBox();
  if sNote <> nil then
    ChangeNote(sNote);
  ScrollBox2.Visible := true;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  Sort();
end;

procedure TForm1.AddNote(n: Note);
var i:integer;
begin
  n.SelectEvent := ChangeNote;
  notesList.Add(n);
  n.CreateFrame();
  ScrollBox2.Visible := false;
  n.noteFrame.Parent := Scrollbox2;
  Scrollbox2.Realign();
  ScrollBox2.Visible := true;
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
      RichEdit1.Text := '';
      RichEdit1.Enabled := false;
      Edit1.Text := '';
      Edit1.Enabled := false;
    end;
  ScrollBox2.RemoveControl(note.noteFrame);
  note.model.Delete();
  note.Free();
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  if sNote <> nil then
    sNote.model.title := Edit1.Text;
end;

procedure TForm1.RichEdit1Change(Sender: TObject);
begin
  if sNote <> nil then
    sNote.model.body := TStringsToString(RichEdit1.Lines);
end;

end.
