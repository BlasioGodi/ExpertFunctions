//include the file Trade.mqh
#include<Trade\Trade.mqh>
#include <ExpertFunctions.mqh>

//Create an instance of CTrade
CTrade trade;

//Create an instance of ExpertFunctions
ExpertFunctions expert;

//User input variables
input int DesiredProfitinPips = 50;
input double Trading_Lvl1 = 0;
input double Trading_Lvl2 = 0;
input double Trading_Lvl3 = 0;
input double Trading_Lvl4 = 0;
input double Trading_Lvl5 = 0;
input double Trading_Lvl6 = 0;

input int ZoneDeviation = 0;
input double LotSize = 0;
input int StartTime = 15;
input int EndTime = 19;

input int Min12 = 12;
input int Min50 = 50;

input int lineWidth = 1;
input ENUM_LINE_STYLE lineStyle = STYLE_SOLID;
input color lineColor = clrMediumSpringGreen;

input ENUM_TIMEFRAMES trade_period = PERIOD_M1;

extern int count = 0;
extern vector Levels {Trading_Lvl1,Trading_Lvl2,Trading_Lvl3,Trading_Lvl4,Trading_Lvl5,Trading_Lvl6};

//Temporary Code Measure to draw lines using struct
struct LineName
  {
   string            Name1;
   string            Name2;
   string            Name3;
   string            Name4;
   string            Name5;
   string            Name6;
  };


//+------------------------------------------------------------------+
//|               OBJECT LINE INITIALIZATION FUNCTION                |
//+------------------------------------------------------------------+
int OnInit()
  {
// struct LineName
   LineName names;
   names.Name1 = "A";
   names.Name2 = "B";
   names.Name3 = "C";
   names.Name4 = "D";
   names.Name5 = "E";
   names.Name6 = "F";

//Create 1st Object Line
   expert.CreateObjectLine(Trading_Lvl1,ZoneDeviation,lineColor,lineStyle,lineWidth,names.Name1);
   expert.CreateObjectLine(Trading_Lvl2,ZoneDeviation,lineColor,lineStyle,lineWidth,names.Name2);
   expert.CreateObjectLine(Trading_Lvl3,ZoneDeviation,lineColor,lineStyle,lineWidth,names.Name3);
   expert.CreateObjectLine(Trading_Lvl4,ZoneDeviation,lineColor,lineStyle,lineWidth,names.Name4);
   expert.CreateObjectLine(Trading_Lvl5,ZoneDeviation,lineColor,lineStyle,lineWidth,names.Name5);
   expert.CreateObjectLine(Trading_Lvl6,ZoneDeviation,lineColor,lineStyle,lineWidth,names.Name6);
   
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//lv.Delete();
//dvH.Delete();
//dvL.Delete();
  }

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
      Comment("Market Direction: ", expert.MarketDirection(trade_period));
      // Check if price is within the trading zone
      if(expert.ExpertZone(Levels,ZoneDeviation,count,trade_period)>=1 && expert.ExpertZone(Levels,ZoneDeviation,count,trade_period)<=50 &&(PositionsTotal()==0)&&(OrdersTotal()==0))
        {
         // Buy trade at Support Level
         if(Bid<expert.Lows(trade_period)+(25*_Point) && expert.PriceZone(Levels,ZoneDeviation,Ask,trade_period)==true && expert.MarketDirection(trade_period) == "SELL")
            trade.Buy(LotSize,_Symbol,Bid,(Bid-(220*_Point)),Bid+220*_Point,NULL);

         // Sell trade at Resistance Level
         if(Ask>expert.Highs(trade_period)-(25*_Point) && expert.PriceZone(Levels,ZoneDeviation,Ask,trade_period)==true && expert.MarketDirection(trade_period) == "BUY")
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
