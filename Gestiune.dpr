program Gestiune;

uses
  Forms,
  Windows,
  Dialogs,
  _Despre_ in '_Despre_.pas' {Despre_},
  _Fise_ in '_Fise_.pas' {Fise_},
  _Operatii_ in '_Operatii_.pas' {Operatii_},
  _Raport_ in '_Raport_.pas' {Raport_},
  _View_ in '_View_.pas' {View_},
  _Istoric_ in '_Istoric_.pas' {Istoric_};

{$R *.RES}

Const Versiune:String='GESTIUNE v1.2';      /////uita-te si in "_Gestiune_.pas"

begin
  If FindWindow('TIstoric_',PChar(Versiune+' - Informatii'))=0 Then
    Begin
      Application.Initialize;
      //With TSplash_.Execute Do
        Try
          Application.CreateForm(TFise_, Fise_);
  Application.CreateForm(TDespre_, Despre_);
  Application.CreateForm(TOperatii_, Operatii_);
  Application.CreateForm(TRaport_, Raport_);
  Application.CreateForm(TView_, View_);
  Application.CreateForm(TIstoric_, Istoric_);
  Finally
      //    Free;
        End;
      Application.Run;
    End
  Else
    MessageDlg('Aplicatia este deja lansata in executie!',mtInformation,[mbOk],0);
end.
