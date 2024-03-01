unit _Raport_;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, Buttons, StdCtrls, ExtCtrls, checklst, ComCtrls, Gauges;

Const FereastraAscunsa:String='';
      FormatDataRaport:Integer=0;
      TipRaport:Integer=0;

type
  TRaport_ = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    LabelListaFise: TLabel;
    Panel5: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Adaugare: TSpeedButton;
    Stergere: TSpeedButton;
    Salvare: TSpeedButton;
    Productie: TSpeedButton;
    Despre: TSpeedButton;
    Reincarcare: TSpeedButton;
    EditareFisa: TSpeedButton;
    Generare: TSpeedButton;
    Panel6: TPanel;
    MainMenu1: TMainMenu;
    Fisier1: TMenuItem;
    N1: TMenuItem;
    Iesire1: TMenuItem;
    Editare1: TMenuItem;
    Editarefisa1: TMenuItem;
    N2: TMenuItem;
    Fisaanterioara1: TMenuItem;
    Fisaurmatoare1: TMenuItem;
    Ajutor1: TMenuItem;
    Despre1: TMenuItem;
    ListaFisa: TCheckListBox;
    R0: TRadioButton;
    R1: TRadioButton;
    N3: TMenuItem;
    Informatii1: TMenuItem;
    Label3: TLabel;
    Operatii1: TMenuItem;
    Raport1: TMenuItem;
    Adaugare1: TMenuItem;
    Stergere1: TMenuItem;
    Salvare1: TMenuItem;
    Reincarcare1: TMenuItem;
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
    Operatiaanterioara1: TMenuItem;
    Operatiaurmatoare1: TMenuItem;
    procedure FormActivate(Sender: TObject);
    procedure EditareFisaClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure DespreClick(Sender: TObject);
    procedure Fisaanterioara1Click(Sender: TObject);
    procedure ListaFisaClick(Sender: TObject);
    procedure Fisaurmatoare1Click(Sender: TObject);
    procedure GenerareClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Informatii1Click(Sender: TObject);
    procedure D0Click(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure D2Click(Sender: TObject);
    procedure D3Click(Sender: TObject);
    procedure D4Click(Sender: TObject);
    procedure ProductieClick(Sender: TObject);
    procedure Iesire1Click(Sender: TObject);
    procedure R0Click(Sender: TObject);
    procedure R1Click(Sender: TObject);
  private
    { Private declarations }
    Procedure ShowHint(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Raport_: TRaport_;

Function AddSpace(s:String;i:Integer;AliniereDreapta:Boolean):String;
Function ScriereData(s:String;i:Integer):String;

implementation

{$R *.DFM}

Uses _Fise_, _Operatii_, _Despre_, _View_, _Istoric_;

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

Function ScriereData(s:String;i:Integer):String;
Const Luna:Array[1..12]Of String[3]=('ian','feb','mar',
                                     'apr','mai','iun',
                                     'iul','aug','sep',
                                     'oct','nov','dec');
Var s1,s2,s3:String;
    e1,e2,e3:Integer;
    Eroare:Boolean;
Begin
  If Length(s)<>0 Then
    Begin
      If Length(s)=8 Then
        Begin
          s1:=Extragere(s,4,True);
          s2:=Extragere(Extragere(s,4,False),2,True);
          s3:=Extragere(s,2,False);
          Eroare:=False;
          Try
            e1:=StrToInt(s1);
            e2:=StrToInt(s2);
            e3:=StrToInt(s3);
          Except
            Eroare:=True;
          End;
          If Not Eroare Then
            Begin
              If (e1>1980) And (e1<2099) And
                 (e2>   0) And (e2<  13) And
                 (e3>   0) And (e3<  32) Then
                Begin
                  If i=0 Then
                    s:=s;
                  If i=1 Then
                    s:=s3+' '+Luna[StrToInt(s2)]+''''+Extragere(s1,2,False);
                  If i=2 Then
                    s:=s3+'.'+s2+'.'+s1;
                  If i=3 Then
                    s:=s3+'/'+s2+'/'+s1;
                  If i=4 Then
                    s:=s3+'-'+s2+'-'+s1;
                End
              Else
                s:='incorect..';
            End
          Else
            s:='';//eroare...
        End
      Else
        s:='scriere...';
    End
  Else
    s:='';
  ScriereData:=s;
End;

Function AddSpace(s:String;i:Integer;AliniereDreapta:Boolean):String;
Begin
  If Length(s)<i Then
    Begin
      While Length(s)<i Do
        Begin
          If AliniereDreapta Then
            s:=' '+s
          Else
            s:=s+' ';
        End;
    End;
  AddSpace:=s;
End;

Procedure TRaport_.ShowHint(Sender: TObject);
begin
  Panel6.Caption:=Application.Hint;
end;

procedure TRaport_.FormActivate(Sender: TObject);
Var i:Integer;
begin
  Panel6.Caption:='';
  Panel6.Repaint;
  Panel7.Visible:=True;
  Gauge1.Progress:=Round(1*100/6);
  Application.OnHint:=ShowHint;
  Gauge1.Progress:=Round(2*100/6);
  ListaFisa.Items:=Fise_.FisiereFisa.Items;
  Gauge1.Progress:=Round(3*100/6);
  ListaFisa.ItemIndex:=Fise_.FisiereFisa.ItemIndex;
  Gauge1.Progress:=Round(4*100/6);
  Generare.Enabled:=ListaFisa.ItemIndex<>-1;
  Gauge1.Progress:=Round(5*100/6);
  For i:=1 To ListaFisa.Items.Capacity Do
    Begin
      ListaFisa.Checked[i-1]:=True;
    End;
  Gauge1.Progress:=Round(6*100/6);
  Panel7.Visible:=False;
end;

procedure TRaport_.EditareFisaClick(Sender: TObject);
begin
  FereastraAscunsa:='gestiune';
  Raport_.Close;
end;

procedure TRaport_.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Raport_.Enabled:=False;
  If FereastraAscunsa='gestiune' Then
    Begin
      Fise_.Enabled:=True;
      Fise_.Show;
    End;
  If FereastraAscunsa='fisa' Then
    Begin
      Operatii_.Enabled:=True;
      Operatii_.Show;
    End;
end;

procedure TRaport_.DespreClick(Sender: TObject);
begin
  Despre_.ShowModal;
end;

procedure TRaport_.Fisaanterioara1Click(Sender: TObject);
begin
  If ListaFisa.ItemIndex>0 Then
    Begin
      ListaFisa.ItemIndex:=ListaFisa.ItemIndex-1;
      ListaFisaClick(Sender);
    End;
end;

procedure TRaport_.ListaFisaClick(Sender: TObject);
begin
  Fise_.FisiereFisa.ItemIndex:=ListaFisa.ItemIndex;
  Fise_.FisiereFisaChange(Sender);
end;

procedure TRaport_.Fisaurmatoare1Click(Sender: TObject);
begin
  If ListaFisa.ItemIndex<=ListaFisa.Items.Capacity Then
    Begin
      ListaFisa.ItemIndex:=ListaFisa.ItemIndex+1;
      ListaFisaClick(Sender);
    End;
end;    

procedure TRaport_.GenerareClick(Sender: TObject);
Var i,j,k:Integer;
    Total:Toperatie;
    TempFisa:TFisa;
begin
  Gauge1.Progress:=0;
  Panel7.Visible:=True;
  View_.Container.Clear;
  Total.Poz:=0;
  Total.Document.Data:='';
  Total.Document.Numar:='';
  Total.Document.Fel:='';
  Total.Intrare:=0;
  Total.Iesire:=0;
  Total.Stoc:=0;
  Total.Pret:=0;
  Total.Destinatie:='';
  Total.Comentariu:='';
  If TipRaport=0 Then       //Raport fisa selectata
    Begin
      View_.Container.Lines.Add('|----------------------------------------------------------------------------------------|');
      View_.Container.Lines.Add('| FISA DE MAGAZIE '+AddSpace(Fisa.Denumire,70,True)+' |');
      View_.Container.Lines.Add('|----------------------------------------------------------------------------------------|');
      View_.Container.Lines.Add('| Data doc.  | Nr.doc.    | Tip doc. | Intrari    | Iesiri     | Stoc       | Pret       |');
      //                           1234567890   1234567890   12345678   1234567890   1234567890   1234567890   123456789
      View_.Container.Lines.Add('|------------|------------|----------|------------|------------|------------|------------|');
      View_.Container.Lines.Add('| '+AddSpace('',10,True)+
                               ' | '+AddSpace(Fisa.Cod,10,True)+
                               ' | '+AddSpace('',8,False)+
                               ' | '+AddSpace('',10,True)+
                               ' | '+AddSpace('',10,True)+
                               ' | '+AddSpace(FloatToStrF(Fisa.StocInitial,ffFixed,16,2),10,True)+
                               ' | '+AddSpace(FloatToStrF(Fisa.Pret,ffFixed,16,2),10,True)+ ' |');
      View_.Container.Lines.Add('|------------|------------|----------|------------|------------|------------|------------|');
      For i:=1 To MaximOperatii Do
        Begin
          Gauge1.Progress:=Round(i*100/MaximOperatii);
          If Fisa.Operatie[i].Poz<>0 Then
            Begin
              Total.Intrare:=Total.Intrare+Fisa.Operatie[i].Intrare;
              Total.Iesire:=Total.Iesire+Fisa.Operatie[i].Iesire;
              Total.Stoc:=Fisa.Operatie[i].Stoc;
              View_.Container.Lines.Add('| '+AddSpace(ScriereData(Fisa.Operatie[i].Document.Data,FormatDataRaport),10,True)+
                                       ' | '+AddSpace(Fisa.Operatie[i].Document.Numar,10,True)+
                                       ' | '+AddSpace(Fisa.Operatie[i].Document.Fel,8,False)+
                                       ' | '+AddSpace(FloatToStrF(Fisa.Operatie[i].Intrare,ffFixed,16,2),10,True)+
                                       ' | '+AddSpace(FloatToStrF(Fisa.Operatie[i].Iesire,ffFixed,16,2),10,True)+
                                       ' | '+AddSpace(FloatToStrF(Fisa.Operatie[i].Stoc,ffFixed,16,2),10,True)+
                                       ' | '+AddSpace(FloatToStrF(Fisa.Operatie[i].Pret,ffFixed,16,2),10,True)+ ' |');
            End;
        End;
      View_.Container.Lines.Add('|------------|------------|----------|------------|------------|------------|------------|');
      View_.Container.Lines.Add('| '+AddSpace('',10,True)+
                               ' | '+AddSpace(Fisa.Cod,10,True)+
                               ' | '+AddSpace('',8,False)+
                               ' | '+AddSpace(FloatToStrF(Total.Intrare,ffFixed,16,2),10,True)+
                               ' | '+AddSpace(FloatToStrF(Total.Iesire,ffFixed,16,2),10,True)+
                               ' | '+AddSpace(FloatToStrF(Total.Stoc,ffFixed,16,2),10,True)+
                               ' | '+AddSpace('',10,True)+ ' |');
      View_.Container.Lines.Add('|----------------------------------------------------------------------------------------|');
    End;
  If TipRaport=1 Then       //Raport inventar fise marcate
    Begin
      View_.Container.Lines.Add('|--------------------------------------------------------------------------------------------------------|');
      View_.Container.Lines.Add('| FISA DE INVENTAR                                                                                       |');
      View_.Container.Lines.Add('|--------------------------------------------------------------------------------------------------------|');
      View_.Container.Lines.Add('| Poz. | Denumire                       | Stoc       | Intrari    | Iesiri     | Stoc       | Pret       |');
      //                           1234   123456789012345678901234567890   1234567890   1234567890   1234567890   1234567890   1234567890
      View_.Container.Lines.Add('|------|--------------------------------|------------|------------|------------|------------|------------|');
      k:=0;
      For j:=1 To ListaFisa.Items.Capacity Do
        Begin
          Gauge1.Progress:=Round(j*100/ListaFisa.Items.Capacity);
          If ListaFisa.Checked[j-1] Then
            Begin
              Inc(k);
              DeschidereFisa(DirectorAplicatie+'FISE\'+ListaFisa.Items[j-1],TempFisa);
              Total.Intrare:=0;
              Total.Iesire:=0;
              Total.Stoc:=0;
              Total.Pret:=0;
              For i:=1 To MaximOperatii Do
                Begin
                  If Fisa.Operatie[i].Poz<>0 Then
                    Begin
                      Total.Intrare:=Total.Intrare+TempFisa.Operatie[i].Intrare;
                      Total.Iesire:=Total.Iesire+TempFisa.Operatie[i].Iesire;
                      Total.Stoc:=TempFisa.Operatie[i].Stoc;
                    End;
                End;
              View_.Container.Lines.Add('| '+AddSpace(IntToStr(k),4,True)+
                                       ' | '+AddSpace(TempFisa.Denumire,30,False)+
                                       ' | '+AddSpace(FloatToStrF(TempFisa.StocInitial,ffFixed,16,2),10,True)+
                                       ' | '+AddSpace(FloatToStrF(Total.Intrare,ffFixed,16,2),10,True)+
                                       ' | '+AddSpace(FloatToStrF(Total.Iesire,ffFixed,16,2),10,True)+
                                       ' | '+AddSpace(FloatToStrF(Total.Stoc,ffFixed,16,2),10,True)+
                                       ' | '+AddSpace(FloatToStrF(TempFisa.Pret,ffFixed,16,2),10,True)+' |');
            End;
        End;
      View_.Container.Lines.Add('|--------------------------------------------------------------------------------------------------------|');  
    End;
  Panel7.Visible:=False;    
  View_.ShowModal;
end;

procedure TRaport_.FormCreate(Sender: TObject);
begin
  Case FormatDataRaport Of
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
  Case TipRaport Of
    0:
      R0Click(Sender);
    1:
      R1Click(Sender);
  End;
end;

procedure TRaport_.Informatii1Click(Sender: TObject);
begin
  Istoric_.ShowModal;    
end;

procedure TRaport_.D0Click(Sender: TObject);
begin
  D0.Checked:=True;
  FormatDataRaport:=0;
end;

procedure TRaport_.D1Click(Sender: TObject);
begin
  D1.Checked:=True;
  FormatDataRaport:=1;
end;

procedure TRaport_.D2Click(Sender: TObject);
begin
  D2.Checked:=True;
  FormatDataRaport:=2;
end;

procedure TRaport_.D3Click(Sender: TObject);
begin
  D3.Checked:=True;
  FormatDataRaport:=3;
end;

procedure TRaport_.D4Click(Sender: TObject);
begin
  D4.Checked:=True;
  FormatDataRaport:=4;
end;

procedure TRaport_.ProductieClick(Sender: TObject);
begin
  FereastraAscunsa:='fisa';
  Raport_.Close;
end;

procedure TRaport_.Iesire1Click(Sender: TObject);
begin
  Raport_.Close;
end;

procedure TRaport_.R0Click(Sender: TObject);
begin
  R0.Checked:=True;
  TipRaport:=0;
end;

procedure TRaport_.R1Click(Sender: TObject);
begin
  R1.Checked:=True;
  TipRaport:=1;
end;

end.
