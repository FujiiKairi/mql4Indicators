//+------------------------------------------------------------------+
//|                                                      envelop.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
//v2にぼりんじゃーバンドによるトレンド時は取引しないようにした
input int MAGICMA=  20181230;
input double Lots          =0.1;//1ロット十万通貨単位
int jouken=0;






void OnTick()
  {
//---
   if(Bars<100 || IsTradeAllowed()==false){//bars チャートに表示されてるバーの本数 istradeallowed 自動売買が許可されているかどうか　されてるならtrue
   
      Print("ゆるされてない");
       return;
      }
//--- calculate open orders by current symbol
   if(CalculateCurrentOrders(Symbol())==0) CheckForOpen();//ポジションを持っていなければポジションを得る
   else                                    CheckForClose();//ポジションを持っていれば決済する
  }
//+------------------------------------------------------------------+
void CheckForOpen()
{
 
   int    res;
//--- go trading only for first tiks of new bar
   
//--- get Moving Average 
    if(jouken==0){
      double RSIbo=0;
      double idouheikin=0;
      double hyoujun=0;
      double up,down;
      for(int i=0;i<21;i++){
         idouheikin=idouheikin+Close[i];
      }
      idouheikin=idouheikin/21;
      for(int i=0;i<21;i++){
         hyoujun=hyoujun+(Close[i]-idouheikin)*(Close[i]-idouheikin);
      }
      hyoujun=MathSqrt(hyoujun/20);
      up=idouheikin+(2*hyoujun);
      down=idouheikin-(2*hyoujun);
   //--- buy conditions
      if(iBands(Symbol(),0,10,2,0,PRICE_CLOSE,MODE_LOWER,0)>Close[0]&&down>Close[0])
        {
        jouken=1;
         return;
      }
   //--- sell conditions
  

      if(iBands(Symbol(),0,10,2,0,PRICE_CLOSE,MODE_UPPER,0)<Close[0]&&up<Close[0])//open[0]が現在のバーの始値
        {
         jouken=2;
         return;
        }
     }
     if(jouken==1&&Volume[0]==1){
      res=OrderSend(Symbol(),OP_BUY,Lots,Ask,3,0,0,"",MAGICMA,0,Red);//戻り値はチケット番号
      jouken=0;
         return;
     }
     if(jouken==2&&Volume[0]==1){
      res=OrderSend(Symbol(),OP_BUY,Lots,Ask,3,0,0,"",MAGICMA,0,Red);//戻り値はチケット番号
      jouken=0;
         return;
     }
     
    
}
void CheckForClose(){
//---
   for(int i=0;i<OrdersTotal();i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderMagicNumber()!=MAGICMA || OrderSymbol()!=Symbol()) continue;
      //--- check order type 
      if(OrderType()==OP_BUY)
        {
         if(Volume[0]==1)
           {
            if(!OrderClose(OrderTicket(),OrderLots(),Bid,3,White))
               Print("OrderClose error ",GetLastError());
           }
         break;
        }
      if(OrderType()==OP_SELL)
        {
         if(Volume[0]==1)
           {
            if(!OrderClose(OrderTicket(),OrderLots(),Ask,3,White))
               Print("OrderClose error ",GetLastError());
           }
         break;
        }
     }
}
int CalculateCurrentOrders(string symbol)//symbol通貨ペア名 オープンポジション数計算関数
  {
   int buys=0,sells=0;
//---
   for(int i=0;i<OrdersTotal();i++)//orderstotal保有ポジションと待機注文の合計
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      //orderselect（インデックス、インデックスを使用して注文する、現在保有している注文）注文出す。注文が成功したらtrue
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==MAGICMA)//ordersymbol()通貨ペア名を取得
        {
         if(OrderType()==OP_BUY)  buys++;
         if(OrderType()==OP_SELL) sells++;
        }
     }
//--- return orders volume
   if(buys>0) return(buys);
   else       return(-sells);
   }