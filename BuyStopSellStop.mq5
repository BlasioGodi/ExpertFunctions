//+------------------------------------------------------------------+
//|                                               BuyStopSellStop.mq5|
//|                                      Copyright 2022, Godi Blasio |
//|                                     https://tradersliquidity.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Godi Blasio"
#property link      "https://tradersliquidity.com"
#property version   "1.00"

// include the file Trade.mqh
#include<Trade\Trade.mqh>
#include <Trade\DealInfo.mqh>

//Create an instance of CTrade & CDealInfo
CTrade trade;
CDealInfo dealInfo;

//--User Input Values
input datetime start_date= D'10.11.2022 00:00:00';
input datetime expiry_date = D'10.11.2022 23:59:00';
input int take_profit = 300;
input int limit_distance = 45;
input double trade_volume = 0.01;
input int stop_loss = 200;
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
   
   Comment("#Time: ",current_time,"\n"
           "#Order Profit: ",CheckClosedDeals()
   );

   if(current_time==start_date)
     {
      if((OrdersTotal()==0)&&(PositionsTotal()==0))
        {
         trade.BuyStop(trade_volume,Ask+limit_distance*_Point,_Symbol,(Ask+limit_distance*_Point)-stop_loss*_Point,(Ask+limit_distance*_Point)+take_profit*_Point,ORDER_TIME_SPECIFIED,expiry_date,NULL);
         trade.SellStop(trade_volume,Bid-limit_distance*_Point,_Symbol,(Bid-limit_distance*_Point)+stop_loss*_Point,(Bid-limit_distance*_Point)-take_profit*_Point,ORDER_TIME_SPECIFIED,expiry_date,NULL);
        }
     }
  }// END OF ON-TICK MAIN FUNCTION
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                     CHECK CLOSED DEALS FUNCTION                  |
//+------------------------------------------------------------------+
double CheckClosedDeals()
  {
   HistorySelect(0,TimeCurrent());
   uint     total_Deals      = HistoryDealsTotal();
   ulong    deal_Ticket      = 0;
   double   profit_value     = 0;

   for(uint i = 1; i < total_Deals; i++)
     {
      deal_Ticket = HistoryDealGetTicket(i);

      if(dealInfo.SelectByIndex(i))
        {
         //--Deal Information
         long     deal_entry        =HistoryDealGetInteger(deal_Ticket,DEAL_ENTRY);
         long     deal_type         =HistoryDealGetInteger(deal_Ticket,DEAL_TYPE);
         long     deal_time         =HistoryDealGetInteger(deal_Ticket,DEAL_TIME);
         double   order_profit      =HistoryDealGetDouble(deal_Ticket,DEAL_PROFIT);

         datetime deal_realTime     =(datetime)deal_time;
         
         //Check if the currency pair fits
         if(deal_type==DEAL_TYPE_BUY||deal_type==DEAL_TYPE_SELL)
           {
            if(deal_entry==1)
              {
               profit_value = order_profit;
              }
           }
        }
     }
   return profit_value;
  }//END OF CHECK CLOSED DEALS FUNCTION
//+------------------------------------------------------------------+