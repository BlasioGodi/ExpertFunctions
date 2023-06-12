//+------------------------------------------------------------------+
//|                                                     RSI_ALERT.mq5|
//|                                      Copyright 2023, Godi Blasio |
//|                                     https://tradersliquidity.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Godi Blasio"
#property link      "https://xauman.com"
#property version   "1.00"

//include the file Trade.mqh
#include<Trade\Trade.mqh>
#include <ExpertFunctions.mqh>

//Create an instance of CTrade
CTrade trade;

//Create an instance of ExpertFunctions
ExpertFunctions expert;

//User input variables
input double top_rsi = 0;
input double bottom_rsi = 0;
input int start_time = 0;
input int end_time = 23;

input int pip_profit1 = 300;
input int pip_profit2 = 600;
input int pip_profit3 = 900;
input int pip_loss = 300;
input double lot_size = 0;

input double trading_lvl1 = 0;
input double trading_lvl2 = 0;
input int zone_deviation1 = 0;
input int zone_deviation2 = 0;

input ENUM_TIMEFRAMES trade_period = PERIOD_H1;

//-- Line Styles
input int lineWidth = 1;
input ENUM_LINE_STYLE lineStyle = STYLE_SOLID;
color lineColor1 = clrMediumSpringGreen;
color lineColor2 = clrBeige;

//Temporary Code Measure to draw lines using struct
struct LineName
  {
   string            Name1;
   string            Name2;
  };

//External Variables
extern int counter = 0;
extern int total_trades = 3;
extern vector Levels {trading_lvl1,trading_lvl2};
extern vector ZoneDeviation {zone_deviation1,zone_deviation1};

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
   expert.CreateObjectLine(trading_lvl1,zone_deviation1,lineColor1,lineStyle,lineWidth,names.Name1);
   expert.CreateObjectLine(trading_lvl2,zone_deviation2,lineColor2,lineStyle,lineWidth,names.Name2);

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
  
  datetime current_time = 0;
  datetime original_time = TimeLocal();

// Get the Ask and Bid price
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   
   expert.ZoneTimer();

   
  }
//+------------------------------------------------------------------+

//
//if(expert.TimeFrame(start_time,end_time)=="Perfect Session")
//     {
//      if(expert.ExpertZone(Levels,ZoneDeviation,counter,trade_period)>=1 && expert.ExpertZone(Levels,ZoneDeviation,counter,trade_period)<=50 &&(PositionsTotal()==0)&&(OrdersTotal()==0))
//        {
//         if(expert.CheckRSIValue(top_rsi,bottom_rsi, counter,trade_period)=="BUY" && expert.PriceZone(Levels,ZoneDeviation,Ask,trade_period)==true)
//           {
//           current_time=TimeCurrent();
//           Print("Trade Time: "+TimeToString(current_time));         
//            trade.Buy(lot_size,_Symbol,Bid,Bid-pip_loss*_Point,Ask+pip_profit1*_Point,NULL);
//            trade.Buy(lot_size,_Symbol,Bid,Bid-pip_loss*_Point,Ask+pip_profit2*_Point,NULL);
//            trade.Buy(lot_size,_Symbol,Bid,Bid-pip_loss*_Point,Ask+pip_profit3*_Point,NULL);
//           }
//
//         if(expert.CheckRSIValue(top_rsi,bottom_rsi, counter,trade_period)=="SELL" && expert.PriceZone(Levels,ZoneDeviation,Ask,trade_period)==true)
//           {
//           current_time=TimeCurrent();
//           Print("Trade Time: "+TimeToString(current_time));
//            trade.Sell(lot_size,_Symbol,Ask,Ask+pip_loss*_Point,Bid-pip_profit1*_Point,NULL);
//            trade.Sell(lot_size,_Symbol,Ask,Ask+pip_loss*_Point,Bid-pip_profit2*_Point,NULL);
//            trade.Sell(lot_size,_Symbol,Ask,Ask+pip_loss*_Point,Bid-pip_profit3*_Point,NULL);
//           }
//        }
//     }
//     Print("Current Time: "+TimeToString(original_time));
