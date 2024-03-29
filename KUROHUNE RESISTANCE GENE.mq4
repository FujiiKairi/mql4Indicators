//+------------------------------------------------------------------+
//|                                                         asdf.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                              https://www.mql5.co |
//+------------------------------------------------------------------+
#define MQL4
#define PROPERTY_LINK ""
#define PROPERTY_COPYRIGHT ""
#define PROPERTY_DESCRIPTION ""
#define OBJNAME_PREFIX "OBJ I23g1 "
#define OBJNAME_BUY OBJNAME_PREFIX + "BUY "
#define OBJNAME_SELL OBJNAME_PREFIX + "SELL "
#define OUTPUT_CONSOLE LEVEL_NONE
#define OUTPUT_FILE LEVEL_NONE
#define OUTPUT_TESTING false
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.co"
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 22//(表示用＋計算用のバッファの数)
#property indicator_plots  22//表示用のバッファの数
#property indicator_minimum 0.3
#property indicator_maximum 5

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
int NumUseIndicator = 0;

input   string              SeparateUseIndicator= "";                   // ▼ 使用インジケーター設定
input   string              SeparateRSI = "";                           //┣ RSI
input   bool                Use1 = true;                                //┃ ┣ON/OFF
input int                   RSIPeriod=14;                               //┃ ┣期間
input int                   UpLine = 70;                                //┃ ┣上の線
input int                   DownLine = 30  ;                            //┃ ┗下の線
input   string              SeparateBands = "";                         //┣ ボリンジャーバンド設定
input   bool                Use2 = true;                                //┃ ┣　ON/OFF
input   uint                BandsPeriod = 14;                           //┃ ┣ 期間
input   double              BandsDeviation = 2;                         //┃ ┗ 偏差
input   string              SeparateMacd = "";                           //┣ MACD設定
input   bool                Use9 = true;                                //┃┣　ON/OFF
input   uint                MacdTanki = 12;                             //┃ ┣　短期EMA
input   uint                MacdTyouki = 26;                            //┃ ┣ 長期EMA
input   uint                MacdSignal = 9;                             //┃ ┗ シグナル
input   string              SeparateCCI   = "";                         //┣ CCI設定
input   bool                Use3 = true;                                //┃┣ ON/OFF
input   uint                CCIPeriod = 14;                             //┃ ┣ 期間
input   int                 CCIUPLine = 100;                            //┃ ┣ 上のライン（％）
input   int                 CCIDOWNLine = -100;                            //┃ ┗ 下のライン（％）
input   string              SeparateEnvelop = "";                       //┣ エンベロープ設定
input   bool                Use4 = true;                                //┃┣　ON/OFF
input   uint                EnvPeriod = 14;                             //┃ ┣ 期間（移動平均線の）
input   double              EnvDeviation = 0.1;                         //┃ ┣ 偏差
input   ENUM_MA_METHOD      EnvMAMethod = MODE_SMA;                     //┃ ┗ 種別
input    string             SeparatePinber = "";                        //┣ ピンバー設定
input    bool               Use5 = true;                                //┃┣　ON/OFF
input    double             pinPosi = 0.7;                              //┃ ┣ 実体の中心の位置
input    double             pinPer = 30;                                //┃ ┣ 実体が足全体を占める割合(%)
input    double             pinLength = 1;                              //┃ ┣ ピンバーとする最少の長さ（単位はpips）
input    int                preBars = 2;                                //┃ ┗ ピンバーと判断するバーの数
input    string             SeparateSt = "";                            //┣ ストキャスティクス設定
input   bool                Use6 = true;                                //┃┣　ON/OFF
input   int                 StKPeriod=5;                                //┃ ┣ %K期間
input   int                 StDPeriod=3;                                //┃ ┣ %D期間
input   int                 StSlowing=3;                                //┃ ┣ スローイング
input   ENUM_MA_METHOD      StMAMethod = MODE_SMA;                      //┃ ┣ 移動平均の種別
input   int                 StUpLine = 60;                              //┃ ┣ 上の線(%)
input   int                 StDownLine = 40;                            //┃ ┗ 下の線(%)
input   string              SeparateDmi = "";                           //┣ DMI設定
input   bool                Use7 = true;                                //┃┣　ON/OFF
input   uint                DmiPeriod = 21;                             //┃ ┣ 期間（移動平均線の）
input   string              SeparateAdx = "";                           //┣ ADX設定
input   bool                Use8 = true;                                //┃┣　ON/OFF
input   uint                AdxPeriod = 21;                             //┃ ┣ 期間（移動平均線の）
input   int                 AdxLine = 45;                               //┃ ┗ ADXのライン

