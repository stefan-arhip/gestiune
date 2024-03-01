unit _Fise_;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FileCtrl, Buttons, ExtCtrls, Menus, Gauges, IniFiles, ShellApi;

Const DirectorAplicatie:String='';
      Extensie:String='';
      MaximOperatii:Integer=300;
      CuloareSalvat=clBlack;
      CuloareNesalvat=clGreen;
      CuloareEroare=clRed;
      FormatDataFisa:Integer=0;
      TipStergereFisa:Integer=0;
      Versiune:String='GESTIUNE v1.2';   ///////uita-te si in "Gestiune.dpr"

Type  TOperatie=Record
                  Poz:Integer;
                  Document:Record
                             Data:String[8];
                             Numar:String[10];
                             Fel:String[3];//BC,FF sau AIM
                           End;
                  Intrare,Iesire,Stoc,Pret:Extended;
                  Destinatie:String[50];
                  Comentariu:String[255];
                End;
      TFisa=Record
             Denumire,Cod:String[30];
             StocInitial,StocFinal,Pret:Extended;
             Comentariu:String[255];
             Operatie:Array [1..300] Of TOperatie;//MaximOperatii=300
           End;

  TFise_ = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    FisiereFisa: TFileListBox;
    LabelDenumire: TLabel;
    Denumire: TEdit;
    LabelCod: TLabel;
    Cod: TEdit;
    LabelStocInitial: TLabel;
    StocInitial: TEdit;
    LabelPretAproximativ: TLabel;
    PretAproximativ: TEdit;
    Panel5: TPanel;
    Panel4: TPanel;
    MainMenu1: TMainMenu;
    Fisier1: TMenuItem;
    Editare1: TMenuItem;
    Ajutor1: TMenuItem;
    LabelComentariu: TLabel;
    Comentariu: TMemo;
    LabelListaFise: TLabel;
    LabelStocFinal: TLabel;
    StocFinal: TEdit;
    Despre1: TMenuItem;
    Iesire1: TMenuItem;
    Adaugare: TSpeedButton;
    Stergere: TSpeedButton;
    Salvare: TSpeedButton;
    Productie: TSpeedButton;
    Despre: TSpeedButton;
    Reincarcare: TSpeedButton;
    Panel6: TPanel;
    Adaugare1: TMenuItem;
    Stergere1: TMenuItem;
    Salvare1: TMenuItem;
    Reincarcare1: TMenuItem;
    N1: TMenuItem;
    Fisaurmatoare1: TMenuItem;
    Fisaanterioara1: TMenuItem;
    N2: TMenuItem;
    Operatii1: TMenuItem;
    EditareFisa: TSpeedButton;
    Raport: TSpeedButton;
    N3: TMenuItem;
    Informatii1: TMenuItem;
    Fisa1: TMenuItem;
    Raport1: TMenuItem;
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
    S1: TMenuItem;
    S2: TMenuItem;
    S0: TMenuItem;
    S3: TMenuItem;
    N4: TMenuItem;
    Operatiaanterioara1: TMenuItem;
    Operatiaurmatoare1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FisiereFisaChange(Sender: TObject);
    procedure AdaugareClick(Sender: TObject);
    procedure SalvareClick(Sender: TObject);
    procedure StergereClick(Sender: TObject);
    procedure Despre1Click(Sender: TObject);
    procedure Iesire1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ProductieClick(Sender: TObject);
    procedure Fisaanterioara1Click(Sender: TObject);
    procedure Fisaurmatoare1Click(Sender: TObject);
    procedure RaportClick(Sender: TObject);
    procedure Informatii1Click(Sender: TObject);
    procedure PretAproximativChange(Sender: TObject);
    procedure StocInitialChange(Sender: TObject);
    procedure DenumireChange(Sender: TObject);
    procedure CodChange(Sender: TObject);
    procedure ComentariuChange(Sender: TObject);
    procedure D0Click(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure D2Click(Sender: TObject);
    procedure D3Click(Sender: TObject);
    procedure D4Click(Sender: TObject);
    procedure S0Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure S2Click(Sender: TObject);
    procedure S3Click(Sender: TObject);
  private
    { Private declarations }
    Procedure ShowHint(Sender: TObject);
    Procedure IncarcareFisa(Adresa:String);
    Procedure SetareControale;
  public
    { Public declarations }
    Procedure IncarcareSetariIni;
    Procedure SalvareSetariIni;
  end;

Procedure DeschidereFisa(Adresa:String;Var Fisa:TFisa);
Procedure SalvareFisa(Adresa:String);
Function CalculareStocFinal(Var Fisa:TFisa;Start,Stop:Integer):Extended;
Function StrToNumber(s:String):Extended;
Function EsteNumar(s:String):Boolean;
Procedure TrimiteInRecycleRin(Nume:String);

var
  Fise_: TFise_;
  Fisa:TFisa;

implementation

uses _Despre_, _Operatii_, _Raport_, _Istoric_;

{$R *.DFM}

Procedure TrimiteInRecycleRin(Nume:String);
Var MyFileStruct:TSHFileOpStruct;
Begin
  With MyFileStruct Do
    Begin
      Wnd:=Fise_.Handle;
      wFunc:=FO_DELETE;
      pFrom:=PChar(Nume);
      fFlags:=FOF_ALLOWUNDO;
    End;
  Try
    SHFileOperation(MyFileStruct);
  Except
    On EAccessViolation Do ;//STERS;
  End;
End;

Procedure CreareDirector(s:String);
Begin
  If Not DirectoryExists(DirectorAplicatie+s) Then
    Begin
      If MessageDlg('Nu exista directorul "'+s+'"'#13+
                    'Se permite aplicatiei sa-l creeze?',mtConfirmation,[mbYes,mbNo],0)=mrYes Then
        Begin
          ChDir(DirectorAplicatie);
          MkDir(s);
        End
      Else
        Begin
          MessageDlg('Nu exista directorul "'+s+'".'#13+
                     'Aplicatia nu poate fi lansata in executie si se inchide!',mtError,[MBoK],0);
          Application.Terminate;
        End;
    End;
End;

Function StrToNumber(s:String):Extended;
Begin
  If s='' Then
    s:='0';
  Try
    Result:=StrToFloat(s);
  Except
    Result:=0;
  End;
End;

Function EsteNumar(s:String):Boolean;
Var Rezultat:Boolean;
    x:Extended;
Begin
  If s='' Then
    s:='0';
  Rezultat:=True;
  Try
    x:=StrToFloat(s);
  Except
    Rezultat:=False;
  End;
  EsteNumar:=Rezultat;
End;

Procedure TFise_.IncarcareSetariIni;
Var f:TIniFile;
Begin
  If FileExists(DirectorAplicatie+'GESTIUNE.INI') Then
    Begin
      f:=TIniFile.Create(DirectorAplicatie+'GESTIUNE.INI');
      Try
        //res:=f.ReadString('Section_Name','Key_Name','default value');
        FormatDataFisa    :=f.ReadInteger('FISA'    ,'Format data'      ,0);
        TipStergereFisa   :=f.ReadInteger('FISA'    ,'Tip stergere fisa',0);
        FormatDataOperatii:=f.ReadInteger('OPERATII','Format data'      ,0);
        FormatDataRaport  :=f.ReadInteger('RAPOARTE','Format data'      ,0);
        TipRaport         :=f.ReadInteger('RAPOARTE','Tip raport'       ,0);
        Operator          :=f.ReadString ('AJUTOR'  ,'Operator'         ,'');
      Finally
        f.Free;
      End;
    End
  Else
    SalvareSetariIni;
End;

Procedure TFise_.SalvareSetariIni;
Var f:TIniFile;
Begin
  f:=TIniFile.Create(DirectorAplicatie+'GESTIUNE.INI');
  Try
    //f.WriteString('Section_Name', 'Key_Name', 'String Value');
    f.WriteInteger('FISA'    ,'Format data'      ,FormatDataFisa    );
    f.WriteInteger('FISA'    ,'Tip stergere fisa',TipStergereFisa   );
    f.WriteInteger('OPERATII','Format data'      ,FormatDataOperatii);
    f.WriteInteger('RAPOARTE','Format data'      ,FormatDataRaport  );
    f.WriteInteger('RAPOARTE','Tip raport'       ,TipRaport         );
    f.WriteString ('AJUTOR'  ,'Operator'         ,Operator          );
  Finally
    f.Free;
  End;
End;

Procedure TFise_.SetareControale;
Begin
  LabelDenumire.Enabled:=FisiereFisa.ItemIndex<>-1;
  Denumire.Enabled:=FisiereFisa.ItemIndex<>-1;
  LabelCod.Enabled:=FisiereFisa.ItemIndex<>-1;
  Cod.Enabled:=FisiereFisa.ItemIndex<>-1;
  LabelPretAproximativ.Enabled:=FisiereFisa.ItemIndex<>-1;
  PretAproximativ.Enabled:=FisiereFisa.ItemIndex<>-1;
  LabelStocInitial.Enabled:=FisiereFisa.ItemIndex<>-1;
  StocInitial.Enabled:=FisiereFisa.ItemIndex<>-1;
  LabelStocFinal.Enabled:=FisiereFisa.ItemIndex<>-1;
  StocFinal.Enabled:=FisiereFisa.ItemIndex<>-1;
  LabelComentariu.Enabled:=FisiereFisa.ItemIndex<>-1;
  Comentariu.Enabled:=FisiereFisa.ItemIndex<>-1;
//////////////////////////////////////////////////////////  
  DenumireChange(Self);
  CodChange(Self);
  PretAproximativChange(Self);
  StocInitialChange(Self);
  ComentariuChange(Self);
End;

Function CalculareStocFinal(Var Fisa:TFisa;Start,Stop:Integer):Extended;
Var i:Integer;
    Temp:Extended;
Begin
  If Start=1 Then
    Temp:=Fisa.StocInitial
  Else              //daca Start>1 atunci...
    Temp:=Fisa.Operatie[Start-1].Stoc;
  For i:=Start To Stop Do
    Begin
      If Fisa.Operatie[i].Poz<>0 Then
        Begin
          Temp:=Temp+Fisa.Operatie[i].Intrare-
                     Fisa.Operatie[i].Iesire;
          Fisa.Operatie[i].Stoc:=Temp;
        End;
    End;
  Fisa.StocFinal:=Temp;
  Result:=Temp;
End;

Procedure FisaNoua(Var Fisa:TFisa;Nume:String);
Var i:Integer;
Begin
  Fisa.Denumire:=Nume;
  Fisa.Cod:='';
  Fisa.StocInitial:=0;
  Fisa.StocFinal:=0;
  Fisa.Pret:=0;
  Fisa.Comentariu:='';
  For i:=1 To MaximOperatii Do
    Begin
      Fisa.Operatie[i].Poz:=0;
      Fisa.Operatie[i].Document.Data:='';
      Fisa.Operatie[i].Document.Numar:='';
      Fisa.Operatie[i].Document.Fel:='';
      Fisa.Operatie[i].Intrare:=0;
      Fisa.Operatie[i].Iesire:=0;
      Fisa.Operatie[i].Stoc:=0;
      Fisa.Operatie[i].Pret:=0;
      Fisa.Operatie[i].Destinatie:='';
      Fisa.Operatie[i].Comentariu:='';
    End;
End;

Procedure DeschidereFisa(Adresa:String;Var Fisa:TFisa);
Var f:File Of TFisa;
Begin
  If FileExists(Adresa) Then
    Begin
      AssignFile(f,Adresa);
      Reset(f);
      Try
        Read(f,Fisa);
      Except
        MessageDlg('Fisierul "'+Adresa+'" nu corespunde formatului!',
                   mtError,[mbOk],0);
      End;
      CloseFile(f);
      //CalculareStocFinal(Fisa,1,MaximOperatii);  /////////
    End;                                                  //
End;                                                      //
                                                          //
Procedure SalvareFisa(Adresa:String);                     //     Daca nu e la Deschidere
Var f:File Of TFisa;                                      //             e la Salvare
Begin                                                     //
  CalculareStocFinal(Fisa,1,MaximOperatii);/////////////////
  AssignFile(f,UpperCase(Adresa));
  Rewrite(f);
  Write(f,Fisa);
  CloseFile(f);
End;

Procedure StergereFisa(Adresa:String);
Var f:File Of TFisa;
Begin
  AssignFile(f,Adresa);
  Try
    Reset(f);
    CloseFile(f);
    Erase(f);
  Except
    On EInOutError Do
      MessageDlg('Eroare la stergere',mtError,[mbOk],0);
  End;
End;

Function ReSelectare(Nume:String;Lista:TFileListBox;Pos:Integer):Integer;
Var i:Integer;
Begin
  Result:=-1;
  For i:=1 To Lista.Items.Capacity Do
    Begin
      If Nume=Lista.Items[i-1] Then
        Begin
          Result:=i-1;
          Break;
        End;
    End;
  If Result=-1 Then
    Result:=Pos;
  If Result>=Lista.Items.Capacity Then
    Result:=Lista.Items.Capacity-1;
End;

Procedure TFise_.IncarcareFisa(Adresa:String);
Begin
  If FileExists(Adresa) Then
    Begin
      DeschidereFisa(Adresa,Fisa);
      Denumire.Text:=Fisa.Denumire;
      Cod.Text:=Fisa.Cod;
      StocInitial.Text:=FloatToStr(Fisa.StocInitial);
      StocFinal.Text:=FloatToStr(Fisa.StocFinal);
      PretAproximativ.Text:=FloatToStr(Fisa.Pret);
      Comentariu.Text:=Fisa.Comentariu;
    End
  Else
    Begin
      Denumire.Text:='';
      Cod.Text:='';
      StocInitial.Text:='0';
      PretAproximativ.Text:='';
      Comentariu.Text:='';
    End;
End;

Procedure TFise_.ShowHint(Sender: TObject);
begin
  Panel6.Caption:=Application.Hint;
end;

procedure TFise_.FormCreate(Sender: TObject);
begin
  DirectorAplicatie:=ExtractFileDir(Application.ExeName);
  If DirectorAplicatie[Length(DirectorAplicatie)]<>'\' Then
    DirectorAplicatie:=DirectorAplicatie+'\';
  CreareDirector('FISE');
  CreareDirector('STERSE');
  FisiereFisa.Mask:='*.'+Extensie;
  IncarcareSetariIni;
  Case FormatDataFisa Of
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
  Case TipStergereFisa Of
    0:
      S0Click(Sender);
    1:
      S1Click(Sender);
    2:
      S2Click(Sender);
    3:
      S3Click(Sender);
  End;
end;

procedure TFise_.FormActivate(Sender: TObject);
Var Poz:Integer;
    Nume:String;
begin
  If FisiereFisa.ItemIndex<>-1 Then                //Poz
    Begin
      Poz:=FisiereFisa.ItemIndex;
      Nume:=Fisa.Denumire;
    End;
  Application.OnHint:=ShowHint;
  FisiereFisa.Directory:='C:\';
  FisiereFisa.Directory:=DirectorAplicatie+'FISE\';
  FisiereFisa.ItemIndex:=ReSelectare(Nume,FisiereFisa,Poz);
  FisiereFisaChange(Sender);
end;

procedure TFise_.FisiereFisaChange(Sender: TObject);
begin
  Panel6.Caption:='';
  Panel6.Repaint;
  Panel7.Visible:=True;
  Gauge1.Progress:=Round(1*100/6);
  If FisiereFisa.ItemIndex<>-1 Then
    DeschidereFisa(DirectorAplicatie+'FISE\'+FisiereFisa.Items[FisiereFisa.ItemIndex],Fisa)
  Else
    FisaNoua(Fisa,'');
  Gauge1.Progress:=Round(2*100/6);
  If FisiereFisa.ItemIndex<>-1 Then
    Begin
      Fise_.Caption:=Versiune+' - editare fisa ['+FisiereFisa.Items[FisiereFisa.ItemIndex]+']';
      Operatii_.Caption:=Versiune+' - editare operatii fisa ['+FisiereFisa.Items[FisiereFisa.ItemIndex]+']';
      Raport_.Caption:=Versiune+' - generare raport ['+FisiereFisa.Items[FisiereFisa.ItemIndex]+']';
    End
  Else
    Begin
      Fise_.Caption:=Versiune+' - editare fisa []';
      Operatii_.Caption:=Versiune+' - editare operatii fisa []';
      Raport_.Caption:=Versiune+' - generare raport []';
    End;
  Gauge1.Progress:=Round(3*100/6);
  If (FisiereFisa.Items.Capacity<>0) And (FisiereFisa.ItemIndex=-1) Then
    FisiereFisa.ItemIndex:=0;
  Gauge1.Progress:=Round(4*100/6);
  If FisiereFisa.ItemIndex<>-1 Then
    Begin
      IncarcareFisa(DirectorAplicatie+'FISE\'+FisiereFisa.Items[FisiereFisa.ItemIndex]);
    End
  Else
    Begin
      Denumire.Text:='';
      Cod.Text:='';
      PretAproximativ.Text:='';
      StocInitial.Text:='';
      StocFinal.Text:='';
      Comentariu.Lines.Clear;
    End;
  Gauge1.Progress:=Round(5*100/6);
  SetareControale;
  Gauge1.Progress:=Round(6*100/6);
  Panel7.Visible:=False;
end;

Function ValidareNume(Nume:String):Boolean;
Var i:Integer;
Begin
  Result:=True;
  For i:=1 To Length(Nume) Do
    If Not (Nume[i] In ['A'..'Z','a'..'z','0'..'9']) Then
      Begin
        Result:=False;
        Break;
      End;
End;

procedure TFise_.AdaugareClick(Sender: TObject);
Label Validare;
Var Nou:Boolean;
    Nume:String;
    i,Poz:Integer;
begin
  Poz:=FisiereFisa.ItemIndex;
  Nume:='';
  Repeat
    Validare:
      Nou:=InputQuery('Fisa noua','Denumire fisa (doar caractere alfanumerice):',Nume);
    If Not ValidareNume(Nume) Then
      Goto Validare;
  Until (Nume<>'') Or (Not Nou);
  Nume:=UpperCase(Nume);
  If Nou Then
    Begin
      For i:=1 To FisiereFisa.Items.Capacity Do
        Begin
          If Nume+Extensie=FisiereFisa.Items[i-1] Then
            Begin
              Nou:=False;
              Break;
            End;
        End;
      If Nou Then
        Begin
          FisaNoua(Fisa,Nume);
          SalvareFisa(DirectorAplicatie+'FISE\'+Nume+Extensie);
          DeschidereFisa(DirectorAplicatie+'FISE\'+Nume+Extensie,Fisa);
        End
      Else
        Begin
          ShowMessage('Fisa "'+Nume+'" exista!');
          FisiereFisa.ItemIndex:=i-1;
          FisiereFisaChange(Sender);
        End;
    End;
  FisiereFisa.Directory:='C:\';
  FisiereFisa.Directory:=DirectorAplicatie+'FISE\';
  FisiereFisa.ItemIndex:=ReSelectare(Nume,FisiereFisa,Poz);
  FisiereFisaChange(Sender);
end;

procedure TFise_.SalvareClick(Sender: TObject);
Var Poz:Integer;
    Temp,TempNume:String;
begin
  Panel6.Caption:='';
  Panel6.Repaint;
  Panel7.Visible:=True;
  Gauge1.Progress:=Round(1*100/15);
  Poz:=FisiereFisa.ItemIndex;
  Gauge1.Progress:=Round(2*100/15);
  If Poz<>-1 Then
    TempNume:=FisiereFisa.Items[FisiereFisa.ItemIndex];
  Gauge1.Progress:=Round(3*100/15);
  If Poz<>-1 Then
    Temp:=Fisa.Denumire;
  Gauge1.Progress:=Round(4*100/15);
  If Poz<>-1 Then
    Fisa.Denumire:=Denumire.Text;
  Gauge1.Progress:=Round(5*100/15);
  If Poz<>-1 Then
    Fisa.Cod:=Cod.Text;
  Gauge1.Progress:=Round(6*100/15);
  If Poz<>-1 Then
    Fisa.StocInitial:=StrToFloat(StocInitial.Text);
  Gauge1.Progress:=Round(7*100/15);
  If Poz<>-1 Then
    Fisa.StocFinal:=StrToFloat(StocFinal.Text);
  Gauge1.Progress:=Round(8*100/15);
  If Poz<>-1 Then
    Fisa.Pret:=StrToFloat(PretAproximativ.Text);
  Gauge1.Progress:=Round(9*100/15);
  If Poz<>-1 Then
    Fisa.Comentariu:=Comentariu.Text;
  Gauge1.Progress:=Round(10*100/15);
  If (Poz<>-1) And (Temp<>Fisa.Denumire) Then
    Begin
      StergereFisa(DirectorAplicatie+'FISE\'+Temp+Extensie);
    End;
  Gauge1.Progress:=Round(11*100/15);
  If Poz<>-1 Then
    SalvareFisa(DirectorAplicatie+'FISE\'+Fisa.Denumire+Extensie);
  Gauge1.Progress:=Round(12*100/15);
  FisiereFisa.Directory:='C:\';
  Gauge1.Progress:=Round(13*100/15);
  FisiereFisa.Directory:=DirectorAplicatie+'FISE\';
  Gauge1.Progress:=Round(14*100/15);
  FisiereFisa.ItemIndex:=ReSelectare(TempNume,FisiereFisa,Poz);
  Gauge1.Progress:=Round(15*100/15);
  FisiereFisaChange(Sender);
  Panel7.Visible:=False;
end;

procedure TFise_.StergereClick(Sender: TObject);
Var Poz:Integer;
    TempNume:String;
begin
  Poz:=FisiereFisa.ItemIndex;
  If Poz<>-1 Then
    TempNume:=FisiereFisa.Items[FisiereFisa.ItemIndex];
  If Poz<>-1 Then
    Case TipStergereFisa Of
      0:
        If MessageDlg('Se confirma stergerea fisei "'+TempNume+'"?',
                      mtConfirmation,[mbYes,mbNo],0)=mrYes Then
          Begin
            StergereFisa(DirectorAplicatie+'FISE\'+TempNume+Extensie);
          End;
      1:
        TrimiteInRecycleRin(DirectorAplicatie+'FISE\'+TempNume+Extensie);
      2:
        RenameFile(DirectorAplicatie+'FISE\'+TempNume+Extensie,
                   DirectorAplicatie+'FISE\'+TempNume+'.TMP');
      3:
        MoveFile(PChar(DirectorAplicatie+'FISE\'+TempNume+Extensie),
                 PChar(PChar(DirectorAplicatie+'STERSE\'+TempNume+Extensie)));
    End;
  FisiereFisa.Directory:='C:\';
  FisiereFisa.Directory:=DirectorAplicatie+'FISE\';
  FisiereFisa.ItemIndex:=ReSelectare(TempNume,FisiereFisa,Poz);
  FisiereFisaChange(Sender);
end;

procedure TFise_.Despre1Click(Sender: TObject);
begin
  Despre_.ShowModal;
end;

procedure TFise_.Iesire1Click(Sender: TObject);
begin
  Fise_.Close;
end;

procedure TFise_.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  If MessageDlg('Se inchide aplicatia?',mtConfirmation,[mbYes,mbNo],0)=mrYes Then
    Begin
      SalvareSetariIni;
      CanClose:=True;
    End
  Else
    CanClose:=False;
end;

procedure TFise_.ProductieClick(Sender: TObject);
begin
  Fise_.Enabled:=False;
  Fise_.Hide;
  Operatii_.Enabled:=True;
  Operatii_.Show;
end;
  
procedure TFise_.Fisaanterioara1Click(Sender: TObject);
begin
  If FisiereFisa.ItemIndex>0 Then
    Begin
      FisiereFisa.ItemIndex:=FisiereFisa.ItemIndex-1;
      FisiereFisaChange(Sender);
    End;
end;

procedure TFise_.Fisaurmatoare1Click(Sender: TObject);
begin
  If FisiereFisa.ItemIndex<=FisiereFisa.Items.Capacity Then
    Begin
      FisiereFisa.ItemIndex:=FisiereFisa.ItemIndex+1;
      FisiereFisaChange(Sender);
    End;
end;     

procedure TFise_.RaportClick(Sender: TObject);
begin
  Fise_.Enabled:=False;
  Fise_.Hide;
  FereastraAscunsa:='gestiune';
  Raport_.Enabled:=True;
  Raport_.Show;
end;

procedure TFise_.Informatii1Click(Sender: TObject);
begin
  Istoric_.ShowModal;
end;

procedure TFise_.PretAproximativChange(Sender: TObject);
begin
  If EsteNumar(PretAproximativ.Text) Then
    If StrToNumber(PretAproximativ.Text)=Fisa.Pret Then
      Begin
        LabelPretAproximativ.Font.Color:=CuloareSalvat;
        PretAproximativ.Font.Color:=CuloareSalvat;
      End
    Else
      Begin
        LabelPretAproximativ.Font.Color:=CuloareNesalvat;
        PretAproximativ.Font.Color:=CuloareNesalvat;
      End
  Else
    Begin
      LabelPretAproximativ.Font.Color:=CuloareEroare;
      PretAproximativ.Font.Color:=CuloareEroare;
    End;
end;

procedure TFise_.StocInitialChange(Sender: TObject);
begin
  If EsteNumar(StocInitial.Text) Then
    If StrToNumber(StocInitial.Text)=Fisa.StocInitial Then
      Begin
        LabelStocInitial.Font.Color:=CuloareSalvat;
        StocInitial.Font.Color:=CuloareSalvat;
      End
    Else
      Begin
        LabelStocInitial.Font.Color:=CuloareNesalvat;
        StocInitial.Font.Color:=CuloareNesalvat;
      End
  Else
    Begin
      LabelStocInitial.Font.Color:=CuloareEroare;
      StocInitial.Font.Color:=CuloareEroare;
    End;
end;

procedure TFise_.DenumireChange(Sender: TObject);
begin
  If Denumire.Text=Fisa.Denumire Then
    Begin
      LabelDenumire.Font.Color:=CuloareSalvat;
      Denumire.Font.Color:=CuloareSalvat;
    End
  Else
    Begin
      LabelDenumire.Font.Color:=CuloareNesalvat;
      Denumire.Font.Color:=CuloareNesalvat;
    End;
end;

procedure TFise_.CodChange(Sender: TObject);
begin
  If Cod.Text=Fisa.Cod Then
    Begin
      LabelCod.Font.Color:=CuloareSalvat;
      Cod.Font.Color:=CuloareSalvat;
    End
  Else
    Begin
      LabelCod.Font.Color:=CuloareNesalvat;
      Cod.Font.Color:=CuloareNesalvat;
    End;
end;

procedure TFise_.ComentariuChange(Sender: TObject);
begin
    If Comentariu.Text=Fisa.Comentariu Then
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

procedure TFise_.D0Click(Sender: TObject);
begin
  D0.Checked:=True;
  FormatDataFisa:=0;
end;

procedure TFise_.D1Click(Sender: TObject);
begin
  D1.Checked:=True;
  FormatDataFisa:=1;
end;

procedure TFise_.D2Click(Sender: TObject);
begin
  D2.Checked:=True;
  FormatDataFisa:=2;
end;

procedure TFise_.D3Click(Sender: TObject);
begin
  D3.Checked:=True;
  FormatDataFisa:=3;
end;

procedure TFise_.D4Click(Sender: TObject);
begin
  D4.Checked:=True;
  FormatDataFisa:=4;
end;

procedure TFise_.S0Click(Sender: TObject);
begin
  S0.Checked:=True;
  TipStergereFisa:=0;
end;

procedure TFise_.S1Click(Sender: TObject);
begin
  S1.Checked:=True;
  TipStergereFisa:=1;
end;

procedure TFise_.S2Click(Sender: TObject);
begin
  S2.Checked:=True;
  TipStergereFisa:=2;
end;

procedure TFise_.S3Click(Sender: TObject);
begin
  S3.Checked:=True;
  TipStergereFisa:=3;
end;

end.
