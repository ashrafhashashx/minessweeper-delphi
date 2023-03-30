unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Mask, ComCtrls, Buttons;

type
  TForm1 = class(TForm)
    Go: TButton;              {God}
    Li: TLabeledEdit;         {Lines}
    Mi: TLabeledEdit;         {Mines}
    Manager         : TButton;
    Co: TLabeledEdit;         {Columns}
    Ti: TLabeledEdit;
    Timer: TTimer;
    Exit: TButton;
    Minimize: TButton;
    StaticText1: TStaticText;         {Time}
    procedure FormCreate(Sender: TObject);
    procedure GoClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure LiChange(Sender: TObject);
    procedure CoChange(Sender: TObject);
    procedure MiChange(Sender: TObject);
    procedure CoExit(Sender: TObject);
    procedure MiExit(Sender: TObject);
    procedure LiClick(Sender: TObject);
    procedure CoClick(Sender: TObject);
    procedure MiClick(Sender: TObject);
    procedure LiExit(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure MinimizeClick(Sender: TObject);
    procedure ManagerClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

const OfficialButtonSize=25;

var
  Form1: TForm1;
  B:Array[1..99,1..99] of TButton;
  S:Array[1..99,1..99] of TPanel;
  X {is there a mine or not} :Array[1..99,1..99] of Boolean;
  Mines {number of mines} ,NumberOfClickedButtons,FirstTop,FirstLeft:Integer;
  Lines,Columns,MaxLines,MaxColumns:Byte;
  Time:LongInt;
  FirstClick:Boolean;

implementation
{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
  var i,j:Byte;
  begin
    Randomize;
    Time:=0;
    Lines:=0;
    Columns:=0;
    Mines:=0;
    FirstTop:= 40;
    FirstLeft:=2;
    MaxLines:=29;
    MaxColumns:=54;
    NumberOfClickedButtons:=0;

    for i:=1 to MaxLines do for j:=1 to MaxColumns do
      begin
      B[i,j]:=TButton.Create(Application);
      S[i,j]:= TPanel.Create(Application);
      S[i,j].Parent:=Form1;
      B[i,j].Parent:=Form1;
      B[i,j].Hide;
      S[i,j].Hide;
      B[i,j].Height:=OfficialButtonSize;
      S[i,j].Height:=OfficialButtonSize;
      B[i,j].Width:=OfficialButtonSize;
      S[i,j].Width:=OfficialButtonSize;
      B[i,j].Left:=OfficialButtonSize*(j-1)+ FirstLeft;
      S[i,j].Left:=B[i,j].Left;
      B[i,j].Top:=OfficialButtonSize*(i-1)+ FirstTop;
      S[i,j].Top:=B[i,j].Top;

      B[i,j].OnClick:= Manager.OnClick;
      B[i,j].Hint:=IntToStr(10000 + i*100 + j);
      B[i,j].ShowHint:= False;

      X[i,j]:=False;

      S[i,j].Font.Size:=13;
      S[i,j].Color:=clSkyBlue;
      S[i,j].Caption:='0';
      end;
  end;

procedure TForm1.TimerTimer(Sender: TObject);
  begin Inc(Time); Ti.Text:=IntToStr(Time); end;

procedure TForm1.GoClick(Sender: TObject);
var i,j,oldLines,oldColumns:Byte;
begin
  //preparing values
  Time:=0;
  Ti.Text:='';
  Timer.Enabled:=False;
  NumberOfClickedButtons:=0;
  oldLines:=Lines;
  oldColumns:=Columns;
  if Li.Text='Random' then Lines:=Random(MaxLines)+1 else Lines:=StrToInt(Li.Text);
  if Co.Text='Random' then Columns:=Random(MaxColumns)+1  else Columns:=StrToInt(Co.Text);
  if Mi.Text='Random' then
    Mines:=Abs(Random(Lines*Columns-1)-Random(Lines*Columns-1))div 4
  else
    Mines:=StrToInt(Mi.Text);
  if Mines>(Lines*Columns-1)then
    begin Mines:=Lines*Columns-1; Mi.Text:=IntToStr(Mines);end;
  //cleaning
  FirstClick:=True;
  if oldLines>0 then for i:=1 to oldLines do for j:=1 to oldColumns do
    if (i>Lines) or (j>Columns) then begin S[i,j].Hide; B[i,j].Hide; end;
  //building
  for i:=1 to Lines do for j:=1 to Columns do
    begin B[i,j].Show; S[i,j].Show; X[i,j]:=False; S[i,j].Caption:='0'; end;

end;

procedure TForm1.LiChange(Sender: TObject);
begin
  if (Length(Li.Text)>0) and (not (Li.Text='Random')) then
  begin
    if not (Li.Text[Length(Li.Text)] in ['0'..'9'])then
      begin Li.Text:=''; end
    else if Li.Text='0' then
      begin Li.Text:='1'; end
    else if StrToInt(Li.Text)>MaxLines then
      begin Li.Text:=IntToStr(MaxLines); end;
  end;
end;

procedure TForm1.CoChange(Sender: TObject);
begin
  if (Length(Co.Text)>0) and (not (Co.Text='Random')) then
  begin
    if not (Co.Text[Length(Co.Text)] in ['0'..'9']) then
      begin Co.Text:=''; end
    else if Co.Text='0' then
      begin Co.Text:='1'; end
    else if StrToInt(Co.Text)>MaxColumns then
      begin Co.Text:=IntToStr(MaxColumns); end;
  end;
end;

procedure TForm1.MiChange(Sender: TObject);
begin
  if (Length(Mi.Text)>0) and (not (Mi.Text='Random')) then
  begin
    if not (Mi.Text[Length(Mi.Text)] in ['0'..'9']) then
      begin Mi.Text:=''; end
    else if Mi.Text='00' then
      begin Mi.Text:='0'; end
    else if StrToInt(Mi.Text)>(MaxLines*MaxColumns-1) then
      begin Mi.Text:=IntToStr(MaxLines*MaxColumns-1); end;
  end;
end;

procedure TForm1.CoExit(Sender: TObject);begin if Co.Text='' then Co.Text:='Random';end;
procedure TForm1.MiExit(Sender: TObject);begin if Mi.Text='' then Mi.Text:='Random';end;
procedure TForm1.LiExit(Sender: TObject);begin if Li.Text='' then Li.Text:='Random';end;

procedure TForm1.LiClick(Sender: TObject);begin Li.Text:=''; end;
procedure TForm1.CoClick(Sender: TObject);begin Co.Text:=''; end;
procedure TForm1.MiClick(Sender: TObject);begin Mi.Text:=''; end;

procedure TForm1.ExitClick(Sender: TObject); begin Form1.Close; end;

procedure TForm1.MinimizeClick(Sender: TObject); begin Form1.WindowState:=wsMinimized; end;

procedure FinishGame(Winner:Boolean);
var i,j:Byte;
begin
  Form1.Timer.Enabled:=False;
  if Winner then ShowMessage('YOU WIN !!!') else ShowMessage('you lose ...');
  for i:=1 to Lines do for j:=1 to Columns do B[i,j].Hide;
end;

procedure PleaseClick(i,j:Byte);
begin
  if(i>0)and(i<=MaxLines)and(j>0)and(j<=MaxColumns)and(B[i,j].Visible)then
  begin
    if X[i,j] then FinishGame(False)
    else
    begin
      Inc(NumberOfClickedButtons);
      B[i,j].Hide;
      if NumberOfClickedButtons = ((Lines*Columns) - Mines) then FinishGame(True);
      if S[i,j].Caption='' then
      begin
        PleaseClick(i-1,j);
        PleaseClick(i-1,j+1);
        PleaseClick(i,j+1);
        PleaseClick(i+1,j+1);
        PleaseClick(i+1,j);
        PleaseClick(i+1,j-1);
        PleaseClick(i,j-1);
        PleaseClick(i-1,j-1);
      end;
    end;
  end;
end;

procedure IncreaseSurroundingMines(i,j:Byte);
begin
  if (i>0)and(i<=Lines)and(j>0)and(j<=Columns)then if not X[i,j] then
    S[i,j].Caption:=IntToStr(StrToInt(S[i,j].Caption)+1);
end;

procedure TForm1.ManagerClick(Sender: TObject);
var i,j,ii,jj:Byte; MinesLeft:Integer;
begin
  i:= StrToInt(Copy(TButton(Sender).Hint,2,2));
  j:= StrToInt(Copy(TButton(Sender).Hint,4,2));
  if FirstClick then
  //putting mines
  begin
    FirstClick:=False;
    Timer.Enabled:=True;
    MinesLeft:=Mines;
    while (MinesLeft > 0 ) do
    begin
      ii:=Random(Lines)+1;
      jj:=Random(Columns)+1;
      if (not(X[ii,jj])) and ((ii<>i) or (jj<>j)) then
      begin
        X[ii,jj]:=True;
        S[ii,jj].Caption:='X';
        MinesLeft:=MinesLeft-1;
        IncreaseSurroundingMines(ii-1,jj);    //up
        IncreaseSurroundingMines(ii-1,jj+1);  //Upper Right
        IncreaseSurroundingMines(ii,jj+1);    //Right
        IncreaseSurroundingMines(ii+1,jj+1);  //Down Right
        IncreaseSurroundingMines(ii+1,jj);    //Down
        IncreaseSurroundingMines(ii+1,jj-1);  //Down Left
        IncreaseSurroundingMines(ii,jj-1);    //Left
        IncreaseSurroundingMines(ii-1,jj-1);  //Upper Left
      end;
    end;
    for ii:=1 to Lines do for jj:=1 to Columns do if S[ii,jj].Caption='0' then
    S[ii,jj].Caption:='';
  end;
  PleaseClick(i,j);
end;

end.
{0936725339}
{åäÇß ØÑíŞÉ ÑÈãÇ ÊÎáÕß ãä ÈØÁ ÇáÈÑäÇãÌ æ åí Ãä ÊŞæã ÈÍĞİå Ãæ åäÇß ØÑíŞÉ ÃÎÑì
åí ÈÊäÓíŞ ÃÈÚÇÏ æ ãßÇä ÇáãÑÈÚÇÊ ÇáÈíÖ (ÇáÃÔßÇá) ÃæáÇğ ÈÃæá ÚäÏ ÇáÍÇÌÉ Ãí ÚäÏ ÇáÖÛØ
Úáì ÇáÒÑ Ğí ÅÍÏÇËíÇÊ ãÚíäÉ íÈÏÃ ÊäÓíŞ ÇáÔßá ÇáĞí ÊÍÊå ...
æ ÃíÖÇğ íãßääÇ ÌÚá ÇáÃáÛÇã ÊÊæÑÒÚ İí Ãæá ÇááÚÈÉ ÈÏáÇğ ãä ÌÚáåÇ ÊİÚá Ğáß ÚäÏ
ÇáÖÛØ Úáì ÇáÒÑ ÇáÃæá , æ ÇáÃİÖá ãä Ğáß ÌÚáåÇ ÊÊæÒÚ ÃæáÇğ ÈÃæá æ åĞå ÊŞäíÉ áã ÃİßÑ
ÈÚÏ İí ßíİíÉ ÊäİíĞåÇ.
}



























