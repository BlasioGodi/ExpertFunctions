//+------------------------------------------------------------------+
//|                                            SimplePositionInfo.mq5|
//|                                      Copyright 2022, Godi Blasio |
//|                                     https://tradersliquidity.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Godi Blasio"
#property link      "https://tradersliquidity.com"
#property version   "1.00"

// include the file Trade.mqh
#include<Trade\Trade.mqh>
#include <ExpertFunctions.mqh>

//Create an instance of CTrade
CTrade trade;

//Create an instance of ExpertFunctions
ExpertFunctions expert;

//+------------------------------------------------------------------+
//|                   SIMPLE POSITION INFORMATION                    |
//+------------------------------------------------------------------+
void OnTick()
  {
  
  // Get the ask price
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);

// Get the bid price
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

if((PositionsTotal()==0)&&(OrdersTotal()==0))   
   trade.Buy(0.2,_Symbol,Bid,(Bid-(300*_Point)),Bid+600*_Point,NULL);
   
  expert.SimplePositionDetails(); 
   
  
  }// END OF THE GETPROFITDETAILS FUNCTION
//+------------------------------------------------------------------+
