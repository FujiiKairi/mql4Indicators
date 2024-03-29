
//+------------------------------------------------------------------+
//|                                                         asdf.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                              https://www.mql5.co |
//+------------------------------------------------------------------+
#define MQL4
#define PROPERTY_LINK ""
#define PROPERTY_COPYRIGHT ""
#define PROPERTY_DESCRIPTION ""
#define OBJNAME_PREFIX "OBJ I20191019 "
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
//GogoJungle top////////////////////////////////////////////////////|
string pid = "【商品IDを入力してください】";
string AccountCert;
#import "wininet.dll"
#define INTERNET_OPEN_TYPE_DIRECT 0
#define AGENT "MetaTrader 4 Terminal fx-on Auth 2018"
#define READURL_BUFFER_SIZE 1000
int InternetOpenW(string sAgent, int lAccessType, string sProxyName="", string sProxyBypass="", int lFlags=0);
int InternetOpenUrlW(int hInternetSession, string sUrl, string sHeaders="", int lHeadersLength=0, int lFlags=0, int lContext=0);
int InternetReadFile(int, uchar & arr[], int, int & arr[]);
int InternetCloseHandle(int hInet);
#import

string GrabWeb(){
  int ErrCd = 0;
  string mes = "";

  if(!IsDllsAllowed()) { ErrCd=1; mes="Authentication failure - Please allow use of DLL : by GogoJungle"; }
  else if(StringFind(WindowExpertName(), "_", 0)==-1){ ErrCd=11; mes="Invalid file name. Please download again from our site : by GogoJungle"; }
  if(ErrCd>0) return(mes);

  if(IsTesting()) { mes="Authentication success - Testion mode : by GogoJungle"; return(mes); }

  int lReturn[1];
  uchar arrReceive[];
  string sid = GetSid();
  string strUrl = StringConcatenate("https://auth.fx-on.com/indicator/index.php?pid=",pid, "&sid=",sid,"&ac=",AccountCompany(),"&an=",IntegerToString(AccountNumber()));
  int hSession = InternetOpenW(AGENT, INTERNET_OPEN_TYPE_DIRECT, "0", "0", 0);
  int hInternet = InternetOpenUrlW(hSession, strUrl, NULL, 0, 0, 0);
  ArrayResize(arrReceive, READURL_BUFFER_SIZE + 1);
  int success = InternetReadFile(hInternet, arrReceive, READURL_BUFFER_SIZE, lReturn);
  string errmes = "Authentication failure - Error connecting to server : by GogoJungle";
  if( success==0 ){
    InternetCloseHandle(hSession);
    return(errmes);
  }
  string strThisRead = CharArrayToString(arrReceive, 0, ArraySize(arrReceive), CP_UTF8);
  InternetCloseHandle(hSession);
  if(StringFind(strThisRead, "Authentication") == -1) return(errmes);
  else return(strThisRead);
}
void Disp(string s){Print(s);Comment(s);}

string GetSid(){
  string filename=WindowExpertName();
  int strpos = 0;
  int cutlen = 0;
  for(int a=0; a<10 ; a++){     strpos = StringFind(filename, "_", 0)+1;
    if(strpos<=0) break;
    cutlen = StringLen(filename)-strpos;
    filename = StringSubstr(filename, strpos, cutlen);
  }
  return(filename);
}
int IndicatorCountedFXON(){
  if(AuthInitiarize == false){
    AuthInitiarize = true;
    return(0);
  }
  return IndicatorCounted();
}

bool AuthInitiarize = false;
bool AuthResult = false;
bool AuthTry = false;
// GogoJungle top ////////////////////////////////////////////////////|
          





input   string              IndiName = "";                              // インジケーターの名前


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
    {
       
    }
    
