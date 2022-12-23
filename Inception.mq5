//Header Files
#include<Trade\Trade.mqh>
#include<ExpertFunctions.mqh>
#include <Trade\DealInfo.mqh>

//Create Class instances
CDealInfo dealInfo;
CTrade trade;
ExpertFunctions expert;


//enum ENUM_TIMERS
//  {
//   ZEROTOTHREE_YES = 1,
//   ZEROTOTHREE_NO = 2,
//
//   THREETOFIVE_YES = 3,
//   THREETOFIVE_NO = 4,
//
//   FIVETOTEN_YES = 5,
//   FIVETOTEN_NO = 6,
//
//   TENTOFIFTEEN_YES = 7,
//   TENTOFIFTEEN_NO = 8,
//
//  };

extern int pip_profit = 0;
extern int pip_loss = 0;
extern int count = 0;

input double LotSize = 0.0;
input int total_layers = 10;

input int Time_0_to_5 = 0;
input int Time_5_to_10 = 0;
input int Time_10_to_15 = 0;
input int Time_15_and_above = 0;

//+------------------------------------------------------------------+
//|                    ON-TICK MAIN FUNCTION                         |
//+------------------------------------------------------------------+
void OnTick()
  {
// Declarations
   int timer_value = 0;

// Get the Ask and Bid price
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

// IDENTIFY TRADE ENTRY POINT (WORK IN PROGRESS)
   if(expert.TradingCandle(count)=="BUY" && CheckClosedDeals()==true && PositionsTotal()==0 && OrdersTotal()==0)
     {
      trade.Buy(LotSize,_Symbol,Bid,0,0,NULL);
     }
   else
      if(expert.TradingCandle(count)=="SELL" && CheckClosedDeals()==true && PositionsTotal()==0 && OrdersTotal()==0)
        {
         trade.Sell(LotSize,_Symbol,Ask,0,0,NULL);
        }

   CheckClosedDeals();

// TRADE EXECUTION PROCESS
   if(PositionSelect(_Symbol)==true)
     {
      // Select all open positions
      for(int i=PositionsTotal()-1; i>=0; i--)
        {
         datetime position_time = (datetime)PositionGetInteger(POSITION_TIME);

         timer_value = expert.EntryTimer(position_time);

         if(timer_value>=0 && timer_value<=3)
           {
            //Comment("Trade is between 0-3mins");
            pip_profit = 50;
           }
         else
            if(timer_value>=3 && timer_value<=5)
              {
               //Comment("Trade is between 3-5mins");
               pip_profit = 50;

              }
            else
               if(timer_value>=5 && timer_value<=10)
                 {
                  //Comment("Trade is between 5-10mins");
                  pip_profit = 20;

                  //Activate the Position Pip loss function
                  expert.PositionPipLoss(Time_5_to_10);
                 }
               else
                  if(timer_value>=10 && timer_value<=15)
                    {
                     //Comment("Trade is between 10-15mins");
                     pip_profit = 10;

                     //Activate the Position Pip loss function
                     expert.PositionPipLoss(Time_10_to_15);
                    }
                  else
                     if(timer_value>=15)
                       {
                        //Comment("Trade is greater than 15mins");
                        pip_profit = 10;

                        //Activate the Position Pip loss function
                        expert.PositionPipLoss(Time_15_and_above);
                       }

         // Activate the PositionPipProfit function
         expert.PositionPipProfit(pip_profit);
         
        }
     }

  }// END OF THE ON-TICK MAIN FUNCTION
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|      CHECK CLOSED DEALS FUNCTION (CORRECT DAILY DIFFERENCE       |
//+------------------------------------------------------------------+
bool CheckClosedDeals()
  {
   HistorySelect(0,TimeCurrent());
   uint     total_Deals      = HistoryDealsTotal();
   ulong    deal_Ticket      = 0;
   bool value = false;

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
         datetime time_local = TimeCurrent();

         MqlDateTime CurrentTime;
         MqlDateTime DealTime;

         TimeToStruct(time_local,CurrentTime);
         TimeToStruct(deal_realTime,DealTime);

         int deal_hours = DealTime.hour;
         int deal_mins = DealTime.min;

         int current_hours = CurrentTime.hour;
         int current_mins = CurrentTime.min;

         int hour_diff = current_hours - deal_hours;
         int min_diff  = (current_mins+(hour_diff*60)) - deal_mins;

         //Check if the currency pair fits
         if(deal_type==DEAL_TYPE_BUY||deal_type==DEAL_TYPE_SELL)
           {
            if(deal_entry==1)
              {
               if(min_diff>=15)
                  value = true;
               else
                  value = false;
              }
           }
        }
     }
   return value;
  }
