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

// Get the Ticket Number
   ulong position_ticket = PositionGetInteger(POSITION_TICKET);

// Get the local date and time
   datetime current_time = TimeLocal();
   
   Comment(current_time);

   if(current_time==start_date)
     {
      if((OrdersTotal()==0)&&(PositionsTotal()==0))
        {
         trade.BuyStop(trade_volume,Ask+limit_distance*_Point,_Symbol,Ask-stop_loss*_Point,Ask+take_profit*_Point,ORDER_TIME_SPECIFIED,expiry_date,NULL);
        }
     }
  }// END OF ON-TICK MAIN FUNCTION
//+------------------------------------------------------------------+