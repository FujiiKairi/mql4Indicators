//+------------------------------------------------------------------+
//|                                                      timeWeb.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_separate_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
#property  indicator_buffers   3                // インジケータバッファ：1つ設定
#property  indicator_color1   clrRed 
#property  indicator_color2   clrBlue      // インジケータ1の色：黄色
#property  indicator_width1    2 
#property  indicator_width2    10 
#property  indicator_color3   clrBlue      // インジケータ1の色：黄色
#property  indicator_width3    2             // インジケータ1の太さ：2


double ExIndLine[100],ExIndLine2[100],ExIndLine3[100]; 
input int openTime=6;
input int closeTime=13;                          // インジケータバッファ：ヒストグラム用

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//|------------------------------------------------------------------|
void init()
{
     SetIndexBuffer(0,ExIndLine);              // ExIndLineをインジケータ1に登録
    SetIndexStyle(0,DRAW_ARROW);              // ンジケータスタイルをアローコードに設定
    SetIndexArrow(0,83);                 // ンジケータスタイルをアローコードに設定
      
   SetIndexBuffer(1,ExIndLine2);              // ExIndLineをインジケータ1に登録
    SetIndexStyle(1,DRAW_LINE);              // ンジケータスタイルをアローコードに設定
                         // ンジケータスタイルをアローコードに設定
       
    
    SetIndexBuffer(2,ExIndLine3);              // ExIndLineをインジケータ1に登録
    SetIndexStyle(2,DRAW_LINE,0,EMPTY_VALUE,Red);              // 描画が下にずれないようにするもの
                  // ンジケータスタイルをアローコードに設定
                // アローコードをチェックサイ記号に設定

    ArrayInitialize(ExIndLine,0); 
    ArrayInitialize(ExIndLine2,0);    
    ArrayInitialize(ExIndLine3,0);           // ExIndLine配列を0で初期化
}


//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int changedBars(int rates_total,int prev_calculated){
   if(prev_calculated==0){
      return rates_total;
   }
   return rates_total-prev_calculated+1;
}
int OnCalculate(
                const int       rates_total,    // 入力された時系列のバー数
                const int       prev_calculated,// 計算済み(前回呼び出し時)のバー数
                const datetime& time[],         // 時間
                const double&   open[],         // 始値
                const double&   high[],         // 高値
                const double&   low[],          // 安値
                const double&   close[],        // 終値
                const long&     tick_volume[],  // Tick出来高
                const long&     volume[],       // Real出来高
                const int&      spread[])       // スプレッド
{
  
    int icount = 0;
    int icountend;
    icountend = rates_total -  prev_calculated;
    if ( icountend >= rates_total ) {
        icountend = rates_total - 1;
    }
      int changed=changedBars(rates_total,prev_calculated);
      
    for( icount = 0; icount <changed ; icount++ ) {
        
         
            datetime dt=time[icount];
            int hour=TimeHour(dt);
            int minute=TimeMinute(dt);
               ExIndLine3[icount]  = 0;
            if(hour==0&&minute==0){
               ExIndLine[icount-2]  = 1;
            }
            if((openTime<hour)&&(closeTime+1>=hour)){
                ExIndLine2[icount]  = 0;
            }
         
    }


    return(rates_total);
}
