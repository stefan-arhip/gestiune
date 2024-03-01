unit _View_;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Menus, ExtCtrls, ShellApi, Clipbrd;

type
  TView_ = class(TForm)
    Container: TRichEdit;
    PopupMenu1: TPopupMenu;
    Export1: TMenuItem;
    SaveDialog1: TSaveDialog;
    Tiparire1: TMenuItem;
    PrinterSetupDialog1: TPrinterSetupDialog;
    ColorDialog1: TColorDialog;
    MainMenu1: TMainMenu;
    Iesire1: TMenuItem;
    ListBox1: TListBox;
    Panel1: TPanel;
    Fisier1: TMenuItem;
    Export2: TMenuItem;
    N2: TMenuItem;
    Tiparire2: TMenuItem;
    Undo1: TMenuItem;
    N1: TMenuItem;
    Cut1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Delete1: TMenuItem;
    N3: TMenuItem;
    SelectAll1: TMenuItem;
    N4: TMenuItem;
    Editare1: TMenuItem;
    Editare2: TMenuItem;
    Undo2: TMenuItem;
    N5: TMenuItem;
    Cut2: TMenuItem;
    Copy2: TMenuItem;
    Paste2: TMenuItem;
    Delete2: TMenuItem;
    N6: TMenuItem;
    SelectAll2: TMenuItem;
    procedure Export1Click(Sender: TObject);
    procedure Tiparire1Click(Sender: TObject);
    procedure Iesire1Click(Sender: TObject);
    procedure SaveDialog1TypeChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
  private
    procedure WM_SpoolerStatus(var Msg:TWMSPOOLERSTATUS); Message WM_SPOOLERSTATUS;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  View_: TView_;

implementation

{$R *.DFM}

Uses _Fise_;

procedure TView_.WM_SpoolerStatus(var Msg: TWMSpoolerStatus);
begin
  If Msg.JobsLeft=0 Then
    Panel1.Visible:=False
  Else
    Begin
      Panel1.Left:=(Width-Panel1.Width) Div 2;
      Panel1.Top:=(Height-Panel1.Height) Div 2;
      Panel1.Caption:='Tiparire '+IntToStr(Msg.JobsLeft)+' documente...';
      Panel1.Visible:=True;
    End;
  View_.Enabled:=Not Panel1.Visible;
end;

procedure TView_.Export1Click(Sender: TObject);
Var i:Integer;
begin
  SaveDialog1.InitialDir:=DirectorAplicatie;
  SaveDialog1.FileName:='FISA DE MAGAZIE '+Fisa.Denumire;
  If SaveDialog1.Execute Then
    Begin
      Case SaveDialog1.FilterIndex Of
        1:  //.RTF
          Container.Lines.SaveToFile(SaveDialog1.FileName);
        2:  //.TXT
          Begin
            ListBox1.Clear;
            For i:=1 To Container.Lines.Capacity Do
              ListBox1.Items.Add(Container.Lines[i-1]);
            ListBox1.Items.SaveToFile(SaveDialog1.FileName);
          End;
      End;
      If MessageDlg('Raportul a fost exportat in fisierul'#13+
                    '"'+SaveDialog1.FileName+'"'#13+
                    'Se deschide pentru vizualizare?',mtConfirmation,[mbYes,mbNo],0)=mrYes Then
        ShellExecute(0,Nil,PChar(SaveDialog1.FileName),Nil,Nil,SW_Maximize);//SW_Normal, SW_Show
    End;
end;

procedure TView_.Tiparire1Click(Sender: TObject);
begin
  If PrinterSetupDialog1.Execute Then
    Container.Print('FAZ - Tiparire... '+Container.Lines[1]);
end;                                 

procedure TView_.Iesire1Click(Sender: TObject);
begin
  View_.Close;
end;

procedure TView_.SaveDialog1TypeChange(Sender: TObject);
begin
  Case SaveDialog1.FilterIndex Of
    1:
      SaveDialog1.DefaultExt:='RTF';
    2:
      SaveDialog1.DefaultExt:='TXT';
  End;
end;

procedure TView_.FormActivate(Sender: TObject);
begin
  //Container.Font.Name:=Setari_.SGF.Items[0];
  //Container.Font.Size:=StrToInt(Setari_.SGF.Items[1]);
  //Container.Font.Color:=StringToColor(Setari_.SGF.Items[2]);
end;

procedure TView_.SelectAll1Click(Sender: TObject);
begin
  Container.SelectAll;
end;

procedure TView_.Copy1Click(Sender: TObject);
begin
  //ShowMessage('Nedisponibil!');
end;

end.
