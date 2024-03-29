#define MQL4
#define PROPERTY_LINK ""
#define PROPERTY_COPYRIGHT ""
#define PROPERTY_DESCRIPTION ""
#define OBJNAME_PREFIX "OBJ I20190510 "
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
#property indicator_buffers 16
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
//+----------------------------------------------------------------------------+

input   string              SeparateNum= "";                            // ▼ 設定
input   int                 NumOfPast = 30;                             // ┣ 過去○○本の足を調べる
input   int                 DisplayFuture = 10;                         // ┣ 未来○○本の足を表示する
input   int                 Num = 0;                                    // ┣ ○○本目の足からの予想を調べる
input   bool                StopTime = true;                            // ┣ trueの時足が動いても予想を動かさない

input   string              SeparateArrow = "";                         // ▼ 足設定
input   string              SeparateArrowColor = "";                    // ┣ 色
input   color               UpColor      = clrBlue;                    // ┃ ┣ 陽線
input   color               DownColor      = clrRed;                    // ┃ ┗ 陰線

double HighDifference[];
double LowDifference[];
double OpenDifference[];
double CloseDifference[];
double MaDifference[];
double UpHigh[];
double UpLow[];
double UpOpen[];
double UpClose[];
double DnHigh[];
double DnLow[];
double DnOpen[];
double DnClose[];
int OnlyStart = 0;

//--- Global Files
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

int OnInit()
  {
//--- indicator buffers mapping
        Comment("KUROHUNEPRO \nTwitterID   :  KUROHUNEtrader \nLINE@       :  @yfy3673g");

   IndicatorBuffers(16);
   
   SetIndexBuffer(0,UpHigh);
   SetIndexBuffer(1,UpLow);
   SetIndexBuffer(2,UpOpen);
   SetIndexBuffer(3,UpClose);
   SetIndexBuffer(4,DnHigh);
   SetIndexBuffer(5,DnLow);
   SetIndexBuffer(6,DnOpen);
   SetIndexBuffer(7,DnClose);
   SetIndexStyle(0, DRAW_HISTOGRAM, STYLE_SOLID, 1, clrBlue);
   SetIndexStyle(1, DRAW_HISTOGRAM, STYLE_SOLID, 1, clrBlue);
   SetIndexStyle(2, DRAW_HISTOGRAM, STYLE_SOLID, 3, clrBlue);
   SetIndexStyle(3, DRAW_HISTOGRAM, STYLE_SOLID, 3, clrBlue);
   SetIndexStyle(4, DRAW_HISTOGRAM, STYLE_SOLID, 1, clrRed);
   SetIndexStyle(5, DRAW_HISTOGRAM, STYLE_SOLID, 1, clrRed);
   SetIndexStyle(6, DRAW_HISTOGRAM, STYLE_SOLID, 3, clrRed);
   SetIndexStyle(7, DRAW_HISTOGRAM, STYLE_SOLID, 3, clrRed);
   
   
   
   for (int i=0; i<8; i++){
      SetIndexShift(i,DisplayFuture - 1 - Num);
   }
   ArrayResize(HighDifference,NumOfPast);   
   ArrayResize(LowDifference,NumOfPast);
   ArrayResize(OpenDifference,NumOfPast);
   ArrayResize(CloseDifference,NumOfPast);
   ArrayResize(MaDifference,NumOfPast);
   

   
      
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
   if(OnlyStart == 0||(Volume[0] == 1 && !StopTime))
   {
      OnlyStart =1;
      double MinimumScore =100000000;
      int MinimumIndex = 0;
      for (int index = Bars - 1; SHIFT_CURRENT + Num + DisplayFuture <= index; index--)
      {   
         double output = CaluculateScore(index ,Num);
           if(output < MinimumScore && 0 < output)
           {
               MinimumScore = output;
               MinimumIndex = index;
           }   
       }
       //Print(MinimumScore);
       //Print(MinimumIndex);
        
     // 未計算の足を全て処理
     
     double difference =  High[1 + Num] - High[MinimumIndex];
       for(int i = 0; i < DisplayFuture  ; i++)
       {
         ResetBuffers(i);
          if(Open[MinimumIndex -(DisplayFuture - i)] <= Close[MinimumIndex -(DisplayFuture - i)])
          {  
            UpHigh[i]  = High[MinimumIndex -(DisplayFuture - i)] + difference;
            UpLow[i]   = Low[MinimumIndex -(DisplayFuture - i)] + difference;
            UpOpen[i]  = Open[MinimumIndex -(DisplayFuture - i)] + difference;
            UpClose[i] = Close[MinimumIndex -(DisplayFuture - i)] + difference;
          }
          if(Open[MinimumIndex -(DisplayFuture - i)] > Close[MinimumIndex -(DisplayFuture - i)])
          { 
            DnHigh[i]  = High[MinimumIndex -(DisplayFuture - i)] + difference;
            DnLow[i]   = Low[MinimumIndex - (DisplayFuture - i)] + difference;
            DnOpen[i]  = Open[MinimumIndex -(DisplayFuture - i)] + difference;
            DnClose[i] = Close[MinimumIndex - (DisplayFuture - i)] + difference;
          }
       }
    }   
        return rates_total - 1;
//--- return value of prev_calculated for next call
   
  }
