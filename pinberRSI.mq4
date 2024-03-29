//+------------------------------------------------------------------+
//|                                                         test.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window//チャートのメインウインドウに表示される。separatewindowの時サブウインドウ
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
// インジケータウインドウ設定
#property  indicator_chart_window          // インジケータをチャートウインドウに表示

// インジケータ設定
#property  indicator_buffers   2                // インジケータバッファ：1つ設定
#property  indicator_color1   clrRed 
#property  indicator_color2   clrBlue      // インジケータ1の色：黄色
#property  indicator_width1    2 
#property  indicator_width2    2              // インジケータ1の太さ：2
input double pinPosi=0.4;
//実体の中心の位置
input double pinPer=60;
//実体が足全体を占める割合(%)
input double pinLength=0;
//ピンバーと認識する最少の長さ（単位はpips）
input int preBars=0;
//ピンバーが直近最安値、最高値かどうかを判断するバーの数
input bool RSI=true;
input int RSIPeriod=14;
//RSIの適用期間
input bool useMail=false;
//シグナルが出たときにメールが届きます
input bool useAlert=false;
//シグナルが出たときにアラートが鳴ります
int RSI1=70;//買われすぎの判断
int RSI2=30;//売られすぎの判断
double ExIndLine[100],ExIndLine2[100];                           // インジケータバッファ：ヒストグラム用

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//|------------------------------------------------------------------|
void init()
{
    SetIndexBuffer(0,ExIndLine);              // ExIndLineをインジケータ1に登録
    SetIndexStyle(0,DRAW_ARROW);              // ンジケータスタイルをアローコードに設定
    SetIndexArrow(0,225);   
    SetIndexBuffer(1,ExIndLine2);              // ExIndLineをインジケータ1に登録
    SetIndexStyle(1,DRAW_ARROW);              // ンジケータスタイルをアローコードに設定
    SetIndexArrow(1,226);              // アローコードをチェックサイン記号に設定

    ArrayInitialize(ExIndLine,0); 
    ArrayInitialize(ExIndLine2,0);             // ExIndLine配列を0で初期化
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
      
    for( icount = 1; icount <changed ; icount++ ) {
        
       if(pinLength*Point*10<high[icount]-low[icount]){
          if(RSI==false){
              if(close[icount]-open[icount]>0){//買いサイン
                    if ( (MathAbs(close[icount]-open[icount])/(high[icount]-low[icount])<(pinPer*0.01)||close[icount]==open[icount])&&
               ((MathAbs(close[icount]-open[icount])/2)+open[icount]-low[icount])/(high[icount]-low[icount])>pinPosi ) {  
                        int i=0,hantei=0;
                        for(i=0;i<preBars;i++){
                           if(low[icount]>low[icount+i+1]){
                              hantei=1;
                           }   
                        }
                          if(hantei==0){
                              ExIndLine[icount]  = low[icount]-(close[icount]-open[icount]);
                              if(icount==1){
                                 if(useMail){
                                    SendMail("買いシグナルが出ました","確認しましょう");
                                 }
                                 if(useAlert){
                                    Alert("買いシグナルが出ました");
                                 }
                              }
                          }
                        
                 
                 }
              }
              else{
                    if ( (MathAbs(close[icount]-open[icount])/(high[icount]-low[icount])<(pinPer*0.01)||close[icount]==open[icount])&&//売りサイン
               (((MathAbs(close[icount]-open[icount]))/2)+high[icount]-open[icount])/(high[icount]-low[icount])>pinPosi ) {  
                int i=0,hantei=0;
                        for(i=0;i<preBars;i++){
                           if(high[icount]<high[icount+i+1]){
                              hantei=1;
                           }   
                        }
                          if(hantei==0){
                                 ExIndLine2[icount]  = low[icount]-(open[icount]-close[icount]);
                                 if(icount==1){
                                    if(useMail){
                                       SendMail("売りシグナルが出ました","確認しましょう");
                                    }
                                    if(useAlert){
                                       Alert("売りシグナルが出ました");
                                    }
                                 }
                      }
                 
                 }
              }
            }
          if(RSI==true){
              if(close[icount]-open[icount]>0){//買いサイン
                    if ((MathAbs(close[icount]-open[icount])/(high[icount]-low[icount])<(pinPer/100)||close[icount]==open[icount])&&
               (((close[icount]-open[icount])/2)+open[icount]-low[icount])/(high[icount]-low[icount])>pinPosi 
               &&iRSI(Symbol(),0,RSIPeriod,0,icount)<=RSI2) {  
                int i=0,hantei=0;
                        for(i=0;i<preBars;i++){
                           if(low[icount]>low[icount+i+1]){
                              hantei=1;
                           }   
                        }
                          if(hantei==0){
                              ExIndLine[icount]  = low[icount]-(close[icount]-open[icount]);
                              if(icount==1){
                                 if(useMail){
                                    SendMail("売りシグナルが出ました","確認しましょう");
                                 }
                                 if(useAlert){
                                    Alert("売りシグナルが出ました");
                                 }
                              }
                        }
                 }
              }
              else{
                    if ((MathAbs(close[icount]-open[icount])/(high[icount]-low[icount])<(pinPer/100)||close[icount]==open[icount])&&//売りサイン
               (((MathAbs(close[icount]-open[icount]))/2)+high[icount]-open[icount])/(high[icount]-low[icount])>pinPosi
               &&iRSI(Symbol(),0,RSIPeriod,0,icount)>=RSI1 ) {  
               int i=0,hantei=0;
                        for(i=0;i<preBars;i++){
                           if(high[icount]<high[icount+i+1]){
                              hantei=1;
                           }   
                        }
                          if(hantei==0){
                        ExIndLine2[icount]  = low[icount]-(open[icount]-close[icount]);
                        if(icount==1){
                           if(useMail){
                              SendMail("売りシグナルが出ました","確認しましょう");
                           }
                           if(useAlert){
                              Alert("売りシグナルが出ました");
                           }
                        }
                      }
                 
                 }
              }
            }
         }
    }


    return(rates_total);
}
