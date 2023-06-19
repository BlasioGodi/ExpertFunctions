//+------------------------------------------------------------------+
//|                                                AThousandMiles.mq5|
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
input ENUM_FX_PAIRS currencySymbol = XAUUSD;
input double lot_size = 0;
input int pip_profit1 = 300;
input int pip_profit2 = 600;
input int pip_profit3 = 900;
input int pip_loss = 300;
input int trailing_stop1 = -300;
input int trailing_stop2 = 50;
input int loading_time = 60;

input int start_time = 0;
input int end_time = 23;

input int line_width = 1;
input ENUM_LINE_STYLE line_style = STYLE_SOLID;

input double price_lvl1 = 0;
input double price_lvl2 = 0;
input double price_lvl3 = 0;
input double price_lvl4 = 0;
input double price_lvl5 = 0;
input double price_lvl6 = 0;
input double price_lvl7 = 0;
input double price_lvl8 = 0;
input double price_lvl9 = 0;
input double price_lvl10 = 0;

input int zone_dev1 = 0;
input int zone_dev2 = 0;
input int zone_dev3 = 0;
input int zone_dev4 = 0;
input int zone_dev5 = 0;
input int zone_dev6 = 0;
input int zone_dev7 = 0;
input int zone_dev8 = 0;
input int zone_dev9 = 0;
input int zone_dev10 = 0;

//-- Line Colours
color line_color1 = clrMediumSpringGreen;
color line_color2 = clrBeige;
color line_color3 = clrMagenta;
color line_color4 = clrYellow;
color line_color5 = clrBlueViolet;
color line_color6 = clrRed;
color line_color7 = clrGreenYellow;
color line_color8 = clrAliceBlue;
color line_color9 = clrGreen;
color line_color10 = clrAquamarine;

input ENUM_TIMEFRAMES trade_period = PERIOD_M1;

extern int count = 0;
extern int count2 = 0;
extern vector Levels {price_lvl1,price_lvl2,price_lvl3,price_lvl4,price_lvl5,price_lvl6,price_lvl7,price_lvl8,price_lvl9,price_lvl10};
extern vector ZoneDeviation {zone_dev1,zone_dev2,zone_dev3,zone_dev4,zone_dev5,zone_dev6,zone_dev7,zone_dev8,zone_dev9,zone_dev10};
extern bool conditions_met = false;
extern bool value_returned = false;
extern datetime time_current=0;
extern bool trade_taken = false;
extern bool in_progress=false;
extern double get_profit=0;
extern string trade_direction = "";

MqlDateTime previousDateTime;  // Global variable to store the previous date and time

//Temporary Code Measure to draw lines using struct
struct LineName
  {
   string            Name1;
   string            Name2;
   string            Name3;
   string            Name4;
   string            Name5;
   string            Name6;
   string            Name7;
   string            Name8;
   string            Name9;
   string            Name10;
  };


//+------------------------------------------------------------------+
//|               OBJECT LINE INITIALIZATION FUNCTION                |
//+------------------------------------------------------------------+
int OnInit()
  {
// Struct LineName
   LineName names;
   names.Name1 = "A";
   names.Name2 = "B";
   names.Name3 = "C";
   names.Name4 = "D";
   names.Name5 = "E";
   names.Name6 = "F";
   names.Name7 = "G";
   names.Name8 = "H";
   names.Name9 = "I";
   names.Name10 = "J";

// Create Line Objects
   expert.CreateObjectLine(price_lvl1,zone_dev1,line_color1,line_style,line_width,names.Name1);
   expert.CreateObjectLine(price_lvl2,zone_dev2,line_color2,line_style,line_width,names.Name2);
   expert.CreateObjectLine(price_lvl3,zone_dev3,line_color3,line_style,line_width,names.Name3);
   expert.CreateObjectLine(price_lvl4,zone_dev4,line_color4,line_style,line_width,names.Name4);
   expert.CreateObjectLine(price_lvl5,zone_dev5,line_color5,line_style,line_width,names.Name5);
   expert.CreateObjectLine(price_lvl6,zone_dev6,line_color6,line_style,line_width,names.Name6);
   expert.CreateObjectLine(price_lvl7,zone_dev7,line_color7,line_style,line_width,names.Name7);
   expert.CreateObjectLine(price_lvl8,zone_dev8,line_color8,line_style,line_width,names.Name8);
   expert.CreateObjectLine(price_lvl9,zone_dev9,line_color9,line_style,line_width,names.Name9);
   expert.CreateObjectLine(price_lvl10,zone_dev10,line_color10,line_style,line_width,names.Name10);

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
// Get the Ask and Bid Prices
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

   datetime currentTime = TimeCurrent();
   MqlDateTime currentDateTime;
   TimeToStruct(currentTime, currentDateTime);

   string currencyDetails = EnumToString(currencySymbol);

// Check if a new day has started and reset all values
   if(currentDateTime.day != previousDateTime.day || currentDateTime.mon != previousDateTime.mon || currentDateTime.year != previousDateTime.year)
     {
         time_current = 0;
         trade_taken = false;
         conditions_met = false;
         value_returned = false;
         get_profit = 0;
         trade_direction = "";
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

   if(expert.ExpertZone(Levels,ZoneDeviation,count2,trade_period)>=1 && expert.ExpertZone(Levels,ZoneDeviation,count2,trade_period)<=50)
     {
      if(expert.PriceZone(Levels,ZoneDeviation,Ask,trade_period)==true && expert.MarketDirection(trade_period) == "BUY")
        {
         if(!conditions_met)
           {
            time_current=TimeCurrent();
            conditions_met = true;
            trade_direction = "BUY";
           }
        }
        
        if(expert.PriceZone(Levels,ZoneDeviation,Ask,trade_period)==true && expert.MarketDirection(trade_period) == "SELL")
        {
         if(!conditions_met)
           {
            time_current=TimeCurrent();
            conditions_met = true;
            trade_direction = "SELL";
           }
        }
     }

// Get trade profit
   get_profit=expert.GetProfitDetails();

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
           "\n#Trade Direction: ",trade_direction,
           "\n#Market Direction: ",expert.CheckOpenPositions(currencyDetails)==true?"No open Positions":"Positions are Open"
           );

   if(expert.TimeFrame(start_time,end_time)=="Perfect Session")
     {
      // Check if price is within the Trading zones
      if(expert.CheckOpenPositions(currencyDetails)==true)
        {
         // Buy at Support
         if(expert.PriceZone(Levels,ZoneDeviation,Ask,trade_period)==true && trade_direction=="SELL" && minDifference>=loading_time)
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

         // Sell at Resistance
         if(expert.PriceZone(Levels,ZoneDeviation,Ask,trade_period)==true && trade_direction=="BUY" && minDifference>=loading_time)
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

// Activate the Trailing Stop Function
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

  }// END OF THE ON-TICK MAIN FUNCTION
//+------------------------------------------------------------------+
