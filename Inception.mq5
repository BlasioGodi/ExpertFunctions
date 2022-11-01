//include the file Trade.mqh
#include<Trade\Trade.mqh>
#include <ExpertFunctions.mqh>

//Create an instance of CTrade
CTrade trade;

//Create an instance of ExpertFunctions
ExpertFunctions expert;

enum ENUM_TIMERS
  {
   ZEROTOTHREE_YES = 1,
   ZEROTOTHREE_NO = 2,

   THREETOFIVE_YES = 3,
   THREETOFIVE_NO = 4,

   FIVETOTEN_YES = 5,
   FIVETOTEN_NO = 6,

   TENTOFIFTEEN_YES = 7,
   TENTOFIFTEEN_NO = 8,

  };

extern int pip_profit = 0;
extern int pip_loss = 0;

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

// IDENTIFY TRADE ENTRY POINT
   expert.TradingCandle();


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
            Comment("Trade is between 0-3mins");
            pip_profit = 50;
           }
         else
            if(timer_value>=3 && timer_value<=5)
              {
               Comment("Trade is between 3-5mins");
               pip_profit = 50;
              }
            else
               if(timer_value>=5 && timer_value<=10)
                 {
                  Comment("Trade is between 5-10mins");
                  pip_profit = 20;
                  pip_loss = 180;

                  //Activate the Position Pip loss function
                  expert.PositionPipLoss(pip_loss);
                 }
               else
                  if(timer_value>=10 && timer_value<=15)
                    {
                     Comment("Trade is between 10-15mins");
                     pip_profit = 10;
                     pip_loss = 180;

                     //Activate the Position Pip loss function
                     expert.PositionPipLoss(pip_loss);
                    }
                  else
                     if(timer_value>=15)
                       {
                        Comment("Trade is greater than 15mins");
                        pip_profit = 10;
                        pip_loss = 200;

                        //Activate the Position Pip loss function
                        expert.PositionPipLoss(pip_loss);
                       }

         // Activate the PositionPipProfit function
         expert.PositionPipProfit(pip_profit);
        }
     }

  }// END OF THE ON-TICK MAIN FUNCTION
//+------------------------------------------------------------------+
