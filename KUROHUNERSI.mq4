//+------------------------------------------------------------------+
//|                                                          RSI.mq4 |
//|                   Copyright 2005-2014, MetaQuotes Software Corp. |
//|                                              http://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright   "2005-2014, MetaQuotes Software Corp."
#property link        "http://www.mql4.com"
#property description "Relative Strength Index"
#property strict

#property indicator_separate_window
#property indicator_minimum    0
#property indicator_maximum    100
#property indicator_buffers    1
#property indicator_color1     DodgerBlue
#property indicator_levelcolor clrSilver
#property indicator_levelstyle STYLE_DOT

#define OBJNAME_PREFIX "OBJ KUROHUNERSI "
#define OBJNAME_BUY OBJNAME_PREFIX + "BUY "
#define OBJNAME_SELL OBJNAME_PREFIX + "SELL "
//--- input parameters
input   string              SeparateRSI = "";                           // ▼ RSI設定
input int                   RSIPeriod=14;                               // ┣期間
input int                   UpLine = 70;                                // ┣上の線
input int                   DownLine = 30  ;                            // ┗下の線

input   string              SeparateArrow = "";                         // ▼ 矢印設定
input   string              SeparateArrowColor = "";                    // ┣ 色
input   color               ArrowColorBuy = clrAqua;                    // ┃ ┣ 買
input   color               ArrowColorSell = clrMagenta;                // ┃ ┗ 売
input   uint                ArrowSize = 1;                              // ┗ 大きさ
input   bool                ArrowDisplay = false;                       // ┗ 矢印ON/OFF

input   string              SeparateAlert = "";                         // ▼ アラート設定
input   bool                UseAlert = false;                            // ┗ ON/OFF

input   string              SeparateSendMail = "";                      // ▼ メール設定
input   bool                UseSendMail = false;                         // ┗ ON/OFF

input   string              SeparateSendPush = "";                      // ▼ プッシュ通知設定
input   bool                UseSendPush = false;                         // ┗ ON/OFF
//--- buffers
double ExtRSIBuffer[];
double ExtPosBuffer[];
double ExtNegBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(void)
  {
   string short_name;
//--- 2 additional buffers are used for counting.
   IndicatorBuffers(3);
   SetIndexBuffer(1,ExtPosBuffer);
   SetIndexBuffer(2,ExtNegBuffer);
//--- indicator line
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtRSIBuffer);
//--- name for DataWindow and indicator subwindow label
   short_name="RSI("+string(RSIPeriod)+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
   
   IndicatorSetDouble(INDICATOR_LEVELVALUE,0,UpLine);
   IndicatorSetDouble(INDICATOR_LEVELVALUE,1,DownLine);
//--- check for input
   if(RSIPeriod<2)
     {
      Print("Incorrect value for input variable RSIPeriod = ",RSIPeriod);
      return(INIT_FAILED);
     }
//---
   SetIndexDrawBegin(0,RSIPeriod);
//--- initialization done
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Relative Strength Index                                          |
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
   
   int    i,pos;
   double diff;
//---
   if(Bars<=RSIPeriod || RSIPeriod<2)
      return(0);
//--- counting from 0 to rates_total
   ArraySetAsSeries(ExtRSIBuffer,false);
   ArraySetAsSeries(ExtPosBuffer,false);
   ArraySetAsSeries(ExtNegBuffer,false);
   ArraySetAsSeries(close,false);
//--- preliminary calculations
   pos=prev_calculated-1;
   if(pos<=RSIPeriod)
     {
      //--- first RSIPeriod values of the indicator are not calculated
      ExtRSIBuffer[0]=0.0;
      ExtPosBuffer[0]=0.0;
      ExtNegBuffer[0]=0.0;
      double sump=0.0;
      double sumn=0.0;
      for(i=1; i<=RSIPeriod; i++)
        {
         ExtRSIBuffer[i]=0.0;
         ExtPosBuffer[i]=0.0;
         ExtNegBuffer[i]=0.0;
         diff=close[i]-close[i-1];
         if(diff>0)
            sump+=diff;
         else
            sumn-=diff;
        }
      //--- calculate first visible value
      ExtPosBuffer[RSIPeriod]=sump/RSIPeriod;
      ExtNegBuffer[RSIPeriod]=sumn/RSIPeriod;
      if(ExtNegBuffer[RSIPeriod]!=0.0)
         ExtRSIBuffer[RSIPeriod]=100.0-(100.0/(1.0+ExtPosBuffer[RSIPeriod]/ExtNegBuffer[RSIPeriod]));
      else
        {
         if(ExtPosBuffer[RSIPeriod]!=0.0)
            ExtRSIBuffer[RSIPeriod]=100.0;
         else
            ExtRSIBuffer[RSIPeriod]=50.0;
        }
      //--- prepare the position value for main calculation
      pos=RSIPeriod+1;
     }
