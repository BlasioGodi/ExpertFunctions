// include the file Trade.mqh
#include<Trade\Trade.mqh>

// include the file Trade.mqh
#include <ExpertFunctions.mqh>

// Include the file ChartObjectsLines.mqh
#include <ChartObjects\ChartObjectsLines.mqh>

//Create an instance of CTrade
CTrade trade;

//Create an instance of ExpertFunctions
ExpertFunctions expert;

//Create an instance of ChartObjects
CChartObjectHLine lv, dvH, dvL;

//User-defined input variables
input double LevelCheck = 0.0;
input int ZoneDeviation = 30;
input int lineWidth = 1;
input ENUM_LINE_STYLE lineStyle = STYLE_SOLID;
input color lineColor = clrDarkMagenta;

//Trading Zone counts
extern int count = 0;

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
//|                OBJECT LINE DE-INITIALIZATION FUNCTION            |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//lv.Delete();
//dvH.Delete();
//dvL.Delete();
  }

//+------------------------------------------------------------------+
//|                      ON-TICK MAIN FUNCTION                       |
//+------------------------------------------------------------------+
void OnTick()
  {
// Get the ask price
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);

// Get the bid price
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

// Get the Ticket Number
   ulong PositionTicket = PositionGetInteger(POSITION_TICKET);

//Get the PositionType (Either buy or sell)
   ulong PositionType = PositionGetInteger(POSITION_TYPE);

//Activate the ZoneSignal function
   expert.ZoneSignal(LevelCheck,ZoneDeviation,count);

  }// END OF THE ON-TICK MAIN FUNCTION
//+------------------------------------------------------------------+
