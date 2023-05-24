//+------------------------------------------------------------------+
//|                                                     RSI_ALERT.mq5|
//|                                      Copyright 2023, Godi Blasio |
//|                                     https://tradersliquidity.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Godi Blasio"
#property link      "https://tradersliquidity.com"
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

input int lineWidth = 1;
input ENUM_LINE_STYLE lineStyle = STYLE_SOLID;
input ENUM_TIMEFRAMES trade_period = PERIOD_H1;


//+------------------------------------------------------------------+
//|                    ON-TICK MAIN FUNCTION                         |
//+------------------------------------------------------------------+
void OnTick()
  {

// Get the Ask and Bid price
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);


//Variable declaration
   string signal = "";

//Create array for RSI Values
   double RSIArray[];
   int myRSIDefinition=iRSI(_Symbol,_Period,14,PRICE_CLOSE);

//Sort array values and fill the array
   ArraySetAsSeries(RSIArray,true);
   CopyBuffer(myRSIDefinition,0,0,3,RSIArray);

//Get the RSI Value
   double myRSIValue = NormalizeDouble(RSIArray[0],2);

   string time_frame = EnumToString(trade_period);
   if(myRSIValue>top_rsi)
      signal="SELL";
   else
     {
      if(myRSIValue<bottom_rsi)
        {
         signal="BUY";
         Alert(time_frame,": Check Charts");
        }

      else
        {
         signal="No signal, Wait";
        }
     }
//Comment and check
   Comment("MyRSI_Value: ",myRSIValue,"\n",
           "MySignal: ",signal,"\n",
           "TimeFrame: ", time_frame);

  }
//+------------------------------------------------------------------+
