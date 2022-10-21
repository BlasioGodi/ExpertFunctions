//include the file Trade.mqh
#include<Trade\Trade.mqh>
#include <ExpertFunctions.mqh>

//Create an instance of CTrade
CTrade trade;

//Create an instance of ExpertFunctions
ExpertFunctions expert;

input int DesiredProfitinPips = 50;
input double Trading_Lvl1 = 0;
input double Trading_Lvl2 = 0;
input double Trading_Lvl3 = 0;
input double Trading_Lvl4 = 0;

input int ZoneDeviation = 0;
input double LotSize = 0;
input int StartTime = 15;
input int EndTime = 19;

input int Min12 = 12;
input int Min50 = 50;

input int lineWidth = 1;
input ENUM_LINE_STYLE lineStyle = STYLE_SOLID;
input color lineColor = clrMediumSpringGreen;

extern int count = 0;
extern vector Levels {Trading_Lvl1,Trading_Lvl2,Trading_Lvl3,Trading_Lvl4};

//+------------------------------------------------------------------+
//|                    ON-TICK MAIN FUNCTION                         |
//+------------------------------------------------------------------+
void OnTick()
  {
// Get the ask price
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);

// Get the bid price
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

//Get the PositionType (Either buy or sell)
   ulong PositionType = PositionGetInteger(POSITION_TYPE);

//+------------------------------------------------------------------ +
// INSERT THE TRADE SIGNAL TEST CONDITIONS HERE

//Execute trades between the 12th min and 50th min
   if(expert.TimeFrame(StartTime,EndTime)=="Perfect Session" && expert.LapsedTimerEntry(Min12,Min50) == true)
     {
      // Check if price is within the trading zone
      if(expert.ExpertZone(Levels,ZoneDeviation,count)>=1 && expert.ExpertZone(Levels,ZoneDeviation,count)<=50 &&(PositionsTotal()==0)&&(OrdersTotal()==0))
        {
         // Buy Limit at support level
         if(Bid<expert.Lows()+(50*_Point) && expert.PriceZone(Levels,ZoneDeviation,Ask)==true && expert.MarketDirection() == "SELL")
            trade.Buy(LotSize,_Symbol,Bid,(Bid-(220*_Point)),Bid+220*_Point,NULL);

         // Sell limit at resistance level
         if(Ask>expert.Highs()-(50*_Point) && expert.PriceZone(Levels,ZoneDeviation,Ask)==true && expert.MarketDirection() == "BUY")
            trade.Sell(LotSize,_Symbol,Ask,(Ask+(220*_Point)),Ask-220*_Point,NULL);

        }
     }
// Activate the PositionPipProfit function
   expert.PositionPipProfit(DesiredProfitinPips);

// Rate of change of price

// INSERT THE TRADE SIGNAL TEST CONDITIONS HERE
//+------------------------------------------------------------------+


  }// END OF THE ON-TICK MAIN FUNCTION
//+------------------------------------------------------------------+
