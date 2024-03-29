//+------------------------------------------------------------------+
//|                                                   LINEBYTIME.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                              https://www.mql5.co |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.co"
#property version   "1.00"
#property strict
#property indicator_chart_window
#define OBJNAME_PREFIX "OBJ I20191020 "
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
input bool window = false;//窓タイム判定
input bool toudai = false;//東大生のやつ
input bool monday = false;
input bool NYbox = false;
input bool nova = false;
input bool test = true;//各市場の午前中（最も活発になる）

int OnInit()
  {
//--- indicator buffers mapping
   Print(IsDST(Time[0],False));
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
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
   for (int index = Bars - IndicatorCounted() - 1; 0 <= index; index--)
   {
      if(Volume[0] == 1&&index == 0)Print((string)Time[0] + "pipsは" +(string)PointToPips(MarketInfo(Symbol(),MODE_SPREAD)));
      if(test)
      {
            if(TimeHour(Time[index]) == 19 )
            {
               if(TimeMinute(Time[index]) == 0)CreateVLine(OBJNAME_PREFIX + TimeToStr(Time[index]) + "VLine",Time[index] ,clrPink ,1 ,STYLE_SOLID ,false ,true);
            }
            if(TimeHour(Time[index]) == 23)
            {
               if(TimeMinute(Time[index]) == 0)CreateVLine(OBJNAME_PREFIX +TimeToStr(Time[index]) + "VLine",Time[index] ,clrPink ,1 ,STYLE_SOLID ,false ,true);
            }
            


  
      }
      if(nova)
      {
            if(TimeHour(Time[index]) == 23 )
            {
               if(TimeMinute(Time[index]) == 0)CreateVLine(OBJNAME_PREFIX + TimeToStr(Time[index]) + "VLine",Time[index] ,clrPink ,1 ,STYLE_SOLID ,false ,true);
            }
            if(TimeHour(Time[index]) == 1)
            {
               if(TimeMinute(Time[index]) == 0)CreateVLine(OBJNAME_PREFIX +TimeToStr(Time[index]) + "VLine",Time[index] ,clrPink ,1 ,STYLE_SOLID ,false ,true);
            }
  
      }
      if(NYbox)
      {
         if(IsDST(Time[index],False))//米国式サマータイムの時
         {
            if(TimeHour(Time[index]) == 7 )
            {
               if(TimeMinute(Time[index]) == 0)CreateVLine(OBJNAME_PREFIX + TimeToStr(Time[index]) + "VLine",Time[index] ,clrPaleGoldenrod ,1 ,STYLE_SOLID ,false ,true);
            }
            if(TimeHour(Time[index]) == 14)
            {
               if(TimeMinute(Time[index]) == 0)CreateVLine(OBJNAME_PREFIX +TimeToStr(Time[index]) + "VLine",Time[index] ,clrPaleGoldenrod ,1 ,STYLE_SOLID ,false ,true);
            }
            
         }
         else//サマータイムじゃないとき
         {
            //if((IsIncludeTime(Time[0],3,0,8,0) || IsIncludeTime(Time[0],11,0,15,0) ) )
            if(TimeHour(Time[index]) == 7 )
            {
               if(TimeMinute(Time[index]) == 0)CreateVLine(OBJNAME_PREFIX +TimeToStr(Time[index]) + "VLine",Time[index] ,clrPaleGoldenrod ,1 ,STYLE_SOLID ,false ,true);
            }
            if(TimeHour(Time[index]) == 14)
            {
               if(TimeMinute(Time[index]) == 0)CreateVLine(OBJNAME_PREFIX +TimeToStr(Time[index]) + "VLine",Time[index] ,clrPaleGoldenrod ,1 ,STYLE_SOLID ,false ,true);
            }
   
         }
      }
      if(window && (TimeDayOfWeek(Time[index]) != 1 || monday == true))
      {
         if(IsDST(Time[index],False))//米国式サマータイムの時
         {
            if(TimeHour(Time[index]) == 23 )
            {
               if(TimeMinute(Time[index]) == 0)CreateVLine(OBJNAME_PREFIX + TimeToStr(Time[index]) + "VLine",Time[index] ,clrBlue ,1 ,STYLE_SOLID ,false ,true);
            }
            if(TimeHour(Time[index]) == 4)
            {
               if(TimeMinute(Time[index]) == 0)CreateVLine(OBJNAME_PREFIX +TimeToStr(Time[index]) + "VLine",Time[index] ,clrRed ,1 ,STYLE_SOLID ,false ,true);
            }
            
         }
         else//サマータイムじゃないとき
         {
            //if((IsIncludeTime(Time[0],3,0,8,0) || IsIncludeTime(Time[0],11,0,15,0) ) )
            if(TimeHour(Time[index]) == 23 )
            {
               if(TimeMinute(Time[index]) == 0)CreateVLine(OBJNAME_PREFIX +TimeToStr(Time[index]) + "VLine",Time[index] ,clrBlue ,1 ,STYLE_SOLID ,false ,true);
            }
            if(TimeHour(Time[index]) == 4)
            {
               if(TimeMinute(Time[index]) == 0)CreateVLine(OBJNAME_PREFIX +TimeToStr(Time[index]) + "VLine",Time[index] ,clrRed ,1 ,STYLE_SOLID ,false ,true);
            }
   
         }
      }
      
      if(toudai&& (TimeDayOfWeek(Time[index]) != 1 ||  monday == true))
      {
         if(IsDST(Time[index],False))//米国式サマータイムの時
         {
            if(TimeHour(Time[index]) == 3 || TimeHour(Time[index]) == 10)
            {
               if(TimeMinute(Time[index]) == 0)CreateVLine(OBJNAME_PREFIX + TimeToStr(Time[index]) + "VLine",Time[index] ,clrRed ,1 ,STYLE_SOLID ,false ,true);
            }
            if(TimeHour(Time[index]) == 8 || TimeHour(Time[index]) == 14 || TimeHour(Time[index]) == 18)
            {
               if(TimeMinute(Time[index]) == 0)CreateVLine(OBJNAME_PREFIX +TimeToStr(Time[index]) + "VLine",Time[index] ,clrYellow ,1 ,STYLE_SOLID ,false ,true);
            }
            if(TimeHour(Time[index]) == 9 || TimeHour(Time[index]) == 15 || TimeHour(Time[index]) == 22)
            {
               if(TimeMinute(Time[index]) == 0)CreateVLine(OBJNAME_PREFIX +TimeToStr(Time[index]) + "VLine",Time[index] ,clrBlue ,1 ,STYLE_SOLID ,false ,true);
            }
            
         }
         
         else//サマータイムじゃないとき
         {
            //if((IsIncludeTime(Time[0],3,0,8,0) || IsIncludeTime(Time[0],11,0,15,0) ) )
            if(TimeHour(Time[index]) == 3 || TimeHour(Time[index]) == 11)
            {
               if(TimeMinute(Time[index]) == 0)CreateVLine(OBJNAME_PREFIX + TimeToStr(Time[index]) + "VLine",Time[index] ,clrRed ,1 ,STYLE_SOLID ,false ,true);
            }
            if(TimeHour(Time[index]) == 8 || TimeHour(Time[index]) == 15 || TimeHour(Time[index]) == 19)
            {
               if(TimeMinute(Time[index]) == 0)CreateVLine(OBJNAME_PREFIX +TimeToStr(Time[index]) + "VLine",Time[index] ,clrYellow ,1 ,STYLE_SOLID ,false ,true);
            }
            if(TimeHour(Time[index]) == 9 || TimeHour(Time[index]) == 16 || TimeHour(Time[index]) == 23)
            {
               if(TimeMinute(Time[index]) == 0)CreateVLine(OBJNAME_PREFIX +TimeToStr(Time[index]) + "VLine",Time[index] ,clrBlue ,1 ,STYLE_SOLID ,false ,true);
            }
   
         }
      }
   }

   // 計算済みの足の本数を返却
   return rates_total - 1;
}
 double PointToPips(double point)
    {
        return NormalizeDouble(point * 0.1, 1);
    }
