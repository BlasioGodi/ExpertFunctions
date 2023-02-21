//+------------------------------------------------------------------+
//|                                              PositionModifier.mq5|
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

//--User Input Values
input datetime start_date= D'06.05.2021 13:59:50';
input datetime expiry_date = D'06.05.2021 15:00:00';
input int take_profit;
input int limit_distance;
input double trade_volume;
input int stop_loss;
//--

//+------------------------------------------------------------------+
//|                    ON-TICK MAIN FUNCTION                         |
//+------------------------------------------------------------------+
void OnTick()
  {
// Get the Ask and Bid Prices
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

   if((OrdersTotal()==0)&&(PositionsTotal()==0))

      trade.Buy(trade_volume,NULL,Ask,(Ask-stop_loss*_Point),(Ask+take_profit*_Point),NULL);

   ChangePositionSize(Ask);

  }
//+------------------------------------------------------------------+
//|                    POSITION SIZE FUNCTION                        |
//+------------------------------------------------------------------+
void ChangePositionSize(double Ask)
  {

// Calculte the balance
   double Balance = AccountInfoDouble(ACCOUNT_BALANCE);

// Calculate the equity
   double Equity = AccountInfoDouble(ACCOUNT_EQUITY);

// From the number of positions count down to zero and go through all Open Positions.
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      // Get the position currency pair
      string symbol = PositionGetSymbol(i);

      // If chart equals position currency pair
      if(_Symbol == symbol)
        {
         //Get the Ticket Number
         ulong PositionTicket = PositionGetInteger(POSITION_TICKET);

         //Get the Position Direction
         long PositionDirection = PositionGetInteger(POSITION_TYPE);

         //If it is a buy position
         if(PositionDirection == POSITION_TYPE_SELL)

            if(Balance < (Equity+10*_Point))
               trade.PositionClosePartial(PositionTicket,0.09,-1);
        }
     }//End of the for loop
  } //END OF THE POSITON SIZE FUNCTION
//+------------------------------------------------------------------+
