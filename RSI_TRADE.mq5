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

// Currency Pairs
enum ENUM_FX_PAIRS
  {
   EURUSD,
   GBPUSD,
   AUDUSD,
   NZDUSD,
   USDJPY,
   USDCHF,
   USDCAD,
   XAUUSD,
   GBPJPY,
   EURAUD,
   EURCAD,
   EURJPY,
   EURGBP
  };

//User input variables
input ENUM_FX_PAIRS currencySymbol= XAUUSD;
input double top_rsi = 0;
input double bottom_rsi = 0;
input int start_time = 0;
input int end_time = 23;

input double lot_size = 0;
input int pip_profit1 = 300;
input int pip_profit2 = 600;
input int pip_profit3 = 900;
input int pip_loss = 300;
input int trailing_stop1 = -300;
input int trailing_stop2 = 50;

input double trading_lvl1 = 0;
input double trading_lvl2 = 0;
input int zone_deviation1 = 0;
input int zone_deviation2 = 0;
input int loading_time = 60;

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
int counter = 0;
int counter2 = 0;
int total_trades = 3;
vector Levels {trading_lvl1,trading_lvl2};
vector ZoneDeviation {zone_deviation1,zone_deviation1};
datetime time_current=0;
bool conditions_met = false;
bool value_returned = false;
bool trade_taken = false;
bool in_progress=false;
double get_profit=0;

MqlDateTime previousDateTime;  // Global variable to store the previous date and time

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
// Get the Ask and Bid price
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

   string currencyDetails = EnumToString(currencySymbol);

   datetime currentTime = TimeCurrent();
   MqlDateTime currentDateTime;
   TimeToStruct(currentTime, currentDateTime);

// Check if a new day has started
   if(currentDateTime.day != previousDateTime.day || currentDateTime.mon != previousDateTime.mon || currentDateTime.year != previousDateTime.year)
     {
      // Reset the value when a new day starts
      time_current = 0;
      trade_taken = false;
      conditions_met = false;
      value_returned = false;
      get_profit = 0;
     }

// Update the previous date and time
   previousDateTime = currentDateTime;

// Get bar opening price array
   MqlRates BarPrice[];

// Sort the array data from zero
   ArraySetAsSeries(BarPrice,true);

// Get data within the array
   CopyRates(_Symbol,PERIOD_M1,0,3,BarPrice);

// Get the current time in minutes of the current array
   datetime BarTime = BarPrice[0].time;

// Get the current time struct
   MqlDateTime CurrentPriceTime;

   TimeToStruct(BarTime,CurrentPriceTime);

   int currentHour = CurrentPriceTime.hour;
   int currentMin = CurrentPriceTime.min;

   if(expert.CheckRSIValue(top_rsi,bottom_rsi, counter2,trade_period)=="BUY" || expert.CheckRSIValue(top_rsi,bottom_rsi, counter2,trade_period)=="SELL")
     {
      if(!conditions_met)
        {
         time_current=TimeCurrent();
         conditions_met = true;
         value_returned = true;
        }
     }

   if(expert.CheckOpenPositions(currencyDetails)==true)
     {
      get_profit=0;
     }
   else
     {
      get_profit=expert.GetProfitDetails();
     }

// Get the zone time struct
   MqlDateTime ZoneTime;
   TimeToStruct(time_current,ZoneTime);

   int zoneHour = ZoneTime.hour;
   int zoneMin = ZoneTime.min;

   int hourDifference = currentHour-zoneHour;
   int minDifference = (currentMin+(hourDifference*60)) - zoneMin;

   Comment("#Current Time: ",BarTime,
           "\n#Min Difference: ",minDifference,
           "\n#Current Hour: ",currentHour,
           "\n#Current Min: ",currentMin,
           "\n#Zone Time: ",time_current,
           "\n#Trade Taken today?: ",trade_taken==false?"No":"Yes",
           "\n#Trade in-progress?: ",in_progress==false?"No":"Yes",
           "\n#Profit Details: ",get_profit,
           "\n#Market Direction: ",expert.CheckOpenPositions(currencyDetails)==true?"No open positions":"Positions are Open"
          );

   if(expert.TimeFrame(start_time,end_time)=="Perfect Session")
     {
      if(expert.CheckOpenPositions(currencyDetails)==true)
        {
         if(expert.CheckRSIValue(top_rsi,bottom_rsi, counter2,trade_period)=="BUY" && minDifference>=loading_time)
           {
            if(!trade_taken)
              {
               trade.Buy(lot_size,_Symbol,Bid,Bid-pip_loss*_Point,Ask+pip_profit1*_Point,NULL);
               trade.Buy(lot_size,_Symbol,Bid,Bid-pip_loss*_Point,Ask+pip_profit2*_Point,NULL);
               trade.Buy(lot_size,_Symbol,Bid,Bid-pip_loss*_Point,Ask+pip_profit3*_Point,NULL);
               trade_taken=true;
               in_progress=true;
              }
           }

         if(expert.CheckRSIValue(top_rsi,bottom_rsi, counter2,trade_period)=="SELL" && minDifference>=loading_time)
           {
            if(!trade_taken)
              {
               trade.Sell(lot_size,_Symbol,Ask,Ask+pip_loss*_Point,Bid-pip_profit1*_Point,NULL);
               trade.Sell(lot_size,_Symbol,Ask,Ask+pip_loss*_Point,Bid-pip_profit2*_Point,NULL);
               trade.Sell(lot_size,_Symbol,Ask,Ask+pip_loss*_Point,Bid-pip_profit3*_Point,NULL);
               trade_taken=true;
               in_progress=true;
              }
           }
        }
     }
   if(get_profit>0 && get_profit<=35)
     {
      expert.SellTrailingStop(trailing_stop1);
      expert.BuyTrailingStop(trailing_stop1);
     }

   if(get_profit>35 && get_profit<=70)
     {
      expert.SellTrailingStop(trailing_stop2);
      expert.BuyTrailingStop(trailing_stop2);
     }
  }
//+------------------------------------------------------------------+