void CreateVLine(string name, datetime time, color c, int width = 1, ENUM_LINE_STYLE style = STYLE_SOLID, bool back = false, bool chart_window = true)
{
     ObjectCreate(NULL, name, OBJ_VLINE, chart_window ? NULL : WindowOnDropped(), NULL, NULL);
     ObjectSetInteger(NULL, name, OBJPROP_BACK, back);
     ObjectSetInteger(NULL, name, OBJPROP_COLOR, c);
     ObjectSetInteger(NULL, name, OBJPROP_HIDDEN, true);
     ObjectSetInteger(NULL, name, OBJPROP_SELECTABLE, false);
     ObjectSetInteger(NULL, name, OBJPROP_STYLE, style);
     ObjectSetInteger(NULL, name, OBJPROP_TIME, 0, time);
     ObjectSetInteger(NULL, name, OBJPROP_WIDTH, width);

}

bool IsIncludeTime(datetime target, uint begin_hour, uint begin_minute, uint end_hour, uint end_minute)//時間内ならTrue
 {
     // 現在の時刻
     uint hour = TimeHour(target);
     uint minute = TimeMinute(target);
     
     string message = "time filter is ng (time=" + TimeToString(TimeCurrent(), TIME_MINUTES) + ")";
 
     // 開始時 < 終了時 の場合
     if (begin_hour < end_hour)
     {
         if (hour < begin_hour) return false;
         if (hour == begin_hour && minute < begin_minute) return false;
         if (hour == end_hour && end_minute <= minute) return false;
         if (end_hour < hour) return false;
     }
 
     // 終了時 < 開始時 の場合
     if (end_hour < begin_hour)
     {
         if (end_hour < hour && hour < begin_hour) return false;
         if (hour == begin_hour && minute < begin_minute) return false;
         if (hour == end_hour && end_minute <= minute) return false;
     }
 
     // 開始時 == 終了時 の場合
     if (begin_hour == end_hour)
     {
         // 開始分 < 終了分 の場合
         if (begin_minute < end_minute)
         {
             if (hour < begin_hour) return false;
             if (hour == begin_hour && minute < begin_minute) return false;
             if (hour == end_hour && end_minute <= minute) return false;
             if (end_hour < hour) return false;
         }
 
         // 終了分 < 開始分 の場合
         if (end_minute < begin_minute)
         {
             if (hour == begin_hour && hour == end_hour && end_minute <= minute && minute < begin_minute) return false;
         }
 
         // 開始分 == 終了分 の場合
         if (begin_minute == end_minute)
         {
             if (hour != begin_hour) return false;
             if (hour != end_hour) return false;
             if (minute != begin_minute) return false;
             if (minute != end_minute) return false;
         }
     }

     // 終了
     return true;
 }
bool IsDST(datetime CurrentTime, bool IsUK){
   datetime StartDate;
   datetime EndDate;
   bool DST;

   string CurrentYear = (string)(TimeYear(CurrentTime));

   if(!IsUK && (int)CurrentYear >= 2007){
      StartDate = (datetime)(CurrentYear + ".3." + (string)(14 - TimeDayOfWeek((datetime)(CurrentYear + ".3.14"))));
      EndDate = (datetime)(CurrentYear + ".11." + (string)(7 - TimeDayOfWeek((datetime)(CurrentYear + ".11.7"))));
   }else{
      if(IsUK){
         StartDate = (datetime)(CurrentYear + ".3." + (string)(31 - TimeDayOfWeek((datetime)(CurrentYear + ".3.31"))));
      }else{
         StartDate = (datetime)(CurrentYear + ".4." + (string)(7 - TimeDayOfWeek((datetime)(CurrentYear + ".4.7"))));
      }

      EndDate = (datetime)(CurrentYear + ".10." + (string)(31 - TimeDayOfWeek((datetime)(CurrentYear + ".10.31"))));
   }


   if(CurrentTime >= StartDate && CurrentTime < EndDate) DST = true;
   else DST = false;

   return(DST);
}
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
