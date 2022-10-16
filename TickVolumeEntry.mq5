//include the file Trade.mqh
#include<Trade\Trade.mqh>
#include <ExpertFunctions.mqh>

//Create an instance of CTrade
CTrade trade;

//Create an instance of ExpertFunctions
ExpertFunctions expert;

input int DesiredProfitinPips = 50;
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
extern vector Levels {1675,1670,1665};

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

// Get bar opening price array
   MqlRates BarPrice[];

// Sort the array data from zero
   ArraySetAsSeries(BarPrice,true);

// Get data within the array
   CopyRates(_Symbol,PERIOD_H1,0,3,BarPrice);

// Tick volume of the candlestick
   long TickVolume = BarPrice[0].tick_volume;

//+------------------------------------------------------------------+
// INSERT THE TRADE SIGNAL TEST CONDITIONS HERE

//Execute trades between the 12th min and 50th min
   if(expert.TimeFrame(StartTime,EndTime)=="Perfect Session" && TickVolume > 23000)
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
