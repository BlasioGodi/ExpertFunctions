//+------------------------------------------------------------------+
//|                                                     RSI_ALERT.mq5|
//|                                      Copyright 2023, Godi Blasio |
//|                                     https://tradersliquidity.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Godi Blasio"
#property link      "https://xauman.com"
#property version   "1.00"

//include the file Trade.mqh
#include<Trade\Trade.mqh>
#include <ExpertFunctions.mqh>

//Create an instance of CTrade
CTrade trade;

//Create an instance of ExpertFunctions
ExpertFunctions expert;

//User input variables
input double top_rsi = 0;
input double bottom_rsi = 0;

input int pip_profit = 300;
input int pip_loss = 300;

input ENUM_LINE_STYLE lineStyle = STYLE_SOLID;
input ENUM_TIMEFRAMES trade_period = PERIOD_H1;

extern int counter = 0;

//+------------------------------------------------------------------+
//|                    ON-TICK MAIN FUNCTION                         |
//+------------------------------------------------------------------+
void OnTick()
  {

// Get the Ask and Bid price
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

   if(expert.CheckRSIValue(top_rsi,bottom_rsi, counter,trade_period)=="BUY"&&(PositionsTotal()==0)&&(OrdersTotal()==0))
     {
      trade.Buy(LotSize,_Symbol,Bid,0,0,NULL);
     }


   if(expert.CheckRSIValue(top_rsi,bottom_rsi, counter,trade_period)=="SELL"&&(PositionsTotal()==0)&&(OrdersTotal()==0))
     {
      trade.Sell(LotSize,_Symbol,Ask,0,0,NULL);
     }

// Activate the PositionPipProfit function
   expert.PositionPipProfit(pip_profit);

// Activate the PositionPipLoss function
   expert.PositionPipLoss(pip_loss);


  }
//+------------------------------------------------------------------+
