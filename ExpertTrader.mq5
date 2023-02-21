//+------------------------------------------------------------------+
//|                                                  ExpertTrader.mq5|
//|                                      Copyright 2022, Godi Blasio |
//|                                     https://tradersliquidity.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Godi Blasio"
#property link      "https://tradersliquidity.com"
#property version   "1.00"

//include the file Trade.mqh
#include<Trade\Trade.mqh>
#include <ExpertFunctions.mqh>

//Create an instance of CTrade
CTrade trade;

//Create an instance of ExpertFunctions
ExpertFunctions expert;

//User input variables
input double Trading_Lvl1 = 0;

input int ZoneDeviation = 0;
input double LotSize = 0;
input int stop_loss = 0;
input int take_profit =0;

//-- Line Properties
color lineColor1 = clrMediumSpringGreen;
input int lineWidth = 1;
input ENUM_LINE_STYLE lineStyle = STYLE_SOLID;

extern int count = 0;
extern vector Levels {Trading_Lvl1};

//Temporary Code Measure to draw lines using struct
struct LineName
  {
   string            Name1;
  };

//+------------------------------------------------------------------+
//|               OBJECT LINE INITIALIZATION FUNCTION                |
//+------------------------------------------------------------------+
int OnInit()
  {
// struct LineName
   LineName names;
   names.Name1 = "A";

//Create 1st Object Line
   expert.CreateObjectLine(Trading_Lvl1,ZoneDeviation,lineColor1,lineStyle,lineWidth,names.Name1);

   return(INIT_SUCCEEDED);
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

//Check all open positions for the current symbol
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      string symbol=PositionGetSymbol(i);

      if(_Symbol==symbol)
        {
         ulong PositionTicket=PositionGetInteger(POSITION_TICKET);
         double CurrentStopLoss=PositionGetDouble(POSITION_SL);
         double CurrentTakeProfit=PositionGetDouble(POSITION_TP);

         Comment("#TicketNumber:",PositionTicket,"\n",
                 "#CurrentStopLoss:",CurrentStopLoss,"\n",
                 "#CurrentTakeProfit:",CurrentTakeProfit);
         
         trade.PositionModify(PositionTicket,stop_loss,take_profit);

        } 
     }

  }
//+------------------------------------------------------------------+
