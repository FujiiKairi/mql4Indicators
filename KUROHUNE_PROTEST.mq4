//+------------------------------------------------------------------+
//|                                                         asdf.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                              https://www.mql5.co |
//+------------------------------------------------------------------+
#define MQL4
#define PROPERTY_LINK ""
#define PROPERTY_COPYRIGHT ""
#define PROPERTY_DESCRIPTION ""
#define OBJNAME_PREFIX "OBJ I23g "
#define OBJNAME_BUY OBJNAME_PREFIX + "BUY "
#define OBJNAME_SELL OBJNAME_PREFIX + "SELL "
#define OUTPUT_CONSOLE LEVEL_NONE
#define OUTPUT_FILE LEVEL_NONE
#define OUTPUT_TESTING false
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.co"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 4//(表示用＋計算用のバッファの数)
//GogoJungle top////////////////////////////////////////////////////|
string pid = "17884";
string AccountCert;
#import "wininet.dll"
#define INTERNET_OPEN_TYPE_DIRECT 0
#define AGENT "MetaTrader 4 Terminal fx-on Auth 2018"
#define READURL_BUFFER_SIZE 1000
int InternetOpenW(string sAgent, int lAccessType, string sProxyName="", string sProxyBypass="", int lFlags=0);
int InternetOpenUrlW(int hInternetSession, string sUrl, string sHeaders="", int lHeadersLength=0, int lFlags=0, int lContext=0);
int InternetReadFile(int, uchar & arr[], int, int & arr[]);
int InternetCloseHandle(int hInet);
#import

string GrabWeb(){
  int ErrCd = 0;
  string mes = "";

  if(!IsDllsAllowed()) { ErrCd=1; mes="Authentication failure - Please allow use of DLL : by GogoJungle"; }
  else if(StringFind(WindowExpertName(), "_", 0)==-1){ ErrCd=11; mes="Invalid file name. Please download again from our site : by GogoJungle"; }
  if(ErrCd>0) return(mes);

  if(IsTesting()) { mes="Authentication success - Testion mode : by GogoJungle"; return(mes); }

  int lReturn[1];
  uchar arrReceive[];
  string sid = GetSid();
  string strUrl = StringConcatenate("https://auth.fx-on.com/indicator/index.php?pid=",pid, "&sid=",sid,"&ac=",AccountCompany(),"&an=",IntegerToString(AccountNumber()));
  int hSession = InternetOpenW(AGENT, INTERNET_OPEN_TYPE_DIRECT, "0", "0", 0);
  int hInternet = InternetOpenUrlW(hSession, strUrl, NULL, 0, 0, 0);
  ArrayResize(arrReceive, READURL_BUFFER_SIZE + 1);
  int success = InternetReadFile(hInternet, arrReceive, READURL_BUFFER_SIZE, lReturn);
  string errmes = "Authentication failure - Error connecting to server : by GogoJungle";
  if( success==0 ){
    InternetCloseHandle(hSession);
    return(errmes);
  }
  string strThisRead = CharArrayToString(arrReceive, 0, ArraySize(arrReceive), CP_UTF8);
  InternetCloseHandle(hSession);
  if(StringFind(strThisRead, "Authentication") == -1) return(errmes);
  else return(strThisRead);
}
void Disp(string s){Print(s);Comment(s);}

string GetSid(){
  string filename=WindowExpertName();
  int strpos = 0;
  int cutlen = 0;
  for(int a=0; a<10 ; a++){     strpos = StringFind(filename, "_", 0)+1;
    if(strpos<=0) break;
    cutlen = StringLen(filename)-strpos;
    filename = StringSubstr(filename, strpos, cutlen);
  }
  return(filename);
}
int IndicatorCountedFXON(){
  if(AuthInitiarize == false){
    AuthInitiarize = true;
    return(0);
  }
  return IndicatorCounted();
}

bool AuthInitiarize = false;
bool AuthResult = false;
bool AuthTry = false;
// GogoJungle top ////////////////////////////////////////////////////|
      

