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
input double pips = 10;
double W11array[24][2];             //1時間の値動きで今後1時間がどう変わるか[勝ち負け]
double W21array[24][2];         
double W12array[24][2];
double W22array[24][2];
double W31array[24][2];
double W32array[24][2];
double W13array[24][2];
double W23array[24][2];
double W33array[24][2];
double W41array[24][2];
double W42array[24][2];
double W43array[24][2];
double W14array[24][2];
double W24array[24][2];
double W34array[24][2];
double W44array[24][2];

double S11array[24][2];             //1時間の値動きで今後1時間がどう変わるか[勝ち負け]
double S21array[24][2];         
double S12array[24][2];
double S22array[24][2];
double S31array[24][2];
double S32array[24][2];
double S13array[24][2];
double S23array[24][2];
double S33array[24][2];
double S41array[24][2];
double S42array[24][2];
double S43array[24][2];
double S14array[24][2];
double S24array[24][2];
double S34array[24][2];
double S44array[24][2];
bool first = true;

int OnInit()
  {
//--- indicator buffers mapping
   for(int i = 0 ; i < 24 ;i++)
   {
      for(int k = 0 ; k < 2 ; k++)
      {
          W11array[i][k] = 0;             
          W21array[i][k] = 0;         
          W12array[i][k] = 0;
          W22array[i][k] = 0;
          W31array[i][k] = 0;
          W32array[i][k] = 0;
          W13array[i][k] = 0;
          W23array[i][k] = 0;
          W33array[i][k] = 0;
          W41array[i][k] = 0;
          W42array[i][k] = 0;
          W43array[i][k] = 0;
          W14array[i][k] = 0;
          W24array[i][k] = 0;
          W34array[i][k] = 0;
          W44array[i][k] = 0;
         
          S11array[i][k] = 0;             //1時間の値動きで今後1時間がどう変わるか[勝ち負け]
          S21array[i][k] = 0;         
          S12array[i][k] = 0;
          S22array[i][k] = 0;
          S31array[i][k] = 0;
          S32array[i][k] = 0;
          S13array[i][k] = 0;
          S23array[i][k] = 0;
          S33array[i][k] = 0;
          S41array[i][k] = 0;
          S42array[i][k] = 0;
          S43array[i][k] = 0;
          S14array[i][k] = 0;
          S24array[i][k] = 0;
          S34array[i][k] = 0;
          S44array[i][k] = 0;
       }
   }
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
   if(first)
   {
      for (int index = Bars - IndicatorCounted() - 1; 10 <= index; index--)
      {
         for(int iTime = 0 ; iTime < 24 ; iTime++ )
         {
            if(TimeHour(Time[index]) == iTime && TimeMinute(Time[index]) == 0)
            {
               if(IsDST(Time[index],False))
               {
                  if(PriceToPips(Close[index] - Close[(index - 1)]) > pips && PriceToPips(Close[(index - 2)  ] - Close[(index - 1)  ] > 0))S11array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 1)]) > pips && PriceToPips(Close[(index - 2)  ] - Close[(index - 1)  ] < 0))S11array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 1)]) < -pips && PriceToPips(Close[(index - 2)  ] - Close[(index - 1)  ] < 0))S11array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 1)]) < -pips && PriceToPips(Close[(index - 2)  ] - Close[(index - 1)  ] > 0))S11array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 1) ]) > pips && PriceToPips(Close[(index - 3)  ] - Close[(index - 1)  ] > 0))S12array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 1)]) > pips && PriceToPips(Close[(index - 3)  ] - Close[(index - 1)  ] < 0))S12array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 1)]) < -pips && PriceToPips(Close[(index - 3)  ] - Close[(index - 1)  ] < 0))S12array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 1)]) < -pips && PriceToPips(Close[(index - 3)  ] - Close[(index - 1)  ] > 0))S12array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 2)]) > pips && PriceToPips(Close[(index - 3)  ] - Close[(index - 2)  ] > 0))S21array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 2)]) > pips && PriceToPips(Close[(index - 3)  ] - Close[(index - 2)  ] < 0))S21array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 2)]) < -pips && PriceToPips(Close[(index - 3)  ] - Close[(index - 2)  ] < 0))S21array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 2)]) < -pips && PriceToPips(Close[(index - 3)  ] - Close[(index - 2)  ] > 0))S21array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 2)]) > pips && PriceToPips(Close[(index - 4)  ] - Close[(index - 2)  ] > 0))S22array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 2)]) > pips && PriceToPips(Close[(index - 4)  ] - Close[(index - 2)  ] < 0))S22array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 2)]) < -pips && PriceToPips(Close[(index - 4)  ] - Close[(index - 2)  ] < 0))S22array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 2)]) < -pips && PriceToPips(Close[(index - 4)  ] - Close[(index - 2)  ] > 0))S22array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 3)]) > pips && PriceToPips(Close[(index - 4)  ] - Close[(index - 3)  ] > 0))S31array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 3)]) > pips && PriceToPips(Close[(index - 4)  ] - Close[(index - 3)  ] < 0))S31array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 3)]) < -pips && PriceToPips(Close[(index - 4)  ] - Close[(index - 3)  ] < 0))S31array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 3)]) < -pips && PriceToPips(Close[(index - 4)  ] - Close[(index - 3)  ] > 0))S31array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 3)]) > pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 3)  ] > 0))S32array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 3)]) > pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 3)  ] < 0))S32array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 3)]) < -pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 3)  ] < 0))S32array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 3)]) < -pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 3)  ] > 0))S32array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 1)]) > pips && PriceToPips(Close[(index - 4)  ] - Close[(index - 1)  ] > 0))S13array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 1)]) > pips && PriceToPips(Close[(index - 4)  ] - Close[(index - 1)  ] < 0))S13array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 1)]) < -pips && PriceToPips(Close[(index - 4)  ] - Close[(index - 1)  ] < 0))S13array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 1)]) < -pips && PriceToPips(Close[(index - 4)  ] - Close[(index - 1)  ] > 0))S13array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 2)]) > pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 2)  ] > 0))S23array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 2)]) > pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 2)  ] < 0))S23array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 2)]) < -pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 2)  ] < 0))S23array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 2)]) < -pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 2)  ] > 0))S23array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 3)]) > pips && PriceToPips(Close[(index - 6)  ] - Close[(index - 3)  ] > 0))S33array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 3)]) > pips && PriceToPips(Close[(index - 6)  ] - Close[(index - 3)  ] < 0))S33array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 3)]) < -pips && PriceToPips(Close[(index - 6) ] - Close[(index - 3)  ] < 0))S33array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 3)]) < -pips && PriceToPips(Close[(index - 6) ] - Close[(index - 3)  ] > 0))S33array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 4)]) > pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 4)  ] > 0))S41array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 4)]) > pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 4)  ] < 0))S41array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 4)]) < -pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 4)  ] < 0))S41array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 4)]) < -pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 4)  ] > 0))S41array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 4)]) > pips && PriceToPips(Close[(index - 6)  ] - Close[(index - 4)  ] > 0))S42array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 4)  ]) > pips && PriceToPips(Close[(index - 6)  ] - Close[(index - 4)  ] < 0))S42array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 4)  ]) < -pips && PriceToPips(Close[(index - 6)  ] - Close[(index - 4)  ] < 0))S42array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 4)  ]) < -pips && PriceToPips(Close[(index - 6)  ] - Close[(index - 4)  ] > 0))S42array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 4)  ]) > pips && PriceToPips(Close[(index - 7)  ] - Close[(index - 4)  ] > 0))S43array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 4)  ]) > pips && PriceToPips(Close[(index - 7)  ] - Close[(index - 4)  ] < 0))S43array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 4)  ]) < -pips && PriceToPips(Close[(index - 7)  ] - Close[(index - 4)  ] < 0))S43array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 4)  ]) < -pips && PriceToPips(Close[(index - 7)  ] - Close[(index - 4)  ] > 0))S43array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 1)  ]) > pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 1)  ] > 0))S14array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 1)  ]) > pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 1)  ] < 0))S14array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 1)  ]) < -pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 1)  ] < 0))S14array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 1)  ]) < -pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 1)  ] > 0))S14array[iTime][1]++;
               
                  if(PriceToPips(Close[index] - Close[(index - 2)  ]) > pips && PriceToPips(Close[(index - 6)  ] - Close[(index - 2)  ] > 0))S24array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 2)  ]) > pips && PriceToPips(Close[(index - 6)  ] - Close[(index - 2)  ] < 0))S24array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 2)  ]) < -pips && PriceToPips(Close[(index - 6)  ] - Close[(index - 2)  ] < 0))S24array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 2)  ]) < -pips && PriceToPips(Close[(index - 6)  ] - Close[(index - 2)  ] > 0))S24array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 3)  ]) > pips && PriceToPips(Close[(index - 7)  ] - Close[(index - 3)  ] > 0))S34array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 3)  ]) > pips && PriceToPips(Close[(index - 7)  ] - Close[(index - 3)  ] < 0))S34array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 3)  ]) < -pips && PriceToPips(Close[(index - 7)  ] - Close[(index - 3)  ] < 0))S34array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 3)  ]) < -pips && PriceToPips(Close[(index - 7)  ] - Close[(index - 3)  ] > 0))S34array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 4)  ]) > pips && PriceToPips(Close[(index - 8)  ] - Close[(index - 4)  ] > 0))S44array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 4)  ]) > pips && PriceToPips(Close[(index - 8)  ] - Close[(index - 4)  ] < 0))S44array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 4)  ]) < -pips && PriceToPips(Close[(index - 8)  ] - Close[(index - 4)  ] < 0))S44array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 4)  ]) < -pips && PriceToPips(Close[(index - 8)  ] - Close[(index - 4)  ] > 0))S44array[iTime][1]++;
               
               }
               
               else
               {
                  if(PriceToPips(Close[index] - Close[(index - 1)]) > pips && PriceToPips(Close[(index - 2)  ] - Close[(index - 1)  ] > 0))W11array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 1)]) > pips && PriceToPips(Close[(index - 2)  ] - Close[(index - 1)  ] < 0))W11array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 1)]) < -pips && PriceToPips(Close[(index - 2)  ] - Close[(index - 1)  ] < 0))W11array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 1)]) < -pips && PriceToPips(Close[(index - 2)  ] - Close[(index - 1)  ] > 0))W11array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 1) ]) > pips && PriceToPips(Close[(index - 3)  ] - Close[(index - 1)  ] > 0))W12array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 1)]) > pips && PriceToPips(Close[(index - 3)  ] - Close[(index - 1)  ] < 0))W12array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 1)]) < -pips && PriceToPips(Close[(index - 3)  ] - Close[(index - 1)  ] < 0))W12array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 1)]) < -pips && PriceToPips(Close[(index - 3)  ] - Close[(index - 1)  ] > 0))W12array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 2)]) > pips && PriceToPips(Close[(index - 3)  ] - Close[(index - 2)  ] > 0))W21array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 2)]) > pips && PriceToPips(Close[(index - 3)  ] - Close[(index - 2)  ] < 0))W21array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 2)]) < -pips && PriceToPips(Close[(index - 3)  ] - Close[(index - 2)  ] < 0))W21array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 2)]) < -pips && PriceToPips(Close[(index - 3)  ] - Close[(index - 2)  ] > 0))W21array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 2)]) > pips && PriceToPips(Close[(index - 4)  ] - Close[(index - 2)  ] > 0))W22array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 2)]) > pips && PriceToPips(Close[(index - 4)  ] - Close[(index - 2)  ] < 0))W22array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 2)]) < -pips && PriceToPips(Close[(index - 4)  ] - Close[(index - 2)  ] < 0))W22array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 2)]) < -pips && PriceToPips(Close[(index - 4)  ] - Close[(index - 2)  ] > 0))W22array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 3)]) > pips && PriceToPips(Close[(index - 4)  ] - Close[(index - 3)  ] > 0))W31array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 3)]) > pips && PriceToPips(Close[(index - 4)  ] - Close[(index - 3)  ] < 0))W31array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 3)]) < -pips && PriceToPips(Close[(index - 4)  ] - Close[(index - 3)  ] < 0))W31array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 3)]) < -pips && PriceToPips(Close[(index - 4)  ] - Close[(index - 3)  ] > 0))W31array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 3)]) > pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 3)  ] > 0))W32array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 3)]) > pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 3)  ] < 0))W32array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 3)]) < -pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 3)  ] < 0))W32array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 3)]) < -pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 3)  ] > 0))W32array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 1)]) > pips && PriceToPips(Close[(index - 4)  ] - Close[(index - 1)  ] > 0))W13array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 1)]) > pips && PriceToPips(Close[(index - 4)  ] - Close[(index - 1)  ] < 0))W13array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 1)]) < -pips && PriceToPips(Close[(index - 4)  ] - Close[(index - 1)  ] < 0))W13array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 1)]) < -pips && PriceToPips(Close[(index - 4)  ] - Close[(index - 1)  ] > 0))W13array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 2)]) > pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 2)  ] > 0))W23array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 2)]) > pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 2)  ] < 0))W23array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 2)]) < -pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 2)  ] < 0))W23array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 2)]) < -pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 2)  ] > 0))W23array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 3)]) > pips && PriceToPips(Close[(index - 6)  ] - Close[(index - 3)  ] > 0))W33array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 3)]) > pips && PriceToPips(Close[(index - 6)  ] - Close[(index - 3)  ] < 0))W33array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 3)]) < -pips && PriceToPips(Close[(index - 6) ] - Close[(index - 3)  ] < 0))W33array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 3)]) < -pips && PriceToPips(Close[(index - 6) ] - Close[(index - 3)  ] > 0))W33array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 4)]) > pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 4)  ] > 0))W41array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 4)]) > pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 4)  ] < 0))W41array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 4)]) < -pips && PriceToPips(Close[(index - 5)] - Close[(index - 4)  ] < 0))W41array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 4)]) < -pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 4)  ] > 0))W41array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 4)]) > pips && PriceToPips(Close[(index - 6)  ] - Close[(index - 4)  ] > 0))W42array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 4)  ]) > pips && PriceToPips(Close[(index - 6)  ] - Close[(index - 4)  ] < 0))W42array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 4)  ]) < -pips && PriceToPips(Close[(index - 6)  ] - Close[(index - 4)  ] < 0))W42array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 4)  ]) < -pips && PriceToPips(Close[(index - 6)  ] - Close[(index - 4)  ] > 0))W42array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 4)  ]) > pips && PriceToPips(Close[(index - 7)  ] - Close[(index - 4)  ] > 0))W43array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 4)  ]) > pips && PriceToPips(Close[(index - 7)  ] - Close[(index - 4)  ] < 0))W43array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 4)  ]) < -pips && PriceToPips(Close[(index - 7)  ] - Close[(index - 4)  ] < 0))W43array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 4)  ]) < -pips && PriceToPips(Close[(index - 7)  ] - Close[(index - 4)  ] > 0))W43array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 1)  ]) > pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 1)  ] > 0))W14array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 1)  ]) > pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 1)  ] < 0))W14array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 1)  ]) < -pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 1)  ] < 0))W14array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 1)  ]) < -pips && PriceToPips(Close[(index - 5)  ] - Close[(index - 1)  ] > 0))W14array[iTime][1]++;
               
                  if(PriceToPips(Close[index] - Close[(index - 2)  ]) > pips && PriceToPips(Close[(index - 6)  ] - Close[(index - 2)  ] > 0))W24array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 2)  ]) > pips && PriceToPips(Close[(index - 6)  ] - Close[(index - 2)  ] < 0))W24array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 2)  ]) < -pips && PriceToPips(Close[(index - 6)  ] - Close[(index - 2)  ] < 0))W24array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 2)  ]) < -pips && PriceToPips(Close[(index - 6)  ] - Close[(index - 2)  ] > 0))W24array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 3)  ]) > pips && PriceToPips(Close[(index - 7)  ] - Close[(index - 3)  ] > 0))W34array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 3)  ]) > pips && PriceToPips(Close[(index - 7)  ] - Close[(index - 3)  ] < 0))W34array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 3)  ]) < -pips && PriceToPips(Close[(index - 7)  ] - Close[(index - 3)  ] < 0))W34array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 3)  ]) < -pips && PriceToPips(Close[(index - 7)  ] - Close[(index - 3)  ] > 0))W34array[iTime][1]++;
                  
                  if(PriceToPips(Close[index] - Close[(index - 4)  ]) > pips && PriceToPips(Close[(index - 8)  ] - Close[(index - 4)  ] > 0))W44array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 4)  ]) > pips && PriceToPips(Close[(index - 8)  ] - Close[(index - 4)  ] < 0))W44array[iTime][1]++;
                  if(PriceToPips(Close[index] - Close[(index - 4)  ]) < -pips && PriceToPips(Close[(index - 8)  ] - Close[(index - 4)  ] < 0))W44array[iTime][0]++;
                  if(PriceToPips(Close[index] - Close[(index - 4)  ]) < -pips && PriceToPips(Close[(index - 8)  ] - Close[(index - 4)  ] > 0))W44array[iTime][1]++;
               
               }
               
            }
         }
        
      }
   }
   for(int iTime = 0 ; iTime < 24 ;iTime++)
   {
      if(100 * S11array[iTime][0]/(S11array[iTime][0]+S11array[iTime][1]) > 60 || 100 * S11array[iTime][0]/(S11array[iTime][0]+S11array[iTime][1]) < 40)Print((string)iTime +"," + "[S11]"+(string)S11array[iTime][0] +"," +(string)S11array[iTime][1] + ","+ (string)(100 * S11array[iTime][0]/(S11array[iTime][0]+S11array[iTime][1])) + "%");
      if(100 * S12array[iTime][0]/(S12array[iTime][0]+S12array[iTime][1]) > 60 || 100 * S12array[iTime][0]/(S12array[iTime][0]+S12array[iTime][1]) < 40)Print((string)iTime +"," + "[S12]"+(string)S12array[iTime][0] +"," +(string)S12array[iTime][1] + ","+ (string)(100 * S12array[iTime][0]/(S12array[iTime][0]+S12array[iTime][1])) + "%");
      if(100 * S21array[iTime][0]/(S21array[iTime][0]+S21array[iTime][1]) > 60 || 100 * S21array[iTime][0]/(S21array[iTime][0]+S21array[iTime][1]) < 40)Print((string)iTime +"," + "[S21]"+(string)S21array[iTime][0] +"," +(string)S21array[iTime][1] + ","+ (string)(100 * S21array[iTime][0]/(S21array[iTime][0]+S21array[iTime][1])) + "%");
      if(100 * S22array[iTime][0]/(S22array[iTime][0]+S22array[iTime][1]) > 60 || 100 * S22array[iTime][0]/(S22array[iTime][0]+S22array[iTime][1]) < 40)Print((string)iTime +"," + "[S22]"+(string)S22array[iTime][0] +"," +(string)S22array[iTime][1] + ","+ (string)(100 * S22array[iTime][0]/(S22array[iTime][0]+S22array[iTime][1])) + "%");
      if(100 * S13array[iTime][0]/(S13array[iTime][0]+S13array[iTime][1]) > 60 || 100 * S13array[iTime][0]/(S13array[iTime][0]+S13array[iTime][1]) < 40)Print((string)iTime +"," + "[S13]"+(string)S13array[iTime][0] +"," +(string)S13array[iTime][1] + ","+ (string)(100 * S13array[iTime][0]/(S13array[iTime][0]+S13array[iTime][1])) + "%");
      if(100 * S23array[iTime][0]/(S23array[iTime][0]+S23array[iTime][1]) > 60 || 100 * S23array[iTime][0]/(S23array[iTime][0]+S23array[iTime][1]) < 40)Print((string)iTime +"," + "[S23]"+(string)S23array[iTime][0] +"," +(string)S23array[iTime][1] + ","+ (string)(100 * S23array[iTime][0]/(S23array[iTime][0]+S23array[iTime][1])) + "%");
      if(100 * S31array[iTime][0]/(S31array[iTime][0]+S31array[iTime][1]) > 60 || 100 * S31array[iTime][0]/(S31array[iTime][0]+S31array[iTime][1]) < 40)Print((string)iTime +"," + "[S31]"+(string)S31array[iTime][0] +"," +(string)S31array[iTime][1] + ","+ (string)(100 * S31array[iTime][0]/(S31array[iTime][0]+S31array[iTime][1])) + "%");
      if(100 * S32array[iTime][0]/(S32array[iTime][0]+S32array[iTime][1]) > 60 || 100 * S32array[iTime][0]/(S32array[iTime][0]+S32array[iTime][1]) < 40)Print((string)iTime +"," + "[S32]"+(string)S32array[iTime][0] +"," +(string)S32array[iTime][1] + ","+ (string)(100 * S32array[iTime][0]/(S32array[iTime][0]+S32array[iTime][1])) + "%");
      if(100 * S33array[iTime][0]/(S33array[iTime][0]+S33array[iTime][1]) > 60 || 100 * S33array[iTime][0]/(S33array[iTime][0]+S33array[iTime][1]) < 40)Print((string)iTime +"," + "[S33]"+(string)S33array[iTime][0] +"," +(string)S33array[iTime][1] + ","+ (string)(100 * S33array[iTime][0]/(S33array[iTime][0]+S33array[iTime][1])) + "%");
      if(100 * S41array[iTime][0]/(S41array[iTime][0]+S41array[iTime][1]) > 60 || 100 * S41array[iTime][0]/(S41array[iTime][0]+S41array[iTime][1]) < 40)Print((string)iTime +"," + "[S41]"+(string)S41array[iTime][0] +"," +(string)S41array[iTime][1] + ","+ (string)(100 * S41array[iTime][0]/(S41array[iTime][0]+S41array[iTime][1])) + "%");
      if(100 * S42array[iTime][0]/(S42array[iTime][0]+S42array[iTime][1]) > 60 || 100 * S42array[iTime][0]/(S42array[iTime][0]+S42array[iTime][1]) < 40)Print((string)iTime +"," + "[S42]"+(string)S42array[iTime][0] +"," +(string)S42array[iTime][1] + ","+ (string)(100 * S42array[iTime][0]/(S42array[iTime][0]+S42array[iTime][1])) + "%");
      if(100 * S43array[iTime][0]/(S43array[iTime][0]+S43array[iTime][1]) > 60 || 100 * S43array[iTime][0]/(S43array[iTime][0]+S43array[iTime][1]) < 40)Print((string)iTime +"," + "[S43]"+(string)S43array[iTime][0] +"," +(string)S43array[iTime][1] + ","+ (string)(100 * S43array[iTime][0]/(S43array[iTime][0]+S43array[iTime][1])) + "%");
      if(100 * S14array[iTime][0]/(S14array[iTime][0]+S14array[iTime][1]) > 60 || 100 * S14array[iTime][0]/(S14array[iTime][0]+S14array[iTime][1]) < 40)Print((string)iTime +"," + "[S14]"+(string)S14array[iTime][0] +"," +(string)S14array[iTime][1] + ","+ (string)(100 * S14array[iTime][0]/(S14array[iTime][0]+S14array[iTime][1])) + "%");
      if(100 * S24array[iTime][0]/(S24array[iTime][0]+S24array[iTime][1]) > 60 || 100 * S24array[iTime][0]/(S24array[iTime][0]+S24array[iTime][1]) < 40)Print((string)iTime +"," + "[S24]"+(string)S24array[iTime][0] +"," +(string)S24array[iTime][1] + ","+ (string)(100 * S24array[iTime][0]/(S24array[iTime][0]+S24array[iTime][1])) + "%");
      if(100 * S34array[iTime][0]/(S34array[iTime][0]+S34array[iTime][1]) > 60 || 100 * S34array[iTime][0]/(S34array[iTime][0]+S34array[iTime][1]) < 40)Print((string)iTime +"," + "[S34]"+(string)S34array[iTime][0] +"," +(string)S34array[iTime][1] + ","+ (string)(100 * S34array[iTime][0]/(S34array[iTime][0]+S34array[iTime][1])) + "%");
      if(100 * S44array[iTime][0]/(S44array[iTime][0]+S44array[iTime][1]) > 60 || 100 * S44array[iTime][0]/(S44array[iTime][0]+S44array[iTime][1]) < 40)Print((string)iTime +"," + "[S44]"+(string)S44array[iTime][0] +"," +(string)S44array[iTime][1] + ","+ (string)(100 * S44array[iTime][0]/(S44array[iTime][0]+S44array[iTime][1])) + "%");
      
      if(100 * W11array[iTime][0]/(W11array[iTime][0]+W11array[iTime][1]) > 60 || 100 * W11array[iTime][0]/(W11array[iTime][0]+W11array[iTime][1]) < 40)Print((string)iTime +"," + "[W11]"+(string)W11array[iTime][0] +"," +(string)W11array[iTime][1] + ","+ (string)(100 * W11array[iTime][0]/(W11array[iTime][0]+W11array[iTime][1])) + "%");
      if(100 * W12array[iTime][0]/(W12array[iTime][0]+W12array[iTime][1]) > 60 || 100 * W12array[iTime][0]/(W12array[iTime][0]+W12array[iTime][1]) < 40)Print((string)iTime +"," + "[W12]"+(string)W12array[iTime][0] +"," +(string)W12array[iTime][1] + ","+ (string)(100 * W12array[iTime][0]/(W12array[iTime][0]+W12array[iTime][1])) + "%");
      if(100 * W21array[iTime][0]/(W21array[iTime][0]+W21array[iTime][1]) > 60 || 100 * W21array[iTime][0]/(W21array[iTime][0]+W21array[iTime][1]) < 40)Print((string)iTime +"," + "[W21]"+(string)W21array[iTime][0] +"," +(string)W21array[iTime][1] + ","+ (string)(100 * W21array[iTime][0]/(W21array[iTime][0]+W21array[iTime][1])) + "%");
      if(100 * W22array[iTime][0]/(W22array[iTime][0]+W22array[iTime][1]) > 60 || 100 * W22array[iTime][0]/(W22array[iTime][0]+W22array[iTime][1]) < 40)Print((string)iTime +"," + "[W22]"+(string)W22array[iTime][0] +"," +(string)W22array[iTime][1] + ","+ (string)(100 * W22array[iTime][0]/(W22array[iTime][0]+W22array[iTime][1])) + "%");
      if(100 * W13array[iTime][0]/(W13array[iTime][0]+W13array[iTime][1]) > 60 || 100 * W13array[iTime][0]/(W13array[iTime][0]+W13array[iTime][1]) < 40)Print((string)iTime +"," + "[W13]"+(string)W13array[iTime][0] +"," +(string)W13array[iTime][1] + ","+ (string)(100 * W13array[iTime][0]/(W13array[iTime][0]+W13array[iTime][1])) + "%");
      if(100 * W23array[iTime][0]/(W23array[iTime][0]+W23array[iTime][1]) > 60 || 100 * W23array[iTime][0]/(W23array[iTime][0]+W23array[iTime][1]) < 40)Print((string)iTime +"," + "[W23]"+(string)W23array[iTime][0] +"," +(string)W23array[iTime][1] + ","+ (string)(100 * W23array[iTime][0]/(W23array[iTime][0]+W23array[iTime][1])) + "%");
      if(100 * W31array[iTime][0]/(W31array[iTime][0]+W31array[iTime][1]) > 60 || 100 * W31array[iTime][0]/(W31array[iTime][0]+W31array[iTime][1]) < 40)Print((string)iTime +"," + "[W31]"+(string)W31array[iTime][0] +"," +(string)W31array[iTime][1] + ","+ (string)(100 * W31array[iTime][0]/(W31array[iTime][0]+W31array[iTime][1])) + "%");
      if(100 * W32array[iTime][0]/(W32array[iTime][0]+W32array[iTime][1]) > 60 || 100 * W32array[iTime][0]/(W32array[iTime][0]+W32array[iTime][1]) < 40)Print((string)iTime +"," + "[W32]"+(string)W32array[iTime][0] +"," +(string)W32array[iTime][1] + ","+ (string)(100 * W32array[iTime][0]/(W32array[iTime][0]+W32array[iTime][1])) + "%");
      if(100 * W33array[iTime][0]/(W33array[iTime][0]+W33array[iTime][1]) > 60 || 100 * W33array[iTime][0]/(W33array[iTime][0]+W33array[iTime][1]) < 40)Print((string)iTime +"," + "[W33]"+(string)W33array[iTime][0] +"," +(string)W33array[iTime][1] + ","+ (string)(100 * W33array[iTime][0]/(W33array[iTime][0]+W33array[iTime][1])) + "%");
      if(100 * W41array[iTime][0]/(W41array[iTime][0]+W41array[iTime][1]) > 60 || 100 * W41array[iTime][0]/(W41array[iTime][0]+W41array[iTime][1]) < 40)Print((string)iTime +"," + "[W41]"+(string)W41array[iTime][0] +"," +(string)W41array[iTime][1] + ","+ (string)(100 * W41array[iTime][0]/(W41array[iTime][0]+W41array[iTime][1])) + "%");
      if(100 * W42array[iTime][0]/(W42array[iTime][0]+W42array[iTime][1]) > 60 || 100 * W42array[iTime][0]/(W42array[iTime][0]+W42array[iTime][1]) < 40)Print((string)iTime +"," + "[W42]"+(string)W42array[iTime][0] +"," +(string)W42array[iTime][1] + ","+ (string)(100 * W42array[iTime][0]/(W42array[iTime][0]+W42array[iTime][1])) + "%");
      if(100 * W43array[iTime][0]/(W43array[iTime][0]+W43array[iTime][1]) > 60 || 100 * W43array[iTime][0]/(W43array[iTime][0]+W43array[iTime][1]) < 40)Print((string)iTime +"," + "[W43]"+(string)W43array[iTime][0] +"," +(string)W43array[iTime][1] + ","+ (string)(100 * W43array[iTime][0]/(W43array[iTime][0]+W43array[iTime][1])) + "%");
      if(100 * W14array[iTime][0]/(W14array[iTime][0]+W14array[iTime][1]) > 60 || 100 * W14array[iTime][0]/(W14array[iTime][0]+W14array[iTime][1]) < 40)Print((string)iTime +"," + "[W14]"+(string)W14array[iTime][0] +"," +(string)W14array[iTime][1] + ","+ (string)(100 * W14array[iTime][0]/(W14array[iTime][0]+W14array[iTime][1])) + "%");
      if(100 * W24array[iTime][0]/(W24array[iTime][0]+W24array[iTime][1]) > 60 || 100 * W24array[iTime][0]/(W24array[iTime][0]+W24array[iTime][1]) < 40)Print((string)iTime +"," + "[W24]"+(string)W24array[iTime][0] +"," +(string)W24array[iTime][1] + ","+ (string)(100 * W24array[iTime][0]/(W24array[iTime][0]+W24array[iTime][1])) + "%");
      if(100 * W34array[iTime][0]/(W34array[iTime][0]+W34array[iTime][1]) > 60 || 100 * W34array[iTime][0]/(W34array[iTime][0]+W34array[iTime][1]) < 40)Print((string)iTime +"," + "[W34]"+(string)W34array[iTime][0] +"," +(string)W34array[iTime][1] + ","+ (string)(100 * W34array[iTime][0]/(W34array[iTime][0]+W34array[iTime][1])) + "%");
      if(100 * W44array[iTime][0]/(W44array[iTime][0]+W44array[iTime][1]) > 60 || 100 * W44array[iTime][0]/(W44array[iTime][0]+W44array[iTime][1]) < 40)Print((string)iTime +"," + "[W44]"+(string)W44array[iTime][0] +"," +(string)W44array[iTime][1] + ","+ (string)(100 * W44array[iTime][0]/(W44array[iTime][0]+W44array[iTime][1])) + "%");
    
   }
   Print("終わりました");
   first = false;
   // 計算済みの足の本数を返却
   return rates_total - 1;
}
 double PointToPips(double point)
    {
        return NormalizeDouble(point * 0.1, 1);
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
double PriceToPips(double price, int digits = EMPTY)
 {
     if (digits == EMPTY) digits = Digits;
     return NormalizeDouble(price * MathPow(10, digits - 1), 1);
 }