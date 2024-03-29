//+------------------------------------------------------------------+
//|                                                         asdf.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                              https://www.mql5.co |
//+------------------------------------------------------------------+
#define MQL4
#define PROPERTY_LINK ""
#define PROPERTY_COPYRIGHT ""
#define PROPERTY_DESCRIPTION ""
#define OBJNAME_PREFIX "OBJ I20190507 "
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
#property indicator_buffers 1//(表示用＋計算用のバッファの数)

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
input   string              SeparateMA = "";                            // ▼ 移動平均線設定
input   uint                MAPeriod = 14;                              // ┣ 期間
input   uint                MAIdou = 0;                                 // ┣ 表示移動
input   ENUM_APPLIED_PRICE  MAAppliedPrice = PRICE_CLOSE;               // ┣ 適用価格
input   color               MAColor = clrRed;                           // ┗ 色
input   string              SeparateMODE = "";                          // ▼ 適用種別設定
input   bool                UseSMA = true;                              // ┣ SMA(単純移動平均)
input   bool                UseEMA = true;                              // ┣ EMA(指数移動平均)
input   bool                UseWMA = true;                              // ┣ WMA(加重移動平均)
input   bool                UseMMA = false;                             // ┗ MMA(平滑移動平均)

int NumUseMA = 0 ;

//--- Global Files

double  MABuffer[];
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
 
        //↓表示用のバッファ
        SetIndexBuffer(0, MABuffer);
        SetIndexLabel(0, StringFormat("KUROHUNE MA",MAPeriod));
        SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 1, MAColor);
        //計算用のバッファ
        if(UseSMA == true)NumUseMA++;
        if(UseEMA == true)NumUseMA++;
        if(UseWMA == true)NumUseMA++;
        if(UseMMA == true)NumUseMA++;
        
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
   for (int index = Bars - IndicatorCounted() - 1; SHIFT_CURRENT <= index; index--)
        {
            double MA = 0;
            if(UseSMA == true)MA = MA + iMA(Symbol(), Period(), MAPeriod, MAIdou ,MODE_SMA ,MAAppliedPrice ,index);
            if(UseEMA == true)MA = MA + iMA(Symbol(), Period(), MAPeriod, MAIdou ,MODE_EMA ,MAAppliedPrice ,index);
            if(UseWMA == true)MA = MA + iMA(Symbol(), Period(), MAPeriod, MAIdou ,MODE_LWMA ,MAAppliedPrice ,index);
            if(UseMMA == true)MA = MA + iMA(Symbol(), Period(), MAPeriod, MAIdou ,MODE_SMMA ,MAAppliedPrice ,index);
            MA = MA / NumUseMA;
            MABuffer[index] = MA;
            
        }
        // 計算済みの足の本数を返却
       
        return rates_total - 1;
//--- return value of prev_calculated for next call
   }
//+------------------------------------------------------------------+




