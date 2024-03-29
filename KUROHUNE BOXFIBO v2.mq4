


//+------------------------------------------------------------------+
//|                                               BreakOut-EAGLE.mq4 |
//|                                      Color Modified by ut2DaMax  |
//|                                                       2007.10.14 |
//|   ++ modified for those that use Black Backgrounds 4 Charts      |
//|   ++ and I think you will find these colors easier on the eyes   |
//|   ++ this indicator will help you indentify the breakouts        |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                               BreakOut-EAGLE.mq4 |
//|                                                        hapalkos  |
//|                                                       2007.02.11 |
//|   ++ modified so that rectangles do not overlay                  |
//|   ++ this makes color selection more versatile                   |
//|   ++ code consolidated                                           |
//+------------------------------------------------------------------+
#property copyright "hapalkos"
#property link      ""

#property indicator_chart_window
input   string              SeparateFiboLine = "";                      // ▼フィボナッチライン設定 
input color                 FibColor = clrYellow;                       // ┗ 色

extern int    NumberOfDays = 50;        
extern string periodBegin    = "05:00"; 
extern string periodEnd      = "08:00";   
extern string BoxEnd         = "23:00"; 
extern int    BoxBreakOut_Offset = 1; 
extern color  BoxHLColor       = C'44,50,48';
extern color  BoxBreakOutColor = C'97,82,43';
extern color  BoxPeriodColor   = White;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void init() {
  DeleteObjects();
  datetime dtTimeBegin;
  datetime dtTimeEnd;
  int startBars;
  int finishBars;
  dtTimeBegin = StrToTime(TimeToStr(TimeCurrent(), TIME_DATE) + " " + periodBegin);
  dtTimeEnd = StrToTime(TimeToStr(TimeCurrent(), TIME_DATE) + " " + periodEnd);
  if(dtTimeEnd < Time[0])
  {
      startBars = iBarShift(Symbol(),Period(),dtTimeBegin , false );
      finishBars = iBarShift(Symbol(),Period(),dtTimeEnd , false );
      FiboLine(finishBars , startBars - finishBars);
  }
  else
  {
      startBars = iBarShift(Symbol(),Period(),dtTimeBegin - 86400 , false );
      finishBars = iBarShift(Symbol(),Period(),dtTimeEnd - 86400 , false );
      FiboLine(finishBars , startBars - finishBars);
  }
  
}

//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
void deinit() {
  DeleteObjects();
return ;
}

//+------------------------------------------------------------------+
//| Remove all Rectangles                                            |
//+------------------------------------------------------------------+
void DeleteObjects() {
    ObjectsDeleteAll(0,OBJ_RECTANGLE);  
    ObjectDelete("KUROHUNEFibo1");  
    ObjectDelete("KUROHUNEFibo2"); 
 return ; 
}

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
void start() {
  datetime dtTradeDate=TimeCurrent();
  datetime dtTimeBegin;
  datetime dtTimeEnd;
  int startBars;
  int finishBars;
  dtTimeBegin = StrToTime(TimeToStr(dtTradeDate, TIME_DATE) + " " + periodBegin);
  dtTimeEnd = StrToTime(TimeToStr(dtTradeDate, TIME_DATE) + " " + periodEnd);
  if(dtTimeEnd < Time[0])
  {
      DeleteObjects();
      startBars = iBarShift(Symbol(),Period(),dtTimeBegin , false );
      finishBars = iBarShift(Symbol(),Period(),dtTimeEnd , false );
      FiboLine(finishBars , startBars - finishBars);
  }
  for (int i=0; i<NumberOfDays; i++) {
  
    DrawObjects(dtTradeDate, "BoxHL  " + TimeToStr(dtTradeDate,TIME_DATE), periodBegin, periodEnd, BoxEnd, BoxHLColor, 0, 1);
    DrawObjects(dtTradeDate, "BoxBreakOut_High  " + TimeToStr(dtTradeDate,TIME_DATE), periodBegin, periodEnd, BoxEnd, BoxBreakOutColor, BoxBreakOut_Offset,2);
    DrawObjects(dtTradeDate, "BoxBreakOut_Low  " + TimeToStr(dtTradeDate,TIME_DATE), periodBegin, periodEnd, BoxEnd, BoxBreakOutColor, BoxBreakOut_Offset,3);
    DrawObjects(dtTradeDate, "BoxPeriod  " + TimeToStr(dtTradeDate,TIME_DATE), periodBegin, periodEnd, periodEnd, BoxPeriodColor, BoxBreakOut_Offset,4);

    dtTradeDate=decrementTradeDate(dtTradeDate);
    while (TimeDayOfWeek(dtTradeDate) > 5) dtTradeDate = decrementTradeDate(dtTradeDate);
  }
}