int OnInit()
  {
// GogoJungle OnInit /////////////////////////////////////////////////|
  if(AccountNumber() == 0){
    AuthResult = false;
    AuthTry = true;
  }
  else{
    AccountCert = GrabWeb();
    Disp(AccountCert);
    if(StringFind(AccountCert, "success") == -1) {AuthResult = false;}
    else{AuthResult = true;} }
  EventSetTimer(5);
// GogoJungle OnInit /////////////////////////////////////////////////|

        Comment("");
        
        Print("---オブジェクト型の矢印の有無を確認します---");
        DisplayObjectCheck();
        Print("---バッファ型の矢印の有無を確認します---");
        iCustom(NULL, 0, IndiName, 0, 0);
        if(GetLastError() == 4072)
        {
            Print("指定した名前のインジケーターは存在しません");
        }
        else DisplayBufferCheck();
      
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
// GogoJungle OnCalculate /////////////////////////////////////////////////|
  if(AuthResult == false){return(0);}
// GogoJungle OnCalculate /////////////////////////////////////////////////|

//--     
        return rates_total - 1;  
  }
//+------------------------------------------------------------------+
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
void DisplayBufferCheck()
    {   
    int shift = 500;
    double cstm ;
    if(Bars < 500)shift = Bars;
    
    for(int i = 0; i < 8 ; i++)
    {
      for(int k = 0 ;k < shift ;k++)
      {
         cstm = iCustom(NULL, 0, IndiName, i, k);
         if(cstm != EMPTY_VALUE && cstm != 0)
         {
             Print((string)i + "番:"+ TimeToStr(iTime( Symbol(), Period() , k))+ "に矢印候補があります");
             break;
         }
         if(k == shift - 1)
         {
            Print((string)i + "番:" + "矢印候補はありません");
         }
      }
    }
 
    }
void DisplayObjectCheck()
    {   
       
        
        int ind = 0; 
        int barIndex;
        int obj_total;
        int count;
        double arrowCode ;
        int countObject = 0;
        int buyFirst = -1;
        int sellFirst = -1;
        obj_total =  ObjectsTotal(ChartID(), 0, OBJ_ARROW);
        
        //ここからソート
        datetime arrayTime[];
        string arrayObjName[];
        ArrayResize(arrayTime,obj_total);
        ArrayResize(arrayObjName,obj_total);
        for(count = 0 ; count < obj_total; count++ )
        {
            arrayTime[count] = (datetime)ObjectGet(ObjectName(count),OBJPROP_TIME1);
            arrayObjName [count] = ObjectName(count);
        }
        merge_sort(arrayTime, arrayObjName,obj_total, 0, obj_total - 1);
        //ここまでソート。そーと後の時間はarrayTime名前はarrayObjNameに入ってる
        while(obj_total > ind  )
        {
               arrowCode = ObjectGet(arrayObjName[obj_total - 1 - ind],OBJPROP_ARROWCODE);
               barIndex = iBarShift(Symbol(),Period(),(datetime)ObjectGet(arrayObjName[obj_total - 1 - ind],OBJPROP_TIME1) , false );
               if(arrowCode == 67 || arrowCode == 71 ||arrowCode == 200 ||arrowCode == 217 ||arrowCode == 221 ||
               arrowCode == 225 ||arrowCode == 228 ||arrowCode == 233 ||arrowCode == 236 ||arrowCode == 241 ||arrowCode == 246)
               {
                   buyFirst = barIndex;
                   break;
               }
               ind++;  
          }
         ind = 0;
         while(obj_total > ind  )
         {
               arrowCode = ObjectGet(arrayObjName[obj_total - 1 - ind],OBJPROP_ARROWCODE);
               barIndex = iBarShift(Symbol(),Period(),(datetime)ObjectGet(arrayObjName[obj_total - 1 - ind],OBJPROP_TIME1) , false );
               if(arrowCode == 68 || arrowCode == 72 ||arrowCode == 202 ||arrowCode == 218 ||arrowCode == 222 ||
               arrowCode == 226 ||arrowCode == 230 ||arrowCode == 234 ||arrowCode == 238 ||arrowCode == 242 ||arrowCode == 248)
               {
                   sellFirst = barIndex;
                   break;
               }
               ind++;  
          }
          if(buyFirst == -1 && sellFirst == -1)
          {
            Print("オブジェクト型の矢印はありません");
          }
          else if(buyFirst == -1 && sellFirst != -1)
          {
            Print("オブジェクト型の売り矢印が" + TimeToStr(iTime( Symbol(), Period() , sellFirst)) + "にあります");
          }
          else if(buyFirst != -1 && sellFirst == -1)
          {
            Print("オブジェクト型の買い矢印が" + TimeToStr(iTime( Symbol(), Period() , buyFirst))+ "にあります");
          }
          else
          {
            if(buyFirst < sellFirst)Print("オブジェクト型の買い矢印が" + TimeToStr(iTime( Symbol(), Period() , buyFirst))+ "にあります");
            else Print("オブジェクト型の売り矢印が" + TimeToStr(iTime( Symbol(), Period() , sellFirst))+ "にあります");
          }

    }     
