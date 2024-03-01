unit _Operatii_;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, Buttons, ExtCtrls, StdCtrls, _Fise_, Mask, Gauges;

Const FormatDataOperatii:Integer=0;

type
  TOperatii_ = class(TForm)
    MainMenu1: TMainMenu;
    Fisier1: TMenuItem;
    Editare1: TMenuItem;
    Ajutor1: TMenuItem;
    Despre1: TMenuItem;
    Iesire1: TMenuItem;
    Panel4: TPanel;
    Adaugare: TSpeedButton;
    Stergere: TSpeedButton;
    Salvare: TSpeedButton;
    Productie: TSpeedButton;
    Despre: TSpeedButton;
    Reincarcare: TSpeedButton;
    Panel6: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    LabelListaFise: TLabel;
    Panel5: TPanel;
    Panel3: TPanel;
    LabelDataDocument: TLabel;
    LabelNumarDocument: TLabel;
    LabelIesiri: TLabel;
    LabelTipDocument: TLabel;
    LabelStoc: TLabel;
    LabelIntrari: TLabel;
    NumarDocument: TEdit;
    Iesiri: TEdit;
    Intrari: TEdit;
    Lista: TListBox;
    Stoc: TEdit;
    TipDocument: TComboBox;
    Destinatar: TEdit;
    LabelDestinatar: TLabel;
    Comentariu: TMemo;
    LabelComentariu: TLabel;
    LabelPret: TLabel;
    Pret: TEdit;
    Adaugare1: TMenuItem;
    N1: TMenuItem;
    Stergere1: TMenuItem;
    Salvare1: TMenuItem;
    Reincarcare1: TMenuItem;
    Operatiaanterioara1: TMenuItem;
    Operatiaurmatoare1: TMenuItem;
    EditareFisa: TSpeedButton;
    N2: TMenuItem;
    Fisa1: TMenuItem;
    Raport: TSpeedButton;
    N3: TMenuItem;
    Informatii1: TMenuItem;
    Operatii1: TMenuItem;
    Raport1: TMenuItem;
    DataDocument: TMaskEdit;
    Optiuni1: TMenuItem;
    Formatdata1: TMenuItem;
    D0: TMenuItem;
    D1: TMenuItem;
    D2: TMenuItem;
    D3: TMenuItem;
    D4: TMenuItem;
    Panel7: TPanel;
    Gauge1: TGauge;
    Tipstergere1: TMenuItem;
    S0: TMenuItem;
    S1: TMenuItem;
    S2: TMenuItem;
    S3: TMenuItem;
    N4: TMenuItem;
    Fisaanterioara1: TMenuItem;
    Fisaurmatoare1: TMenuItem;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Despre1Click(Sender: TObject);
    procedure Iesire1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ListaClick(Sender: TObject);
    procedure AdaugareClick(Sender: TObject);
    procedure ReincarcareClick(Sender: TObject);
    procedure SalvareClick(Sender: TObject);
    procedure StergereClick(Sender: TObject);
    procedure Operatiaanterioara1Click(Sender: TObject);
    procedure Operatiaurmatoare1Click(Sender: TObject);
    procedure Informatii1Click(Sender: TObject);
    procedure D0Click(Sender: TObject);
    procedure D2Click(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure D3Click(Sender: TObject);
    procedure D4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NumarDocumentChange(Sender: TObject);
    procedure DestinatarChange(Sender: TObject);
    procedure ComentariuChange(Sender: TObject);
    procedure TipDocumentChange(Sender: TObject);
    procedure IntrariChange(Sender: TObject);
    procedure IesiriChange(Sender: TObject);
    procedure PretChange(Sender: TObject);
    procedure DataDocumentChange(Sender: TObject);
    procedure RaportClick(Sender: TObject);
  private
    { Private declarations }
    Procedure ShowHint(Sender: TObject);
    Procedure IncarcareFise(Fisa:TFisa);
    Procedure IncarcareOperatie(Poz:Integer);
    Procedure SetareControale;
  public
    { Public declarations }
  end;

var
  Operatii_: TOperatii_;

implementation

uses _Despre_, _Istoric_, _Raport_;

{$R *.DFM}

Function Extragere(t:String;i:Integer;b:Boolean):String;
Var s:string;
Begin
  s:=t;
  If b Then
    Delete(s,Length(s)-i+1,length(s))
  Else
    Delete(s,1,Length(s)-i);
  Extragere:=s;
End;

Function FisaDataToString(Data:String;Format:Integer):String;
Begin
  Case Format Of
    0:           //aaaallzz
      Begin
        Result:=Data;
      End;
    1:           //zz lll 'aa
      Begin
        Result:=''
      End;
    2:           //zz.ll.aaaa
      Begin
        Result:=Extragere(Data,2,False)+'.'+Extragere(Extragere(Data,Length(Data)-4,False),2,True)+'.'+Extragere(Data,4,True);
      End;
    3:           //zz/ll/aaaa
      Begin
        Result:=Extragere(Data,2,False)+'/'+Extragere(Extragere(Data,Length(Data)-4,False),2,True)+'/'+Extragere(Data,4,True);
      End;
    4:           //zz-ll-aaaa
      Begin
        Result:=Extragere(Data,2,False)+'-'+Extragere(Extragere(Data,Length(Data)-4,False),2,True)+'-'+Extragere(Data,4,True);
      End;
  End;
End;

Function StringToFisaData(Data:String;Format:Integer):String;
Begin
  Case Format Of
    0:           //aaaallzz
      Begin
        Result:=Data;
      End;
    1:           //zz lll 'aa
      Begin
        Result:=''
      End;
    2,3,4:       //zz.ll.aaaa, zz/ll/aaaa, zz-ll-aaaa
      Begin
        Result:=Extragere(Data,4,False)+Extragere(Extragere(Data,5,True),2,False)+Extragere(Data,Length(Data)-2,True);
      End;
  End;
End;

Function EsteData(Data:String;Format:Integer):Boolean;
Var a,l,z:Extended;
    c:Boolean;
Begin
  //ShowMessage('<'+Data+'>');
  Case Format Of
    0:           //aaaallzz
      Begin
        a:=StrToNumber(Extragere(Data,4,True));
        l:=StrToNumber(Extragere(Extragere(Data,Length(Data)-4,False),2,True));
        z:=StrToNumber(Extragere(Data,2,False));
        c:=(Data[1] In ['0'..'9']) And
           (Data[2] In ['0'..'9']) And
           (Data[3] In ['0'..'9']) And
           (Data[4] In ['0'..'9']) And
           (Data[5] In ['0'..'9']) And
           (Data[6] In ['0'..'9']) And
           (Data[7] In ['0'..'9']) And
           (Data[8] In ['0'..'9']);
      End;
    1:           //zz lll 'aa
      Begin
        //Result:='';
      End;
    2,3,4:       //zz.ll.aaaa, zz/ll/aaaa, zz-ll-aaaa
      Begin
        a:=StrToNumber(Extragere(Data,4,False));
        l:=StrToNumber(Extragere(Extragere(Data,Length(Data)-5,True),2,False));
        z:=StrToNumber(Extragere(Data,Length(Data)-2,True));
        c:=(Data[ 1] In ['0'..'9']) And
           (Data[ 2] In ['0'..'9']) And
           (Data[ 4] In ['0'..'9']) And
           (Data[ 5] In ['0'..'9']) And
           (Data[ 7] In ['0'..'9']) And
           (Data[ 8] In ['0'..'9']) And
           (Data[ 9] In ['0'..'9']) And
           (Data[10] In ['0'..'9']);
      End;
  End;
  Result:=((c) And
           (a>=2005) And (a<=2100) And
           (l>=   1) And (l<=  12) And
           (z>=   1) And (z<=  31)) Or
          ((Format=0) And (Data='      ')) Or
          ((Format=2) And (Data='  .  .    ')) Or
          ((Format=3) And (Data='  /  /    ')) Or
          ((Format=4) And (Data='  -  -    ')) Or
          (Data='');
End;

Procedure SchimbareOperatie(Var O1,O2:TOperatie);
Var O3:TOperatie;
Begin
  O3:=O1;
  O1:=O2;
  O2:=O3;
End;

Function OperatieVida:TOperatie;
Begin
  Result.Poz:=0;        // este suficient sa se stearga pozitia,
                        // pt. ca daca e zero, operatia nu se mai incarca in lista
  //Result.Document.Data:='';
  //Result.Document.Numar:='';
  //Result.Document.Fel:='';
  //Result.Intrare:=0;
  //Result.Iesire:=0;
  //Result.Stoc:=0;///TREBUIE CALCULAT!!!
  //Result.Pret:=0;
  //Result.Destinatie:='';
  //Result.Comentariu:='';    
End;

Procedure StergereOperatie(Var Fisa:TFisa;Poz:Integer);
Var i:Integer;
Begin
  For i:=Poz To MaximOperatii-1 Do
    Begin
      SchimbareOperatie(Fisa.Operatie[i],Fisa.Operatie[i+1]);
      If Fisa.Operatie[i].Poz<>0 Then
        Fisa.Operatie[i].Poz:=i;
    End;
  Fisa.Operatie[MaximOperatii]:=OperatieVida;
End;

Procedure TOperatii_.ShowHint(Sender: TObject);
begin
  Panel6.Caption:=Application.Hint;
end;

Procedure TOperatii_.SetareControale;
Begin
  LabelDataDocument.Enabled:=Lista.ItemIndex<>-1;
  DataDocument.Enabled:=Lista.ItemIndex<>-1;
  LabelNumarDocument.Enabled:=Lista.ItemIndex<>-1;
  NumarDocument.Enabled:=Lista.ItemIndex<>-1;
  LabelTipDocument.Enabled:=Lista.ItemIndex<>-1;
  TipDocument.Enabled:=Lista.ItemIndex<>-1;
  LabelIesiri.Enabled:=Lista.ItemIndex<>-1;
  Iesiri.Enabled:=Lista.ItemIndex<>-1;
  LabelIntrari.Enabled:=Lista.ItemIndex<>-1;
  Intrari.Enabled:=Lista.ItemIndex<>-1;
  LabelStoc.Enabled:=Lista.ItemIndex<>-1;
  Stoc.Enabled:=Lista.ItemIndex<>-1;
  LabelPret.Enabled:=Lista.ItemIndex<>-1;
  Pret.Enabled:=Lista.ItemIndex<>-1;
  LabelDestinatar.Enabled:=Lista.ItemIndex<>-1;
  Destinatar.Enabled:=Lista.ItemIndex<>-1;
  LabelComentariu.Enabled:=Lista.ItemIndex<>-1;
  Comentariu.Enabled:=Lista.ItemIndex<>-1;
//////////////////////////////////////////////////////////
  DataDocumentChange(Self);
  NumarDocumentChange(Self);
  TipDocumentChange(Self);
  IntrariChange(Self);
  IesiriChange(Self);
  PretChange(Self);
  DestinatarChange(Self);
  ComentariuChange(Self);
End;

Procedure TOperatii_.IncarcareFise(Fisa:TFisa);
Var i:Integer;
Begin
  Lista.Clear;
  For i:=1 To MaximOperatii Do
    Begin
      If Fisa.Operatie[i].Poz<>0 Then
        Lista.Items.Add(AddSpace(IntToStr(Fisa.Operatie[i].Poz),3,True)+' '+
                        AddSpace(ScriereData(Fisa.Operatie[i].Document.Data,FormatDataOperatii),10,False)+' '+
                        AddSpace(Fisa.Operatie[i].Document.Numar,10,True)+' '+
                        AddSpace(Fisa.Operatie[i].Document.Fel,3,False));
    End;
End;

Procedure TOperatii_.IncarcareOperatie(Poz:Integer);
Begin
  If Poz In [1..MaximOperatii] Then
    Begin
      DataDocument.Text:=FisaDataToString(Fisa.Operatie[Poz].Document.Data,FormatDataOperatii);
      NumarDocument.Text:=Fisa.Operatie[Poz].Document.Numar;
      If Fisa.Operatie[Poz].Document.Fel='AIM' Then
        TipDocument.ItemIndex:=1
      Else
        If Fisa.Operatie[Poz].Document.Fel='BC' Then
          TipDocument.ItemIndex:=2
        Else
          If Fisa.Operatie[Poz].Document.Fel='FF' Then
            TipDocument.ItemIndex:=3
          Else
            TipDocument.ItemIndex:=0;
      TipDocumentChange(Self);
      Iesiri.Text:=FloatToStr(Fisa.Operatie[Poz].Iesire);
      Intrari.Text:=FloatToStr(Fisa.Operatie[Poz].Intrare);
      Stoc.Text:=FloatToStr(Fisa.Operatie[Poz].Stoc);////E CALCULAT LA SALVARE
      Pret.Text:=FloatToStr(Fisa.Operatie[Poz].Pret);
      Destinatar.Text:=Fisa.Operatie[Poz].Destinatie;
      Comentariu.Text:=Fisa.Operatie[Poz].Comentariu;
    End
  Else
    Begin
      DataDocument.Text:='';
      NumarDocument.Text:='';
      TipDocument.ItemIndex:=0;
      Iesiri.Text:='0';
      Intrari.Text:='0';
      Stoc.Text:='0';//E CALCULAT LA SALVARE
      Pret.Text:='0';
      Destinatar.Text:='';
      Comentariu.Text:='';
    End
End;

procedure TOperatii_.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Operatii_.Enabled:=False;
  Fise_.Enabled:=True;
  Fise_.Show;
end;

procedure TOperatii_.Despre1Click(Sender: TObject);
begin
  Despre_.ShowModal;
end;

procedure TOperatii_.Iesire1Click(Sender: TObject);
begin
  Operatii_.Close;
end;           

procedure TOperatii_.FormActivate(Sender: TObject);
begin
  Application.OnHint:=ShowHint;
  IncarcareFise(Fisa);
  If Lista.Items.Capacity<>0 Then
    Lista.ItemIndex:=0;
  ListaClick(Sender);
end;

procedure TOperatii_.ListaClick(Sender: TObject);
begin
  SetareControale;
  //CalculareStocFinal(Fisa,1,300);
  IncarcareOperatie(Lista.ItemIndex+1);
end;

procedure TOperatii_.AdaugareClick(Sender: TObject);
begin
  If (Fise_.FisiereFisa.ItemIndex<>-1) And (Lista.Items.Capacity<MaximOperatii) Then
    Begin
      Fisa.Operatie[Lista.Items.Capacity+1].Poz:=Lista.Items.Capacity+1;
      IncarcareFise(Fisa);
    End;
  Lista.ItemIndex:=Lista.Items.Capacity-1;
  ListaClick(Sender);
end;

procedure TOperatii_.ReincarcareClick(Sender: TObject);
Var Poz:Integer;
begin
  Panel6.Caption:='';
  Panel6.Repaint;
  Panel7.Visible:=True;
  Gauge1.Progress:=Round(1*100/6);
  If Fise_.FisiereFisa.ItemIndex<>-1 Then
    DeschidereFisa(DirectorAplicatie+'FISE\'+Fisa.Denumire+Extensie,Fisa);
  Gauge1.Progress:=Round(2*100/6);
  Poz:=Lista.ItemIndex;
  Gauge1.Progress:=Round(3*100/6);
  IncarcareFise(Fisa);
  Gauge1.Progress:=Round(4*100/6);
  If Poz=-1 Then
    If Lista.Items.Capacity<>0 Then
      Lista.ItemIndex:=0
    Else
  Else
    Lista.ItemIndex:=Poz;
  Gauge1.Progress:=Round(5*100/6);
  ListaClick(Sender);
  Gauge1.Progress:=Round(6*100/6);
  Panel7.Visible:=False;
end;

procedure TOperatii_.SalvareClick(Sender: TObject);
begin
  Panel6.Caption:='';
  Panel6.Repaint;
  Panel7.Visible:=True;
  Gauge1.Progress:=Round(1*100/10);
  If Lista.ItemIndex<>-1 Then
    Fisa.Operatie[Lista.ItemIndex+1].Document.Data:=StringToFisaData(DataDocument.Text,FormatDataOperatii);
  Gauge1.Progress:=Round(2*100/10);
  If Lista.ItemIndex<>-1 Then
    Fisa.Operatie[Lista.ItemIndex+1].Document.Numar:=NumarDocument.Text;
  Gauge1.Progress:=Round(3*100/10);
  If Lista.ItemIndex<>-1 Then
    Fisa.Operatie[Lista.ItemIndex+1].Document.Fel:=TipDocument.Text;
  Gauge1.Progress:=Round(4*100/10);
  If Lista.ItemIndex<>-1 Then
    Fisa.Operatie[Lista.ItemIndex+1].Intrare:=StrToNumber(Intrari.Text);
  Gauge1.Progress:=Round(5*100/10);
  If Lista.ItemIndex<>-1 Then
    Fisa.Operatie[Lista.ItemIndex+1].Iesire:=StrToNumber(Iesiri.Text);
  Gauge1.Progress:=Round(6*100/10);
  If Lista.ItemIndex<>-1 Then
    Fisa.Operatie[Lista.ItemIndex+1].Stoc:=StrToNumber(Stoc.Text);////TREBUIE CALCULAT!!!!
  Gauge1.Progress:=Round(7*100/10);
  If Lista.ItemIndex<>-1 Then
    Fisa.Operatie[Lista.ItemIndex+1].Pret:=StrToNumber(Pret.Text);
  Gauge1.Progress:=Round(8*100/10);
  If Lista.ItemIndex<>-1 Then
    Fisa.Operatie[Lista.ItemIndex+1].Destinatie:=Destinatar.Text;
  Gauge1.Progress:=Round(9*100/10);
  If Lista.ItemIndex<>-1 Then
    Fisa.Operatie[Lista.ItemIndex+1].Comentariu:=Comentariu.Text;
  Gauge1.Progress:=Round(10*100/10);
  If Fise_.FisiereFisa.ItemIndex<>-1 Then
    SalvareFisa(DirectorAplicatie+'FISE\'+Fisa.Denumire+Extensie);
  ReincarcareClick(Sender);
  Panel7.Visible:=False;
end;

procedure TOperatii_.StergereClick(Sender: TObject);
Var Poz:Integer;
begin
  Poz:=Lista.ItemIndex;
  If Poz<>-1 Then
    If MessageDlg('Se confirma stergerea operatiei "'+
                  IntToStr(Fisa.Operatie[Lista.ItemIndex+1].Poz)+'"?',
                  mtConfirmation,[mbYes,mbNo],0)=mrYes Then
      Begin
        StergereOperatie(Fisa,Lista.ItemIndex+1);
        CalculareStocFinal(Fisa,1,MaximOperatii);
        IncarcareFise(Fisa);
        If Not (Poz=Lista.Items.Capacity-1) Then
          Dec(Poz);
        Lista.ItemIndex:=Poz;
        ListaClick(Sender);
      End;
end;

procedure TOperatii_.Operatiaanterioara1Click(Sender: TObject);
begin
  If Lista.ItemIndex>0 Then
    Begin
      Lista.ItemIndex:=Lista.ItemIndex-1;
      ListaClick(Sender);
    End;
end;

procedure TOperatii_.Operatiaurmatoare1Click(Sender: TObject);
begin
  If Lista.ItemIndex<=Lista.Items.Capacity Then
    Begin
      Lista.ItemIndex:=Lista.ItemIndex+1;
      ListaClick(Sender);
    End;
end;

procedure TOperatii_.Informatii1Click(Sender: TObject);
begin
  Istoric_.ShowModal;
end;

procedure TOperatii_.D0Click(Sender: TObject);
begin
  DataDocument.EditMask:='99999999;1;_';
  D0.Checked:=True;
  FormatDataOperatii:=0;
  ReincarcareClick(Sender);
end;

procedure TOperatii_.D1Click(Sender: TObject);
begin
  //
  D1.Checked:=True;
  FormatDataOperatii:=1;
  ReincarcareClick(Sender);
end;

procedure TOperatii_.D2Click(Sender: TObject);
begin
  DataDocument.EditMask:='99.99.9999;1;_';
  D2.Checked:=True;
  FormatDataOperatii:=2;
  ReincarcareClick(Sender);
end;

procedure TOperatii_.D3Click(Sender: TObject);
begin
  DataDocument.EditMask:='99/99/9999;1;_';
  D3.Checked:=True;
  FormatDataOperatii:=3;
  ReincarcareClick(Sender);
end;

procedure TOperatii_.D4Click(Sender: TObject);
begin
  DataDocument.EditMask:='99-99-9999;1;_';
  D4.Checked:=True;
  FormatDataOperatii:=4;
  ReincarcareClick(Sender);
end;

procedure TOperatii_.FormCreate(Sender: TObject);
begin
  Case FormatDataOperatii Of
    0:
      D0Click(Sender);
    1:
      D1Click(Sender);
    2:
      D2Click(Sender);
    3:
      D3Click(Sender);
    4:
      D4Click(Sender);
  End;
end;

procedure TOperatii_.NumarDocumentChange(Sender: TObject);
begin
  If NumarDocument.Text=Fisa.Operatie[Lista.ItemIndex+1].Document.Numar Then
    Begin
      LabelNumarDocument.Font.Color:=CuloareSalvat;
      NumarDocument.Font.Color:=CuloareSalvat;
    End
  Else
    Begin
      LabelNumarDocument.Font.Color:=CuloareNesalvat;
      NumarDocument.Font.Color:=CuloareNesalvat;
    End;
end;

procedure TOperatii_.DestinatarChange(Sender: TObject);
begin
  If Destinatar.Text=Fisa.Operatie[Lista.ItemIndex+1].Destinatie Then
    Begin
      LabelDestinatar.Font.Color:=CuloareSalvat;
      Destinatar.Font.Color:=CuloareSalvat;
    End
  Else
    Begin
      LabelDestinatar.Font.Color:=CuloareNesalvat;
      Destinatar.Font.Color:=CuloareNesalvat;
    End;
end;

procedure TOperatii_.ComentariuChange(Sender: TObject);
begin
  If Comentariu.Text=Fisa.Operatie[Lista.ItemIndex+1].Comentariu Then
    Begin
      LabelComentariu.Font.Color:=CuloareSalvat;
      Comentariu.Font.Color:=CuloareSalvat;
    End
  Else
    Begin
      LabelComentariu.Font.Color:=CuloareNesalvat;
      Comentariu.Font.Color:=CuloareNesalvat;
    End;
end;

procedure TOperatii_.TipDocumentChange(Sender: TObject);
begin
  If TipDocument.Items[TipDocument.ItemIndex]=Fisa.Operatie[Lista.ItemIndex+1].Document.Fel Then
    Begin
      LabelTipDocument.Font.Color:=CuloareSalvat;
      TipDocument.Font.Color:=CuloareSalvat;
    End
  Else
    Begin
      LabelTipDocument.Font.Color:=CuloareNesalvat;
      TipDocument.Font.Color:=CuloareNesalvat;
    End;
end;

procedure TOperatii_.IntrariChange(Sender: TObject);
begin
  If EsteNumar(Intrari.Text) Then
    If StrToNumber(Intrari.Text)=Fisa.Operatie[Lista.ItemIndex+1].Intrare Then
      Begin
        LabelIntrari.Font.Color:=CuloareSalvat;
        Intrari.Font.Color:=CuloareSalvat;
      End
    Else
      Begin
        LabelIntrari.Font.Color:=CuloareNesalvat;
        Intrari.Font.Color:=CuloareNesalvat;
      End
  Else
    Begin
      LabelIntrari.Font.Color:=CuloareEroare;
      Intrari.Font.Color:=CuloareEroare;
    End;
end;

procedure TOperatii_.IesiriChange(Sender: TObject);
begin
  If EsteNumar(Iesiri.Text) Then
    If StrToNumber(Iesiri.Text)=Fisa.Operatie[Lista.ItemIndex+1].Iesire Then
      Begin
        LabelIesiri.Font.Color:=CuloareSalvat;
        Iesiri.Font.Color:=CuloareSalvat;
      End
    Else
      Begin
        LabelIesiri.Font.Color:=CuloareNesalvat;
        Iesiri.Font.Color:=CuloareNesalvat;
      End
  Else
    Begin
      LabelIesiri.Font.Color:=CuloareEroare;
      Iesiri.Font.Color:=CuloareEroare;
    End;
end;

procedure TOperatii_.PretChange(Sender: TObject);
begin
  If EsteNumar(Pret.Text) Then
    If StrToNumber(Pret.Text)=Fisa.Operatie[Lista.ItemIndex+1].Pret Then
      Begin
        LabelPret.Font.Color:=CuloareSalvat;
        Pret.Font.Color:=CuloareSalvat;
      End
    Else
      Begin
        LabelPret.Font.Color:=CuloareNesalvat;
        Pret.Font.Color:=CuloareNesalvat;
      End
  Else
    Begin
      LabelPret.Font.Color:=CuloareEroare;
      Pret.Font.Color:=CuloareEroare;
    End;
end;

procedure TOperatii_.DataDocumentChange(Sender: TObject);
begin
  If EsteData(DataDocument.Text,FormatDataOperatii) Then
    If StringToFisaData(DataDocument.Text,FormatDataOperatii)=Fisa.Operatie[Lista.ItemIndex+1].Document.Data Then
      Begin
        LabelDataDocument.Font.Color:=CuloareSalvat;
        DataDocument.Font.Color:=CuloareSalvat;
      End
    Else
      Begin
        LabelDataDocument.Font.Color:=CuloareNesalvat;
        DataDocument.Font.Color:=CuloareNesalvat;
      End
  Else
    Begin
      LabelDataDocument.Font.Color:=CuloareEroare;
      DataDocument.Font.Color:=CuloareEroare;
    End;
end;

procedure TOperatii_.RaportClick(Sender: TObject);
begin
  Operatii_.Enabled:=False;
  Operatii_.Hide;
  FereastraAscunsa:='fisa';
  Raport_.Enabled:=True;
  Raport_.Show;
end;


end.
