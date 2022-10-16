// include the file Trade.mqh
#include<Trade\Trade.mqh>
#include <ExpertFunctions.mqh>

//Create an instance of CTrade
CTrade trade;

//Create an instance of ExpertFunctions
ExpertFunctions expert;

extern int count = 0;

input int DesiredProfitinPips = 75;
input double LevelCheck = 0;
input int ZoneDeviation = 0;
input double LotSize = 0;

input int lineWidth = 1;
input ENUM_LINE_STYLE lineStyle = STYLE_SOLID;
input color lineColor = clrMediumSpringGreen;



//+------------------------------------------------------------------+
//|               OBJECT LINE INITIALIZATION FUNCTION                |
//+------------------------------------------------------------------+
int OnInit()
  {

//Create 1st Object Line
   expert.CreateObjectLine(LevelCheck,ZoneDeviation,lineColor,lineStyle,lineWidth);

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
//|                                                                  |
//+------------------------------------------------------------------+
void OnTick()
  {

// Get the Ask price
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);

// Get the Bid price
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

// Test trade
   if((expert.ZoneSignal(LevelCheck,ZoneDeviation,count)==150)&&(PositionsTotal()==0)&&(OrdersTotal()==0))
      trade.Buy(LotSize,_Symbol,Bid,(Bid-(300*_Point)),Bid+300*_Point,NULL);

// Test the function here
   expert.PositionPipProfit(DesiredProfitinPips);

  }
//+------------------------------------------------------------------+
