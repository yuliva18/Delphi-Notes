unit NoteUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, NoteFrameUnit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.Grids, Vcl.DBGrids;

type
  TPropertyChangedEvent = procedure() of object;
  NoteModel = Class
    private
      _conn: TFDConnection;
      _id: integer;
      _date, _body, _title: string;
      procedure setBody(value: string);
      procedure setTitle(value: string);
      procedure Update();
      function GetNextNoteName(default: string) : string;
    public
      BodyPropertyChangedEvent: TPropertyChangedEvent;
      TitlePropertyChangedEvent: TPropertyChangedEvent;
      constructor Create(q: TFDQuery); overload;
      constructor Create(conn: TFDConnection; baseTitle: string); overload;
      property conn: TFDConnection read _conn;
      property id: integer read _id;
      property body: string read _body write setBody;
      property title: string read _title write setTitle;
      property date: string read _date;
      procedure Delete();
end;

type
  TSelectEvent = procedure(Sender: TObject) of object;
  Note = Class
    private
      FSelectEvent : TSelectEvent;
      _model: NoteModel;
      procedure Click(Sender: TObject);
      procedure DoSelectEvent(Sender: TObject);
      procedure ReviewBody();
      procedure ReviewTitle();
    public
      noteFrame: TNoteFrame;
      constructor Create(Sender: TObject; q: TFDQuery); overload;
      constructor Create(Sender: TObject; conn: TFDConnection; baseBody: string); overload;
      property SelectEvent: TSelectEvent read FSelectEvent write FSelectEvent;
      property model: NoteModel read _model;
end;

implementation

//-------------------------------------------------------------------------------------------------------
//                                             NoteModel
//-------------------------------------------------------------------------------------------------------

function toSQL(s: string) : string;
begin
  result := s.Replace('"','""').Replace('\','\\')	;
end;

procedure NoteModel.Update();
var
  q: TFDQuery;
begin
  q := TFDQuery.Create(nil);
  q.Connection := conn;
  q.SQL.Text := Format('UPDATE notes SET title = "%s", body = "%s" WHERE id = %d',[toSQL(title), toSQL(body), id]);
  q.ExecSQL();
end;

procedure NoteModel.Delete();
var
  q: TFDQuery;
begin
  q := TFDQuery.Create(nil);
  q.Connection := conn;
  q.SQL.Text := Format('DELETE FROM notes WHERE id = %d',[id]);
  q.ExecSQL();
end;

procedure NoteModel.setBody(value: String);
begin
  _body := value;
  if Assigned(BodyPropertyChangedEvent) then
    BodyPropertyChangedEvent();
    if conn <> nil then
      Update();
end;

procedure NoteModel.setTitle(value: String);
begin
  _title := value;
  if Assigned(TitlePropertyChangedEvent) then
    TitlePropertyChangedEvent();
    if conn <> nil then
      Update();
end;

function NoteModel.GetNextNoteName(default: string) : string;
var
q: TFDQuery;
id: integer;
begin
  q := TFDQuery.Create(nil);
  q.Connection := conn;
  q.SQL.Text := 'select min(cur - (cur != lg + 1) * (cur - lg - 1) + (cur = lg + 1)) as id from (select lag(cur, 1, 0) over () as lg, lead(cur, 1, 0) over () as ld, cur ' +
  'from (select distinct cast(substr(title, ' + (default.Length + 1).ToString() + ') AS integer) as cur from notes where title like "' + default+ ' %" order by cur)) ' +
  'where cur != lg + 1 or cur != ld - 1';
  q.Open();
  while not q.Eof do
  begin
    try
      id := q.FieldByName('id').AsInteger;
    except
       id := 1;
    end;
    q.Next;
  end;
  q.Close();
  Result := default + ' ' + id.ToString();
end;

constructor NoteModel.Create(q: TFDQuery);
begin
  self._id := q.FieldByName('id').AsInteger;
  self._title := q.FieldByName('title').AsString;
  self._body := q.FieldByName('body').AsString;
  self._date := q.FieldByName('date').AsString;
  self._conn := TFDConnection(q.Connection);
end;

constructor NoteModel.Create(conn: TFDConnection; baseTitle: string);
var
  q: TFDQuery;
  id: integer;
begin
  _conn := conn;
  title := GetNextNoteName(baseTitle);
  q := TFDQuery.Create(nil);
  q.Connection := conn;
  q.SQL.Text := Format('INSERT INTO notes(title, body) VALUES("%s", "%s")',[title, '']);
  q.ExecSQL();
  id := integer(conn.GetLastAutoGenValue('notes'));
  q.SQL.Text := Format('SELECT * FROM notes WHERE id = %d', [id]);
  q.Open();
  Create(q);
  q.Close();
end;

//-------------------------------------------------------------------------------------------------------
//                                                Note
//-------------------------------------------------------------------------------------------------------

constructor Note.Create(Sender: TObject; q: TFDQuery);
begin
  noteFrame := TNoteFrame.Create(nil);
  _model := NoteModel.Create(q);
  _model.BodyPropertyChangedEvent := ReviewBody;
  _model.TitlePropertyChangedEvent := ReviewTitle;
  noteFrame.TitleLabel.Caption := model.title;
  noteFrame.BodyLabel.Caption := (model.body + chr(13)).Split([chr(13)])[0];
  noteFrame.DateLabel.Caption := model.date;
  noteFrame.ClickEvent := Click;
end;

constructor Note.Create(Sender: TObject; conn: TFDConnection; baseBody: string);
begin
  noteFrame := TNoteFrame.Create(nil);
  _model := NoteModel.Create(conn, baseBody);
  _model.BodyPropertyChangedEvent := ReviewBody;
  _model.TitlePropertyChangedEvent := ReviewTitle;
  noteFrame.TitleLabel.Caption := model.title;
  noteFrame.BodyLabel.Caption := (model.body + chr(13)).Split([chr(13)])[0];
  noteFrame.DateLabel.Caption := model.date;
  noteFrame.ClickEvent := Click;
end;

procedure Note.DoSelectEvent(Sender: TObject);
begin
  if Assigned(FSelectEvent) then
    FSelectEvent(Sender);
end;

procedure Note.Click(Sender: TObject);
begin
  DoSelectEvent(Self);
end;

procedure Note.ReviewBody();
begin
  noteFrame.BodyLabel.Caption := (model.body + chr(13)).Split([chr(13)])[0];
end;

procedure Note.ReviewTitle();
begin
  noteFrame.TitleLabel.Caption := model.title;
end;

end.
