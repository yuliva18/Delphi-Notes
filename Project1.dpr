program Project1;

uses
  Vcl.Forms,
  MainUnit in 'MainUnit.pas' {Form1},
  NoteUnit in 'NoteUnit.pas',
  NoteFrameUnit in 'NoteFrameUnit.pas' {NoteFrame: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
