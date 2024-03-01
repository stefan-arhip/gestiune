unit _Istoric_;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus;

type
  TIstoric_ = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Panel1: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    MainMenu1: TMainMenu;
    Fisier1: TMenuItem;
    Adaugare1: TMenuItem;
    Stergere1: TMenuItem;
    Salvare1: TMenuItem;
    Reincarcare1: TMenuItem;
    N1: TMenuItem;
    Iesire1: TMenuItem;
    Editare1: TMenuItem;
    Editarefisa1: TMenuItem;
    Operatii1: TMenuItem;
    Raport1: TMenuItem;
    N2: TMenuItem;
    Ajutor1: TMenuItem;
    Informatii1: TMenuItem;
    N3: TMenuItem;
    Despre1: TMenuItem;
    Utilizare1: TMenuItem;
    Istoric1: TMenuItem;
    Optiuni1: TMenuItem;
    Formatdata1: TMenuItem;
    Tipstergere1: TMenuItem;
    N0aaaallzz1: TMenuItem;
    N1zzlllaa1: TMenuItem;
    N2zzllaaaa1: TMenuItem;
    N3zzllaaaa1: TMenuItem;
    N4zzllaaaa1: TMenuItem;
    N0Stergerecompleta1: TMenuItem;
    N1Recyclebin1: TMenuItem;
    N2SchimbareextensieTMP1: TMenuItem;
    N3MutareindirectorulSTERSE1: TMenuItem;
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure Iesire1Click(Sender: TObject);
    procedure Utilizare1Click(Sender: TObject);
    procedure Istoric1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Istoric_: TIstoric_;

implementation

{$R *.DFM}

procedure TIstoric_.RadioButton1Click(Sender: TObject);
begin
  RadioButton1.Checked:=True;
  Memo1.Visible:=True;
  Memo2.Visible:=False;
  Istoric1.Checked:=True;
end;

procedure TIstoric_.RadioButton2Click(Sender: TObject);
begin
  RadioButton2.Checked:=True;
  Memo1.Visible:=False;
  Memo2.Visible:=True;
  Utilizare1.Checked:=True;
end;

procedure TIstoric_.Iesire1Click(Sender: TObject);
begin
  Close;
end;

procedure TIstoric_.Utilizare1Click(Sender: TObject);
begin
  RadioButton2Click(Sender);
end;

procedure TIstoric_.Istoric1Click(Sender: TObject);
begin
  RadioButton1Click(Sender);
end;

end.
