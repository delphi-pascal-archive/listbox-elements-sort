program PListe;

uses
  Forms,
  UListe in 'UListe.pas' {FListe};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFListe, FListe);
  Application.Run;
end.
