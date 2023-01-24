//+------------------------------------------------------------------+
//|                                                       RSI_SND.mq5|
//|                                      Copyright 2023, Godi Blasio |
//|                                     https://tradersliquidity.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Godi Blasio"
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
input int pip_profit = 300;
input int pip_loss = 200;
input double LotSize = 0;
input double top_rsi = 0;
input double bottom_rsi = 0;

input double Trading_Lvl1 = 0;
input double Trading_Lvl2 = 0;
input double Trading_Lvl3 = 0;
input double Trading_Lvl4 = 0;
input double Trading_Lvl5 = 0;
input double Trading_Lvl6 = 0;
input int ZoneDeviation = 0;

input int lineWidth = 1;
input ENUM_LINE_STYLE lineStyle = STYLE_SOLID;

//-- Line Colours
color lineColor1 = clrMediumSpringGreen;
color lineColor2 = clrBeige;
color lineColor3 = clrMagenta;
color lineColor4 = clrYellow;
color lineColor5 = clrBlueViolet;
color lineColor6 = clrRed;

input ENUM_TIMEFRAMES trade_period = PERIOD_H1;

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

// Get the Ask and Bid price
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

// ExpertZone values
   int expertCount = expert.ExpertZone(Levels,ZoneDeviation,count,trade_period);

//Variable declaration
   string signal = "";

//Create array for RSI Values
   double RSIArray[];
   int myRSIDefinition=iRSI(_Symbol,_Period,14,PRICE_CLOSE);

//Sort array values and fill the array
   ArraySetAsSeries(RSIArray,true);
   CopyBuffer(myRSIDefinition,0,0,3,RSIArray);

//Get the RSI Value
   double myRSIValue = NormalizeDouble(RSIArray[0],2);

   if(myRSIValue>top_rsi)
      signal="SELL";
   else
      if(myRSIValue<bottom_rsi)
         signal="BUY";
      else
         signal="No signal, Wait";

//Comment and check
   Comment("MyRSI_Value: ",myRSIValue,"\n",
           "MySignal: ",signal,"\n",
           "ExpertCount: ",expertCount);

   if(expert.ExpertZone(Levels,ZoneDeviation,count,trade_period)>=1 && expert.ExpertZone(Levels,ZoneDeviation,count,trade_period)<=50 && (PositionsTotal()==0)&&(OrdersTotal()==0))
     {
      if(signal="SELL")
         trade.Sell(LotSize,_Symbol,Ask,0,0,NULL);
     }

   if(expert.ExpertZone(Levels,ZoneDeviation,count,trade_period)>=1 && expert.ExpertZone(Levels,ZoneDeviation,count,trade_period)<=50 && (PositionsTotal()==0)&&(OrdersTotal()==0))
     {
      if(signal="BUY")
         trade.Buy(LotSize,_Symbol,Bid,0,0,NULL);
     }

// Activate the PositionPipProfit function
   expert.PositionPipProfit(pip_profit);

// Activate the PositionPipLoss function
   expert.PositionPipLoss(pip_loss);

  }
//+------------------------------------------------------------------+
