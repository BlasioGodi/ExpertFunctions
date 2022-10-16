// include the file Trade.mqh
#include<Trade\Trade.mqh>

//Create an instance of CTrade
CTrade trade;

//+------------------------------------------------------------------+
//|                    ON TICK MAIN FUNCTION                         |
//+------------------------------------------------------------------+
void OnTick()
  {
// Get the ask price
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);

// Get the highest ask price
   double askHigh = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASKHIGH),_Digits);

// Get the lowest ask price
   double askLow = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASKLOW),_Digits);

// Get the bid price
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

// Get the highest bid price
   double bidHigh = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BIDHIGH),_Digits);

// Get the lowest bid price
   double bidLow = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BIDLOW),_Digits);

// Get the Ticket Number
   ulong PositionTicket = PositionGetInteger(POSITION_TICKET);

//Get the PositionType (Either buy or sell)
   ulong PositionType = PositionGetInteger(POSITION_TYPE);

//Call the trade alert function
   TradeAlert();

  }// End of On-Tick Main Function
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|               TRADE ALERT SIGNAL FUNCITON                        |
//+------------------------------------------------------------------+
void TradeAlert()
  {

//Get PriceArray from rates
   MqlRates CurrentPriceArray[];

//Sort data within array starting from zero
   ArraySetAsSeries(CurrentPriceArray,true);

//Get Price data within the array
   int PriceData = CopyRates(_Symbol,PERIOD_H4,0,7,CurrentPriceArray);

//Get the high, low and open prices of the current candlestick
   double highPrice1 = NormalizeDouble(CurrentPriceArray[0].high,_Digits);
   double lowPrice1 = NormalizeDouble(CurrentPriceArray[0].low,_Digits);
   double openPrice1 = NormalizeDouble(CurrentPriceArray[0].open,_Digits);
   double currentPrice1 = NormalizeDouble(CurrentPriceArray[0].close,_Digits);

// Compare the current price against the highest and lowest prices of the candlestick
   if(lowPrice1==currentPrice1)
     {

      Comment("The current price is equal to the lowest bid price: Signal BUY");
      Alert("Check the chart");
     }
   else
      if(highPrice1==currentPrice1)
        {

         Comment("The current price is equal to the highest ask price: Signal SELL");
         Alert("Check the chart");
        }
  }
//+------------------------------------------------------------------+
