//+------------------------------------------------------------------+
//|                                                         asdf.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                              https://www.mql5.co |
//+------------------------------------------------------------------+
#define MQL4
#define PROPERTY_LINK ""
#define PROPERTY_COPYRIGHT ""
#define PROPERTY_DESCRIPTION ""
#define OBJNAME_PREFIX "OBJ I20190425 "
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
#property indicator_buffers 18//(表示用＋計算用のバッファの数)
#property indicator_plots  18//表示用のバッファの数
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

input   string              SeparateArrow = "";                         // ▼ 矢印設定
input   string              SeparateArrowColor = "";                    // ┣ 色
input   color               ArrowColorBuy = clrAqua;                    // ┃ ┣ 買
input   color               ArrowColorSell = clrMagenta;                // ┃ ┗ 売
input   bool                ArrowKakutei = true;                        // ┣ 足が確定してから矢印を出す
input   int                 NumOfSignal = 6;                            // ┗ ○個以上シグナルが重なれば矢印を出す


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
   
        Comment("KUROHUNE RESISTANCE \nTwitterID   :  KUROHUNEtrader \nLINE@       :  @yfy3673g");
 
        
        //↓表示用のバッファ
        
        
        //計算用のバッファ
        IndicatorBuffers(18);
        IndicatorShortName("KUROHUNE_RESISTANCE SENYOU");
        //↓表示用のバッファ
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
        
        minus = double(5.0/(NumUseIndicator + 1));
        ObjectDelete("STA_TEXT_M1");
        ObjectDelete("STA_TEXT_M2");
        ObjectDelete("STA_TEXT_M3");
        ObjectDelete("STA_TEXT_M4");
        ObjectDelete("STA_TEXT_M5");
        ObjectDelete("STA_TEXT_M6");
        ObjectDelete("STA_TEXT_M7");
        ObjectDelete("STA_TEXT_M8");
        ObjectDelete("STA_TEXT_M9");
        int OrderOfIndi2 = 0;
        if(Use1 == true){
           SetIndexStyle (0, DRAW_ARROW, STYLE_SOLID, ThickOfText, LineColorOn);
           SetIndexArrow (0, 167);
           SetIndexBuffer(0, ON1_Buffer);
           SetIndexEmptyValue(0, EMPTY_VALUE);
           SetIndexStyle (1, DRAW_ARROW, STYLE_SOLID, ThickOfText, LineColorOff);
           SetIndexArrow (1, 167);
           SetIndexBuffer(1, OFF1_Buffer);
           SetIndexEmptyValue(1, EMPTY_VALUE);
           ObjName = "STA_TEXT_M1"; ObjText = "RSI";
           ObjectDelete(ChartID(),"STA_TEXT_M1" );
           ObjectCreate(ObjName,OBJ_TEXT,ChartWindowFind(NULL, "KUROHUNE_RESISTANCE"),0,0);
           ObjectSetText(ObjName, ObjText, SizeOfText, "Tahoma", TextColor);
           ObjectSet(ObjName,OBJPROP_PRICE1,5 - (minus * (OrderOfIndi2 + 1))+LabelsVerticalShift);
           ObjectSet(ObjName,OBJPROP_TIME1,Time[0]+Period()*LabelsHorizontalShift*60);
           OrderOfIndi2++;
        }
        if(Use2 == true){
           SetIndexStyle (2, DRAW_ARROW, STYLE_SOLID, ThickOfText, LineColorOn);
           SetIndexArrow (2, 167);
           SetIndexBuffer(2, ON2_Buffer);
           SetIndexEmptyValue(2, EMPTY_VALUE);
           SetIndexStyle (3, DRAW_ARROW, STYLE_SOLID, ThickOfText, LineColorOff);
           SetIndexArrow (3, 167);
           SetIndexBuffer(3, OFF2_Buffer);
           SetIndexEmptyValue(3, EMPTY_VALUE);
           ObjName = "STA_TEXT_M2"; ObjText = "BB";
           ObjectDelete(ChartID(),"STA_TEXT_M2" );
           ObjectCreate(ObjName,OBJ_TEXT,ChartWindowFind(NULL, "KUROHUNE_RESISTANCE"),0,0);
           ObjectSetText(ObjName, ObjText, SizeOfText, "Tahoma", TextColor);
           ObjectSet(ObjName,OBJPROP_PRICE1,5 - (minus * (OrderOfIndi2 + 1))+LabelsVerticalShift);
           ObjectSet(ObjName,OBJPROP_TIME1,Time[0]+Period()*LabelsHorizontalShift*60);
           OrderOfIndi2++;
        }
        if(Use9 == true){ 
           SetIndexStyle (16, DRAW_ARROW, STYLE_SOLID, ThickOfText, LineColorOn);
           SetIndexArrow (16, 167);
           SetIndexBuffer(16, ON9_Buffer);
           SetIndexEmptyValue(16, EMPTY_VALUE);
           SetIndexStyle (17, DRAW_ARROW, STYLE_SOLID, ThickOfText, LineColorOff);
           SetIndexArrow (17, 167);
           SetIndexBuffer(17, OFF9_Buffer);
           SetIndexEmptyValue(17, EMPTY_VALUE);
           ObjName = "STA_TEXT_M9"; ObjText = "MACD";
           ObjectDelete(ChartID(),"STA_TEXT_M9" );
           ObjectCreate(ObjName,OBJ_TEXT,ChartWindowFind(NULL, "KUROHUNE_RESISTANCE"),0,0);
           ObjectSetText(ObjName, ObjText, SizeOfText, "Tahoma", TextColor);
           ObjectSet(ObjName,OBJPROP_PRICE1,5 - (minus * (OrderOfIndi2 + 1))+LabelsVerticalShift);
           ObjectSet(ObjName,OBJPROP_TIME1,Time[0]+Period()*LabelsHorizontalShift*60);
           OrderOfIndi2++;
        }
        if(Use3 == true){ 
           SetIndexStyle (4, DRAW_ARROW, STYLE_SOLID, ThickOfText, LineColorOn);
           SetIndexArrow (4, 167);
           SetIndexBuffer(4, ON3_Buffer);
           SetIndexEmptyValue(4, EMPTY_VALUE);
           SetIndexStyle (5, DRAW_ARROW, STYLE_SOLID, ThickOfText, LineColorOff);
           SetIndexArrow (5, 167);
           SetIndexBuffer(5, OFF3_Buffer);
           SetIndexEmptyValue(5, EMPTY_VALUE);
           ObjName = "STA_TEXT_M3"; ObjText = "CCI";
           ObjectDelete(ChartID(),"STA_TEXT_M3" );
           ObjectCreate(ObjName,OBJ_TEXT,ChartWindowFind(NULL, "KUROHUNE_RESISTANCE"),0,0);
           ObjectSetText(ObjName, ObjText, SizeOfText, "Tahoma", TextColor);
           ObjectSet(ObjName,OBJPROP_PRICE1,5 - (minus * (OrderOfIndi2 + 1))+LabelsVerticalShift);
           ObjectSet(ObjName,OBJPROP_TIME1,Time[0]+Period()*LabelsHorizontalShift*60);
           OrderOfIndi2++;
        }
        if(Use4 == true){
           SetIndexStyle (6, DRAW_ARROW, STYLE_SOLID, ThickOfText, LineColorOn);
           SetIndexArrow (6, 167);
           SetIndexBuffer(6, ON4_Buffer);
           SetIndexEmptyValue(6, EMPTY_VALUE);
           SetIndexStyle (7, DRAW_ARROW, STYLE_SOLID, ThickOfText, LineColorOff);
           SetIndexArrow (7, 167);
           SetIndexBuffer(7, OFF4_Buffer);
           SetIndexEmptyValue(7, EMPTY_VALUE);
           ObjName = "STA_TEXT_M4"; ObjText = "Envelope";
           ObjectDelete(ChartID(),"STA_TEXT_M4" );
           ObjectCreate(ObjName,OBJ_TEXT,ChartWindowFind(NULL, "KUROHUNE_RESISTANCE"),0,0);
           ObjectSetText(ObjName, ObjText, SizeOfText, "Tahoma", TextColor);
           ObjectSet(ObjName,OBJPROP_PRICE1,5 - (minus * (OrderOfIndi2 + 1))+LabelsVerticalShift);
           ObjectSet(ObjName,OBJPROP_TIME1,Time[0]+Period()*LabelsHorizontalShift*60);
           OrderOfIndi2++;
        }
        if(Use5 == true){        
           SetIndexStyle (8, DRAW_ARROW, STYLE_SOLID, ThickOfText, LineColorOn);
           SetIndexArrow (8, 167);
           SetIndexBuffer(8, ON5_Buffer);
           SetIndexEmptyValue(8, EMPTY_VALUE);
           SetIndexStyle (9, DRAW_ARROW, STYLE_SOLID, ThickOfText, LineColorOff);
           SetIndexArrow (9, 167);
           SetIndexBuffer(9, OFF5_Buffer);
           SetIndexEmptyValue(9, EMPTY_VALUE);
           ObjName = "STA_TEXT_M5"; ObjText = "Pinbar";
           ObjectDelete(ChartID(),"STA_TEXT_M5" );
           ObjectCreate(ObjName,OBJ_TEXT,ChartWindowFind(NULL, "KUROHUNE_RESISTANCE"),0,0);
           ObjectSetText(ObjName, ObjText, SizeOfText, "Tahoma", TextColor);
           ObjectSet(ObjName,OBJPROP_PRICE1,5 - (minus * (OrderOfIndi2 + 1))+LabelsVerticalShift);
           ObjectSet(ObjName,OBJPROP_TIME1,Time[0]+Period()*LabelsHorizontalShift*60);
           OrderOfIndi2++;
        }
        if(Use6 == true){
           SetIndexStyle (10, DRAW_ARROW, STYLE_SOLID, ThickOfText, LineColorOn);
           SetIndexArrow (10, 167);
           SetIndexBuffer(10, ON6_Buffer);
           SetIndexEmptyValue(10, EMPTY_VALUE);
           SetIndexStyle (11, DRAW_ARROW, STYLE_SOLID, ThickOfText, LineColorOff);
           SetIndexArrow (11, 167);
           SetIndexBuffer(11, OFF6_Buffer);
           SetIndexEmptyValue(11, EMPTY_VALUE);
           ObjName = "STA_TEXT_M6"; ObjText = "Stochastic";
           ObjectDelete(ChartID(),"STA_TEXT_M6" );
           ObjectCreate(ObjName,OBJ_TEXT,ChartWindowFind(NULL, "KUROHUNE_RESISTANCE"),0,0);
           ObjectSetText(ObjName, ObjText, SizeOfText, "Tahoma", TextColor);
           ObjectSet(ObjName,OBJPROP_PRICE1,5 - (minus * (OrderOfIndi2 + 1))+LabelsVerticalShift);
           ObjectSet(ObjName,OBJPROP_TIME1,Time[0]+Period()*LabelsHorizontalShift*60);
           OrderOfIndi2++;
        }
        if(Use7 == true){ 
           SetIndexStyle (12, DRAW_ARROW, STYLE_SOLID, ThickOfText, LineColorOn);
           SetIndexArrow (12, 167);
           SetIndexBuffer(12, ON7_Buffer);
           SetIndexEmptyValue(12, EMPTY_VALUE);
           SetIndexStyle (13, DRAW_ARROW, STYLE_SOLID, ThickOfText, LineColorOff);
           SetIndexArrow (13, 167);
           SetIndexBuffer(13, OFF7_Buffer);
           SetIndexEmptyValue(13, EMPTY_VALUE);
           ObjName = "STA_TEXT_M7"; ObjText = "DMI";
           ObjectDelete(ChartID(),"STA_TEXT_M7" );
           ObjectCreate(ObjName,OBJ_TEXT,ChartWindowFind(NULL, "KUROHUNE_RESISTANCE"),0,0);
           ObjectSetText(ObjName, ObjText, SizeOfText, "Tahoma", TextColor);
           ObjectSet(ObjName,OBJPROP_PRICE1,5 - (minus * (OrderOfIndi2 + 1))+LabelsVerticalShift);
           ObjectSet(ObjName,OBJPROP_TIME1,Time[0]+Period()*LabelsHorizontalShift*60);
           OrderOfIndi2++;
        }
        if(Use8 == true){ 
           SetIndexStyle (14, DRAW_ARROW, STYLE_SOLID, ThickOfText, ADXColor);
           SetIndexArrow (14, 167);
           SetIndexBuffer(14, ON8_Buffer);
           SetIndexEmptyValue(14, EMPTY_VALUE);
           SetIndexStyle (15, DRAW_ARROW, STYLE_SOLID, ThickOfText, LineColorOff);
           SetIndexArrow (15, 167);
           SetIndexBuffer(15, OFF8_Buffer);
           SetIndexEmptyValue(15, EMPTY_VALUE);
           ObjName = "STA_TEXT_M8"; ObjText = "ADX";
           ObjectDelete(ChartID(),"STA_TEXT_M8" );
           ObjectCreate(ObjName,OBJ_TEXT,ChartWindowFind(NULL, "KUROHUNE_RESISTANCE"),0,0);
           ObjectSetText(ObjName, ObjText, SizeOfText, "Tahoma", TextColor);
           ObjectSet(ObjName,OBJPROP_PRICE1,5 - (minus * (OrderOfIndi2 + 1))+LabelsVerticalShift);
           ObjectSet(ObjName,OBJPROP_TIME1,Time[0]+Period()*LabelsHorizontalShift*60);
           OrderOfIndi2++;
        }
        
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
        if(Volume[0] == 1)
        {
           string ObjName = "";
           string ObjText = "";
           int OrderOfIndi2 = 0;
           if(Use1 == true){
              ObjName = "STA_TEXT_M1"; ObjText = "RSI";
              ObjectDelete(ChartID(),"STA_TEXT_M1" );
              ObjectCreate(ObjName,OBJ_TEXT,ChartWindowFind(NULL, "KUROHUNE_RESISTANCE"),0,0);
              ObjectSetText(ObjName, ObjText, SizeOfText, "Tahoma", TextColor);
              ObjectSet(ObjName,OBJPROP_PRICE1,5 - (minus * (OrderOfIndi2 + 1))+LabelsVerticalShift);
              ObjectSet(ObjName,OBJPROP_TIME1,Time[0]+Period()*LabelsHorizontalShift*60);
              OrderOfIndi2++;
           }
           if(Use2 == true){
              ObjName = "STA_TEXT_M2"; ObjText = "BB";
              ObjectDelete(ChartID(),"STA_TEXT_M2" );
              ObjectCreate(ObjName,OBJ_TEXT,ChartWindowFind(NULL, "KUROHUNE_RESISTANCE"),0,0);
              ObjectSetText(ObjName, ObjText, SizeOfText, "Tahoma", TextColor);
              ObjectSet(ObjName,OBJPROP_PRICE1,5 - (minus * (OrderOfIndi2 + 1))+LabelsVerticalShift);
              ObjectSet(ObjName,OBJPROP_TIME1,Time[0]+Period()*LabelsHorizontalShift*60);
              OrderOfIndi2++;
           }
           if(Use9 == true){ 
              ObjName = "STA_TEXT_M9"; ObjText = "MACD";
              ObjectDelete(ChartID(),"STA_TEXT_M9" );
              ObjectCreate(ObjName,OBJ_TEXT,ChartWindowFind(NULL, "KUROHUNE_RESISTANCE"),0,0);
              ObjectSetText(ObjName, ObjText, SizeOfText, "Tahoma", TextColor);
              ObjectSet(ObjName,OBJPROP_PRICE1,5 - (minus * (OrderOfIndi2 + 1))+LabelsVerticalShift);
              ObjectSet(ObjName,OBJPROP_TIME1,Time[0]+Period()*LabelsHorizontalShift*60);
              OrderOfIndi2++;
           }
           if(Use3 == true){ 
              ObjName = "STA_TEXT_M3"; ObjText = "CCI";
              ObjectDelete(ChartID(),"STA_TEXT_M3" );
              ObjectCreate(ObjName,OBJ_TEXT,ChartWindowFind(NULL, "KUROHUNE_RESISTANCE"),0,0);
              ObjectSetText(ObjName, ObjText, SizeOfText, "Tahoma", TextColor);
              ObjectSet(ObjName,OBJPROP_PRICE1,5 - (minus * (OrderOfIndi2 + 1))+LabelsVerticalShift);
              ObjectSet(ObjName,OBJPROP_TIME1,Time[0]+Period()*LabelsHorizontalShift*60);
              OrderOfIndi2++;
           }
           if(Use4 == true){
              ObjName = "STA_TEXT_M4"; ObjText = "Envelope";
              ObjectDelete(ChartID(),"STA_TEXT_M4" );
              ObjectCreate(ObjName,OBJ_TEXT,ChartWindowFind(NULL, "KUROHUNE_RESISTANCE"),0,0);
              ObjectSetText(ObjName, ObjText, SizeOfText, "Tahoma", TextColor);
              ObjectSet(ObjName,OBJPROP_PRICE1,5 - (minus * (OrderOfIndi2 + 1))+LabelsVerticalShift);
              ObjectSet(ObjName,OBJPROP_TIME1,Time[0]+Period()*LabelsHorizontalShift*60);
              OrderOfIndi2++;
           }
           if(Use5 == true){        
              ObjName = "STA_TEXT_M5"; ObjText = "Pinbar";
              ObjectDelete(ChartID(),"STA_TEXT_M5" );
              ObjectCreate(ObjName,OBJ_TEXT,ChartWindowFind(NULL, "KUROHUNE_RESISTANCE"),0,0);
              ObjectSetText(ObjName, ObjText, SizeOfText, "Tahoma", TextColor);
              ObjectSet(ObjName,OBJPROP_PRICE1,5 - (minus * (OrderOfIndi2 + 1))+LabelsVerticalShift);
              ObjectSet(ObjName,OBJPROP_TIME1,Time[0]+Period()*LabelsHorizontalShift*60);
              OrderOfIndi2++;
           }
           if(Use6 == true){
              ObjName = "STA_TEXT_M6"; ObjText = "Stochastic";
              ObjectDelete(ChartID(),"STA_TEXT_M6" );
              ObjectCreate(ObjName,OBJ_TEXT,ChartWindowFind(NULL, "KUROHUNE_RESISTANCE"),0,0);
              ObjectSetText(ObjName, ObjText, SizeOfText, "Tahoma", TextColor);
              ObjectSet(ObjName,OBJPROP_PRICE1,5 - (minus * (OrderOfIndi2 + 1))+LabelsVerticalShift);
              ObjectSet(ObjName,OBJPROP_TIME1,Time[0]+Period()*LabelsHorizontalShift*60);
              OrderOfIndi2++;
           }
           if(Use7 == true){ 
              ObjName = "STA_TEXT_M7"; ObjText = "DMI";
              ObjectDelete(ChartID(),"STA_TEXT_M7" );
              ObjectCreate(ObjName,OBJ_TEXT,ChartWindowFind(NULL, "KUROHUNE_RESISTANCE"),0,0);
              ObjectSetText(ObjName, ObjText, SizeOfText, "Tahoma", TextColor);
              ObjectSet(ObjName,OBJPROP_PRICE1,5 - (minus * (OrderOfIndi2 + 1))+LabelsVerticalShift);
              ObjectSet(ObjName,OBJPROP_TIME1,Time[0]+Period()*LabelsHorizontalShift*60);
              OrderOfIndi2++;
           }
           if(Use8 == true){ 
              ObjName = "STA_TEXT_M8"; ObjText = "ADX";
              ObjectDelete(ChartID(),"STA_TEXT_M8" );
              ObjectCreate(ObjName,OBJ_TEXT,ChartWindowFind(NULL, "KUROHUNE_RESISTANCE"),0,0);
              ObjectSetText(ObjName, ObjText, SizeOfText, "Tahoma", TextColor);
              ObjectSet(ObjName,OBJPROP_PRICE1,5 - (minus * (OrderOfIndi2 + 1))+LabelsVerticalShift);
              ObjectSet(ObjName,OBJPROP_TIME1,Time[0]+Period()*LabelsHorizontalShift*60);
              OrderOfIndi2++;
           }
        }
   for (int index = Bars - IndicatorCounted() - 1; SHIFT_CURRENT <= index; index--)
        {
            int OrderOfIndi = 0;//trueの何番目か
            if(Use1 == true ){
               ON1_Buffer[index] = EMPTY_VALUE;
               OFF1_Buffer[index] = EMPTY_VALUE;
               if(CheckRSIBuy(index))ON1_Buffer[index] =  5 - (minus * (OrderOfIndi + 1));
               else if(CheckRSISell(index))OFF1_Buffer[index] =  5 - (minus * (OrderOfIndi + 1));
               OrderOfIndi++;
            }
            if(Use2 == true ){
               ON2_Buffer[index] = EMPTY_VALUE;
               OFF2_Buffer[index] = EMPTY_VALUE;
               if(CheckBBBuy(index))ON2_Buffer[index] =  5 - (minus * (OrderOfIndi + 1));
               else if(CheckBBSell(index))OFF2_Buffer[index] =  5 - (minus * (OrderOfIndi + 1));
               OrderOfIndi++;
            }
            if(Use9 == true ){
               ON9_Buffer[index] = EMPTY_VALUE;
               OFF9_Buffer[index] = EMPTY_VALUE;
               if(CheckMacdBuy(index))ON9_Buffer[index] =  5 - (minus * (OrderOfIndi + 1));
               else if(CheckMacdSell(index))OFF9_Buffer[index] =  5 - (minus * (OrderOfIndi + 1));
               OrderOfIndi++;
            }
            if(Use3 == true ){
               ON3_Buffer[index] = EMPTY_VALUE;
               OFF3_Buffer[index] = EMPTY_VALUE;
               if(CheckCCIBuy(index))ON3_Buffer[index] =  5 - (minus * (OrderOfIndi + 1));
               else if(CheckCCISell(index))OFF3_Buffer[index] =  5 - (minus * (OrderOfIndi + 1));
               OrderOfIndi++;
            }
            if(Use4 == true ){
               ON4_Buffer[index] = EMPTY_VALUE;
               OFF4_Buffer[index] = EMPTY_VALUE;
               if(CheckEnvelopeBuy(index))ON4_Buffer[index] =  5 - (minus * (OrderOfIndi + 1));
               else if(CheckEnvelopeSell(index))OFF4_Buffer[index] =  5 - (minus * (OrderOfIndi + 1));
               OrderOfIndi++;
            }
            if(Use5 == true ){
               ON5_Buffer[index] = EMPTY_VALUE;
               OFF5_Buffer[index] = EMPTY_VALUE;
               if(CheckPinbarBuy(index))ON5_Buffer[index] =  5 - (minus * (OrderOfIndi + 1));
               else if(CheckPinbarSell(index))OFF5_Buffer[index] =  5 - (minus * (OrderOfIndi + 1));
               OrderOfIndi++;
            }
            if(Use6 == true ){
               ON6_Buffer[index] = EMPTY_VALUE;
               OFF6_Buffer[index] = EMPTY_VALUE;
               if(CheckStBuy(index))ON6_Buffer[index] =  5 - (minus * (OrderOfIndi + 1));
               else if(CheckStSell(index))OFF6_Buffer[index] =  5 - (minus * (OrderOfIndi + 1));
               OrderOfIndi++;
            }
            if(Use7 == true ){
               ON7_Buffer[index] = EMPTY_VALUE;
               OFF7_Buffer[index] = EMPTY_VALUE;
               if(CheckDmiBuy(index))ON7_Buffer[index] =  5 - (minus * (OrderOfIndi + 1));
               else if(CheckDmiSell(index))OFF7_Buffer[index] =  5 - (minus * (OrderOfIndi + 1));
               OrderOfIndi++;
            }
            if(Use8 == true ){
               ON8_Buffer[index] = EMPTY_VALUE;
               OFF8_Buffer[index] = EMPTY_VALUE;
               if(CheckAdx(index))ON8_Buffer[index] =  5 - (minus * (OrderOfIndi + 1));
               OrderOfIndi++;
            }    
        }
         
        for (int index = Bars - IndicatorCounted() - 1; SHIFT_CURRENT <= index; index--)
        {
            string objname_buy = OBJNAME_BUY + TimeToString(Time[index]);
            string objname_sell = OBJNAME_SELL + TimeToString(Time[index]);
        
            ObjectDelete(ChartID(), objname_buy);
            ObjectDelete(ChartID(), objname_sell);
            
            if(NumUseIndicator < NumOfSignal)
            {
               
            }
            else
            {
               int cBuy = CheckBuy(index);
               if (cBuy >=  NumOfSignal)
               {   
                  int size = 0;
                  if(cBuy == 9)size = 6;
                  if(cBuy == 8 || cBuy == 7)size = 5;
                  if(cBuy == 6 || cBuy == 5)size = 4;
                  if(cBuy == 4 || cBuy == 3)size = 3;
                  if(cBuy == 2 || cBuy == 1)size = 2; 
                  CreateArrow(objname_buy, 233, ArrowColorBuy,size , Time[index], Low[index], ANCHOR_TOP);
               }
               int cSell = CheckSell(index);
               if (cSell >= NumOfSignal )
               {
                   int size = 0;
                   if(cSell == 9)size = 6;
                   if(cSell == 8 || cSell == 7)size = 5;
                   if(cSell == 6 || cSell == 5)size = 4;
                   if(cSell == 4 || cSell == 3)size = 3;
                   if(cSell == 2 || cSell == 1)size = 2; 
                   CreateArrow(objname_sell, 234, ArrowColorSell,size , Time[index], High[index], ANCHOR_BOTTOM);              
               }
            }
            
        }
        
        static datetime PreviousAlertAndMailTime = NULL;
        
        
        if (PreviousAlertAndMailTime != Time[SHIFT_CURRENT] )
        {
            
            if ((ObjectFind(ChartID(), OBJNAME_BUY + TimeToString(Time[SHIFT_CURRENT])) != EMPTY && ArrowKakutei == false)
            ||(ObjectFind(ChartID(), OBJNAME_BUY + TimeToString(Time[SHIFT_PREVIOUS1])) != EMPTY && ArrowKakutei == true))
            {
                string message = Symbol() + "," + TimeframeToString(Period()) + ": " + WindowExpertName() + " is Buy.";
                if (UseAlert) Alert(message);
                if (UseSendMail) SendMail(message, message);
                PreviousAlertAndMailTime = Time[SHIFT_CURRENT];
            }
            
            if ((ObjectFind(ChartID(), OBJNAME_BUY + TimeToString(Time[SHIFT_CURRENT])) != EMPTY && ArrowKakutei == false)
            ||(ObjectFind(ChartID(), OBJNAME_BUY + TimeToString(Time[SHIFT_PREVIOUS1])) != EMPTY && ArrowKakutei == true))
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
   void CreateLabel(string name, string text, color c, uint size, uint width, ENUM_BASE_CORNER corner, uint x, uint y, string font, bool back = false, string window_name = "")
    {
        // ラベルオブジェクトを作成
        ObjectCreate(NULL, name, OBJ_LABEL, window_name == "" ? NULL : (window_name == "0" ? NULL : WindowFind(window_name)), NULL, NULL);
        ObjectSetInteger(NULL, name, OBJPROP_BACK, back);
        ObjectSetInteger(NULL, name, OBJPROP_COLOR, c);
        ObjectSetInteger(NULL, name, OBJPROP_CORNER, corner);
        ObjectSetInteger(NULL, name, OBJPROP_WIDTH, 30);
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
     void CreateArrow(string name, uint code, color c, int size, datetime time, double price, ENUM_ARROW_ANCHOR anchor = ANCHOR_TOP, bool chart_window = true, bool is_back = false)
    {
    	ObjectCreate(NULL, name, OBJ_ARROW, 0, NULL, NULL);
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


    
   int CheckBuy(int shift)
   {    
        if(ArrowKakutei == true && shift == 0)return -1;
        int count = 0;
        if(CheckRSIBuy(shift) && Use1)count++; 
        if(CheckBBBuy(shift)&& Use2)count++; 
        if(CheckMacdBuy(shift)&& Use9)count++; 
        if(CheckCCIBuy(shift)&& Use3)count++; 
        if(CheckEnvelopeBuy(shift)&& Use4)count++; 
        if(CheckPinbarBuy(shift)&& Use5)count++; 
        if(CheckStBuy(shift)&& Use6)count++; 
        if(CheckDmiBuy(shift)&& Use7)count++; 
        if(CheckAdx(shift)&& Use8)count++; 
        return count;   
   }
    
   int CheckSell(int shift)
   {
        if(ArrowKakutei == true && shift == 0)return -1;
        int count = 0;
        if(CheckRSISell(shift) && Use1)count++; 
        if(CheckBBSell(shift)&& Use2)count++; 
        if(CheckMacdSell(shift)&& Use9)count++; 
        if(CheckCCISell(shift)&& Use3)count++; 
        if(CheckEnvelopeSell(shift)&& Use4)count++; 
        if(CheckPinbarSell(shift)&& Use5)count++; 
        if(CheckStSell(shift)&& Use6)count++; 
        if(CheckDmiSell(shift)&& Use7)count++; 
        if(CheckAdx(shift)&& Use8)count++; 
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
        if( PreMain <= PreSignal )return false;
        if( Signal <= Main )return false;
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
        if(PreSignal <= PreMain)return false;
        if(Main <= Signal)return false;
        
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
        if(PreKLine <= PreDLine)return false;
        if(DLine <= KLine)return false;
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
        if(PreDLine <= PreKLine)return false;
        if(KLine <= DLine )return false;
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




