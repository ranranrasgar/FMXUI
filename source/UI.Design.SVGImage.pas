unit UI.Design.SVGImage;

interface

uses
  UI.Utils.SVGImage,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, UI.Base,
  FMX.Layouts, FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation;

type
  TFrmDesignSVGImage = class(TForm)
    Layout1: TLayout;
    Button2: TButton;
    btnOk: TButton;
    labelScale: TLabel;
    edtHeight: TEdit;
    Button1: TButton;
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    edtWidth: TEdit;
    Button3: TButton;
    View1: TView;
    OpenDialog1: TOpenDialog;
    Button4: TButton;
    procedure Button3Click(Sender: TObject);
    procedure View1Resize(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure edtWidthExit(Sender: TObject);
    procedure edtHeightExit(Sender: TObject);
    procedure edtWidthKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
    FChangeing: Boolean;
  public
    { Public declarations }
    Bmp: TSVGImage;
    procedure LoadImage(ABmp: TSVGImage);
    procedure ViewImage();
  end;

var
  FrmDesignSVGImage: TFrmDesignSVGImage;

implementation

{$R *.fmx}

procedure TFrmDesignSVGImage.btnOkClick(Sender: TObject);
begin
  if Assigned(Bmp) and (not Bmp.Empty) then
    ModalResult := mrOk
  else begin
    ShowMessage('Please load the SVG image.');
    Exit;
  end;
end;

procedure TFrmDesignSVGImage.Button1Click(Sender: TObject);
begin
  if (Bmp = nil) or (Bmp.Empty) then
    Exit;
  View1.Width := Bmp.Data.ViewBox.X;
  View1.Height := Bmp.Data.ViewBox.Y;
end;

procedure TFrmDesignSVGImage.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmDesignSVGImage.Button3Click(Sender: TObject);
begin
  if OpenDialog1.Execute() then begin
    if Bmp = nil then
      Bmp := TSVGImage.Create;
    Bmp.LoadFormFile(OpenDialog1.FileName);
    ViewImage;
  end;
end;

procedure TFrmDesignSVGImage.Button4Click(Sender: TObject);
begin
  FreeAndNil(Bmp);
  ViewImage();
end;

procedure TFrmDesignSVGImage.edtHeightExit(Sender: TObject);
begin
  if Bmp = nil then Exit;
  if FChangeing then
    Exit;
  FChangeing := True;
  try
    Bmp.Height := StrToIntDef(edtHeight.Text, Bmp.Height);
    ViewImage();
  finally
    FChangeing := False;
  end;
end;

procedure TFrmDesignSVGImage.edtWidthExit(Sender: TObject);
begin
  if Bmp = nil then Exit;
  if FChangeing then
    Exit;
  FChangeing := True;
  try
    Bmp.Width := StrToIntDef(edtWidth.Text, Bmp.Width);
    ViewImage();
  finally
    FChangeing := False;
  end;
end;

procedure TFrmDesignSVGImage.edtWidthKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then begin
    Key := 0;
    TControl(Sender).FocusToNext();
  end;
end;

procedure TFrmDesignSVGImage.LoadImage(ABmp: TSVGImage);
begin
  if not Assigned(ABmp) then begin
    FreeAndNil(Bmp);
    Exit;
  end;
  if Bmp = nil then
    Bmp := TSVGImage.Create;
  Bmp.Assign(ABmp);
  ViewImage();
end;

procedure TFrmDesignSVGImage.View1Resize(Sender: TObject);
begin
  if FChangeing then
    Exit;
  FChangeing := True;
  edtWidth.Text := IntToStr(Round(View1.Width));
  edtHeight.Text := IntToStr(Round(View1.Height));
  FChangeing := False;
end;

procedure TFrmDesignSVGImage.ViewImage;
begin
  if Assigned(Bmp) then begin
    View1.Width := Bmp.Width;
    View1.Height := Bmp.Height;
    View1.Background.SetBitmap(TViewState.None, Bmp.Bitmap);
  end else begin
    View1.Width := 50;
    View1.Height := 50;
    View1.Background.SetBitmap(TViewState.None, TBitmap(nil));
  end;
  View1.Invalidate;
end;

end.