enum ENUM_MA
{
    SHORT_TERM = 0,              // 短期
    MEDIUM_TERM = 1,             // 中期
    LONG_TERM = 2,               // 長期
    SHORT_MEDIUM_TERM = 3,       // 短中期
    MEDIUM_LONG_TERM = 4,        // 中長期
    SHORT_MEDIUM_LONG_TERM = 5,  // 短中長期
};
enum ENUM_SHIFT
{
    SHIFT_CURRENT = 0,      // current bar
    SHIFT_PREVIOUS1 = 1,    // 1 previous bar
    SHIFT_PREVIOUS2 = 2,    // 2 previous bar
    SHIFT_PREVIOUS3 = 3,    // 3 previous bar
    SHIFT_PREVIOUS4 = 4,    // 4 previous bar
    SHIFT_PREVIOUS5 = 5,    // 5 previous bar
    SHIFT_PREVIOUS6 = 6     // 6 previous bar
};
input   string              SeparateBands = "";                         // ▼ ボリンジャーバンド設定
input   uint                BandsPeriod = 10;                           // ┣ 期間
input   double              BandsDeviation = 2;                         // ┗ 偏差

input   string              SeparateRSI = "";                           // ▼ RSI設定
input   uint                RSIPeriod = 14;                             // ┣ 期間
input   string              SeparateRSIBands = "";                      // ┗ ▼ ボリンジャーバンド設定
input   uint                RSIBandsPeriod = 21;                        // 　 ┣ 期間
input   double              RSIBandsDeviation = 2;                      // 　 ┗ 偏差

input   string              SeparateDisplay = "";                       // ▼ ディスプレイ設定
input   uint                ArrowCountNum = 100;                        // ┣ カウントする矢印の数
input   bool                UseResultDisplay = true;                    // ┗ ディスプレイON/OFF

input   string              KakuteiArrow = "";                          // ▼ 足が確定してから矢印を出す
input   bool                Kakutei =true;                              // ┗ ON/OFF

input   string              SeparateArrow = "";                         // ▼ 矢印設定
input   string              SeparateArrowColor = "";                    // ┣ 色
input   color               ArrowColorBuy = clrAqua;                    // ┃ ┣ 買
input   color               ArrowColorSell = clrMagenta;                // ┃ ┗ 売
input   uint                ArrowSize = 5;                              // ┗ 大きさ

input   string              SeparateAlert = "";                         // ▼ アラート設定
input   bool                UseAlert = true;                            // ┗ ON/OFF

input   string              SeparateSendMail = "";                      // ▼ メール設定
input   bool                UseSendMail = true;                         // ┗ ON/OFF
//+----------------------------------------------------------------------------+


//--- Global Files

double  Arrow[];
double  WinBuffer[];
double  LoseBuffer[];
double  RSIBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
    {
        
        
    
       
    
        // コメント削除
        Comment("");
    
        // 全てのオブジェクトを削除
        DeleteAllObjects();
    
       
    }
    void DeleteAllObjects(string prefix = "")
    {
        
        
        // 接頭辞を設定
        if (prefix == "") prefix = OBJNAME_PREFIX;
    
        // チャート上のオブジェクトを全て処理
        for (int index = 0; index < ObjectsTotal(); index++)
        {
            // プログラムにより作成したオブジェクト以外の場合は次へ
            if (StringFind(ObjectName(NULL, index), prefix) == EMPTY) continue;

            // オブジェクトを削除
            ObjectDelete(ObjectName(NULL, index));
    
            // オブジェクトの数が減るためデクリメント
            index--;
        }
    }