//+------------------------------------------------------------------+
void ResetBuffers(int shift){
 UpHigh[shift]  = EMPTY_VALUE;
 UpLow[shift]   = EMPTY_VALUE;
 UpOpen[shift]  = EMPTY_VALUE;
 UpClose[shift] = EMPTY_VALUE;
 DnHigh[shift]  = EMPTY_VALUE;
 DnLow[shift]   = EMPTY_VALUE;
 DnOpen[shift]  = EMPTY_VALUE;
 DnClose[shift] = EMPTY_VALUE;
 return;
}

double CaluculateScore(int index , int Num1)
{
   double score = 0;
   if(index == 0 ||index == 1)return -1;
   if( Bars - index - 1 < NumOfPast)return -1;
   
   for(int i = 0; i < NumOfPast ; i++)
   {
      double difference =  High[1 + Num1] - High[index];
      double madifference =  iMA(Symbol(), Period(), NumOfPast, NULL ,MODE_EMA ,PRICE_CLOSE ,1 + Num1)
      - iMA(Symbol(), Period(), NumOfPast, NULL ,MODE_EMA ,PRICE_CLOSE ,index);
      
      HighDifference[i] = MathPow(MathAbs(High[i + 1 + Num1] - (High[index + i] + difference)) ,2);//差の絶対値の二乗
      LowDifference[i] =  MathPow(MathAbs(Low[i + 1 + Num1] - (Low[index + i] + difference)),2);
      OpenDifference[i] =  MathPow(MathAbs(Open[i + 1 + Num1] - (Open[index + i] + difference)),2);
      CloseDifference[i] =  MathPow(MathAbs(Close[i + 1 + Num1] - (Close[index + i] + difference)),2);
      MaDifference[i] =  MathPow(MathAbs(iMA(Symbol(), Period(), NumOfPast, NULL ,MODE_EMA ,PRICE_CLOSE ,i + 1 + Num1) 
      - (iMA(Symbol(), Period(), NumOfPast, NULL ,MODE_EMA ,PRICE_CLOSE ,index + i) + difference)),2);
   }
   for(int i = 0; i < NumOfPast ; i++)
   {
     score = score + (HighDifference[i] *(NumOfPast - i));
      score = score + (LowDifference[i] *(NumOfPast - i));
      score = score + (OpenDifference[i] *(NumOfPast - i));
      score = score + (CloseDifference[i] *(NumOfPast - i));
      score = score + (MaDifference[i] *(NumOfPast - i));
   }
   return score;
}

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
uint ChartGetCandlestikWidth()
{
  if (ChartGetInteger(ChartID(), CHART_SCALE) == 0) return 1;
  if (ChartGetInteger(ChartID(), CHART_SCALE) == 1) return 1;
  if (ChartGetInteger(ChartID(), CHART_SCALE) == 2) return 2;
  if (ChartGetInteger(ChartID(), CHART_SCALE) == 3) return 3;
  if (ChartGetInteger(ChartID(), CHART_SCALE) == 4) return 6;
  if (ChartGetInteger(ChartID(), CHART_SCALE) == 5) return 13;
  return 0;
}