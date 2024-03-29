
//+----------------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                         asdf.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                              https://www.mql5.co |
//+------------------------------------------------------------------+
#define MQL4
#define PROPERTY_LINK ""
#define PROPERTY_COPYRIGHT ""
#define PROPERTY_DESCRIPTION ""
#define OBJNAME_PREFIX "OBJ I20190524 "
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
#property indicator_buffers 4//(表示用＋計算用のバッファの数)



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
input   string              SeparateName = "";                          // ▼ 名前設定（必須）
input   string              IndiName = "";                              // ┗ インジケーターの名前

input   string              SeparateMode = "";                          // ▼ サイン設定（必須）    
input   int                 ModeBuy = 0;                                // ┣ 買いサインの順番
input   int                 ModeSell = 1;                               // ┗ 売りサインの順番


int     ObjectNum = 0;
bool 　　　Done = false;
int     ThereisError = 0;


string fname = "HighLow.txt";  // ファイル名
int    fh;  
string autoStatus ="開始する";
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
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
{
   if(id==CHARTEVENT_OBJECT_CLICK)
   {
      if(sparam == "OBJ I20190524 startAutoButton")
      {
         changeAutoStatus();
         ObjectSetInteger(0,sparam,OBJPROP_STATE,0);
      }
   }
   
}

void changeAutoStatus()
{
   if(autoStatus == "開始する")
   {
      autoStatus = "終了する";
      ObjectSetInteger(NULL, "OBJ I20190524 startAutoButton", OBJPROP_BGCOLOR, clrRed);
      ObjectSetString(NULL, "OBJ I20190524 startAutoButton", OBJPROP_TEXT, autoStatus);
   }
   else if(autoStatus == "終了する")
   {
      autoStatus = "開始する";
      ObjectSetInteger(NULL, "OBJ I20190524 startAutoButton", OBJPROP_BGCOLOR, clrBrown);
      ObjectSetString(NULL, "OBJ I20190524 startAutoButton", OBJPROP_TEXT, autoStatus);
   }
   
}

int OnInit()
  {
//--- indicator buffers mapping
   
     Comment("");
     Comment("KUROHUNE AUTO BINARY \nTwitterID   :  KUROHUNEtrader \nLINE@       :  @yfy3673g");

     
     //↓表示用のバッファ
     iCustom(NULL, 0, IndiName, ModeBuy, 0);

     //計算用のバッファ
     
     
     fh = FileOpen( fname ,  FILE_WRITE  );
     FileWrite(fh,"reload");
     FileClose(fh);
     CreateButton("OBJ I20190524 startAutoButton",autoStatus,CORNER_RIGHT_UPPER, 150, 30, 120, 30,clrNONE, clrBrown,"Tahoma","0");
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

        
        // 未計算の足を全て処理
        for (int index = 2; SHIFT_CURRENT <= index; index--)
        {
        
            string objname_buy = OBJNAME_BUY + TimeToString(Time[index]);
            string objname_sell = OBJNAME_SELL + TimeToString(Time[index]);
            
            
            ObjectDelete(ChartID(), objname_buy);//同じチャート上にすでに同じ名前のオブジェクトがあれば削除するということ
            ObjectDelete(ChartID(), objname_sell);
            
            
            if (CheckBuy(index))
            {      
                if(TimeToString(Time[index-1]) == TimeToString(TimeCurrent())&&(autoStatus == "終了する"))
                {
                   fh = FileOpen( fname ,  FILE_WRITE  );
                   FileWrite(fh,"BUY",TimeToString(Time[index]));
                   FileClose(fh);
                }
            }
             
            if (CheckSell(index))
            {      
                if(TimeToString(Time[index-1]) == TimeToString(TimeCurrent())&&(autoStatus == "終了する"))
                {
                   fh = FileOpen( fname ,  FILE_WRITE  );
                   FileWrite(fh,"SELL",TimeToString(Time[index]));
                   FileClose(fh);
                }
            }
   
        }
        

       
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
    void CreateButton(string name, string text, ENUM_BASE_CORNER corner, int x, int y, int width, int height, color fg_color = clrNONE, color bg_color = clrNONE, string font = "Arial", string window_name = "")
    {
        fg_color = fg_color == clrNONE ? (color) ChartGetInteger(NULL, CHART_COLOR_FOREGROUND) : fg_color;
        bg_color = bg_color == clrNONE ? (color) ChartGetInteger(NULL, CHART_COLOR_BACKGROUND) : bg_color;
        ObjectCreate(NULL, name, OBJ_BUTTON, window_name == "" ? NULL : (window_name == "0" ? NULL : WindowFind(window_name)), NULL, NULL);
        ObjectSetInteger(NULL, name, OBJPROP_BGCOLOR, bg_color);
        ObjectSetInteger(NULL, name, OBJPROP_COLOR, fg_color);
        ObjectSetInteger(NULL, name, OBJPROP_CORNER, corner);
        ObjectSetInteger(NULL, name, OBJPROP_HIDDEN, true);
        ObjectSetInteger(NULL, name, OBJPROP_XDISTANCE, x);
        ObjectSetInteger(NULL, name, OBJPROP_XSIZE, width);
        ObjectSetInteger(NULL, name, OBJPROP_YDISTANCE, y);
        ObjectSetInteger(NULL, name, OBJPROP_YSIZE, height);
        ObjectSetInteger(NULL, name, OBJPROP_FONTSIZE, 12);
        ObjectSetString(NULL, name, OBJPROP_TEXT, text);
        ObjectSetString(NULL, name, OBJPROP_FONT, font);
        
        //if (corner == CORNER_LEFT_UPPER) ObjectSetInteger(NULL, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
        //if (corner == CORNER_LEFT_LOWER) ObjectSetInteger(NULL, name, OBJPROP_ANCHOR, ANCHOR_LEFT_LOWER);
        //if (corner == CORNER_RIGHT_UPPER) ObjectSetInteger(NULL, name, OBJPROP_ANCHOR, ANCHOR_RIGHT_UPPER);
        //if (corner == CORNER_RIGHT_LOWER) ObjectSetInteger(NULL, name, OBJPROP_ANCHOR, ANCHOR_RIGHT_LOWER);
        ObjectSetInteger(NULL, name, OBJPROP_ANCHOR, ANCHOR_LEFT_UPPER);
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
        if(shift == 0)return false; 
         double cstm ;
         cstm = iCustom(NULL, 0, IndiName, ModeBuy, shift);
         if(cstm == EMPTY_VALUE || cstm == 0)return false;
         return true;
   }
    
   int CheckSell(int shift)
   {
        if(shift == 0)return false; 
         double cstm ;
         cstm = iCustom(NULL, 0, IndiName, ModeSell, shift);
         if(cstm == EMPTY_VALUE || cstm == 0)return false;
         return true;
   }
   




