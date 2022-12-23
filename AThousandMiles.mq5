//include the file Trade.mqh
#include<Trade\Trade.mqh>
#include <ExpertFunctions.mqh>

//Create an instance of CTrade
CTrade trade;

//Create an instance of ExpertFunctions
ExpertFunctions expert;

//User input variables
input int DesiredProfitinPips = 500;
input int pip_loss = 200;
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

//-- Line Colours
color lineColor1 = clrMediumSpringGreen;
color lineColor2 = clrBeige;
color lineColor3 = clrMagenta;
color lineColor4 = clrYellow;
color lineColor5 = clrBlueViolet;
color lineColor6 = clrRed;


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
   expert.CreateObjectLine(Trading_Lvl1,ZoneDeviation,lineColor1,lineStyle,lineWidth,names.Name1);
   expert.CreateObjectLine(Trading_Lvl2,ZoneDeviation,lineColor2,lineStyle,lineWidth,names.Name2);
   expert.CreateObjectLine(Trading_Lvl3,ZoneDeviation,lineColor3,lineStyle,lineWidth,names.Name3);
   expert.CreateObjectLine(Trading_Lvl4,ZoneDeviation,lineColor4,lineStyle,lineWidth,names.Name4);
   expert.CreateObjectLine(Trading_Lvl5,ZoneDeviation,lineColor5,lineStyle,lineWidth,names.Name5);
   expert.CreateObjectLine(Trading_Lvl6,ZoneDeviation,lineColor6,lineStyle,lineWidth,names.Name6);
   
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

// Get the PositionType (Either buy or sell)
   ulong PositionType = PositionGetInteger(POSITION_TYPE);

// Set the timeframe periods  
   ENUM_TIMEFRAMES period_m1 = PERIOD_M1;
   ENUM_TIMEFRAMES period_m5 = PERIOD_M5;
   ENUM_TIMEFRAMES period_m15 = PERIOD_M15;
   ENUM_TIMEFRAMES period_m30 = PERIOD_M30;
   ENUM_TIMEFRAMES period_h1 = PERIOD_H1;
   ENUM_TIMEFRAMES period_h4 = PERIOD_H4;
   ENUM_TIMEFRAMES period_d1 = PERIOD_D1;


//+------------------------------------------------------------------ +
// INSERT THE TRADE SIGNAL TEST CONDITIONS HERE

// Execute trades between the 12th min and 50th min
   if(expert.TimeFrame(StartTime,EndTime)=="Perfect Session" && expert.LapsedTimerEntry(Min12,Min50) == true)
     {
      Comment("#Trade Direction: ", expert.MarketDirection(trade_period),"\n"
              "#M1-Chart Direction: ", expert.MarketDirection(period_m1),"\n"
              "#M5-Chart Direction: ", expert.MarketDirection(period_m5),"\n"
              "#M15-Chart Direction: ", expert.MarketDirection(period_m15),"\n"
              "#M30-Chart Direction: ", expert.MarketDirection(period_m30),"\n"
              "#H1-Chart Direction: ", expert.MarketDirection(period_h1),"\n"
              "#H4-Chart Direction: ", expert.MarketDirection(period_h4),"\n"
              "#D1-Chart Direction: ", expert.MarketDirection(period_d1)
             );
      // Check if price is within the trading zone
      if(expert.ExpertZone(Levels,ZoneDeviation,count,trade_period)>=1 && expert.ExpertZone(Levels,ZoneDeviation,count,trade_period)<=50 &&(PositionsTotal()==0)&&(OrdersTotal()==0))
        {
         // Buy trade at Support Level
         if(Bid<expert.Lows(trade_period)+(25*_Point) && expert.PriceZone(Levels,ZoneDeviation,Ask,trade_period)==true && expert.MarketDirection(trade_period) == "SELL")
            trade.Buy(LotSize,_Symbol,Bid,0,0,NULL);

         // Sell trade at Resistance Level
         if(Ask>expert.Highs(trade_period)-(25*_Point) && expert.PriceZone(Levels,ZoneDeviation,Ask,trade_period)==true && expert.MarketDirection(trade_period) == "BUY")
            trade.Sell(LotSize,_Symbol,Ask,0,0,NULL);
        }
     }
// Activate the PositionPipProfit function
   expert.PositionPipProfit(DesiredProfitinPips);
   
   // Activate the PositionPipProfit function
   expert.PositionPipLoss(pip_loss);
   
   
   


// INSERT THE TRADE SIGNAL TEST CONDITIONS HERE
//+------------------------------------------------------------------+


  }// END OF THE ON-TICK MAIN FUNCTION
//+------------------------------------------------------------------+
