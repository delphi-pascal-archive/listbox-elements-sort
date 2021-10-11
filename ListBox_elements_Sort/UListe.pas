unit UListe;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Graphics;

type
    TFListe = class(TForm)
    Panel4: TPanel;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    BFin: TButton;
    ListBox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    ListBox4: TListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel5: TPanel;
    BEfface: TButton;
    procedure FormShow(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
    procedure RadioClick(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ListBox2DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ListBox3DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ListBox4DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure BEffaceClick(Sender: TObject);

  private
    { Déclarations privées }
  public
  end;
const
     Nombre = 20;
type
    PEns = ^REns;
    REns = record
                 nom : string;
                 cod : Integer;
                 dat : TDateTime;
           end;
var
   FListe : TFListe;
   Ens : PEns;
   ANom : array[0..Nombre] of string =
   ('Paris','Lyon','Agent','Avignon','Brest','Dijon','Sens',
    'Auxerre','Rouen','Toulouse','Marseille','Toulon','Perpignan','Caen',
    'Annecy','Metz','Strasbourg','Dunkerque','Le Havre','Cherbourg','Dax');
   ACode : array[0..Nombre] of Integer = (75000,69001,47000,84000,29200,
    21000,89100,89000,76000,31000,13001,83000,66000,14000,74000,57000,
    67000,59140,76600,50100,40100);
   ADate : array[0..Nombre] of TDate = (37234,35824,37953,36584,39542,38258,
    35615,35563,35844,35058,36975,36479,35742,36856,37453,36472,36531,39973,
    38628,37584,36176);
   Liste : array[1..4] of TList;
   LAuxi : array[1..2] of TList;

implementation

{$R *.DFM}

(***************************** Trie des listes *******************************)

function TriInv(Item1,Item2 : Pointer) : Integer;
// Fonction de tri sur le nom
begin
     if Item1 = nil then if Item2 = nil then Result := 0
                                        else Result := -1
                    else if Item2 = nil then Result := 1
                                        else
     if PEns(Item1).nom > PEns(Item2).nom then Result := -1
                                          else
     if PEns(Item1).nom < PEns(Item2).nom then Result := 1
                                          else Result := 0;
end;

function TriNom(Item1,Item2 : Pointer) : Integer;
// Fonction de tri sur le nom
begin
     if Item1 = nil then if Item2 = nil then Result := 0
                                        else Result := -1
                    else if Item2 = nil then Result := 1
                                        else
     if PEns(Item1).nom < PEns(Item2).nom then Result := -1
                                          else
     if PEns(Item1).nom > PEns(Item2).nom then Result := 1
                                          else Result := 0;
end;

function TriCode(Item1,Item2 : Pointer) : Integer;
// Fonction de tri sur le numéro
begin
     if Item1 = nil then if Item2 = nil then Result := 0
                                        else Result := -1
                    else if Item2 = nil then Result := 1
                                        else
     if PEns(Item1).cod < PEns(Item2).cod then Result := -1
                                          else
     if PEns(Item1).cod > PEns(Item2).cod then Result := 1
                                          else Result := 0;
end;

function TriDate(Item1,Item2 : Pointer) : Integer;
// Fonction de tri sur la date
begin
     if Item1 = nil then if Item2 = nil then Result := 0
                                        else Result := -1
                    else if Item2 = nil then Result := 1
                                        else
     if PEns(Item1).dat < PEns(Item2).dat then Result := -1
                                          else
     if PEns(Item1).dat > PEns(Item2).dat then Result := 1
                                          else Result := 0;
end;

(************************* Utilisation des listes ****************************)

procedure Affiche(Lst : TList;Box : TListBox);
var
   i : Integer;
begin
     Box.Clear;
     if Lst.Count > 0 then for i := 0 to Lst.Count - 1 do
     begin
          ens := Lst.Items[i];
          Box.Items.Add(ens^.nom + IntToStr(ens^.cod) +
          FormatDateTime('dddd, d mmmm yyyy',ens^.dat));
     end;
end;

procedure Nom(Lst : TList);
begin
     FListe.ListBox1.Hint := 'Liste 1' + #13 + 'En ordre alphabétique';
     Lst.Sort(TriNom);
     FListe.ListBox1.Tag := 1;
     Affiche(Lst,FListe.ListBox1);
end;

procedure Code(Lst : TList);
begin
     FListe.ListBox3.Hint := 'Liste 2' + #13 + 'Triée par valeur';
     Lst.Sort(TriCode);
     FListe.ListBox2.Tag := 1;
     Affiche(Lst,FListe.ListBox2);
end;

procedure Date(Lst : TList);
begin
     FListe.ListBox4.Hint := 'Liste 3' + #13 + 'Triée par date';
     Lst.Sort(TriDate);
     FListe.ListBox3.Tag := 1;
     Affiche(Lst,FListe.ListBox3);
end;

procedure NomInv(Lst : TList);
begin
     FListe.ListBox2.Hint := 'Liste 4' + #13 + 'En inverse alphabétique';
     Lst.Sort(TriInv);
     FListe.ListBox4.Tag := 1;
     Affiche(Lst,FListe.ListBox4);
end;

procedure FaitAuxi;
var
   i : Byte;
begin
     LAuxi[1].Clear;
     LAuxi[2].Clear;
     for i := 0 to Liste[1].Count - 1 do
     begin
          if i < 15 then LAuxi[1].Add(Liste[1].Items[i]);
          if i > 4 then LAuxi[2].Add(Liste[1].Items[i]);
     end;
end;

procedure FaitListe;
var
   i : Byte;
begin
     Liste[1].Clear;
     for i := 0 to Nombre do
     begin
          New(Ens);
          Ens^.nom := ANom[i];
          Ens^.cod := ACode[i];
          Ens^.dat := ADate[i];
          Liste[1].Add(Ens);
     end;
end;

procedure TFListe.FormShow(Sender: TObject);
begin
     FListe.ListBox1.Hint := 'Liste 1' + #13 + 'Montre la liste d''origine';
     FaitListe;
     FListe.ListBox1.Tag := 1;
     Affiche(Liste[1],FListe.ListBox1);
     FaitAuxi;
end;

procedure TFListe.ButtonClick(Sender: TObject);
begin
     Application.Terminate
end;
(*************************** Mixage des fichiers ******************************)
procedure FaitListe5;
begin
     FListe.ListBox4.Hint := 'Liste 4' + #13 + 'Addition sans les articles' +
                                         #13 + 'existant dans chaque liste';
     FListe.ListBox4.Clear;
     Liste[1].Assign(LAuxi[1]);
     FListe.ListBox4.Tag := 1;
     Liste[1].Assign(LAuxi[2],laXor,nil);
     if Liste[1].Count > 0 then
     Affiche(Liste[1],FListe.ListBox4);
end;

procedure FaitListe4;
begin
     FListe.ListBox4.Hint := 'Liste 4' + #13 + 'Addition sans les articles' +
                                         #13 + 'de la liste 3';
     FListe.ListBox4.Clear;
     Liste[1].Assign(LAuxi[1]);
     FListe.ListBox4.Tag := 1;
     Liste[1].Assign(LAuxi[2],laSrcUnique,nil);
     if Liste[1].Count > 0 then
     Affiche(Liste[1],FListe.ListBox4);
end;

procedure FaitListe3;
begin
     FListe.ListBox4.Hint := 'Liste 4' + #13 + 'Addition sans doublons';
     FListe.ListBox4.Clear;
     Liste[1].Assign(LAuxi[1]);
     FListe.ListBox4.Tag := 1;
     Liste[1].Assign(LAuxi[2],laOr,nil);
     if Liste[1].Count > 0 then
     Affiche(Liste[1],FListe.ListBox4);
end;

procedure FaitListe2;
begin
     FListe.ListBox4.Hint := 'Liste 4' + #13 + 'Ceux existant dans les 2 listes';
     FListe.ListBox4.Clear;
     Liste[1].Assign(LAuxi[1]);
     FListe.ListBox4.Tag := 1;
     Liste[1].Assign(LAuxi[2],laAnd,nil);
     if Liste[1].Count > 0 then
     Affiche(Liste[1],FListe.ListBox4);
end;

procedure FaitListe1;
// Copie normale
begin
     FListe.ListBox4.Hint := 'Liste 4' + #13 + 'Addition des 2 listes';
     FListe.ListBox4.Clear;
     Liste[1].Assign(LAuxi[1]);
     FListe.ListBox4.Tag := 1;
     Liste[1].Assign(LAuxi[2],laCopy,nil);
     if Liste[1].Count > 0 then
     Affiche(Liste[1],FListe.ListBox4);
end;

procedure TFListe.RadioClick(Sender: TObject);
begin
     case (Sender as TRadioGroup).Tag of
          1 : if RadioGroup1.ItemIndex > - 1 then
              case RadioGroup1.ItemIndex of
                   0 : Nom(Liste[1]);
                   1 : Code(Liste[1]);
                   2 : Date(Liste[1]);
                   3 : NomInv(Liste[1]);
              end;
          2 : if RadioGroup2.ItemIndex > - 1 then
              begin
                   FListe.ListBox2.Hint := 'Liste 2' + #13 + 'Liste prise 1 sur 2';
                   FListe.ListBox2.Tag := 5;
                   Affiche(LAuxi[1],FListe.ListBox2);
                   FListe.ListBox3.Hint := 'Liste 3' + #13 + 'Liste prise 1 sur 3';
                   FListe.ListBox3.Tag := 5;
                   Affiche(LAuxi[2],FListe.ListBox3);
                   case RadioGroup2.ItemIndex of
                        0 : FaitListe1;
                        1 : FaitListe2;
                        2 : FaitListe3;
                        3 : FaitListe4;
                        4 : FaitListe5;
                   end;
              end;
     end;
end;

procedure TFListe.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
   st : string;
begin
     Ens := Liste[ListBox1.Tag].Items[Index];
     with ListBox1.Canvas do
     begin
          FillRect(Rect);
          TextOut(3,Rect.Top + 1,Ens^.nom);
          st := IntToStr(Ens^.cod);
          TextOut(100 - TextWidth(st),Rect.Top,st);
          TextOut(110,Rect.Top + 1,FormatDateTime('dd/mm/yyyy',Ens^.dat));
          MoveTo(60,Rect.Top);
          LineTo(60,Rect.Bottom);
          MoveTo(105,Rect.Top);
          LineTo(105,Rect.Bottom);
     end;
end;

procedure TFListe.ListBox2DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
   st : string;
begin
     if ListBox2.Tag < 5 then Ens := Liste[ListBox2.Tag].Items[Index]
                         else
     if ListBox2.Tag = 5 then Ens := LAuxi[1].Items[Index];
     with ListBox2.Canvas do
     begin
          FillRect(Rect);
          TextOut(3,Rect.Top + 1,Ens^.nom);
          st := IntToStr(Ens^.cod);
          TextOut(100 - TextWidth(st),Rect.Top,st);
          TextOut(110,Rect.Top + 1,FormatDateTime('dd/mm/yyyy',Ens^.dat));
          MoveTo(65,Rect.Top);
          LineTo(65,Rect.Bottom);
          MoveTo(105,Rect.Top);
          LineTo(105,Rect.Bottom);
     end;
end;

procedure TFListe.ListBox3DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
   st : string;
begin
     if ListBox3.Tag < 5 then Ens := Liste[ListBox3.Tag].Items[Index]
                         else
     if ListBox3.Tag = 5 then Ens := LAuxi[2].Items[Index];
     with ListBox3.Canvas do
     begin
          FillRect(Rect);
          st := IntToStr(Ens^.cod);
          TextOut(35 - TextWidth(st),Rect.Top,st);
          TextOut(45,Rect.Top + 1,Ens^.nom);
          TextOut(115,Rect.Top + 1,FormatDateTime('dd/mm/yyyy',Ens^.dat));
          MoveTo(40,Rect.Top);
          LineTo(40,Rect.Bottom);
          MoveTo(110,Rect.Top);
          LineTo(110,Rect.Bottom);
     end;
end;

procedure TFListe.ListBox4DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
   st : string;
begin
     {if ListBox4.Tag < 5 then Ens := Liste[ListBox4.Tag].Items[Index]
                         else
     if ListBox4.Tag = 5 then Ens := LAuxi[1].Items[Index];}
     Ens := Liste[ListBox4.Tag].Items[Index];
     with ListBox4.Canvas do
     begin
          FillRect(Rect);
          st := FormatDateTime('dd/mm/yyyy',Ens^.dat);
          TextOut(65 - TextWidth(st),Rect.Top,st);
          TextOut(75,Rect.Top + 1,Ens^.nom);
          st := IntToStr(Ens^.cod);
          TextOut(140,Rect.Top + 1,st);
          MoveTo(70,Rect.Top);
          LineTo(70,Rect.Bottom);
          MoveTo(135,Rect.Top);
          LineTo(135,Rect.Bottom);
     end;
end;

procedure TFListe.BEffaceClick(Sender: TObject);
begin
     ListBox2.Clear;
     ListBox3.Clear;
     ListBox4.Clear;
end;

initialization
  //Randomize;

// Création des listes
  Liste[1] := TList.Create;
  Liste[2] := TList.Create;
  Liste[3] := TList.Create;
  Liste[4] := TList.Create;
  LAuxi[1] := TList.Create;
  LAuxi[2] := TList.Create;

finalization
// Destruction des listes
  Liste[1].Free;
  Liste[2].Free;
  Liste[3].Free;
  Liste[4].Free;
  LAuxi[1].Free;
  LAuxi[2].Free;

end.

