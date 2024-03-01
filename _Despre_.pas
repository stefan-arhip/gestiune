unit _Despre_;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ShellAPI, Dialogs, Menus;

Const Operator:String='';

type
  TDespre_ = class(TForm)
    OKButton: TButton;
    Panel2: TPanel;
    ProgramIcon: TImage;
    ProductName: TLabel;
    Version: TLabel;
    Copyright: TLabel;
    Comments: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    Label3: TLabel;
    MainMenu1: TMainMenu;
    Iesire1: TMenuItem;
    procedure OKButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Label2Click(Sender: TObject);
    procedure ProgramIconClick(Sender: TObject);
    procedure Iesire1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Despre_: TDespre_;

implementation

{$R *.DFM}

Procedure Executie (s:String);
  Var t:Array[0..79]Of Char;
  Begin
    StrPCopy(t,s);
    ShellExecute(0, Nil, t, Nil, Nil, SW_NORMAL);
  End;

procedure TDespre_.OKButtonClick(Sender: TObject);
begin
  Despre_.Close;
end;

procedure TDespre_.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  OKButtonClick(Sender);
end;

procedure TDespre_.Label2Click(Sender: TObject);
begin
  If MessageDlg('Se confirma descarcarea de pe Internet'+#13+
                'a ultimei versiuni a aplicatiei?',mtInformation,
                [mbYes,mbNo],0)=mrYes Then
    Begin
      Executie ('http:\\'+Label2.Caption);
      Label2.Font.Color:=clRed;
    End;
end;

procedure TDespre_.ProgramIconClick(Sender: TObject);
begin
  If MessageDlg('Se confirma trimiterea unui mesaj autorului?',
                mtInformation,[mbYes,mbNo],0)=mrYes Then
    Executie ('mailto:stedanarh@go.ro');
end;


procedure TDespre_.Iesire1Click(Sender: TObject);
begin
  //If PermiteIesirea Then
    Despre_.Close;
end;

procedure TDespre_.FormActivate(Sender: TObject);
begin
  Height:=232;
end;

procedure TDespre_.FormCreate(Sender: TObject);
begin
  Label1.Caption:=Operator;
end;

end.