//--- the main loop of calculations
   for(i=pos; i<rates_total && !IsStopped(); i++)
     {
      diff=close[i]-close[i-1];
      ExtPosBuffer[i]=(ExtPosBuffer[i-1]*(RSIPeriod-1)+(diff>0.0?diff:0.0))/RSIPeriod;
      ExtNegBuffer[i]=(ExtNegBuffer[i-1]*(RSIPeriod-1)+(diff<0.0?-diff:0.0))/RSIPeriod;
      if(ExtNegBuffer[i]!=0.0)
         ExtRSIBuffer[i]=100.0-100.0/(1+ExtPosBuffer[i]/ExtNegBuffer[i]);
      else
        {
         if(ExtPosBuffer[i]!=0.0)
            ExtRSIBuffer[i]=100.0;
         else
            ExtRSIBuffer[i]=50.0;
        }
     }
     
     for (int index = Bars - IndicatorCounted() - 1; 0 <= index; index--)
        {
            string objname_buy = OBJNAME_BUY + TimeToString(Time[index]);
            string objname_sell = OBJNAME_SELL + TimeToString(Time[index]);
        
            ObjectDelete(ChartID(), objname_buy);
            ObjectDelete(ChartID(), objname_sell);
        
            if (CheckBuy(index) )
            {
                CreateArrow(objname_buy, 233, ArrowColorBuy, ArrowSize, Time[index], Low[index], ANCHOR_TOP);
            }
            
            if (CheckSell(index) )
            {
                CreateArrow(objname_sell, 234, ArrowColorSell, ArrowSize, Time[index], High[index], ANCHOR_BOTTOM);
            }
        }
        
        static datetime PreviousAlertAndMailTime = NULL;
        
        if (PreviousAlertAndMailTime != Time[0])
        {
            if (ObjectFind(ChartID(), OBJNAME_BUY + TimeToString(Time[1])) != EMPTY)
            {
                string message = Symbol() + "," + TimeframeToString(Period()) + ": " + WindowExpertName() + " is Buy.";
                if (UseAlert) Alert(message);
                if (UseSendMail) SendMail(message, message);
                if (UseSendPush) SendNotification(message);
                PreviousAlertAndMailTime = Time[0];
            }
            
            if (ObjectFind(ChartID(), OBJNAME_SELL + TimeToString(Time[1])) != EMPTY)
            {
                string message = Symbol() + "," + TimeframeToString(Period()) + ": " + WindowExpertName() + " is Sell.";
                if (UseAlert) Alert(message);
                if (UseSendMail) SendMail(message, message);
                if (UseSendPush) SendNotification( message);
                PreviousAlertAndMailTime = Time[0];
            }
            
        }
//---
   return(rates_total);
  }
//+------------------------------------------------------------------+
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
    
bool CheckBuy(int icount)
{
    if(ArrowDisplay == false)return false;
    if(icount == 0)return false;
    if(iRSI(Symbol(), 0, RSIPeriod, 0, icount) >= DownLine)return false;
    return true;
}
    
bool CheckSell(int icount)
{
    if(ArrowDisplay == false)return false;
    if(icount == 0)return false;
    if(iRSI(Symbol(), 0, RSIPeriod, 0, icount) <= UpLine)return false;
    return true;
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
   

void OnDeinit(const int reason)
{
    
        // コメント削除
        Comment("");
    
        // 全てのオブジェクトを削除
        DeleteAllObjects("");
    
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
