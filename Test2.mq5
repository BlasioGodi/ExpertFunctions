// include the file Trade.mqh
#include<Trade\Trade.mqh>
#include <ExpertFunctions.mqh>


//Create an instance of CTrade
CTrade trade;

//Create an instance of COrderInfo
COrderInfo orderInfo;

//Create an instance of CPositionInfo
CPositionInfo positionInfo;

//Create an instance of ExpertFunctions
ExpertFunctions expert;

input int DesiredProfitinPips = 75;
input double LevelCheck = 0;
input double LevelCheck2 = 0;
input int ZoneDeviation = 0;
input double LotSize = 0;

input int lineWidth = 1;
input ENUM_LINE_STYLE lineStyle = STYLE_SOLID;
input color lineColor = clrMediumSpringGreen;

input int Time1 = 12;
input int Time2 = 50;
extern int count = 0;

//Temporary Code Measure to draw lines using struct
struct LineName
  {
   string            Name1;
   string            Name2;
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

//Create 1st Object Line
   expert.CreateObjectLine(LevelCheck,ZoneDeviation,lineColor,lineStyle,lineWidth,names.Name1);
   expert.CreateObjectLine(LevelCheck2,ZoneDeviation,lineColor,lineStyle,lineWidth,names.Name2);

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

//+------------------------------------------------------------------+
// INSERT THE TRADE SIGNAL TEST CONDITIONS HERE

// Check if price is within the First Zone
   if((expert.ZoneSignal(LevelCheck, ZoneDeviation, count)==150)&&(PositionsTotal()==0)&&(OrdersTotal()==0))
     {
      //Buy at support level if the Bid price is between the current low of the candlestick
      //and 30 points above the high of the same candlestick

      if(Bid<expert.Lows()+(30*_Point) && expert.MarketDirection() == "SELL")
         trade.Buy(LotSize,_Symbol,Bid,(Bid-(300*_Point)),Bid+350*_Point,NULL);

      //Sell at resistance level if the Ask price is between the current high of the candlestick
      //and 30 points below the high of the same candlestick

      if(Ask>expert.Highs()-(30*_Point) && expert.MarketDirection() == "BUY")
         trade.Sell(LotSize,_Symbol,Ask,(Ask+(300*_Point)),Ask-350*_Point,NULL);

     }

// Activate the PositionPipProfit function
   expert.PositionPipProfit(DesiredProfitinPips);


// INSERT THE TRADE SIGNAL TEST CONDITIONS HERE
//+------------------------------------------------------------------+


  }// END OF THE ON-TICK MAIN FUNCTION
//+------------------------------------------------------------------+

//(expert.ZoneSignal(LevelCheck, ZoneDeviation, count)==150)&&
