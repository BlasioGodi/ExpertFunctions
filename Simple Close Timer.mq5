//+------------------------------------------------------------------+
//|                                              SimpleCloseTimer.mq5|
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

//Create an instance of COrderInfo
COrderInfo orderInfo;

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

// If we have no open positions
   if(OrdersTotal()==0)
     {
      //Place a Buy Limit Order if all conditions are met
      trade.BuyLimit(trade_volume,(Bid-(limit_distance*_Point)),_Symbol,Bid-stop_loss*_Point,Bid+take_profit*_Point,ORDER_TIME_GTC,0,NULL);
      
      //Place a Sell Limit Order if all conditions are met
      trade.SellLimit(trade_volume,(Ask+(limit_distance*_Point)),_Symbol,Ask+stop_loss*_Point,Ask-take_profit*_Point,ORDER_TIME_GTC,0,NULL);
     }

// Activate the CheckCloseTimer function
   CheckCloseTimer();

  }// END OF ON-TICK MAIN FUNCTION
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                     CLOSE TIMER FUNCTION                         |
//+------------------------------------------------------------------+
void CheckCloseTimer()
  {
  
  //declare the variables
   uint TotalNumberofDeals = HistoryDealsTotal();
   ulong OrderTicketNumber,OrderSelected = 0;
   long OrderType = 0;
   double OrderProfit = 0;
   string MySymbol = "";
   string MyResult = "";
   string OrderProfitValue = "";

// Go through all orders
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      // Get Order Ticket
      OrderTicketNumber = OrderGetTicket(i);
      
      // Select an order
      OrderSelected = OrderSelect(OrderTicketNumber);
      
      // Get the local time
      datetime MyTime = TimeLocal();

      // Calculate the current hour
      int CurrentHour = GetHour(MyTime);

      // Convert time for output
      string TimeWithSeconds = TimeToString(TimeLocal(),TIME_DATE|TIME_SECONDS);

      // Calculate the order open hour
      int OpeningHour = GetHour(orderInfo.TimeSetup());

      // Convert opening time for output
      string OpeningTimeWithSeconds = TimeToString(orderInfo.TimeSetup(),TIME_DATE|TIME_SECONDS);

      // Calculate the difference between current hour and opening hour
      int Difference = CurrentHour-OpeningHour;

      // Chart Output
      Comment("### Order Ticket: ", OrderSelected,"\n",
      "### Order OpenTime: ", OpeningTimeWithSeconds,"\n",
      "### Order Profit: ", OrderProfit,"\n",
      "### Order LocalTime: ", TimeWithSeconds,"\n",
      "### Order Difference: ", Difference
      );

      // If x hours have passed
      if(Difference>0)
        {
         // If profit is negative
         if(OrderProfit<0)
           {
            // If it is a SELL position
            if(OrderType==ORDER_TYPE_SELL)
               // Close the current sell position
               trade.OrderDelete(OrderSelected);

            // If it is a BUY position
            if(OrderType==ORDER_TYPE_BUY)
               // Close the current sell position
               trade.OrderDelete(OrderSelected);

           }

        }

     } // End of for loop

  } // End of CheckCloseTimer function
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                        GETHOUR FUNCTION                          |
//+------------------------------------------------------------------+
int GetHour(datetime trade_hour)
  {
//DateTime Struct
   MqlDateTime TradeHour;

   TimeToStruct(trade_hour,TradeHour);

   return TradeHour.hour;
   
  }//END OF GETDAY FUNCTION
//+------------------------------------------------------------------+
