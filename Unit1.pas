unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    ScrollBox1: TScrollBox;
    ScrollBox2: TScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure aaa(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  a: TList;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
s, i: INTEGER;
p: TPanel;
begin
  s := 15;
  a := TList.Create();
  for i := 0 to s-1 do
  begin
    p := TPanel.Create(Self);
    p.Caption := i.ToString();
    p.Anchors := [akTop, akRight, akLeft];
    p.Align := TAlign.alTop;
    p.OnClick := aaa;
    a.Add(p);
  end;
  for i := 0 to a.Count - 1 do
  begin
    TPanel(a[i]).Parent := ScrollBox2;
  end;
end;

procedure TForm1.aaa(Sender: TObject);
begin
  a.Remove(TPanel(Sender));
  ScrollBox2.RemoveControl(TPanel(Sender));
  ShowMessage(Format('����� ������� %s, �������� ��������� %d', [TPanel(Sender).Caption, a.Count]));
end;





end.