input   string              SeparateDisplay = "";                       // ▼ ディスプレイ設定
input   uint                ArrowCountNum = 100;                        // ┣ カウントする矢印の数
input   bool                UseResultDisplay = true;                    // ┗ ディスプレイON/OFF

input   string              SeparateArrow = "";                         // ▼ 矢印設定
input   string              SeparateArrowColor = "";                    // ┣ 色
input   color               ArrowColorBuy = clrAqua;                    // ┃ ┣ 買
input   color               ArrowColorSell = clrMagenta;                // ┃ ┗ 売
        bool                ArrowKakutei = true;                        // ┣ 足が確定してから矢印を出す
input   double              NumOfSignal = 5.0;                            // ┗ ○個以上シグナルが重なれば矢印を出す

        bool                Kakutei =true;                              // ┗ ON/OFF

input   string              Separateindi = "";                          // ▼ インジケーターの名前設定
input   int                 SizeOfText  =  10;                          // ┣ 文字の大きさ
input   color               TextColor = clrAqua;                        // ┃ 文字の色
input   double              LabelsVerticalShift=0.4;                    // ┣ 文字の垂直位置
input   int                 LabelsHorizontalShift = 10;                 // ┗ 文字の水平位置

input   string              SeparateLine = "";                          // ▼ ライン設定
input   string              SeparateLineColor = "";                     // ┣ 色
input   color               LineColorOn = clrRed;                       // ┃ ┣ 買いシグナル
input   color               LineColorOff = clrBlue;                     // ┃ ┃ 売りシグナル
input   color               ADXColor = clrOrange;                       // ┃ ┗ ADX
input   int                 ThickOfText  =  2;                          // ┗ ラインの太さ

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

double ON1_Buffer[];
double OFF1_Buffer[];
double ON2_Buffer[];
double OFF2_Buffer[];
double ON3_Buffer[];
double OFF3_Buffer[];
double ON4_Buffer[];
double OFF4_Buffer[];
double ON5_Buffer[];
double OFF5_Buffer[];
double ON6_Buffer[];
double OFF6_Buffer[];
double ON7_Buffer[];
double OFF7_Buffer[];
double ON8_Buffer[];
double OFF8_Buffer[];
double ON9_Buffer[];
double OFF9_Buffer[];




