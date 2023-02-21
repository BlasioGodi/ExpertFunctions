//+------------------------------------------------------------------+
//|                                                     KaylaNews.mq5|
//|                                      Copyright 2022, Godi Blasio |
//|                                     https://tradersliquidity.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Godi Blasio"
#property link      "https://tradersliquidity.com"
#property version   "1.00"

// include the file Trade.mqh
#include<Trade\Trade.mqh>
#include <ExpertFunctions.mqh>

//Create an instance of CTrade
CTrade trade;

//Create an instance of ExpertFunctions
ExpertFunctions expert;

input int DesiredProfitinPips = 75;
input int NewsDistance = 1500;
input int ZoneDeviation = 0;
input double LotSize = 0;

input datetime NewsTime = D'06.06.2022 13:59:50';

input int lineWidth = 1;
input ENUM_LINE_STYLE lineStyle = STYLE_SOLID;
input color lineColor = clrMediumSpringGreen;

extern int count = 0;

// Declare the Zonelines
extern double ZonelinesA = 0;
extern double ZonelinesB = 0;

//Temporary Code Measure to draw lines using struct
struct LineName
  {
   string            Name1;
   string            Name2;
  };

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

// Get the local date and time
   datetime OfficialTime = TimeLocal();

// Trade Time
   datetime d1 = NewsTime;

// struct LineName
   LineName lineName;
   lineName.Name1 = "A";
   lineName.Name2 = "B";

//+------------------------------------------------------------------+
// INSERT THE TRADE SIGNAL TEST CONDITIONS HERE

   if(OfficialTime==d1)
     {

      ZonelinesA = Ask+NewsDistance*_Point;
      ZonelinesB = Ask-NewsDistance*_Point;

      expert.CreateObjectLine(ZonelinesA, ZoneDeviation,lineColor,lineStyle,lineWidth,lineName.Name1);
      expert.CreateObjectLine(ZonelinesB, ZoneDeviation,lineColor,lineStyle,lineWidth,lineName.Name2);

      Comment(ZonelinesA);

     }

// Check if price is within the First Zone
   if(expert.ZoneSignal(ZonelinesA,ZoneDeviation,count)>=1 && expert.ZoneSignal(ZonelinesA,ZoneDeviation,count)<=50 &&(PositionsTotal()==0)&&(OrdersTotal()==0))
     {
      // Buy Limit at support level
      if(Bid<expert.Lows()+(50*_Point) && expert.PriceZone(ZonelinesA,ZoneDeviation,Ask)==true && expert.MarketDirection() == "SELL")
         trade.Buy(LotSize,_Symbol,Bid,(Bid-(300*_Point)),Bid+650*_Point,NULL);

      // Sell limit at resistance level
      if(Ask>expert.Highs()-(50*_Point) && expert.PriceZone(ZonelinesA,ZoneDeviation,Ask)==true && expert.MarketDirection() == "BUY")
         trade.Sell(LotSize,_Symbol,Ask,(Ask+(300*_Point)),Ask-650*_Point,NULL);

     }

   if(expert.ZoneSignal(ZonelinesB,ZoneDeviation,count)>=1 && expert.ZoneSignal(ZonelinesB,ZoneDeviation,count)<=50 &&(PositionsTotal()==0)&&(OrdersTotal()==0))
     {
      // Buy Limit at support level
      if(Bid<expert.Lows()+(50*_Point) && expert.PriceZone(ZonelinesB,ZoneDeviation,Ask)==true && expert.MarketDirection() == "SELL")
         trade.Buy(LotSize,_Symbol,Bid,(Bid-(300*_Point)),Bid+650*_Point,NULL);

      // Sell limit at resistance level
      if(Ask>expert.Highs()-(50*_Point) && expert.PriceZone(ZonelinesB,ZoneDeviation,Ask)==true && expert.MarketDirection() == "BUY")
         trade.Sell(LotSize,_Symbol,Ask,(Ask+(300*_Point)),Ask-650*_Point,NULL);

     }

// Activate the PositionPipProfit function
   expert.PositionPipProfit(DesiredProfitinPips);

// INSERT THE TRADE SIGNAL TEST CONDITIONS HERE
//+------------------------------------------------------------------+


  }// END OF THE ON-TICK MAIN FUNCTION
//+------------------------------------------------------------------+