int OnInit()
  {
// GogoJungle OnInit /////////////////////////////////////////////////|
  if(AccountNumber() == 0){
    AuthResult = false;
    AuthTry = true;
  }
  else{
    AccountCert = GrabWeb();
    Disp(AccountCert);
    if(StringFind(AccountCert, "success") == -1) {AuthResult = false;}
    else{AuthResult = true;} }
  EventSetTimer(5);
// GogoJungle OnInit /////////////////////////////////////////////////|

//--- indicator buffers mapping
   Comment("");
        Comment("KUROHUNEPRO \nTwitterID   :  KUROHUNEtrader \nLINE@       :  @yfy3673g");
 
        
        //↓表示用のバッファ
        
        
        //計算用のバッファ
        IndicatorBuffers(0);//計算用のインジケーターの数
        SetIndexBuffer(0, Arrow);
        SetIndexLabel(0, NULL);
        SetIndexStyle(0, DRAW_NONE);
        SetIndexEmptyValue(0,0);
        SetIndexBuffer(1, WinBuffer);
        SetIndexLabel(1, NULL);
        SetIndexStyle(1, DRAW_NONE);
        SetIndexEmptyValue(1,0);
        SetIndexBuffer(2, LoseBuffer);
        SetIndexLabel(2, NULL);
        SetIndexStyle(2, DRAW_NONE);
        SetIndexEmptyValue(2,0);
        SetIndexBuffer(3, RSIBuffer);
        SetIndexLabel(3, NULL);
        SetIndexStyle(3, DRAW_NONE);
        
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
// GogoJungle OnCalculate /////////////////////////////////////////////////|
  if(AuthResult == false){return(0);}
// GogoJungle OnCalculate /////////////////////////////////////////////////|

//---
   for (int index = Bars - IndicatorCounted() - 1; SHIFT_CURRENT <= index; index--)
        {
           RSIBuffer[index] = iRSI(Symbol(), Period(), RSIPeriod, PRICE_CLOSE, index);
        }
        
        
        // 未計算の足を全て処理
        for (int index = Bars - IndicatorCounted() - 1; SHIFT_CURRENT <= index; index--)
        {
        
            string objname_buy = OBJNAME_BUY + TimeToString(Time[index]);
            string objname_sell = OBJNAME_SELL + TimeToString(Time[index]);
            
            
            ObjectDelete(ChartID(), objname_buy);//同じチャート上にすでに同じ名前のオブジェクトがあれば削除するということ
            ObjectDelete(ChartID(), objname_sell);
            
            
            if (CheckBuy(index))
            {
                CreateArrow(objname_buy, 233, ArrowColorBuy, ArrowSize, Time[index], Low[index], ANCHOR_TOP);
                Arrow[index]=1;
            }
            
            
            if (CheckSell(index))
            {
                CreateArrow(objname_sell, 234, ArrowColorSell, ArrowSize, Time[index], High[index], ANCHOR_BOTTOM);
                Arrow[index]=2;
            }
            
            
         
            
        }
        DisplayResult(ArrowCountNum  ,time );
        
        static datetime PreviousAlertAndMailTime = NULL;
        
        if (PreviousAlertAndMailTime != Time[SHIFT_CURRENT])
        {
            if (ObjectFind(ChartID(), OBJNAME_BUY + TimeToString(Time[SHIFT_CURRENT])) != EMPTY)
            {
                string message = Symbol() + "," + TimeframeToString(Period()) + ": " + WindowExpertName() + " is Buy.";
                if (UseAlert) Alert(message);
                if (UseSendMail) SendMail(message, message);
                PreviousAlertAndMailTime = Time[SHIFT_CURRENT];
            }
            
            if (ObjectFind(ChartID(), OBJNAME_SELL + TimeToString(Time[SHIFT_CURRENT])) != EMPTY)
            {
                string message = Symbol() + "," + TimeframeToString(Period()) + ": " + WindowExpertName() + " is Sell.";
                if (UseAlert) Alert(message);
                if (UseSendMail) SendMail(message, message);
                PreviousAlertAndMailTime = Time[SHIFT_CURRENT];
            }
        }
        
        // 計算済みの足の本数を返却
       
        return rates_total - 1;
//--- return value of prev_calculated for next call
   
  }