double minus;
double bias ;
double GeneArray[9][30];  //遺伝子の配列
int    NumOfRepeat = 100;
double WinPercentage[30];
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
//--- indicator buffers mapping　 
        MathSrand(GetTickCount());              //ランダムのシード値を獲得
        for(int RepeatCount = 0 ; RepeatCount < 30 ; RepeatCount++)
        {
            for(int IndicatorCount = 0 ;IndicatorCount < 9;IndicatorCount++)
            {
               bias = ((MathRand() % 10) + 1) / 10.0;//0.1~1が入る
               GeneArray[IndicatorCount][RepeatCount] = bias;
               if(IndicatorCount == 1)Print(bias);
            }
        }
        
        //↓表示用のバッファ
        
        
        //計算用のバッファ
        IndicatorBuffers(22);
        IndicatorShortName("KUROHUNE_RESISTANCE");
       
        SetIndexBuffer(18, Arrow);
        SetIndexLabel(18, NULL);
        SetIndexStyle(18, DRAW_NONE);
        SetIndexEmptyValue(18,0);
        SetIndexBuffer(19, WinBuffer);
        SetIndexLabel(19, NULL);
        SetIndexStyle(19, DRAW_NONE);
        SetIndexEmptyValue(19,0);
        SetIndexBuffer(20, LoseBuffer);
        SetIndexLabel(20, NULL);
        SetIndexStyle(20, DRAW_NONE);
        SetIndexEmptyValue(20,0);
        SetIndexBuffer(21, RSIBuffer);
        SetIndexLabel(21, NULL);
        SetIndexStyle(21, DRAW_NONE);
        
        string ObjName = "";
        string ObjText = "";
        double t = 5 ;//サブウィンドウの縦の長さ
        NumUseIndicator = 0;
        if(Use1 == true)NumUseIndicator++;
        if(Use2 == true)NumUseIndicator++;
        if(Use3 == true)NumUseIndicator++;
        if(Use4 == true)NumUseIndicator++;
        if(Use5 == true)NumUseIndicator++;
        if(Use6 == true)NumUseIndicator++;
        if(Use7 == true)NumUseIndicator++;
        if(Use8 == true)NumUseIndicator++;
        if(Use9 == true)NumUseIndicator++;
        
       
        
        IndicatorDigits(0);
        if(NumUseIndicator < NumOfSignal)
            {
               Print("[○○個以上シグナルが重なれば矢印を出す]が適用するテクニカルの数よりも少ないです。");
            }
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
//---
      
        
        // 未計算の足を全て処理
     
     for(int RepeatCount = 0 ;RepeatCount < NumOfRepeat;RepeatCount++)
     {
        for (int index = Bars - IndicatorCounted() - 1; SHIFT_CURRENT <= index; index--)
        {
        
               double cBuy = CheckBuy(index,RepeatCount);
               if (cBuy >=  NumOfSignal)
               {   
                  Arrow[index]=1;
               }
               double cSell = CheckSell(index,RepeatCount );
               if (cSell >= NumOfSignal )
               {
                   Arrow[index]=2;            
               }
        }
        
        GetWinPercentage(ArrowCountNum  ,time ,RepeatCount);
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
double GetWinPercentage(int countnum  ,const datetime& timeA[] ,int k )
    {   
       
        int calculatedArrow = 0;
        int ind = 2; 
        uint totalWin = 0;
        uint totalLose = 0;
        uint    WinCount[24]={0};
        uint    LoseCount[24]={0};
       
       
        
        
        while(calculatedArrow < countnum && ArrayRange(WinBuffer,0) > ind  && UseResultDisplay == true)
        {
           
            double cBuy = CheckBuy(ind , k);
            double cSell = CheckSell(ind , k);
            bool cBuyBool =false;
            bool cSellBool =false;
            if(cBuy >=  NumOfSignal)cBuyBool = true;
            if(cSell >=  NumOfSignal)cSellBool = true;
            
            if(cBuyBool){ 
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
            if(cSellBool){
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
        
        
        
        
        for(int i = 0 ; i < 24 ; i++)
        {
            totalWin = totalWin + WinCount[i];
            totalLose = totalLose +LoseCount[i]; 
        }
        if(totalWin == 0 && totalLose == 0)
        {
            return 0;
        }
        else
        {
            return 100 *( totalWin / (totalWin + totalLose));
        }    
           
        
        
        
    }
    
    double CheckBuy(int shift,int i)
   {    
        if(ArrowKakutei == true && shift == 0)return -1;
        double count = 0;
        if(CheckRSIBuy(shift) && Use1)count = count + GeneArray[0][i]; 
        if(CheckBBBuy(shift)&& Use2)count = count + GeneArray[1][i];
        if(CheckMacdBuy(shift)&& Use9)count = count + GeneArray[8][i];
        if(CheckCCIBuy(shift)&& Use3)count = count + GeneArray[2][i];
        if(CheckEnvelopeBuy(shift)&& Use4)count = count + GeneArray[3][i]; 
        if(CheckPinbarBuy(shift)&& Use5)count = count + GeneArray[4][i]; 
        if(CheckStBuy(shift)&& Use6)count = count + GeneArray[5][i];
        if(CheckDmiBuy(shift)&& Use7)count = count + GeneArray[6][i];
        if(CheckAdx(shift)&& Use8)count = count + GeneArray[7][i];
        return count;   
   }
    
   double CheckSell(int shift,int i)
   {
        if(ArrowKakutei == true && shift == 0)return -1;
        double count = 0;
        if(CheckRSISell(shift) && Use1)count = count + GeneArray[0][i]; 
        if(CheckBBSell(shift)&& Use2)count = count + GeneArray[1][i];  
        if(CheckMacdSell(shift)&& Use9)count = count + GeneArray[8][i]; 
        if(CheckCCISell(shift)&& Use3)count = count + GeneArray[2][i];  
        if(CheckEnvelopeSell(shift)&& Use4)count = count + GeneArray[3][i];  
        if(CheckPinbarSell(shift)&& Use5)count = count + GeneArray[4][i];  
        if(CheckStSell(shift)&& Use6)count = count + GeneArray[5][i];  
        if(CheckDmiSell(shift)&& Use7)count = count + GeneArray[6][i];  
        if(CheckAdx(shift)&& Use8)count = count + GeneArray[7][i];  
        return count;    
   }
   bool CheckRSIBuy(int shift)
   {     
        if(iRSI(Symbol(), 0, RSIPeriod, 0, shift) >= DownLine)return false;
        return true;   
   }
    
   bool CheckRSISell(int shift)
   {
        if(iRSI(Symbol(), 0, RSIPeriod, 0, shift) <= UpLine)return false;
        return true;
   }
   bool CheckBBBuy(int shift)
   {     
        double bands = iBands(Symbol(), Period(), BandsPeriod, BandsDeviation, NULL, PRICE_CLOSE, MODE_LOWER, shift);
        if (Close[shift] >= bands) return false;
        return true;   
   }
    
   bool CheckBBSell(int shift)
   {
        double bands = iBands(Symbol(), Period(), BandsPeriod, BandsDeviation, NULL, PRICE_CLOSE, MODE_UPPER, shift);
        if (Close[shift] <= bands) return false;
        return true;
   }
   bool CheckMacdBuy(int shift)
   {     
        
        if(shift + 1 >= Bars -1)return false;
        double PreMain = iMACD(NULL,0,MacdTanki,MacdTyouki,MacdSignal,PRICE_CLOSE,MODE_MAIN,shift + 1);
        double PreSignal = iMACD(NULL,0,MacdTanki,MacdTyouki,MacdSignal,PRICE_CLOSE,MODE_SIGNAL,shift + 1);
        double Main = iMACD(NULL,0,MacdTanki,MacdTyouki,MacdSignal,PRICE_CLOSE,MODE_MAIN,shift);
        double Signal = iMACD(NULL,0,MacdTanki,MacdTyouki,MacdSignal,PRICE_CLOSE,MODE_SIGNAL,shift);
        if(0 <= Main)return false;
        if( PreMain >= PreSignal )return false;
        if( Signal >= Main )return false;
        return true;   
   }
    
   bool CheckMacdSell(int shift)
   {
        if(shift + 1 >= Bars -1)return false;
        double PreMain = iMACD(NULL,0,MacdTanki,MacdTyouki,MacdSignal,PRICE_CLOSE,MODE_MAIN,shift + 1);
        double PreSignal = iMACD(NULL,0,MacdTanki,MacdTyouki,MacdSignal,PRICE_CLOSE,MODE_SIGNAL,shift + 1);
        double Main = iMACD(NULL,0,MacdTanki,MacdTyouki,MacdSignal,PRICE_CLOSE,MODE_MAIN,shift);
        double Signal = iMACD(NULL,0,MacdTanki,MacdTyouki,MacdSignal,PRICE_CLOSE,MODE_SIGNAL,shift);
        if(Main <= 0)return false;
        if(PreSignal >= PreMain)return false;
        if(Main >= Signal)return false;
        
        return true;   
   }
   bool CheckCCIBuy(int shift)
   {     
        double cci = iCCI(Symbol(), Period(), CCIPeriod, PRICE_CLOSE, shift);
        if (CCIDOWNLine <= cci) return false;
        return true;   
   }
    
   bool CheckCCISell(int shift)
   {
        double cci = iCCI(Symbol(), Period(), CCIPeriod, PRICE_CLOSE, shift);
        if (cci <= CCIUPLine) return false;
        return true;
   }
   bool CheckEnvelopeBuy(int shift)
   {     
        double envelope = iEnvelopes(NULL,0,EnvPeriod,EnvMAMethod,0,PRICE_CLOSE,EnvDeviation,MODE_LOWER,shift);
        if( envelope <= Close[shift])return false;
        return true; 
   }
    
   bool CheckEnvelopeSell(int shift)
   {
        double envelope = iEnvelopes(NULL,0,EnvPeriod,EnvMAMethod,0,PRICE_CLOSE,EnvDeviation,MODE_UPPER,shift);
        if(Close[shift] <=  envelope )return false;
        return true;
   }
   bool CheckPinbarBuy(int icount )
   {   
        if(icount + preBars >= Bars -1)return false;
        if(!(pinLength*Point*10<High[icount]-Low[icount]))return false;
        if(Close[icount]-Open[icount]>0){//買いサイン
                    if ( (MathAbs(Close[icount]-Open[icount])/(High[icount]-Low[icount])<(pinPer*0.01)||Close[icount]==Open[icount])&&
                  ((MathAbs(Close[icount]-Open[icount])/2)+Open[icount]-Low[icount])/(High[icount]-Low[icount])>pinPosi ) {  
                        int i=0,hantei=0;
                        for(i=0;i<preBars;i++){
                           if(Low[icount]>Low[icount+i+1]){
                              return false;
                           }   
                        }  
                        return true;
                   }
              return false;
         }
         return false;
   }   
   bool CheckPinbarSell(int icount)
   {
        if(icount + preBars >= Bars -1)return false;
        if(!(pinLength*Point*10<High[icount]-Low[icount]))return false;
        if(Open[icount]-Close[icount]>0){
                    if ( (MathAbs(Close[icount]-Open[icount])/(High[icount]-Low[icount])<(pinPer*0.01)||Close[icount]==Open[icount])&&//売りサイン
               (((MathAbs(Close[icount]-Open[icount]))/2)+High[icount]-Open[icount])/(High[icount]-Low[icount])>pinPosi ) {  
                int i=0,hantei=0;
                        for(i=0;i<preBars;i++){
                           if(High[icount]<High[icount+i+1]){
                              return false;
                           }   
                        }
                         return true;
                 }
                 return false;
              }
           return false;
   }       
   bool CheckStBuy(int shift)
   {     
        if(shift + 1 >= Bars -1)return false;
        double PreKLine = iStochastic(NULL,0,StKPeriod , StDPeriod,StSlowing,StMAMethod, 0, MODE_MAIN, shift + 1);
        double PreDLine = iStochastic(NULL,0, StKPeriod, StDPeriod, StSlowing, StMAMethod, 0, MODE_SIGNAL, shift + 1);
        double KLine = iStochastic(NULL, 0, StKPeriod, StDPeriod, StSlowing, StMAMethod, 0, MODE_MAIN, shift);
        double DLine = iStochastic(NULL, 0, StKPeriod, StDPeriod, StSlowing, StMAMethod, 0, MODE_SIGNAL, shift);
        if(StDownLine <= KLine)return false;
        if(StDownLine <= DLine)return false;
        if(PreKLine >= PreDLine)return false;
        if(DLine >= KLine)return false;
        return true; 
   }
    
   bool CheckStSell(int shift)
   {
        if(shift + 1 >= Bars -1)return false;
        double PreKLine = iStochastic(NULL,0, StKPeriod ,StDPeriod,StSlowing,StMAMethod,0,MODE_MAIN,shift + 1);
        double PreDLine = iStochastic(NULL,0,StKPeriod,StDPeriod,StSlowing,StMAMethod,0,MODE_SIGNAL,shift + 1);
        double KLine = iStochastic(NULL,0,StKPeriod,StDPeriod,StSlowing,StMAMethod,0,MODE_MAIN,shift);
        double DLine = iStochastic(NULL,0,StKPeriod,StDPeriod,StSlowing,StMAMethod,0,MODE_SIGNAL,shift);
        if(KLine<=StUpLine)return false;
        if(DLine<=StUpLine)return false;
        if(PreDLine >= PreKLine)return false;
        if(KLine >= DLine )return false;
        return true; 
   }
   bool CheckDmiBuy(int shift)
   {     
        if(shift + 1 >= Bars -1)return false;
        double Predmiminus = iADX(NULL,0,DmiPeriod,PRICE_CLOSE,MODE_PLUSDI,shift + 1);
        double Predmiplus = iADX(NULL,0,DmiPeriod,PRICE_CLOSE,MODE_MINUSDI,shift + 1);
        double dmiminus = iADX(NULL,0,DmiPeriod,PRICE_CLOSE,MODE_PLUSDI,shift );
        double dmiplus = iADX(NULL,0,DmiPeriod,PRICE_CLOSE,MODE_MINUSDI,shift );
        if( Predmiminus <= Predmiplus)return false;
        if( dmiplus <= dmiminus)return false;
        return true; 
   }
    
   bool CheckDmiSell(int shift)
   {
        if(shift + 1 >= Bars -1)return false;
        double Predmiminus = iADX(NULL,0,DmiPeriod,PRICE_CLOSE,MODE_PLUSDI,shift + 1);
        double Predmiplus = iADX(NULL,0,DmiPeriod,PRICE_CLOSE,MODE_MINUSDI,shift + 1);
        double dmiminus = iADX(NULL,0,DmiPeriod,PRICE_CLOSE,MODE_PLUSDI,shift );
        double dmiplus = iADX(NULL,0,DmiPeriod,PRICE_CLOSE,MODE_MINUSDI,shift );
        if(  Predmiplus <= Predmiminus )return false;
        if( dmiminus <= dmiplus )return false;
        return true; 
   }
   bool CheckAdx(int shift)
   {
        double adx = iADX(NULL,0,AdxPeriod,PRICE_CLOSE,MODE_MAIN,shift);
        if(AdxLine <= adx)return false;
        return true; 
   }




