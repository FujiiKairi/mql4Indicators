//+------------------------------------------------------------------+
//|                                               KUROHUNE_CYCLE.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                              https://www.mql5.co |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.co"
#property version   "1.00"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
#property  indicator_buffers   2  
double depth = 50;
double deviation = 5;
double backstep = 3;
int goalPeriod;
int Array[500];
string zigName = "ZigZag"; 

double zigzagHigh[];                       
double zigzagLow[];                           
int OnInit()
  {
//--- indicator buffers mapping
   if(Period() == 60)goalPeriod = 100;
   if(Period() == 240)goalPeriod = 70;
   if(Period() == 1440)goalPeriod = 40;
   if(Period() == 10080)goalPeriod = 30;
   //山と谷の数を数える 
   double differencePeriod = 10000;
   double avgPeriod = 0;
   while()
   {
      for(int i = 0 ; i < Bars ; i++)
      {
         int zigNum = 0;
         double zig = iCustom(Symbol(),0,zigName,depth,deviation,backstep,0,i);
         if( zig != 0)
         {
             Array[zigNum] = i; 
         } 
         zigNum++;
      }
      //山谷の平均の期間を調べる
      double sumPeriod = 0;
      
      for(int i = 0 ; i < zigNum / 2 ;i++)
      {
         sumPeriod = sumPeriod + MathAbs(Array[i * 2] - Array[i * 2 + 1] );
      }
      avgPeriod = sumPeriod / (zignum / 2); 
      if(avgPeriod <= goalPeriod)
//---
   }
   
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
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   
  }
//+------------------------------------------------------------------+