//+------------------------------------------------------------------+
void CreateLabel(string name, string text, color c, uint size, ENUM_BASE_CORNER corner, uint x, uint y, string font, bool back = false, string window_name = "")
    {
        // ラベルオブジェクトを作成
        ObjectCreate(NULL, name, OBJ_LABEL, window_name == "" ? NULL : (window_name == "0" ? NULL : WindowFind(window_name)), NULL, NULL);
        ObjectSetInteger(NULL, name, OBJPROP_BACK, back);
        ObjectSetInteger(NULL, name, OBJPROP_COLOR, c);
        ObjectSetInteger(NULL, name, OBJPROP_CORNER, corner);
        ObjectSetInteger(NULL, name, OBJPROP_FONTSIZE, size);
        ObjectSetInteger(NULL, name, OBJPROP_HIDDEN, true);
        ObjectSetInteger(NULL, name, OBJPROP_SELECTABLE, false);
        ObjectSetInteger(NULL, name, OBJPROP_XDISTANCE, x);
        ObjectSetInteger(NULL, name, OBJPROP_YDISTANCE, y);
        ObjectSetString(NULL, name, OBJPROP_FONT, font);
        ObjectSetString(NULL, name, OBJPROP_TEXT, text);
    
        // 表示位置によりアンカーを設定
        if (corner == CORNER_LEFT_UPPER) ObjectSetInteger(NULL, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
        if (corner == CORNER_LEFT_LOWER) ObjectSetInteger(NULL, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
        if (corner == CORNER_RIGHT_UPPER) ObjectSetInteger(NULL, name, OBJPROP_ANCHOR, ANCHOR_RIGHT_UPPER);
        if (corner == CORNER_RIGHT_LOWER) ObjectSetInteger(NULL, name, OBJPROP_ANCHOR, ANCHOR_RIGHT_LOWER);
    }
string TimeframeToString(uint timeframe)
    {
        if (timeframe == PERIOD_M1) return "M1";
        if (timeframe == PERIOD_M5) return "M5";
        if (timeframe == PERIOD_M15) return "M15";
        if (timeframe == PERIOD_M30) return "M30";
        if (timeframe == PERIOD_H1) return "H1";
        if (timeframe == PERIOD_H4) return "H4";
        if (timeframe == PERIOD_D1) return "D1";
        if (timeframe == PERIOD_W1) return "W1";
        if (timeframe == PERIOD_MN1) return "MN1";
        return "M" + IntegerToString(timeframe);
    }
void CreateArrow(string name, uint code, color c, int size, datetime time, double price, ENUM_ARROW_ANCHOR anchor = ANCHOR_TOP, bool chart_window = true, bool is_back = false)
    {
    	ObjectCreate(NULL, name, OBJ_ARROW, chart_window ? NULL : WindowOnDropped(), NULL, NULL);
    	ObjectSetInteger(NULL, name, OBJPROP_ARROWCODE, code);
    	ObjectSetInteger(NULL, name, OBJPROP_ANCHOR, anchor);
    	ObjectSetInteger(NULL, name, OBJPROP_BACK, is_back);
    	ObjectSetInteger(NULL, name, OBJPROP_COLOR, c);
    	ObjectSetInteger(NULL, name, OBJPROP_HIDDEN, true);
    	ObjectSetInteger(NULL, name, OBJPROP_SELECTED, false);
    	ObjectSetInteger(NULL, name, OBJPROP_TIME, 0, time);
    	ObjectSetInteger(NULL, name, OBJPROP_SELECTABLE, false);
    	ObjectSetInteger(NULL, name, OBJPROP_WIDTH, size);
    	ObjectSetDouble(NULL, name, OBJPROP_PRICE, 0, price);
    }
void DisplayResult(int countnum  ,const datetime& timeA[] )
    {   
       
        int calculatedArrow = 0;
        int ind = 2; 
        uint totalWin = 0;
        uint totalLose = 0;
        uint    WinCount[24]={0};
        uint    LoseCount[24]={0};
       
       
        if(timeA[0] != Time[0])return;
        
        while(calculatedArrow < countnum && ArrayRange(WinBuffer,0) > ind  && UseResultDisplay == true)
        {
            
            if(CheckBuy(ind)){ 
                  if(Close[ind - 1] - Open[ind - 1] > 0)
                 {
                    WinBuffer[ind]=1;
                    calculatedArrow++;
                 }
                 else
                 {
                    LoseBuffer[ind]=1;
                    calculatedArrow++;
                 }
            }
            if(CheckSell(ind)){
                  if(Open[ind - 1] - Close[ind - 1] > 0)
                 {
                    WinBuffer[ind]=1;
                    calculatedArrow++;
                 }
                 else
                 {
                    LoseBuffer[ind]=1;
                    calculatedArrow++;
                 }
             }
             ind++;
        }
            
                 
            
           
        
        int ind2 = 2;
        int count2 = 0;
        while(count2 < calculatedArrow &&  UseResultDisplay == true && ArrayRange(WinBuffer,0) > ind2)
        {
            if(WinBuffer[ind2]==1)
            {
               WinCount[TimeHour(Time[ind2])]++;
               count2++;
            }
            if(LoseBuffer[ind2]==1)
            {
               LoseCount[TimeHour(Time[ind2])]++;
               count2++;
            }
        ind2++;
        }
        
        
        
        double a[25],b[25],c[25];
        for(int i = 0 ; i < 24 ; i++)
        {
            a[i] = WinCount[i];
            b[i] = LoseCount[i];
            if(a[i] == 0 && b[i] == 0)
            {
               c[i] = 0;
            }
            else
            {
                c[i] =100 *( a[i] / (a[i] + b[i]));
            }
           // c[i] = NormalizeDouble(c[i],1);
            totalWin = totalWin + WinCount[i];
            totalLose = totalLose +LoseCount[i];
           
        }
        a[24] = totalWin;
        b[24] = totalLose;
        if(a[24] == 0 && b[24] == 0)
        {
               c[24] = 0;
        }
        else
        {
               c[24] =100 *( a[24] / (a[24] + b[24]));
        }    
           
        
        ObjectDelete(ChartID(), "OBJ I23g DisplayTop");
        ObjectDelete(ChartID(), "OBJ I23g Display0");
        ObjectDelete(ChartID(), "OBJ I23g Display1");
        ObjectDelete(ChartID(), "OBJ I23g Display2");
        ObjectDelete(ChartID(), "OBJ I23g Display3");
        ObjectDelete(ChartID(), "OBJ I23g Display4");
        ObjectDelete(ChartID(), "OBJ I23g Display5");
        ObjectDelete(ChartID(), "OBJ I23g Display6");
        ObjectDelete(ChartID(), "OBJ I23g Display7");
        ObjectDelete(ChartID(), "OBJ I23g Display8");
        ObjectDelete(ChartID(), "OBJ I23g Display9");
        ObjectDelete(ChartID(), "OBJ I23g Display10");
        ObjectDelete(ChartID(), "OBJ I23g Display11");
        ObjectDelete(ChartID(), "OBJ I23g Display12");
        ObjectDelete(ChartID(), "OBJ I23g Display13");
        ObjectDelete(ChartID(), "OBJ I23g Display14");
        ObjectDelete(ChartID(), "OBJ I23g Display15");
        ObjectDelete(ChartID(), "OBJ I23g Display16");
        ObjectDelete(ChartID(), "OBJ I23g Display17");
        ObjectDelete(ChartID(), "OBJ I23g Display18");
        ObjectDelete(ChartID(), "OBJ I23g Display19");
        ObjectDelete(ChartID(), "OBJ I23g Display20");
        ObjectDelete(ChartID(), "OBJ I23g Display21");
        ObjectDelete(ChartID(), "OBJ I23g Display22");
        ObjectDelete(ChartID(), "OBJ I23g Display23");
        
        //オブジェクト名（1番目の引数がかぶっている場合ObjectCreateは実行されない）
        if(UseResultDisplay){
        
           CreateLabel("OBJ I23g DisplayTop", StringFormat("%3d回  %3d勝　%3d負　%5.1f%%",totalWin + totalLose,totalWin ,totalLose ,c[24]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 10, "ＭＳ ゴシック", false, "");
           CreateLabel("OBJ I23g Display0", StringFormat("0時   %3d勝  %3d負   %5.1f%%",WinCount[0] ,LoseCount[0],c[0]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 60, "ＭＳ ゴシック", false, "");
           CreateLabel("OBJ I23g Display1", StringFormat("1時   %3d勝  %3d負   %5.1f%%",WinCount[1] ,LoseCount[1],c[1]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 80, "ＭＳ ゴシック", false, "");
           CreateLabel("OBJ I23g Display2", StringFormat("2時   %3d勝  %3d負   %5.1f%%",WinCount[2] ,LoseCount[2],c[2]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 100, "ＭＳ ゴシック", false, "");
           CreateLabel("OBJ I23g Display3", StringFormat("3時   %3d勝  %3d負   %5.1f%%",WinCount[3] ,LoseCount[3],c[3]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 120, "ＭＳ ゴシック", false, "");
           CreateLabel("OBJ I23g Display4", StringFormat("4時   %3d勝  %3d負   %5.1f%%",WinCount[4] ,LoseCount[4],c[4]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 140, "ＭＳ ゴシック", false, "");
           CreateLabel("OBJ I23g Display5", StringFormat("5時   %3d勝  %3d負   %5.1f%%",WinCount[5] ,LoseCount[5],c[5]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 160, "ＭＳ ゴシック", false, "");
           CreateLabel("OBJ I23g Display6", StringFormat("6時   %3d勝  %3d負   %5.1f%%",WinCount[6] ,LoseCount[6],c[6]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 180, "ＭＳ ゴシック", false, "");
           CreateLabel("OBJ I23g Display7", StringFormat("7時   %3d勝  %3d負   %5.1f%%",WinCount[7] ,LoseCount[7],c[7]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 200, "ＭＳ ゴシック", false, "");
           CreateLabel("OBJ I23g Display8", StringFormat("8時   %3d勝  %3d負   %5.1f%%",WinCount[8] ,LoseCount[8],c[8]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 220, "ＭＳ ゴシック", false, "");
           CreateLabel("OBJ I23g Display9", StringFormat("9時   %3d勝  %3d負   %5.1f%%",WinCount[9] ,LoseCount[9],c[9]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 240, "ＭＳ ゴシック", false, "");
           CreateLabel("OBJ I23g Display10", StringFormat("10時   %3d勝  %3d負   %5.1f%%",WinCount[10] ,LoseCount[10],c[10]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 260, "ＭＳ ゴシック", false, "");
           CreateLabel("OBJ I23g Display11", StringFormat("11時   %3d勝  %3d負   %5.1f%%",WinCount[11] ,LoseCount[11],c[11]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 280, "ＭＳ ゴシック", false, "");
           CreateLabel("OBJ I23g Display12", StringFormat("12時   %3d勝  %3d負   %5.1f%%",WinCount[12] ,LoseCount[12],c[12]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 300, "ＭＳ ゴシック", false, "");
           CreateLabel("OBJ I23g Display13", StringFormat("13時   %3d勝  %3d負   %5.1f%%",WinCount[13] ,LoseCount[13],c[13]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 320, "ＭＳ ゴシック", false, "");
           CreateLabel("OBJ I23g Display14", StringFormat("14時   %3d勝  %3d負   %5.1f%%",WinCount[14] ,LoseCount[14],c[14]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 340, "ＭＳ ゴシック", false, "");
           CreateLabel("OBJ I23g Display15", StringFormat("15時   %3d勝  %3d負   %5.1f%%",WinCount[15] ,LoseCount[15],c[15]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 360, "ＭＳ ゴシック", false, "");
           CreateLabel("OBJ I23g Display16", StringFormat("16時   %3d勝  %3d負   %5.1f%%",WinCount[16] ,LoseCount[16],c[16]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 380, "ＭＳ ゴシック", false, "");
           CreateLabel("OBJ I23g Display17", StringFormat("17時   %3d勝  %3d負   %5.1f%%",WinCount[17] ,LoseCount[17],c[17]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 400, "ＭＳ ゴシック", false, "");
           CreateLabel("OBJ I23g Display18", StringFormat("18時   %3d勝  %3d負   %5.1f%%",WinCount[18] ,LoseCount[18],c[18]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 420, "ＭＳ ゴシック", false, "");
           CreateLabel("OBJ I23g Display19", StringFormat("19時   %3d勝  %3d負   %5.1f%%",WinCount[19] ,LoseCount[19],c[19]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 440, "ＭＳ ゴシック", false, "");
           CreateLabel("OBJ I23g Display20", StringFormat("20時   %3d勝  %3d負   %5.1f%%",WinCount[20] ,LoseCount[20],c[20]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 460, "ＭＳ ゴシック", false, "");
           CreateLabel("OBJ I23g Display21", StringFormat("21時   %3d勝  %3d負   %5.1f%%",WinCount[21] ,LoseCount[21],c[21]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 480, "ＭＳ ゴシック", false, "");
           CreateLabel("OBJ I23g Display22", StringFormat("22時   %3d勝  %3d負   %5.1f%%",WinCount[22] ,LoseCount[22],c[22]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 500, "ＭＳ ゴシック", false, "");
           CreateLabel("OBJ I23g Display23", StringFormat("23時   %3d勝  %3d負   %5.1f%%",WinCount[23] ,LoseCount[23],c[23]), clrWhite, 10, CORNER_RIGHT_UPPER, 10, 520, "ＭＳ ゴシック", false, "");
           if(c[24] >= 60)ObjectSetInteger(NULL, "OBJ I23g DisplayTop", OBJPROP_COLOR, clrYellow);
           if(c[0] >= 60)ObjectSetInteger(NULL, "OBJ I23g Display0", OBJPROP_COLOR, clrYellow);
           if(c[1] >= 60)ObjectSetInteger(NULL, "OBJ I23g Display1", OBJPROP_COLOR, clrYellow);
           if(c[2] >= 60)ObjectSetInteger(NULL, "OBJ I23g Display2", OBJPROP_COLOR, clrYellow);
           if(c[3] >= 60)ObjectSetInteger(NULL, "OBJ I23g Display3", OBJPROP_COLOR, clrYellow);
           if(c[4] >= 60)ObjectSetInteger(NULL, "OBJ I23g Display4", OBJPROP_COLOR, clrYellow);
           if(c[5] >= 60)ObjectSetInteger(NULL, "OBJ I23g Display5", OBJPROP_COLOR, clrYellow);
           if(c[6] >= 60)ObjectSetInteger(NULL, "OBJ I23g Display6", OBJPROP_COLOR, clrYellow);
           if(c[7] >= 60)ObjectSetInteger(NULL, "OBJ I23g Display7", OBJPROP_COLOR, clrYellow);
           if(c[8] >= 60)ObjectSetInteger(NULL, "OBJ I23g Display8", OBJPROP_COLOR, clrYellow);
           if(c[9] >= 60)ObjectSetInteger(NULL, "OBJ I23g Display9", OBJPROP_COLOR, clrYellow);
           if(c[10] >= 60)ObjectSetInteger(NULL, "OBJ I23g Display10", OBJPROP_COLOR, clrYellow);
           if(c[11] >= 60)ObjectSetInteger(NULL, "OBJ I23g Display11", OBJPROP_COLOR, clrYellow);
           if(c[12] >= 60)ObjectSetInteger(NULL, "OBJ I23g Display12", OBJPROP_COLOR, clrYellow);
           if(c[13] >= 60)ObjectSetInteger(NULL, "OBJ I23g Display13", OBJPROP_COLOR, clrYellow);
           if(c[14] >= 60)ObjectSetInteger(NULL, "OBJ I23g Display14", OBJPROP_COLOR, clrYellow);
           if(c[15] >= 60)ObjectSetInteger(NULL, "OBJ I23g Display15", OBJPROP_COLOR, clrYellow);
           if(c[16] >= 60)ObjectSetInteger(NULL, "OBJ I23g Display16", OBJPROP_COLOR, clrYellow);
           if(c[17] >= 60)ObjectSetInteger(NULL, "OBJ I23g Display17", OBJPROP_COLOR, clrYellow);
           if(c[18] >= 60)ObjectSetInteger(NULL, "OBJ I23g Display18", OBJPROP_COLOR, clrYellow);
           if(c[19] >= 60)ObjectSetInteger(NULL, "OBJ I23g Display19", OBJPROP_COLOR, clrYellow);
           if(c[20] >= 60)ObjectSetInteger(NULL, "OBJ I23g Display20", OBJPROP_COLOR, clrYellow);
           if(c[21] >= 60)ObjectSetInteger(NULL, "OBJ I23g Display21", OBJPROP_COLOR, clrYellow);
           if(c[22] >= 60)ObjectSetInteger(NULL, "OBJ I23g Display22", OBJPROP_COLOR, clrYellow);
           if(c[23] >= 60)ObjectSetInteger(NULL, "OBJ I23g Display23", OBJPROP_COLOR, clrYellow);
           
        }   
        
    }
    
    bool CheckBuy(int shift)
    {
        if(Kakutei == true && shift == 0)return false;
        double bands = iBands(Symbol(), Period(), BandsPeriod, BandsDeviation, NULL, PRICE_CLOSE, MODE_LOWER, shift);
        if (Close[shift] > bands) return false;
        
        
        double rsi = iRSI(Symbol(), Period(), RSIPeriod, PRICE_CLOSE, shift);
        double rsi_bands = iBandsOnArray(RSIBuffer, NULL, RSIBandsPeriod, RSIBandsDeviation, NULL, MODE_LOWER, shift);
        if (rsi > rsi_bands) return false;
        if(rsi > 70)return false;
        if(rsi_bands > 70)return false;
        if(rsi < 30)return false;
        if(rsi_bands < 30)return false;
   
        return true;
        
        
    }
    
    bool CheckSell(int shift)
    {
        if(Kakutei == true && shift == 0)return false;
        double bands = iBands(Symbol(), Period(), BandsPeriod, BandsDeviation, NULL, PRICE_CLOSE, MODE_UPPER, shift);
        if (Close[shift] < bands) return false;
    
        double rsi = iRSI(Symbol(), Period(), RSIPeriod, PRICE_CLOSE, shift);
        double rsi_bands = iBandsOnArray(RSIBuffer, NULL, RSIBandsPeriod, RSIBandsDeviation, NULL, MODE_UPPER, shift);
        if (rsi < rsi_bands) return false;
        if(rsi > 70)return false;
        if(rsi_bands > 70)return false;
        if(rsi < 30)return false;
        if(rsi_bands < 30)return false;
        return true;
        
        
        
    }





void OnTimer()
{
// GogoJungle OnTimer /////////////////////////////////////////////////|
  if(AuthTry == true && AccountNumber() > 0){
    AccountCert = GrabWeb();
    Disp(AccountCert);
    AuthTry = false;
    if(StringFind(AccountCert, "success") == -1) { AuthResult = false; }
    else{
      AuthResult = true;
      long volume[];
      int spread[];
      ArrayResize(volume, Bars, 0);
      ArrayResize(spread, Bars, 0);
      ArrayInitialize(volume, 0);
      ArrayInitialize(spread, 0);
      OnCalculate(Bars, 0, Time, Open, High, Low, Close, Volume, volume, spread);
    }
  }
// GogoJungle OnTimer /////////////////////////////////////////////////|
}
