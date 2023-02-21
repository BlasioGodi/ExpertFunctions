//+------------------------------------------------------------------+
//|                                              SimpleFractalsEA.mq5|
//|                                      Copyright 2022, Godi Blasio |
//|                                     https://tradersliquidity.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Godi Blasio"
#property link      "https://tradersliquidity.com"
#property version   "1.00"

// include the file Trade.mqh
#include<Trade\Trade.mqh>

//Create an instance of CTrade
CTrade trade;

//+------------------------------------------------------------------+
//|                          OnTick Main Function                    |
//+------------------------------------------------------------------+
void OnTick()
  {
// Get the ask price
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);

// Get the bid price
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   
   // We create an empty string for the signal
   string Signal = "";
   
   // create a price array
   MqlRates PriceArray[];
   
   // Sort the array from the current candle downwards
   ArraySetAsSeries(PriceArray,true);
   
   // We fill the array with price data
   int Data = CopyRates(_Symbol,_Period,0,3,PriceArray);
   
   // Create a fractals array
   double UpperFractalsArray[], LowerFractalsArray[];
   
   // Defined EA, current candle, 3 candles, save the result
   int FractalsDefinition = iFractals(_Symbol,_Period);
   
   // Sort the array from the current candle downwards
   ArraySetAsSeries(UpperFractalsArray,true);
   ArraySetAsSeries(LowerFractalsArray,true);
   
   // Defined EA, current buffer, current candle, 3 candles, save in array
   CopyBuffer(FractalsDefinition,UPPER_LINE,1,3,UpperFractalsArray);
   CopyBuffer(FractalsDefinition,LOWER_LINE,1,3,LowerFractalsArray);
   
   // Calculate the value for the last candle
   double UpperFractalsValue=UpperFractalsArray[1];
   double LowerFractalsValue=LowerFractalsArray[1];
   
   // Result if value is empty
   if(UpperFractalsValue==EMPTY_VALUE)
   UpperFractalsValue=0;
   
   // Result if value is empty
   if(LowerFractalsValue==EMPTY_VALUE)
   LowerFractalsValue=0;
   
   // If it is going up 
   if(LowerFractalsValue!=0)
   if(LowerFractalsValue<PriceArray[1].low)
   {
   Signal = "buy";
   }
   
      // If it is going down
   if(UpperFractalsValue!=0)
   if(UpperFractalsValue>PriceArray[1].high)
   {
   Signal = "sell";
   }
   
   // Sell 10 Microlot
   if (Signal=="sell"&&PositionsTotal()<1)
   trade.Sell(0.1,NULL,Bid,(Bid+200*_Point),(Bid-150*_Point),NULL);
   
   // Buy 10 Microlot
   if (Signal=="buy"&&PositionsTotal()<1)
   trade.Buy(0.1,NULL,Ask,(Ask-200*_Point),(Ask+150*_Point),NULL);
   
   // Chart Output
   Comment(
            "The signal is : ", Signal, "\n",
               "UpperFractals Value: ", UpperFractalsValue, "\n",
               "LowerFractals Value: ", LowerFractalsValue
           
   );  
   
  }
//+------------------------------------------------------------------+