int checkArrow(int shift )//０は何もない、1なら買い、2は売り
    {   
       
        
        int ind = 0; 
        int barIndex;
        int obj_total;
        int count;
        double arrowCode ;
        int countObject = 0;
        int buyFirst = -1;
        int sellFirst = -1;
        
        obj_total =  ObjectsTotal(ChartID(), 0, OBJ_ARROW);
        
        //ここからソート
        datetime arrayTime[];
        string arrayObjName[];
        ArrayResize(arrayTime,obj_total);
        ArrayResize(arrayObjName,obj_total);
        for(count = 0 ; count < obj_total; count++ )
        {
            arrayTime[count] = (datetime)ObjectGet(ObjectName(count),OBJPROP_TIME1);
            arrayObjName [count] = ObjectName(count);
        }
        merge_sort(arrayTime, arrayObjName,obj_total, 0, obj_total - 1);
        //ここまでソート。そーと後の時間はarrayTime名前はarrayObjNameに入ってる
        while(obj_total > ind  )
        {
               arrowCode = ObjectGet(arrayObjName[obj_total - 1 - ind],OBJPROP_ARROWCODE);
               barIndex = iBarShift(Symbol(),Period(),(datetime)ObjectGet(arrayObjName[obj_total - 1 - ind],OBJPROP_TIME1) , false );
               if(arrowCode == 67 || arrowCode == 71 ||arrowCode == 200 ||arrowCode == 217 ||arrowCode == 221 ||
               arrowCode == 225 ||arrowCode == 228 ||arrowCode == 233 ||arrowCode == 236 ||arrowCode == 241 ||arrowCode == 246)
               {
                   buyFirst = barIndex;
                   break;
               }
               ind++;  
          }
         ind = 0;
         while(obj_total > ind  )
         {
               arrowCode = ObjectGet(arrayObjName[obj_total - 1 - ind],OBJPROP_ARROWCODE);
               barIndex = iBarShift(Symbol(),Period(),(datetime)ObjectGet(arrayObjName[obj_total - 1 - ind],OBJPROP_TIME1) , false );
               if(arrowCode == 68 || arrowCode == 72 ||arrowCode == 202 ||arrowCode == 218 ||arrowCode == 222 ||
               arrowCode == 226 ||arrowCode == 230 ||arrowCode == 234 ||arrowCode == 238 ||arrowCode == 242 ||arrowCode == 248)
               {
                   sellFirst = barIndex;
                   break;
               }
               ind++;  
          }
          if(buyFirst == shift)return 1;
          if(sellFirst == shift)return 2;
          return 0;
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

void OnTimer()
{
// GogoJungle OnTimer /////////////////////////////////////////////////|
  if(AuthTry == true && AccountNumber() > 0){
    AccountCert = GrabWeb();
    Disp(AccountCert);
    AuthTry = false;
    if(StringFind(AccountCert, "success") == -1) { AuthResult = false; }
    else{
      AuthResult = true;
      long volume[];
      int spread[];
      ArrayResize(volume, Bars, 0);
      ArrayResize(spread, Bars, 0);
      ArrayInitialize(volume, 0);
      ArrayInitialize(spread, 0);
      OnCalculate(Bars, 0, Time, Open, High, Low, Close, Volume, volume, spread);
    }
  }
// GogoJungle OnTimer /////////////////////////////////////////////////|
}

/*
//+------------------------------------------------------------------+
//|                                                         asdf.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                              https://www.mql5.co |
//+------------------------------------------------------------------+
#define MQL4
#define PROPERTY_LINK ""
#define PROPERTY_COPYRIGHT ""
#define PROPERTY_DESCRIPTION ""
#define OBJNAME_PREFIX "OBJ I20191019 "
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





input   string              IndiName = "";                              // インジケーターの名前


//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
    {
       
    }
    
int OnInit()
  {
        Comment("");
        
        Print("---オブジェクト型の矢印の有無を確認します---");
        DisplayObjectCheck();
        Print("---バッファ型の矢印の有無を確認します---");
        iCustom(NULL, 0, IndiName, 0, 0);
        if(GetLastError() == 4072)
        {
            Print("指定した名前のインジケーターは存在しません");
        }
        else DisplayBufferCheck();
      
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
        return rates_total - 1;  
  }
//+------------------------------------------------------------------+
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
void DisplayBufferCheck()
    {   
    int shift = 500;
    double cstm ;
    if(Bars < 500)shift = Bars;
    
    for(int i = 0; i < 8 ; i++)
    {
      for(int k = 0 ;k < shift ;k++)
      {
         cstm = iCustom(NULL, 0, IndiName, i, k);
         if(cstm != EMPTY_VALUE && cstm != 0)
         {
             Print((string)i + "番:"+ TimeToStr(iTime( Symbol(), Period() , k))+ "に矢印候補があります");
             break;
         }
         if(k == shift - 1)
         {
            Print((string)i + "番:" + "矢印候補はありません");
         }
      }
    }

    }
void DisplayObjectCheck()
    {   
       
        
        int ind = 0; 
        int barIndex;
        int obj_total;
        int count;
        double arrowCode ;
        int countObject = 0;
        int buyFirst = -1;
        int sellFirst = -1;
        obj_total =  ObjectsTotal(ChartID(), 0, OBJ_ARROW);
        
        //ここからソート
        datetime arrayTime[];
        string arrayObjName[];
        ArrayResize(arrayTime,obj_total);
        ArrayResize(arrayObjName,obj_total);
        for(count = 0 ; count < obj_total; count++ )
        {
            arrayTime[count] = (datetime)ObjectGet(ObjectName(count),OBJPROP_TIME1);
            arrayObjName [count] = ObjectName(count);
        }
        merge_sort(arrayTime, arrayObjName,obj_total, 0, obj_total - 1);
        //ここまでソート。そーと後の時間はarrayTime名前はarrayObjNameに入ってる
        while(obj_total > ind  )
        {
               arrowCode = ObjectGet(arrayObjName[obj_total - 1 - ind],OBJPROP_ARROWCODE);
               barIndex = iBarShift(Symbol(),Period(),(datetime)ObjectGet(arrayObjName[obj_total - 1 - ind],OBJPROP_TIME1) , false );
               if(arrowCode == 67 || arrowCode == 71 ||arrowCode == 200 ||arrowCode == 217 ||arrowCode == 221 ||
               arrowCode == 225 ||arrowCode == 228 ||arrowCode == 233 ||arrowCode == 236 ||arrowCode == 241 ||arrowCode == 246)
               {
                   buyFirst = barIndex;
                   break;
               }
               ind++;  
          }
         ind = 0;
         while(obj_total > ind  )
         {
               arrowCode = ObjectGet(arrayObjName[obj_total - 1 - ind],OBJPROP_ARROWCODE);
               barIndex = iBarShift(Symbol(),Period(),(datetime)ObjectGet(arrayObjName[obj_total - 1 - ind],OBJPROP_TIME1) , false );
               if(arrowCode == 68 || arrowCode == 72 ||arrowCode == 202 ||arrowCode == 218 ||arrowCode == 222 ||
               arrowCode == 226 ||arrowCode == 230 ||arrowCode == 234 ||arrowCode == 238 ||arrowCode == 242 ||arrowCode == 248)
               {
                   sellFirst = barIndex;
                   break;
               }
               ind++;  
          }
          if(buyFirst == -1 && sellFirst == -1)
          {
            Print("オブジェクト型の矢印はありません");
          }
          else if(buyFirst == -1 && sellFirst != -1)
          {
            Print("オブジェクト型の売り矢印が" + TimeToStr(iTime( Symbol(), Period() , sellFirst)) + "にあります");
          }
          else if(buyFirst != -1 && sellFirst == -1)
          {
            Print("オブジェクト型の買い矢印が" + TimeToStr(iTime( Symbol(), Period() , buyFirst))+ "にあります");
          }
          else
          {
            if(buyFirst < sellFirst)Print("オブジェクト型の買い矢印が" + TimeToStr(iTime( Symbol(), Period() , buyFirst))+ "にあります");
            else Print("オブジェクト型の売り矢印が" + TimeToStr(iTime( Symbol(), Period() , sellFirst))+ "にあります");
          }

    }     
int checkArrow(int shift )//０は何もない、1なら買い、2は売り
    {   
       
        
        int ind = 0; 
        int barIndex;
        int obj_total;
        int count;
        double arrowCode ;
        int countObject = 0;
        int buyFirst = -1;
        int sellFirst = -1;
        
        obj_total =  ObjectsTotal(ChartID(), 0, OBJ_ARROW);
        
        //ここからソート
        datetime arrayTime[];
        string arrayObjName[];
        ArrayResize(arrayTime,obj_total);
        ArrayResize(arrayObjName,obj_total);
        for(count = 0 ; count < obj_total; count++ )
        {
            arrayTime[count] = (datetime)ObjectGet(ObjectName(count),OBJPROP_TIME1);
            arrayObjName [count] = ObjectName(count);
        }
        merge_sort(arrayTime, arrayObjName,obj_total, 0, obj_total - 1);
        //ここまでソート。そーと後の時間はarrayTime名前はarrayObjNameに入ってる
        while(obj_total > ind  )
        {
               arrowCode = ObjectGet(arrayObjName[obj_total - 1 - ind],OBJPROP_ARROWCODE);
               barIndex = iBarShift(Symbol(),Period(),(datetime)ObjectGet(arrayObjName[obj_total - 1 - ind],OBJPROP_TIME1) , false );
               if(arrowCode == 67 || arrowCode == 71 ||arrowCode == 200 ||arrowCode == 217 ||arrowCode == 221 ||
               arrowCode == 225 ||arrowCode == 228 ||arrowCode == 233 ||arrowCode == 236 ||arrowCode == 241 ||arrowCode == 246)
               {
                   buyFirst = barIndex;
                   break;
               }
               ind++;  
          }
         ind = 0;
         while(obj_total > ind  )
         {
               arrowCode = ObjectGet(arrayObjName[obj_total - 1 - ind],OBJPROP_ARROWCODE);
               barIndex = iBarShift(Symbol(),Period(),(datetime)ObjectGet(arrayObjName[obj_total - 1 - ind],OBJPROP_TIME1) , false );
               if(arrowCode == 68 || arrowCode == 72 ||arrowCode == 202 ||arrowCode == 218 ||arrowCode == 222 ||
               arrowCode == 226 ||arrowCode == 230 ||arrowCode == 234 ||arrowCode == 238 ||arrowCode == 242 ||arrowCode == 248)
               {
                   sellFirst = barIndex;
                   break;
               }
               ind++;  
          }
          if(buyFirst == shift)return 1;
          if(sellFirst == shift)return 2;
          return 0;
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
*/