//+------------------------------------------------------------------+
//| Create Rectangles                                                |
//+------------------------------------------------------------------+

void DrawObjects(datetime dtTradeDate, string sObjName, string sTimeBegin, string sTimeEnd, string sTimeObjEnd, color cObjColor, int iOffSet, int iForm) {
  datetime dtTimeBegin, dtTimeEnd, dtTimeObjEnd;
  double   dPriceHigh,  dPriceLow;
  int      iBarBegin,   iBarEnd;

  dtTimeBegin = StrToTime(TimeToStr(dtTradeDate, TIME_DATE) + " " + sTimeBegin);
  dtTimeEnd = StrToTime(TimeToStr(dtTradeDate, TIME_DATE) + " " + sTimeEnd);
  dtTimeObjEnd = StrToTime(TimeToStr(dtTradeDate, TIME_DATE) + " " + sTimeObjEnd);
      
  iBarBegin = iBarShift(NULL, 0, dtTimeBegin);
  iBarEnd = iBarShift(NULL, 0, dtTimeEnd);
  dPriceHigh = High[Highest(NULL, 0, MODE_HIGH, iBarBegin-iBarEnd, iBarEnd)];
  dPriceLow = Low [Lowest (NULL, 0, MODE_LOW , iBarBegin-iBarEnd, iBarEnd)];
 
  ObjectCreate(sObjName, OBJ_RECTANGLE, 0, 0, 0, 0, 0);
  
  ObjectSet(sObjName, OBJPROP_TIME1 , dtTimeBegin);
  ObjectSet(sObjName, OBJPROP_TIME2 , dtTimeObjEnd);
  
//---- High-Low Rectangle
   if(iForm==1){  
      ObjectSet(sObjName, OBJPROP_PRICE1, dPriceHigh);  
      ObjectSet(sObjName, OBJPROP_PRICE2, dPriceLow);
      ObjectSet(sObjName, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(sObjName, OBJPROP_COLOR, cObjColor);
      ObjectSet(sObjName, OBJPROP_BACK, True);
   }
   
//---- Upper Rectangle
  if(iForm==2){
      ObjectSet(sObjName, OBJPROP_PRICE1, dPriceHigh);
      ObjectSet(sObjName, OBJPROP_PRICE2, dPriceHigh + iOffSet*Point);
      ObjectSet(sObjName, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(sObjName, OBJPROP_COLOR, cObjColor);
      ObjectSet(sObjName, OBJPROP_BACK, True);
   }
 
 //---- Lower Rectangle 
  if(iForm==3){
      ObjectSet(sObjName, OBJPROP_PRICE1, dPriceLow - iOffSet*Point);
      ObjectSet(sObjName, OBJPROP_PRICE2, dPriceLow);
      ObjectSet(sObjName, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(sObjName, OBJPROP_COLOR, cObjColor);
      ObjectSet(sObjName, OBJPROP_BACK, True);
   }

//---- Period Rectangle
  if(iForm==4){
      ObjectSet(sObjName, OBJPROP_PRICE1, dPriceHigh + iOffSet*Point);
      ObjectSet(sObjName, OBJPROP_PRICE2, dPriceLow - iOffSet*Point);
      ObjectSet(sObjName, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(sObjName, OBJPROP_COLOR, cObjColor);
      ObjectSet(sObjName, OBJPROP_WIDTH, 2);
      ObjectSet(sObjName, OBJPROP_BACK, False);
   }   
      string sObjDesc = StringConcatenate("High: ",dPriceHigh,"  Low: ", dPriceLow, " OffSet: ",iOffSet);  
      ObjectSetText(sObjName, sObjDesc,10,"Times New Roman",Black);
}

//+------------------------------------------------------------------+
//| Decrement Date to draw objects in the past                       |
//+------------------------------------------------------------------+
void FiboLine(int lastbar,int lookback)
 {
   ObjectDelete("Fibo1");
   ObjectDelete("Fibo2");
   if(lookback+lastbar < 5)
   {
      Print("足5本よりも大きい範囲をとってください");
      return;
   }
     
   
//----
   double lowest=1000, highest=0;
   datetime T1 = iTime(Symbol(),Period(),0);
   datetime T2 = iTime(Symbol(),Period(),0);
   for(int i=lookback+lastbar;i > lastbar+1 ; i--)
   {  
      double curLow0=iLow(Symbol(),Period(),i+2);
      double curLow1=iLow(Symbol(),Period(),i+1);
      double curLow2=iLow(Symbol(),Period(),i);
      double curLow3=iLow(Symbol(),Period(),i-1);
      double curLow4=iLow(Symbol(),Period(),i-2);
      
       double curHigh0=iHigh(Symbol(),Period(),i+2);
       double curHigh1=iHigh(Symbol(),Period(),i+1);
        double curHigh2=iHigh(Symbol(),Period(),i);
         double curHigh3=iHigh(Symbol(),Period(),i-1);
         double curHigh4=iHigh(Symbol(),Period(),i-2);
         
      if(curLow2<=curLow4 &&curLow2<=curLow3 && curLow2<=curLow1 && curLow2<=curLow0 )
      {
      if(lowest>curLow2){
         lowest=curLow2;
         T2=iTime(Symbol(),Period(),i);
      }
      }
      
      if(curHigh2>=curHigh0 && curHigh2>=curHigh1 && curHigh2>=curHigh3&& curHigh2>=curHigh4)
      {  
         if(highest<curHigh2){
         highest=curHigh2;
         T1=iTime(Symbol(),Period(),i);}
      }
   
   
   }   
   
 
   
   //Comment(highest, lowest);

   ObjectCreate("KUROHUNEFibo1", OBJ_FIBO, 0, T1, highest,T2,lowest);
   ObjectCreate("KUROHUNEFibo2", OBJ_FIBO, 0, T2, lowest, T1,highest);
   
//----
 
string fiboobjname = "KUROHUNEFibo1";
ObjectSet(fiboobjname, OBJPROP_FIBOLEVELS, 11);
      ObjectSet(fiboobjname, OBJPROP_FIRSTLEVEL, 0.0);
      ObjectSetFiboDescription(fiboobjname,0,"0    %$");
      ObjectSet(fiboobjname, OBJPROP_FIRSTLEVEL+1, 0.236);
      ObjectSetFiboDescription(fiboobjname,1,"23.6     %$");
      ObjectSet(fiboobjname, OBJPROP_FIRSTLEVEL+2, 0.382);
      ObjectSetFiboDescription(fiboobjname,2,"38.2     %$");
      ObjectSet(fiboobjname, OBJPROP_FIRSTLEVEL+3, 0.50);
      ObjectSetFiboDescription(fiboobjname,3,"50.0     %$");
      ObjectSet(fiboobjname, OBJPROP_FIRSTLEVEL+4, 0.618);
      ObjectSetFiboDescription(fiboobjname,4,"61.8     %$");
      ObjectSet(fiboobjname, OBJPROP_FIRSTLEVEL+5, 0.764);
      ObjectSetFiboDescription(fiboobjname,5,"76.4     %$");  
      ObjectSet(fiboobjname, OBJPROP_FIRSTLEVEL+6, 1.000);
      ObjectSetFiboDescription(fiboobjname,6,"100    %$");   
      ObjectSet(fiboobjname, OBJPROP_FIRSTLEVEL+7, 1.382);
      ObjectSetFiboDescription(fiboobjname,7,"138.2     %$");
      ObjectSet(fiboobjname, OBJPROP_FIRSTLEVEL+8, 1.618);
      ObjectSetFiboDescription(fiboobjname,8,"161.8     %$");
      ObjectSet(fiboobjname, OBJPROP_FIRSTLEVEL+9, 2.618);
      ObjectSetFiboDescription(fiboobjname,9,"261.8     %$");
      ObjectSet(fiboobjname, OBJPROP_FIRSTLEVEL+10, 4.236);
      ObjectSetFiboDescription(fiboobjname,10,"423.6     %$");
   ObjectSet( "Fibo1", OBJPROP_LEVELCOLOR, FibColor) ;
   
      fiboobjname = "KUROHUNEFibo2";
ObjectSet(fiboobjname, OBJPROP_FIBOLEVELS, 11);
      ObjectSet(fiboobjname, OBJPROP_FIRSTLEVEL, 0.0);
      ObjectSetFiboDescription(fiboobjname,0,"0    %$");
      ObjectSet(fiboobjname, OBJPROP_FIRSTLEVEL+1, 0.236);
      ObjectSetFiboDescription(fiboobjname,1,"23.6     %$");
      ObjectSet(fiboobjname, OBJPROP_FIRSTLEVEL+2, 0.382);
      ObjectSetFiboDescription(fiboobjname,2,"38.2     %$");
      ObjectSet(fiboobjname, OBJPROP_FIRSTLEVEL+3, 0.50);
      ObjectSetFiboDescription(fiboobjname,3,"50.0     %$");
      ObjectSet(fiboobjname, OBJPROP_FIRSTLEVEL+4, 0.618);
      ObjectSetFiboDescription(fiboobjname,4,"61.8     %$");
      ObjectSet(fiboobjname, OBJPROP_FIRSTLEVEL+5, 0.764);
      ObjectSetFiboDescription(fiboobjname,5,"76.4     %$");  
      ObjectSet(fiboobjname, OBJPROP_FIRSTLEVEL+6, 1.000);
      ObjectSetFiboDescription(fiboobjname,6,"100    %$");   
      ObjectSet(fiboobjname, OBJPROP_FIRSTLEVEL+7, 1.382);
      ObjectSetFiboDescription(fiboobjname,7,"138.2     %$");
      ObjectSet(fiboobjname, OBJPROP_FIRSTLEVEL+8, 1.618);
      ObjectSetFiboDescription(fiboobjname,8,"161.8     %$");
      ObjectSet(fiboobjname, OBJPROP_FIRSTLEVEL+9, 2.618);
      ObjectSetFiboDescription(fiboobjname,9,"261.8     %$");
      ObjectSet(fiboobjname, OBJPROP_FIRSTLEVEL+10, 4.236);
      ObjectSetFiboDescription(fiboobjname,10,"423.6     %$");
   ObjectSet( "Fibo2", OBJPROP_LEVELCOLOR, FibColor) ;
   ObjectsRedraw();
    }
datetime decrementTradeDate (datetime dtTimeDate) {
   int iTimeYear=TimeYear(dtTimeDate);
   int iTimeMonth=TimeMonth(dtTimeDate);
   int iTimeDay=TimeDay(dtTimeDate);
   int iTimeHour=TimeHour(dtTimeDate);
   int iTimeMinute=TimeMinute(dtTimeDate);

   iTimeDay--;
   if (iTimeDay==0) {
     iTimeMonth--;
     if (iTimeMonth==0) {
       iTimeYear--;
       iTimeMonth=12;
     }
    
     // Thirty days hath September...  
     if (iTimeMonth==4 || iTimeMonth==6 || iTimeMonth==9 || iTimeMonth==11) iTimeDay=30;
     // ...all the rest have thirty-one...
     if (iTimeMonth==1 || iTimeMonth==3 || iTimeMonth==5 || iTimeMonth==7 || iTimeMonth==8 || iTimeMonth==10 || iTimeMonth==12) iTimeDay=31;
     // ...except...
     if (iTimeMonth==2) if (MathMod(iTimeYear, 4)==0) iTimeDay=29; else iTimeDay=28;
   }
  return(StrToTime(iTimeYear + "." + iTimeMonth + "." + iTimeDay + " " + iTimeHour + ":" + iTimeMinute));
}

//+------------------------------------------------------------------+
