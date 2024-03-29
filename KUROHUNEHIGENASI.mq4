#define MQL4
#define PROPERTY_LINK ""
#define PROPERTY_COPYRIGHT ""
#define PROPERTY_DESCRIPTION ""
#define OBJNAME_PREFIX "OBJ I20191004 "
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
input   string              SeparateRSI = "";                           // ▼ RSI設定
input int                   RSIPeriod=14;                               // ┣期間
input int                   UpLine = 70;                                // ┣上の線
input int                   DownLine = 30  ;                            // ┗下の線

input   string              SeparateBunbo = "";                         // ▼ 分母設定(1/○○)
input int                   Bunbo　= 10;                                 //　┗分母

input   string              SeparateArrow = "";                         // ▼ 矢印設定
input   string              SeparateArrowColor = "";                    // 色
input   color               ArrowColorBuy = clrAqua;                    // ┃ ┣ 買
input   color               ArrowColorSell = clrMagenta;                // ┃ ┗ 売
input   uint                ArrowSize = 3;                              // ┗ 大きさ

input   string              SeparateAlert = "";                         // ▼ アラート設定
input   bool                UseAlert = true;                            // ┗ ON/OFF

input   string              SeparateSendMail = "";                      // ▼ メール設定
input   bool                UseSendMail = true;                         // ┗ ON/OFF
//+----------------------------------------------------------------------------+

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
        for (int index = Bars - IndicatorCounted() - 1; SHIFT_CURRENT <= index; index--)
        {
            string objname_buy = OBJNAME_BUY + TimeToString(Time[index]);
            string objname_sell = OBJNAME_SELL + TimeToString(Time[index]);
        
            ObjectDelete(ChartID(), objname_buy);
            ObjectDelete(ChartID(), objname_sell);

            if (CheckBuy(index))
            {
                CreateArrow(objname_buy, 233, ArrowColorBuy, ArrowSize, Time[index], Low[index], ANCHOR_TOP);
            }
            
            if (CheckSell(index))
            {
                CreateArrow(objname_sell, 234, ArrowColorSell, ArrowSize, Time[index], High[index], ANCHOR_BOTTOM);
            }
        }
        
        static datetime PreviousAlertAndMailTime = NULL;
        
        if (PreviousAlertAndMailTime != Time[SHIFT_CURRENT])
        {
            if (ObjectFind(ChartID(), OBJNAME_BUY + TimeToString(Time[1])) != EMPTY)
            {
                string message = Symbol() + "," + TimeframeToString(Period()) + ": " + WindowExpertName() + " is Buy.";
                if (UseAlert) Alert(message);
                if (UseSendMail) SendMail(message, message);
                PreviousAlertAndMailTime = Time[SHIFT_CURRENT];
            }
            
            if (ObjectFind(ChartID(), OBJNAME_SELL + TimeToString(Time[1])) != EMPTY)
            {
                string message = Symbol() + "," + TimeframeToString(Period()) + ": " + WindowExpertName() + " is Sell.";
                if (UseAlert) Alert(message);
                if (UseSendMail) SendMail(message, message);
                PreviousAlertAndMailTime = Time[SHIFT_CURRENT];
            }
        }
        
        // 計算済みの足の本数を返却
        return rates_total - 1;
   
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


 
int CheckBuy(int icount)
{    
     if(icount == 0)return false;
     if(iRSI(Symbol(), 0, RSIPeriod, PRICE_CLOSE, icount) > DownLine)return false;
     if(Close[icount] - Open[icount] > 0)return false;
     if(Open[icount] - Close[icount] < Bunbo　* (High[icount] - Open[icount]))return false;
     if(Open[icount] - Close[icount] < Bunbo　* (Close[icount] - Low[icount]))return false;
     return true;
}
 
int CheckSell(int icount)
{
     if(icount == 0)return false;
     if(iRSI(Symbol(), 0, RSIPeriod, PRICE_CLOSE, icount) < UpLine)return false;
     if(Close[icount] - Open[icount] < 0)return false;
     if(Close[icount] - Open[icount] < Bunbo　* (High[icount] - Close[icount]))return false;
     if(Close[icount] - Open[icount] < Bunbo　* (Open[icount] - Low[icount]))return false;
     return true;  
}
   


