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

//Класс для хранения данных заметки из бд
type
  TPropertyChangedEvent = procedure() of object;
  NoteModel = Class
    private
      _conn: TFDConnection;
      _id: integer;
      _date, _body, _title, _rtf: string;
      procedure setBody(value: string);
      procedure setRtf(value: string);
      procedure setTitle(value: string);
      procedure Update();
      function GetNextNoteName(default: string) : string;
    public
      BodyPropertyChangedEvent: TPropertyChangedEvent;
      TitlePropertyChangedEvent: TPropertyChangedEvent;
      RtfPropertyChangedEvent: TPropertyChangedEvent;
      constructor Create(q: TFDQuery); overload;
      constructor Create(conn: TFDConnection; baseTitle: string); overload;
      property conn: TFDConnection read _conn;
      property id: integer read _id;
      property body: string read _body write setBody;
      property title: string read _title write setTitle;
      property rtf: string read _rtf write setRtf;
      property date: string read _date;
      procedure Delete();
end;

//Класс для связи NoteFrame и NoteModel
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
      constructor Create(q: TFDQuery); overload;
      constructor Create(conn: TFDConnection; baseTitle: string); overload;
      property SelectEvent: TSelectEvent read FSelectEvent write FSelectEvent;
      property model: NoteModel read _model;
      procedure CreateFrame();
end;

implementation

//-------------------------------------------------------------------------------------------------------
//                                             NoteModel
//-------------------------------------------------------------------------------------------------------

function toSQL(s: string) : string;
begin
  s := s.Replace('"','""').Replace('\','\\').Replace('!','!!').Replace('&','"||chr(38)||"');
  result := s;
end;

//Обновление заметки в бд
procedure NoteModel.Update();
var
  q: TFDQuery;
  s: string;
begin
  q := TFDQuery.Create(nil);
  q.Connection := conn;
  s := body;
  q.SQL.Text := Format('UPDATE notes SET title = "%s", body = "%s" WHERE id = %d',[toSQL(title), toSQL(body), id]);
  q.ExecSQL();
  q.SQL.Text := Format('SELECT * from notes  WHERE id = %d', [id]);
  q.Active := true;
  q.Edit;
  q.FieldByName('rtf').AsAnsiString := rtf;
  q.Post;
  q.Active := false;
  q.Free();
end;

//Удаление заметки из бд
procedure NoteModel.Delete();
var
  q: TFDQuery;
begin
  q := TFDQuery.Create(nil);
  q.Connection := conn;
  q.SQL.Text := Format('DELETE FROM notes WHERE id = %d',[id]);
  q.ExecSQL();
  q.Free();
end;

//Set-теры, вызывающие Update в бд
procedure NoteModel.setBody(value: String);
begin
  _body := value;
  if Assigned(BodyPropertyChangedEvent) then
    BodyPropertyChangedEvent();
    if conn <> nil then
      Update();
end;

procedure NoteModel.setRtf(value: String);
begin
  _rtf := value;
  if Assigned(RtfPropertyChangedEvent) then
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

//Получение следующего стандартного имени заметки (Новая заметка 1 -> Новая заметка 2)
function NoteModel.GetNextNoteName(default: string) : string;
var
q: TFDQuery;
id: integer;
begin
  q := TFDQuery.Create(nil);
  q.Connection := conn;
  q.SQL.Text := 'select min(cur - (cur != lg + 1) * (cur - lg - 1) + (cur = lg + 1)) as id from (select lag(cur, 1, 0) over () as lg, lead(cur, 1, 0) over () as ld, cur ' +
  'from (select distinct cast(s AS integer) as cur from (select substr(title, ' + (default.Length + 1).ToString() +
  ') as s from notes where title like "' + default +' %") where s = cast(s AS integer) order by cur)) ' +
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
  q.Free();
end;

//Конструктор для заметки, существующей в бд
constructor NoteModel.Create(q: TFDQuery);
begin
  self._id := q.FieldByName('id').AsInteger;
  self._title := q.FieldByName('title').AsString;
  self._rtf := q.FieldByName('rtf').AsAnsiString;
  self._body := q.FieldByName('body').AsString;
  self._date := q.FieldByName('date').AsString;
  self._conn := TFDConnection(q.Connection);
end;

//Конструктор для заметки, которая не существует в бд
constructor NoteModel.Create(conn: TFDConnection; baseTitle: string);
var
  q: TFDQuery;
  id: integer;
begin
  _conn := conn;
  _title := GetNextNoteName(baseTitle);
  q := TFDQuery.Create(nil);
  q.Connection := conn;
  q.SQL.Text := Format('INSERT INTO notes(title, body, rtf) VALUES("%s", "%s", "%s")',[title, '', '']);
  q.ExecSQL();
  id := integer(conn.GetLastAutoGenValue('notes'));
  q.SQL.Text := Format('SELECT * FROM notes WHERE id = %d', [id]);
  q.Open();
  Create(q);
  q.Close();
  q.Free();
end;

//-------------------------------------------------------------------------------------------------------
//                                                Note
//-------------------------------------------------------------------------------------------------------

//Конструктор для заметки, существующей в бд
constructor Note.Create(q: TFDQuery);
begin
  _model := NoteModel.Create(q);
  _model.BodyPropertyChangedEvent := ReviewBody;
  _model.TitlePropertyChangedEvent := ReviewTitle;
  CreateFrame();
end;

//Конструктор для заметки, которая не существует в бд
constructor Note.Create(conn: TFDConnection; baseTitle: string);
begin

  _model := NoteModel.Create(conn, baseTitle);
  _model.BodyPropertyChangedEvent := ReviewBody;
  _model.TitlePropertyChangedEvent := ReviewTitle;
  CreateFrame();

end;

//Создание/пересоздание NoteFrame для заметки
procedure Note.CreateFrame();
begin
  noteFrame.Free();
  noteFrame := TNoteFrame.Create(nil);
  noteFrame.TitleLabel.Caption := model.title;
  noteFrame.BodyLabel.Caption := (model.body + chr(13)).Split([chr(13)])[0];
  noteFrame.DateLabel.Caption := model.date;
  noteFrame.ClickEvent := Click;
end;

//Обработчики
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
