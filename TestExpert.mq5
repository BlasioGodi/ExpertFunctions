//include the file Trade.mqh
#include<Trade\Trade.mqh>
#include <ExpertFunctions.mqh>

//Create an instance of CTrade
CTrade trade;

//Create an instance of ExpertFunctions
ExpertFunctions expert;

input int DesiredProfitinPips = 100;
input int ZoneDeviation = 0;
input double LotSize = 0;
input int USATimeStart = 15;
input int USATimeEnd = 19;

input int Min12 = 12;
input int Min50 = 50;

input int lineWidth = 1;
input ENUM_LINE_STYLE lineStyle = STYLE_SOLID;
input color lineColor = clrMediumSpringGreen;

extern int count = 0;
extern vector Levels {1860,1850,1840};

extern int candleOfInterest = 0;

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
   CopyRates(_Symbol,PERIOD_CURRENT,0,3,BarPrice);

// Tick volume of the candlestick
   long TickVolume = BarPrice[0].tick_volume;

// Current time of the candlestick
   datetime BarTime = BarPrice[0].time;

//if(TickVolume > 32000)
//  {
//   candleOfInterest++;

   Comment("### The tick volume is ", TickVolume,"\n"
           "### This is a candle of interest. Count: ", candleOfInterest,"\n"
           "### The time recorded is: ", BarTime);

//      if((PositionsTotal()==0)&&(OrdersTotal()==0))
//        {
//         trade.Buy(LotSize,_Symbol,Bid,(Bid-(220*_Point)),Bid+800*_Point,NULL);
//        }
//
//     }

// Activate the PositionPipProfit function
   expert.PositionPipProfit(DesiredProfitinPips);

  }// END OF THE ON-TICK MAIN FUNCTION
//+------------------------------------------------------------------+
