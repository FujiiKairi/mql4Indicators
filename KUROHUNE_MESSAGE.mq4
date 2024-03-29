

//+------------------------------------------------------------------+
//|                                                         asdf.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                              https://www.mql5.co |
//+------------------------------------------------------------------+
#define MQL4
#define PROPERTY_LINK ""
#define PROPERTY_COPYRIGHT ""
#define PROPERTY_DESCRIPTION ""
#define OBJNAME_PREFIX "OBJ I20190919 "
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
#property indicator_buffers 6//(表示用＋計算用のバッファの数)

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

input   string              separateAlert = "";                         //▼ 足が確定してから出た矢印の通知を出す
input   bool                Kakutei = True;                             // ┗ ON/OFF

input   string              SeparateAlert = "";                         // ▼ アラート設定
input   bool                UseAlert = True;                            // ┗ ON/OFF

input   string              SeparateSendMail = "";                      // ▼ メール設定
input   bool                UseSendMail = True;                         // ┗ ON/OFF

input   string              SeparateSendPush = "";                      // ▼ プッシュ通知設定
input   bool                UseSendPush = True;                         // ┗ ON/OFF

//--- Global Files

double  Arrow[];


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
        Comment("");
        Comment("KUROHUNE_MESSAGE \nTwitterID   :  KUROHUNEtrader \nLINE@       :  @yfy3673g");
        
        
      
        //計算用のバッファ
        IndicatorBuffers(0);//計算用のインジケーターの数
        SetIndexBuffer(0, Arrow);
        SetIndexLabel(0, NULL);
        SetIndexStyle(0, DRAW_NONE);
        SetIndexEmptyValue(0,0);
        

        
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
//--     
        
        
        static datetime PreviousAlertAndMailTime = NULL;
        
        
        if (PreviousAlertAndMailTime != Time[SHIFT_CURRENT])
        {
            if(Kakutei == false)
            {
               if (isBuyArrow(SHIFT_CURRENT) == true)
               {
                   string message = Symbol() + "," + TimeframeToString(Period()) + ": buy sign";
                   if (UseAlert) Alert(message);
                   if (UseSendMail) SendMail(message, message);
                   if (UseSendPush) SendNotification(message);
                   PreviousAlertAndMailTime = Time[SHIFT_CURRENT];
               }
               
               if (isSellArrow(SHIFT_CURRENT) == true)
               {
                   string message = Symbol() + "," + TimeframeToString(Period()) + ": sell sign";
                   if (UseAlert) Alert(message);
                   if (UseSendMail) SendMail(message, message);
                   if (UseSendPush) SendNotification(message);
                   PreviousAlertAndMailTime = Time[SHIFT_CURRENT];
               }
            }
            if(Kakutei == true)
            {
               if (isBuyArrow(SHIFT_PREVIOUS1) == true)
               {
                   string message = Symbol() + "," + TimeframeToString(Period()) + ": buy sign";
                   if (UseAlert) Alert(message);
                   if (UseSendMail) SendMail(message, message);
                   if (UseSendPush) SendNotification(message);
                   PreviousAlertAndMailTime = Time[SHIFT_CURRENT];
               }
               
               if (isSellArrow(SHIFT_PREVIOUS1) == true)
               {
                   string message = Symbol() + "," + TimeframeToString(Period()) + ": sell sign";
                   if (UseAlert) Alert(message);
                   if (UseSendMail) SendMail(message, message);
                   if (UseSendPush) SendNotification(message);
                   PreviousAlertAndMailTime = Time[SHIFT_CURRENT];
               }
            }
        }
        // 計算済みの足の本数を返却
       
        return rates_total - 1;
//--- return value of prev_calculated for next call
   
  }
//+------------------------------------------------------------------+
bool isBuyArrow (int index)
{
     int obj_total =  ObjectsTotal(ChartID(), 0, OBJ_ARROW);  
     double arrowCode;
     int barIndex;
     datetime indexTime ;
     for(int count = 0 ; count < obj_total; count++ )
     {
         indexTime = (datetime)ObjectGet(ObjectName(count),OBJPROP_TIME1);
         barIndex = iBarShift(Symbol(),Period(),indexTime , false );
         if(barIndex == index)
         {
             arrowCode = ObjectGet(ObjectName(count),OBJPROP_ARROWCODE);
             if(arrowCode == 67 || arrowCode == 71 ||arrowCode == 200 ||arrowCode == 217 ||arrowCode == 221 ||
             arrowCode == 225 ||arrowCode == 228 ||arrowCode == 233 ||arrowCode == 236 ||arrowCode == 241 ||arrowCode == 246)
             {
                  return true;
             }
             break;
         }
     }
     return false;
}
bool isSellArrow (int index)
{
   int obj_total =  ObjectsTotal(ChartID(), 0, OBJ_ARROW);  
     double arrowCode;
     int barIndex;
     datetime indexTime ;
     for(int count = 0 ; count < obj_total; count++ )
     {
         indexTime = (datetime)ObjectGet(ObjectName(count),OBJPROP_TIME1);
         barIndex = iBarShift(Symbol(),Period(),indexTime , false );
         if(barIndex == index)
         {
             arrowCode = ObjectGet(ObjectName(count),OBJPROP_ARROWCODE);
             if(arrowCode == 68 || arrowCode == 72 ||arrowCode == 202 ||arrowCode == 218 ||arrowCode == 222 ||
             arrowCode == 226 ||arrowCode == 230 ||arrowCode == 234 ||arrowCode == 238 ||arrowCode == 242 ||arrowCode == 248)
             {
                 return true;
             }
             break;
         }
     }
     return false;
}
void merge_sort (datetime &arrayTime[],string &arrayObjName[],int obj_total, int left, int right) {
  int i, j, k, mid;
  datetime workTime[];  // 作業用配列
  string workName[];  // 作業用配列
  ArrayResize(workTime,obj_total);
  ArrayResize(workName,obj_total);
  if (left < right) {
    mid = (left + right)/2; // 真ん中
    merge_sort(arrayTime,arrayObjName,obj_total,left, mid);  // 左を整列
    merge_sort(arrayTime,arrayObjName,obj_total ,mid+1, right);  // 右を整列
    for (i = mid; i >= left; i--) 
         {
          workTime[i] = arrayTime[i]; 
          workName[i] = arrayObjName[i];
         } // 左半分
    for (j = mid+1; j <= right; j++) {
      workTime[right-(j-(mid+1))] = arrayTime[j]; // 右半分を逆順
      workName[right-(j-(mid+1))] = arrayObjName[j]; // 右半分を逆順
    }
    i = left; j = right;
    for (k = left; k <= right; k++) {
      if (workTime[i] < workTime[j]) 
      {
          arrayTime[k] = workTime[i]; 
          arrayObjName[k] = workName[i];
          i++;
      }
      else                   
      { 
         arrayTime[k] = workTime[j]; 
         arrayObjName[k] = workName[j];
         j--;
      }
    }
  }
}
    
  
     
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
    
    
   
