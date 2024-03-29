//+------------------------------------------------------------------+
//|                               Back_to_the_Economic_Indicator.mq4 |
//|                                                            Rondo |
//|                                         fx-dollaryen.seesaa.net/ |
//+------------------------------------------------------------------+
#property copyright "KUROHUNE"
#property link      "https://kurohune-site.com/"
#property version   "1.1"
#property description "DLLの使用を許可するにチェックを入れてください"
#property description "cキーでHIGHLOWオーストラリア,oキーでtheOptionのページに飛びます"
#property strict
#property indicator_chart_window

#import "shell32.dll"
   int ShellExecuteW(int hWnd, string lpVerb, string lpFile, string lpParameters, string lpDirectory, int nCmdShow);
#import

#define SW_SHOWNORMAL   1
#define KEY_C           67
#define KEY_O           79


int xCursor, yCursor;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){
   
   ChartSetInteger(0, CHART_EVENT_MOUSE_MOVE, 0, true);
   
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
                  const string &sparam){

   if(id == CHARTEVENT_KEYDOWN){

      if(lparam == KEY_C){
         string URL;
         URL = "https://jp.trade.highlow.net/";
         ShellExecuteW(0, "open", URL, NULL, NULL, SW_SHOWNORMAL);
            
      }
      if(lparam == KEY_O){
         string URL;
         URL = "http://jp.theoption.com/trading";
         ShellExecuteW(0, "open", URL, NULL, NULL, SW_SHOWNORMAL);
            
      }
      
   }
}
//+------------------------------------------------------------------+


