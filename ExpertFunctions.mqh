//+------------------------------------------------------------------+
//|                                              ExpertFunctions.mqh |
//|                                      Copyright 2022, Godi Blasio |
//|                                     https://tradersliquidity.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Godi Blasio"
#property link      "https://tradersliquidity.com"
#property version   "1.00"

// Include the file Trade.mqh
#include<Trade\Trade.mqh>

// Include the file ChartObjectsLines.mqh
#include <ChartObjects\ChartObjectsLines.mqh>

// Include the file List.mqh
#include <Arrays\List.mqh>

//Create an instance of CTrade
CTrade expertTrade;

//Create an instance of COrderInfo
COrderInfo orderInformation;

//Create an instance of ChartObjects
CChartObjectHLine MainLevel, deviationHigh, deviationLow;

//Create an instance of CPositionInfo
CPositionInfo posInfo;

#define TIMETOSECS 900;

//+------------------------------------------------------------------+
//|                       CLASS EXPERTFUNCTIONS                      |
//+------------------------------------------------------------------+
class ExpertFunctions
  {
private:
   string            MyTradeResult;

public:

   //Constructors & Destructors
                     ExpertFunctions();
                    ~ExpertFunctions();

   //Function Prototype
   string            TradeAlert(void);
   void              TakeProfit(ulong,double);
   void              BuyTrailingStop(double);
   void              SellTrailingStop(double);
   string            GetProfitDetails(void);
   void              CreateObjectLine(double, int, color, ENUM_LINE_STYLE, int, string);
   void              CheckCloseTime(double);
   void              PendingOrderDelete(void);
   string            TimeFrame(int,int);

   //--Redundant to be omitted
   string            SupportAndResistance(double, double,int,double,double,double,double,double,double,double,double);
   //--Redundant to be omitted

   double            Highs(ENUM_TIMEFRAMES);
   double            Lows(ENUM_TIMEFRAMES);
   void              SimplePositionDetails(void);
   bool              PriceZone(vector&,  vector &, double, ENUM_TIMEFRAMES);
   int               ZoneSignal(double, double, int&);
   int               ExpertZone(vector&, vector &, int &, ENUM_TIMEFRAMES);
   void              PositionPipProfit(int);
   void              PositionPipLoss(int);
   bool              LapsedTimerEntry(int, int);
   string            MarketDirection(ENUM_TIMEFRAMES);
   string            MarketDirectionH4();
   void              TradeLapsedTime(void);
   void              SimplePositionClose(void);
   bool              PricedTime(datetime);
   int               EntryTimer(datetime);
   void              FailSafe(void);
   string            TradingCandle(int&);
   void              CheckRSIValue(double, double, int &rsi_count, ENUM_TIMEFRAMES);


  };
//+------------------------------------------------------------------+
//|                   CONSTRUCTOR & DESTRUCTOR                       |
//+------------------------------------------------------------------+

//Constructor
ExpertFunctions::ExpertFunctions() :  MyTradeResult("")

  {
  }

//Destructor
ExpertFunctions::~ExpertFunctions()
  {
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                   TAKEPROFIT FUNCTION                            |
//+------------------------------------------------------------------+
void ExpertFunctions::TakeProfit(ulong PositionTicket, double DesiredProfit)
  {

//Calculate the current position profit
   double PositionProfit = PositionGetDouble(POSITION_PROFIT);

//Get the current position ticket
   PositionTicket = PositionGetInteger(POSITION_TICKET);

//If the PositionProfit is greater than the DesiredProfit
   if(PositionProfit > DesiredProfit)

      //Close the position
      expertTrade.PositionClose(PositionTicket);

  } // END OF THE TAKEPROFIT FUNCTION
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                    BUYTRAILINGSTOPFUNCTION                       |
//+------------------------------------------------------------------+
void ExpertFunctions::BuyTrailingStop(double Ask)
  {
//Set the desired Stop loss to 200 points
   double SL=NormalizeDouble(Ask-250*_Point,_Digits);

//Check all open positions for the current symbol
   for(int i=PositionsTotal()-1; i>=0; i--) // count all currency pair positions
     {
      string symbol=PositionGetSymbol(i); //get position symbol

      if(_Symbol==symbol)  //if chart symbol equals position symbol
        {
         // get the ticket number
         ulong PositionTicket=PositionGetInteger(POSITION_TICKET);

         // get the current Stop Loss
         double CurrentStopLoss=PositionGetDouble(POSITION_SL);

         // If current Stop Loss is below 200 points from Ask Price
         if(CurrentStopLoss<SL)
           {
            // Modify the Stop Loss by 20 Points
            expertTrade.PositionModify(PositionTicket,(CurrentStopLoss+150*_Point),0);

            ////Do this TrailingStop Modification only once.
            //break;
           }
        } // End Symbol If loop
     }// End For Loop

  }// END OF THE BUYTRAILINGSTOP FUNCTION
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                    SELLTRAILINGSTOPFUNCTION                      |
//+------------------------------------------------------------------+
void ExpertFunctions::SellTrailingStop(double Bid)
  {
//Set the desired Stop loss to 200 points
   double SL=NormalizeDouble(Bid+250*_Point,_Digits);

//Check all open positions for the current symbol
   for(int i=PositionsTotal()-1; i>=0; i--) // count all currency pair positions
     {
      string symbol=PositionGetSymbol(i); //get position symbol

      if(_Symbol==symbol)  //if chart symbol equals position symbol
        {
         // get the ticket number
         ulong PositionTicket=PositionGetInteger(POSITION_TICKET);

         // get the current Stop Loss
         double CurrentStopLoss=PositionGetDouble(POSITION_SL);

         // If current Stop Loss is above 200 points from the Bid Price
         if(CurrentStopLoss>SL)// This is insufficient
           {
            // Modify the Stop Loss by 20 Points
            expertTrade.PositionModify(PositionTicket,(CurrentStopLoss-150*_Point),0);

            ////Do this TrailingStop Modification only once.
            //break;
           }
        } // End Symbol If loop
     }// End For Loop

  }// END OF THE SELLTRAILINGSTOP FUNCTION
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                GETPROFITDETAILS FUNCTION                         |
//+------------------------------------------------------------------+
string ExpertFunctions::GetProfitDetails(void)
  {

//declare the variables
   uint TotalNumberofDeals = HistoryDealsTotal();
   ulong TicketNumber = 0;
   long OrderType,DealEntry;
   double OrderProfit;
   string MySymbol = "";
   string MyResult = "";
   string OrderProfitValue = "";

//get the history
   HistorySelect(0,TimeCurrent());

//Go through all the deals
   for(uint i = 0; i < TotalNumberofDeals; i++)
     {
      //We look for a ticket number
      if((TicketNumber = HistoryDealGetTicket(i))>0)
        {
         //Get the last order deal type
         OrderType = HistoryDealGetInteger(TicketNumber,DEAL_TYPE);

         //Get the order profit
         OrderProfit = HistoryDealGetDouble(TicketNumber,DEAL_PROFIT);

         //Convert OrderProfit to string
         OrderProfitValue = DoubleToString(OrderProfit);

         //Get the currency pair
         MySymbol = HistoryDealGetString(TicketNumber,DEAL_SYMBOL);

         //Get the deal entry type to check for close types
         DealEntry = HistoryDealGetInteger(TicketNumber,DEAL_ENTRY);

         //Check if the currency pair fits
         if(MySymbol==_Symbol)

            //if it is a buy or a sell order
            if(OrderType==ORDER_TYPE_BUY||OrderType==ORDER_TYPE_SELL)
              {
               //if the order was closed
               if(DealEntry==1)
                 {
                  MyResult = "The Profit was " +OrderProfitValue;
                 }
              }
        }
     }
   return MyResult;

  }// END OF THE GETPROFITDETAILS FUNCTION
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                   CREATEOBJECTLINE FUNCTION                      |
//+------------------------------------------------------------------+
void ExpertFunctions::CreateObjectLine(double CheckLevel, int Deviation, color Color, ENUM_LINE_STYLE Style, int Width, string LineName)
  {

   string name = LineName+"alert.lv-";
   double dv;
   color color_;
   dv = Deviation * SymbolInfoDouble(NULL, SYMBOL_POINT);
   color_ = Color;
   for(int n = 0; n <= INT_MAX && !IsStopped(); n++)
     {
      MainLevel.Create(0, LineName+"alert" + (string)n, 0, CheckLevel);
      MainLevel.Width(Width);
      MainLevel.Style(Style);
      MainLevel.Color(color_);
      deviationHigh.Create(0, LineName+"alert.dvH-" + (string)n, 0, CheckLevel + dv);
      deviationHigh.Width(1);
      deviationHigh.Style(STYLE_DOT);
      deviationHigh.Color(color_);
      deviationLow.Create(0, LineName+"alert.dvL-" + (string)n, 0, CheckLevel - dv);
      deviationLow.Width(1);
      deviationLow.Style(STYLE_DOT);
      deviationLow.Color(color_);
      break;
     }

  }// END OF THE CREATEOBJECTLINE FUNCTION
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                PENDINGORDERDELETE FUNCTION                       |
//+------------------------------------------------------------------+
void ExpertFunctions::PendingOrderDelete(void)
  {
   int o_total=OrdersTotal();
   for(int j=o_total-1; j>=0; j--)
     {
      ulong o_ticket = OrderGetTicket(j);
      if(o_ticket != 0)
        {
         // delete the pending order
         expertTrade.OrderDelete(o_ticket);

         Print("Pending order deleted sucessfully!");
        }
     }
  }// END OF THE PENDINGORDERDELETE FUNCTION
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                    CHECKCLOSETIME FUNCTION                       |
//+------------------------------------------------------------------+

//Check if 15mins has lapsed since the last order was executed
//and then execute the cancel order option if PositionsTotal()==0
//i.e. no positions have been opened.

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ExpertFunctions::CheckCloseTime(double TimePassed)
  {
//declare the variables
   uint TotalNumberofDeals = HistoryDealsTotal();
   ulong OrderTicketNumber,OrderSelected = 0;
   long OrderType = 0;
   datetime MyTime = 0;

// Go through all orders
   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      // Get Order Ticket
      OrderTicketNumber = OrderGetTicket(i);

      // Select an order
      OrderSelected = OrderSelect(OrderTicketNumber);

      // Get the order type
      OrderType = OrderGetInteger(ORDER_TYPE);

      // Get the local time
      MyTime = TimeLocal();

      //---Current Local Time Converted to Struct

      MqlDateTime MyTimeStruct;

      // Convert local time to struct
      TimeToStruct(MyTime,MyTimeStruct);

      int CurrentMin = MyTimeStruct.min;
      //---End of LocalTime Struct

      // Convert time for output
      string TimeWithSeconds = TimeToString(TimeLocal(),TIME_DATE|TIME_SECONDS);

      //---Order OpenTime Converted to Struct

      MqlDateTime MyOpenTimeStruct;

      // Convert order open time to struct
      TimeToStruct(orderInformation.TimeSetup(),MyOpenTimeStruct);

      int OpeningMin = MyOpenTimeStruct.min;
      //---End of OpenTime Struct

      // Convert opening time for output
      string OpeningTimeWithSeconds = TimeToString(orderInformation.TimeSetup(),TIME_DATE|TIME_SECONDS);

      // Calculate the difference between current min and opening min
      int Difference = CurrentMin-OpeningMin;

      //// Chart Output
      Comment("### Order Ticket: ", OrderSelected,"\n",
              "### Order OpenTime: ", OpeningTimeWithSeconds,"\n",
              "### Order LocalTime: ", TimeWithSeconds,"\n",
              "### Order Difference: ", Difference
             );

      // Check if a certain amount of time has passed inorder to cancel the open order
      if(Difference>TimePassed)
        {
         PendingOrderDelete();
        }
     }
  } // END OF THE CHECKCLOSETIME FUNCTION
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                      TIMEFRAME FUNCTION                          |
//+------------------------------------------------------------------+
string ExpertFunctions::TimeFrame(int TimeStart,int TimeEnd)
  {

//Variable Declarations
   datetime CurrentTime = 0;
   string MyTradingMarket = "";

   CurrentTime = TimeLocal();
   MqlDateTime MyTimeStruct;

// Convert local time to struct
   TimeToStruct(CurrentTime,MyTimeStruct);

   int CurrentHour = MyTimeStruct.hour;

//---TRADING TIMES
//London Stock Exchange (London Market) - 1100hrs - 1900hrs
//Tokyo Stock Exchange (Asian Market) - 0200hrs - 1000hrs
//NewYork Stock Exchange (NewYork Market) - 1500hrs - 2200hrs
//Frankfurt Stock Exchange (European Market) - 1000hrs - 1800hrs
//Sydney Stock Exchange (Australian Market) - 0000hrs - 0800hrs

////MarketStart Times Declaration - Defined as Int Variables
//   int LondonStart = 11;
//   int TokyoStart = 2;
//   int NewYorkStart = 15;
//   int FrankfurtStart = 10;
//   int SydneyStart = 0;
//
////MarketEnd Times Declaration - Defined as Int Variables
//   int LondonEnd = 19;
//   int TokyoEnd = 10;
//   int NewYorkEnd = 22;
//   int FrankfurtEnd = 18;
//   int SydneyEnd = 8;

//Check for the Trading Session
   if(CurrentHour>=TimeStart&&CurrentHour<=TimeEnd)

      MyTradingMarket = "Perfect Session";

   else
      MyTradingMarket = "Session has not arrived";

   return MyTradingMarket;

  }// END OF THE TIMEFRAME FUNCTION
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                   SUPPORTANDRESISTANCE FUNCTION                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string ExpertFunctions::SupportAndResistance(double Ask, double Bid, int Deviation, double SR1,double SR2,double SR3,double SR4,double SR5,double SR6,double SR7,double SR8)
  {

//Variable Declarations
   string MyLevels = "";
   vector PriceLevels{SR1,SR2,SR3,SR4,SR5,SR6,SR7,SR8};

   double Level1 = PriceLevels[0];
   double Level2 = PriceLevels[1];
   double Level3 = PriceLevels[2];
   double Level4 = PriceLevels[3];
   double Level5 = PriceLevels[4];
   double Level6 = PriceLevels[5];
   double Level7 = PriceLevels[6];
   double Level8 = PriceLevels[7];

   double UpperZone1 = Level1 + Deviation*_Point;
   double LowerZone1 = Level1 - Deviation*_Point;

   double UpperZone2 = Level2 + Deviation*_Point;
   double LowerZone2 = Level2 - Deviation*_Point;

   double UpperZone3 = Level3 + Deviation*_Point;
   double LowerZone3 = Level3 - Deviation*_Point;

   double UpperZone4 = Level4 + Deviation*_Point;
   double LowerZone4 = Level4 - Deviation*_Point;

   double UpperZone5 = Level5 + Deviation*_Point;
   double LowerZone5 = Level5 - Deviation*_Point;

   double UpperZone6 = Level6 + Deviation*_Point;
   double LowerZone6 = Level6 - Deviation*_Point;

   double UpperZone7 = Level7 + Deviation*_Point;
   double LowerZone7 = Level7 - Deviation*_Point;

   double UpperZone8 = Level8 + Deviation*_Point;
   double LowerZone8 = Level8 - Deviation*_Point;


// Get current price array
   MqlRates CurrentArray[];

// Sort the array data from zero
   ArraySetAsSeries(CurrentArray,true);

// Get data within the array
   CopyRates(_Symbol,_Period,0,3,CurrentArray);

   double highPrice1 = NormalizeDouble(CurrentArray[0].high,_Digits);
   double lowPrice1 = NormalizeDouble(CurrentArray[0].low,_Digits);
   double openPrice1 = NormalizeDouble(CurrentArray[0].open,_Digits);
   double currentPrice1 = NormalizeDouble(CurrentArray[0].close,_Digits);

//Check whether current price levels match with the ask or bid price
   if(currentPrice1>openPrice1)
     {
      if(UpperZone1>Ask && LowerZone1<Ask)
         MyLevels = "EXECUTE SELL";

      if(UpperZone2>Ask && LowerZone2<Ask)
         MyLevels = "EXECUTE SELL";

      if(UpperZone3>Ask && LowerZone3<Ask)
         MyLevels = "EXECUTE SELL";

      if(UpperZone4>Ask && LowerZone4<Ask)
         MyLevels = "EXECUTE SELL";

      if(UpperZone5>Ask && LowerZone5<Ask)
         MyLevels = "EXECUTE SELL";

      if(UpperZone6>Ask && LowerZone6<Ask)
         MyLevels = "EXECUTE SELL";

      if(UpperZone7>Ask && LowerZone7<Ask)
         MyLevels = "EXECUTE SELL";

      if(UpperZone8>Ask && LowerZone8<Ask)
         MyLevels = "EXECUTE SELL";
     }

   if(currentPrice1<openPrice1)
     {
      if(UpperZone1>Bid && LowerZone1<Bid)
         MyLevels = "EXECUTE BUY";

      if(UpperZone2>Bid && LowerZone2<Bid)
         MyLevels = "EXECUTE BUY";

      if(UpperZone3>Bid && LowerZone3<Bid)
         MyLevels = "EXECUTE BUY";

      if(UpperZone4>Bid && LowerZone4<Bid)
         MyLevels = "EXECUTE BUY";

      if(UpperZone5>Bid && LowerZone5<Bid)
         MyLevels = "EXECUTE BUY";

      if(UpperZone6>Bid && LowerZone6<Bid)
         MyLevels = "EXECUTE BUY";

      if(UpperZone7>Bid && LowerZone7<Bid)
         MyLevels = "EXECUTE BUY";

      if(UpperZone8>Bid && LowerZone8<Bid)
         MyLevels = "EXECUTE BUY";
     }

   return MyLevels;

  }// END OF THE SUPPORTANDRESISTANCE FUNCTION
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                        HIGH FUNCTION                             |
//+------------------------------------------------------------------+
double ExpertFunctions::Highs(ENUM_TIMEFRAMES time_period)
  {

//Variable declaration
   double High = 0;

// Get current price array
   MqlRates CurrentArray[];

// Sort the array data from zero
   ArraySetAsSeries(CurrentArray,true);

// Get data within the array
   CopyRates(_Symbol,time_period,0,3,CurrentArray);

   double highPrice1 = NormalizeDouble(CurrentArray[0].high,_Digits);
   double lowPrice1 = NormalizeDouble(CurrentArray[0].low,_Digits);
   double openPrice1 = NormalizeDouble(CurrentArray[0].open,_Digits);
   double currentPrice1 = NormalizeDouble(CurrentArray[0].close,_Digits);

// Determine the high and low of the current candlestick
   if(currentPrice1>openPrice1)
     {
      High = highPrice1;
     }

   return High;

  }//END OF THE HIGHANDLOW FUNCTION
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                      LOW FUNCTION                                |
//+------------------------------------------------------------------+
double ExpertFunctions::Lows(ENUM_TIMEFRAMES time_period)
  {

//Variable declaration
   double Low = 0;

// Get current price array
   MqlRates CurrentArray[];

// Sort the array data from zero
   ArraySetAsSeries(CurrentArray,true);

// Get data within the array
   CopyRates(_Symbol,time_period,0,3,CurrentArray);

   double highPrice1 = NormalizeDouble(CurrentArray[0].high,_Digits);
   double lowPrice1 = NormalizeDouble(CurrentArray[0].low,_Digits);
   double openPrice1 = NormalizeDouble(CurrentArray[0].open,_Digits);
   double currentPrice1 = NormalizeDouble(CurrentArray[0].close,_Digits);

// Determine the high and low of the current candlestick

   if(currentPrice1<openPrice1)
     {
      Low = lowPrice1;
     }

   return Low;


  }//END OF THE HIGHANDLOW FUNCTION
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|   TRADE ALERT SIGNAL FUNCTION (FOR INFORMATION PURPOSE ONLY)     |
//+------------------------------------------------------------------+
string ExpertFunctions::TradeAlert(void)
  {

//Get PriceArray from rates
   MqlRates CurrentPriceArray[];

//Sort data within array starting from zero
   ArraySetAsSeries(CurrentPriceArray,true);

//Get Price data within the array
   int PriceData = CopyRates(_Symbol,PERIOD_H4,0,10,CurrentPriceArray);

//Get the high, low and open prices of the current candlestick
   double highPrice1 = NormalizeDouble(CurrentPriceArray[0].high,_Digits);
   double lowPrice1 = NormalizeDouble(CurrentPriceArray[0].low,_Digits);
   double openPrice1 = NormalizeDouble(CurrentPriceArray[0].open,_Digits);
   double currentPrice1 = NormalizeDouble(CurrentPriceArray[0].close,_Digits);

// Compare the current price against the highest and lowest prices of the candlestick on the H4 Chart
   if(lowPrice1==currentPrice1)
     {
      MyTradeResult = "BUY";
     }

   if(highPrice1==currentPrice1)
     {
      MyTradeResult = "SELL";
     }

//TradeAlert Output
   return (MyTradeResult);

  }// END OF THE TRADE ALERT SIGNAL FUNCTION
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                  SIMPLEPOSITIONDETAILS FUNCTION                  |
//+------------------------------------------------------------------+
void ExpertFunctions::SimplePositionDetails(void)
  {
// if positions for the curreny pair exist
   if(PositionSelect(_Symbol)==true)
     {
      // From the number of positions count down to zero and go through all Open Positions.
      for(int i=PositionsTotal()-1; i>=0; i--)
        {

         //Get the Ticket Number
         ulong PositionTicket = PositionGetInteger(POSITION_TICKET);

         //Calculate the currency pair
         string PositionSymbol = PositionGetString(POSITION_SYMBOL);

         //Calculate the open price for the position
         double PositionPriceOpen = PositionGetDouble(POSITION_PRICE_OPEN);

         //Calculate the current price for the position
         double PositionPriceCurrent = PositionGetDouble(POSITION_PRICE_CURRENT);

         double PositionDetails = PositionPriceOpen+265*_Point;

         //Calculate the current position profit
         double PositionProfit = PositionGetDouble(POSITION_PROFIT);

         //Calculate the current position swap
         int PositionSwap = (int)PositionGetDouble(POSITION_SWAP);

         //Calculate the current position net profit
         double PositionNetProfit = PositionProfit+PositionSwap;

         if(PositionSymbol==_Symbol)
           {
            Comment("Position Number: ", 1, "\n",
                    "Position Ticket: ", PositionTicket, "\n",
                    "Position Symbol: ", PositionSymbol, "\n",
                    "Position Profit: ", PositionProfit, "\n",
                    "Position Swap  : ", PositionSwap, "\n",
                    "Position NetProfit: ", PositionNetProfit, "\n",
                    "Position Price Open: ", PositionPriceOpen, "\n",
                    "Position Price Current: ", PositionPriceCurrent, "\n",
                    "Position Price Details: ", PositionDetails
                   );
           }

        }
     }
  }// END OF THE SIMPLEPOSITIONDETAILS FUNCTION
//+------------------------------------------------------------------+

//Make ZoneSignal Function report the tradelevel as well.
//+------------------------------------------------------------------+
//|                      PRICE ZONE FUNCTION                         |
//+------------------------------------------------------------------+
bool ExpertFunctions::PriceZone(vector &PriceLevel,vector &PointChange, double AskingPrice, ENUM_TIMEFRAMES period)
  {

// Price entry
   string priceEntry = "";
// Get current price array
   MqlRates CurrentPriceArray[];

// Sort the array data from zero
   ArraySetAsSeries(CurrentPriceArray,true);

// Get data within the array
   CopyRates(_Symbol,period,0,3,CurrentPriceArray);

   double highPrice1 = NormalizeDouble(CurrentPriceArray[0].high,_Digits);
   double lowPrice1 = NormalizeDouble(CurrentPriceArray[0].low,_Digits);
   double openPrice1 = NormalizeDouble(CurrentPriceArray[0].open,_Digits);
   double currentPrice1 = NormalizeDouble(CurrentPriceArray[0].close,_Digits);

   for(int i = 0; i < (int)PriceLevel.Size(); i++)
     {
      double UpperZone = PriceLevel[i] + PointChange[i]*_Point;
      double LowerZone = PriceLevel[i] - PointChange[i]*_Point;

      // Check whether the current price falls within your price zones
      if(currentPrice1>openPrice1)
        {
         if(UpperZone>currentPrice1 && LowerZone<currentPrice1)
           {
            priceEntry = "IN";
           }

        }

      if(currentPrice1<openPrice1)
        {
         if(UpperZone>currentPrice1 && LowerZone<currentPrice1)
           {
            priceEntry = "IN";
           }

        }
     }//End of For Loop

   if(priceEntry == "IN")
     {
      //Comment("Within range");
      return (true);
     }
   else
     {
      //Comment("Not Within range");
      return (false);
     }

  }// END OF THE PRICE ZONE FUNCTION
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                 POSITIONPIPPROFIT FUNCTION                       |
//+------------------------------------------------------------------+
void ExpertFunctions::PositionPipProfit(int DesiredPipProfit)
  {
//Check all open positions for the current symbol
   for(int i=PositionsTotal()-1; i>=0; i--) // count all currency pair positions
     {
      //Get the history
      HistorySelect(0,TimeCurrent());

      string symbol=PositionGetSymbol(i); //get position symbol

      if(_Symbol==symbol)  //if chart symbol equals position symbol
        {
         // Get the ticket number for the open position
         ulong PositionTicket=PositionGetInteger(POSITION_TICKET);

         // Get the position type
         ulong PositionType = PositionGetInteger(POSITION_TYPE);

         // Get the position profit for the current position
         double PositionProfit = PositionGetDouble(POSITION_PROFIT);

         //Calculate the open price for the position
         double PositionPriceOpen = PositionGetDouble(POSITION_PRICE_OPEN);

         // Get the price difference
         double price_diff=MathAbs(posInfo.PriceCurrent()-PositionPriceOpen);

         // Get the current profit in points
         int pointsProfit=(int)(price_diff/Point());

         //Check if the current Position is a BUY
         if(PositionType == POSITION_TYPE_BUY)
           {
            // Check if the current price is greater than the deal price
            if(posInfo.PriceCurrent()>PositionPriceOpen)
              {
               if(pointsProfit >= DesiredPipProfit)
                 {

                  expertTrade.PositionClose(PositionTicket);

                  // Reset the profit in points to 0 after function call
                  pointsProfit = 0;
                 }
              }
           }
         //Check if the current Position is a sell
         if(PositionType == POSITION_TYPE_SELL)
           {
            // Check if the current price is lower than the deal price
            if(posInfo.PriceCurrent()<PositionPriceOpen)
              {
               if(pointsProfit >= DesiredPipProfit)
                 {

                  expertTrade.PositionClose(PositionTicket);

                  // Reset the profit in points to 0 after function call
                  pointsProfit = 0;
                 }
              }
           }

         //Comment("The Current pip profit is: ",pointsProfit);
        } // End Symbol If loop
     }// End For Loop

  }//END OF THE POSITIONPIPPROFIT FUNCTION
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                   POSITIONPIPLOSS FUNCTION                       |
//+------------------------------------------------------------------+
void ExpertFunctions::PositionPipLoss(int DesiredPipLoss)
  {
//Check all open positions for the current symbol
   for(int i=PositionsTotal()-1; i>=0; i--) // count all currency pair positions
     {
      //Get the history
      HistorySelect(0,TimeCurrent());

      string symbol=PositionGetSymbol(i); //get position symbol

      if(_Symbol==symbol)  //if chart symbol equals position symbol
        {
         // Get the ticket number for the open position
         ulong PositionTicket=PositionGetInteger(POSITION_TICKET);

         // Get the position type
         ulong PositionType = PositionGetInteger(POSITION_TYPE);

         // Get the position profit for the current position
         double PositionProfit = PositionGetDouble(POSITION_PROFIT);

         //Calculate the open price for the position
         double PositionPriceOpen = PositionGetDouble(POSITION_PRICE_OPEN);

         // Get the price difference
         double price_diff=MathAbs(posInfo.PriceCurrent()-PositionPriceOpen);

         // Get the current profit in points
         int pointsProfit=(int)(price_diff/Point());

         //Check if the current Position is a BUY
         if(PositionType == POSITION_TYPE_BUY)
           {
            // Check if the current price is greater than the deal price
            if(posInfo.PriceCurrent()<PositionPriceOpen)
              {
               if(pointsProfit >= DesiredPipLoss)
                 {

                  expertTrade.PositionClose(PositionTicket);

                  // Reset the profit in points to 0 after function call
                  pointsProfit = 0;
                 }
              }
           }
         //Check if the current Position is a sell
         if(PositionType == POSITION_TYPE_SELL)
           {
            // Check if the current price is lower than the deal price
            if(posInfo.PriceCurrent()>PositionPriceOpen)
              {
               if(pointsProfit >= DesiredPipLoss)
                 {

                  expertTrade.PositionClose(PositionTicket);

                  // Reset the profit in points to 0 after function call
                  pointsProfit = 0;
                 }
              }
           }

         //Comment("The Current pip profit is: ",pointsProfit);
        } // End Symbol If loop
     }// End For Loop

  }//END OF THE POSITIONPIPLOSS FUNCTION
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                       LAPSED TIMER ENTRY FUNCTION                |
//+------------------------------------------------------------------+
bool ExpertFunctions::LapsedTimerEntry(int Twelfth, int Fiftieth)
  {
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

   int CurrentMin = CurrentPriceTime.min;

   if(CurrentMin>Twelfth && CurrentMin<Fiftieth)
     {
      //Comment("The time is ",BarTime,". Lapsed time is between the 12th and 50th min");
      return (true);
     }

   else
     {
      //Comment("The time is ",BarTime,". Lapsed time is not between the 12th and 50th min");
      return (false);
     }

  } // END OF THE LAPSED TIMER ENTRY FUNCTION
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                      MARKET DIRECTION FUNCTION                   |
//+------------------------------------------------------------------+
string ExpertFunctions::MarketDirection(ENUM_TIMEFRAMES timePeriod)
  {

//Variable declaration
   string direction = "";

// REMOVE REDUDANCY BELOW ON GETTING CURRENT ARRAY PRICES
// Get current price array
   MqlRates CurrentArray[];

// Sort the array data from zero
   ArraySetAsSeries(CurrentArray,true);

// Get data within the array
   CopyRates(_Symbol,timePeriod,0,3,CurrentArray);

   double highPrice1 = NormalizeDouble(CurrentArray[0].high,_Digits);
   double lowPrice1 = NormalizeDouble(CurrentArray[0].low,_Digits);
   double openPrice1 = NormalizeDouble(CurrentArray[0].open,_Digits);
   double currentPrice1 = NormalizeDouble(CurrentArray[0].close,_Digits);

// Determine if the current price is higher or lower than the open price
// in-order to confirm market direction

   if(currentPrice1>openPrice1)
     {
      direction = "BUY";
     }
   if(currentPrice1<openPrice1)
     {
      direction = "SELL";
     }
   return direction;

  }//END OF THE MARKET DIRECTION FUNCTION
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                      MARKET DIRECTION FUNCTION                   |
//+------------------------------------------------------------------+
string ExpertFunctions::MarketDirectionH4()
  {

//Variable declaration
   string direction = "";

// REMOVE REDUDANCY BELOW ON GETTING CURRENT ARRAY PRICES
// Get current price array
   MqlRates CurrentArray[];

// Sort the array data from zero
   ArraySetAsSeries(CurrentArray,true);

// Get data within the array
   CopyRates(_Symbol,PERIOD_H4,0,3,CurrentArray);

   double highPrice1 = NormalizeDouble(CurrentArray[0].high,_Digits);
   double lowPrice1 = NormalizeDouble(CurrentArray[0].low,_Digits);
   double openPrice1 = NormalizeDouble(CurrentArray[0].open,_Digits);
   double currentPrice1 = NormalizeDouble(CurrentArray[0].close,_Digits);

// Determine if the current price is higher or lower than the open price
// in-order to confirm market direction

   if(currentPrice1>openPrice1)
     {
      direction = "BUY";
     }
   if(currentPrice1<openPrice1)
     {
      direction = "SELL";
     }
   return direction;

  }//END OF THE MARKET DIRECTION FUNCTION
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                 SIMPLE POSITION CLOSE FUNCTION                   |
//+------------------------------------------------------------------+
void ExpertFunctions::SimplePositionClose(void)
  {
//Check all open positions for the current symbol
   for(int i=PositionsTotal()-1; i>=0; i--) // count all currency pair positions
     {
      //Get the history
      HistorySelect(0,TimeCurrent());

      string symbol=PositionGetSymbol(i); //get position symbol

      if(_Symbol==symbol)  //if chart symbol equals position symbol
        {
         // Get the ticket number for the open position
         ulong PositionTicket=PositionGetInteger(POSITION_TICKET);

         expertTrade.PositionClose(PositionTicket);

        } // End Symbol If loop
     }// End For Loop

  }//END OF THE SIMPLE POSITION CLOSE FUNCTION
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                     ZONE SIGNAL FUNCTION                         |
//+------------------------------------------------------------------+
int ExpertFunctions::ZoneSignal(double Level,double PointChange, int &Pips)
  {
// Get current price array
   MqlRates CurrentPriceArray[];

// Sort the array data from zero
   ArraySetAsSeries(CurrentPriceArray,true);

// Get data within the array
   CopyRates(_Symbol,_Period,0,3,CurrentPriceArray);

   double highPrice1 = NormalizeDouble(CurrentPriceArray[0].high,_Digits);
   double lowPrice1 = NormalizeDouble(CurrentPriceArray[0].low,_Digits);
   double openPrice1 = NormalizeDouble(CurrentPriceArray[0].open,_Digits);
   double currentPrice1 = NormalizeDouble(CurrentPriceArray[0].close,_Digits);

   double UpperZone = Level + PointChange*_Point;
   double LowerZone = Level - PointChange*_Point;

// Check whether the current price falls within your price zones
   if(currentPrice1>openPrice1)
     {
      if(UpperZone>currentPrice1 && LowerZone<currentPrice1)
        {
         if(Pips<=1)
           {
            Alert("Price is at your level");

            // Push notification to Expert Advisor
            SendNotification("Price has hit your level");

            //Insert the link to the external desktop API here

           }
         Pips++;
        }
      else
         if(currentPrice1<(UpperZone+400*_Point)&&currentPrice1>(UpperZone+100*_Point))
            Pips = 0;

     }

   if(currentPrice1<openPrice1)
     {
      if(UpperZone>currentPrice1 && LowerZone<currentPrice1)
        {
         if(Pips<=1)
           {
            Alert("Price is at your level");

            // Push notification to Expert Advisor
            SendNotification("Price has hit your level");

            //Insert the link to the external desktop API here

           }
         Pips++;
        }
      else
         if(currentPrice1>(LowerZone-400*_Point)&&currentPrice1<(LowerZone-100*_Point))
            Pips = 0;

     }

//Comment("The Current Pip count: ", Pips);

   return(Pips);

  }// END OF THE ZONE SIGNAL FUNCTION
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                      EXPERT ZONE FUNCTION                        |
//+------------------------------------------------------------------+
int ExpertFunctions::ExpertZone(vector &Level,vector<double> &PointChange, int &Pips, ENUM_TIMEFRAMES time_period)
  {
// Get current price array
   MqlRates CurrentPriceArray[];

// Sort the array data from zero
   ArraySetAsSeries(CurrentPriceArray,true);

// Get data within the array
   CopyRates(_Symbol,time_period,0,3,CurrentPriceArray);

   double highPrice1 = NormalizeDouble(CurrentPriceArray[0].high,_Digits);
   double lowPrice1 = NormalizeDouble(CurrentPriceArray[0].low,_Digits);
   double openPrice1 = NormalizeDouble(CurrentPriceArray[0].open,_Digits);
   double currentPrice1 = NormalizeDouble(CurrentPriceArray[0].close,_Digits);

   for(int i = 0; i < (int)Level.Size(); i++)
     {
      double UpperZone = Level[i] + PointChange[i]*_Point;
      double LowerZone = Level[i] - PointChange[i]*_Point;

      // Check whether the current price falls within your price zones
      if(currentPrice1>openPrice1)
        {
         if(UpperZone>currentPrice1 && LowerZone<currentPrice1)
           {
            if(Pips<=1)
              {
               Alert("Price is between: "+DoubleToString(UpperZone,2)+" and "+DoubleToString(LowerZone,2));

               // Push notification to Expert Advisor
               SendNotification("Price is between: "+DoubleToString(UpperZone,2)+" and "+DoubleToString(LowerZone,2));

               //Insert the link to the external desktop API here

              }
            Pips++;
           }
         else
            if(currentPrice1<(UpperZone+400*_Point)&&currentPrice1>(UpperZone+100*_Point))
               Pips = 0;

        }

      if(currentPrice1<openPrice1)
        {
         if(UpperZone>currentPrice1 && LowerZone<currentPrice1)
           {
            if(Pips<=1)
              {
               Alert("Price is between: "+DoubleToString(UpperZone,2)+" and "+DoubleToString(LowerZone,2));

               // Push notification to Expert Advisor
               SendNotification("Price is between: "+DoubleToString(UpperZone,2)+" and "+DoubleToString(LowerZone,2));

               //Insert the link to the external desktop API here

              }
            Pips++;
           }
         else
            if(currentPrice1>(LowerZone-400*_Point)&&currentPrice1<(LowerZone-100*_Point))
               Pips = 0;

        }
     }//End of the For Loop

   return(Pips);

  }// END OF THE EXPERT ZONE FUNCTION
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                      PRICED TIME FUNCTION                        |
//+------------------------------------------------------------------+
bool ExpertFunctions::PricedTime(datetime PriceTime)
  {
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

   int CurrentMin = CurrentPriceTime.min;

// Get the check time struct
   MqlDateTime CheckPriceTime;

   TimeToStruct(PriceTime,CheckPriceTime);

   int CheckMin = CheckPriceTime.min;


   if(CurrentMin==CheckMin)
     {
      Comment("Just Checking if its working");
      return (true);
     }

   else
     {
      Comment("I dont think its working");
      return (false);
     }

  } // END OF THE PRICED TIME FUNCTION
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                         FAILSAFE FUNCTION                        |
//+------------------------------------------------------------------+
void ExpertFunctions::FailSafe(void)
  {

//Variable declaration
   int failSafeValue = 150;

//Check all open positions for the current symbol
   for(int i=PositionsTotal()-1; i>=0; i--) // count all currency pair positions
     {
      //Get the history
      HistorySelect(0,TimeCurrent());

      string symbol=PositionGetSymbol(i); //get position symbol

      if(_Symbol==symbol)  //if chart symbol equals position symbol
        {
         // Get the ticket number for the open position
         ulong PositionTicket=PositionGetInteger(POSITION_TICKET);

         // Get the position type
         ulong PositionType = PositionGetInteger(POSITION_TYPE);

         // Get the position profit for the current position
         double PositionProfit = PositionGetDouble(POSITION_PROFIT);

         //Calculate the open price for the position
         double PositionPriceOpen = PositionGetDouble(POSITION_PRICE_OPEN);

         // Get the price difference
         double price_diff=MathAbs(posInfo.PriceCurrent()-PositionPriceOpen);

         // Get the current profit in points
         int pointsProfit=(int)(price_diff/Point());

         //Check if the current Position is a BUY
         if(PositionType == POSITION_TYPE_BUY)
           {

            // Check if the current price is lower than the deal price
            if(posInfo.PriceCurrent()<PositionPriceOpen)
              {
               if(pointsProfit >= failSafeValue)
                 {

                  expertTrade.PositionClose(PositionTicket);

                  // Reset the profit in points to 0 after function call
                  pointsProfit = 0;
                 }
              }
           }
         //Check if the current Position is a sell
         if(PositionType == POSITION_TYPE_SELL)
           {
            // Check if the current price is greater than the deal price
            if(posInfo.PriceCurrent()>PositionPriceOpen)
              {
               if(pointsProfit >= failSafeValue)
                 {

                  expertTrade.PositionClose(PositionTicket);

                  // Reset the profit in points to 0 after function call
                  pointsProfit = 0;
                 }
              }
           }

         Comment("The Current pip profit is: ",pointsProfit);
        } // End Symbol If loop
     }// End For Loop

  }//END OF THE FAILSAFE FUNCTION
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                      ENTRY TIMER FUNCTION                        |
//+------------------------------------------------------------------+
int ExpertFunctions::EntryTimer(datetime EntryTime)
  {
// Used the One min candlestick to get the current trading time.
   MqlRates BarPrice[];
   ArraySetAsSeries(BarPrice,true);

   CopyRates(_Symbol,PERIOD_M1,0,3,BarPrice);

   datetime BarTime = BarPrice[0].time;

   MqlDateTime CurrentPriceTime;
   TimeToStruct(TimeCurrent(),CurrentPriceTime);

   int current_hour = CurrentPriceTime.hour;
   int current_min = CurrentPriceTime.min;

// Get the entry time details
   MqlDateTime PriceTime;

   TimeToStruct(EntryTime,PriceTime);

   int check_hour = PriceTime.hour;
   int check_min = PriceTime.min;

// Get the time difference
   int hour_difference = current_hour - check_hour;
   int min_difference  = (current_min+(hour_difference*60)) - check_min;

//(current_min+(hour_difference*60))

   return min_difference;

  } // END OF THE ENTRY TIMER FUNCTION
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                      CANDLE OF INTEREST FUNCTION                 |
//+------------------------------------------------------------------+
string ExpertFunctions::TradingCandle(int &pips)
  {

// Variable declaration
   double price_diff    = 0;
   double price_ratio   = 0;
   double price_ratio2  = 0;
   double price_diffHC  = 0;
   double price_diffHO  = 0;
   double price_diffOL  = 0;
   double price_diffCL  = 0;
   string candle_indication = "";

// Get current price array and sort information
   MqlRates CandleArray[];
   ArraySetAsSeries(CandleArray,true);

   CopyRates(_Symbol,PERIOD_H4,0,3,CandleArray);

   double high_price  = NormalizeDouble(CandleArray[0].high,_Digits);
   double low_price   = NormalizeDouble(CandleArray[0].low,_Digits);
   double open_price  = NormalizeDouble(CandleArray[0].open,_Digits);
   double close_price = NormalizeDouble(CandleArray[0].close,_Digits);

   datetime time_candle = CandleArray[0].time;

   double high_price1  = NormalizeDouble(CandleArray[1].high,_Digits);
   double low_price1   = NormalizeDouble(CandleArray[1].low,_Digits);
   double open_price1 = NormalizeDouble(CandleArray[1].open,_Digits);
   double close_price1 = NormalizeDouble(CandleArray[1].close,_Digits);

   datetime time_candle1 = CandleArray[1].time;

// If it is a buy candlestick
   if(close_price>open_price)
     {
      price_diff = (NormalizeDouble(high_price - low_price,2))*100;
      price_diffHC = high_price-close_price;
      price_diffHO = high_price-open_price;

      price_ratio = price_diffHC/price_diffHO;

      if(price_diff>=450 && close_price>(open_price1+(75*_Point)))
        {
         if(price_ratio>=0.45 && price_ratio<=0.75)
           {
            candle_indication = "BUY";

            if(pips<=1)
              {
               Alert("Check Charts! Candle of Interest");
               SendNotification("Check Charts! Candle of Interest");
              }
            pips++;
           }
         else
           {
            candle_indication = "NO BUY";

            if(price_ratio2>=0.0 && price_ratio2<=0.2)
               pips = 0;
            else
               if(price_ratio2>=0.9 && price_ratio2<=0.99)
                  pips = 0;
           }
        }

      Comment("Price Ratio: ",NormalizeDouble(price_ratio,4),"\n"
              "Price Difference: ",price_diff,"\n"
              "Trade Direction: ",candle_indication,"\n"
              "Prev. H4 Close Price: ",close_price1);
     }

// If it is a sell candlestick
   if(close_price<open_price)
     {
      price_diff = (NormalizeDouble(high_price - low_price,2))*100;
      price_diffCL = close_price-low_price;
      price_diffOL = open_price-low_price;

      price_ratio2 = price_diffCL/price_diffOL;

      if(price_diff>=450 && close_price<close_price1)
        {
         if(price_ratio2>=0.45 && price_ratio2<=0.75)
           {
            candle_indication = "SELL";

            if(pips<=1)
              {
               Alert("Check Charts! Candle of Interest");
               SendNotification("Check Charts! Candle of Interest");
              }
            pips++;
           }
         else
           {
            candle_indication = "NO SELL";

            if(price_ratio2>=0.0 && price_ratio2<=0.2)
               pips = 0;
            else
               if(price_ratio2>=0.9 && price_ratio2<=0.99)
                  pips = 0;
           }
        }

      Comment("Price Ratio: ",NormalizeDouble(price_ratio2,4),"\n"
              "Price Difference: ",price_diff,"\n"
              "Trade Direction: ",candle_indication,"\n"
              "Prev. H4 Close Price: ",close_price1);
     }
   return candle_indication;

  } // END OF THE CANDLE OF INTEREST FUNCTION
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                     CHECK RSI VALUE FUNCTION                     |
//+------------------------------------------------------------------+
void ExpertFunctions::CheckRSIValue(double rsi_top, double rsi_bottom, int &rsi_count, ENUM_TIMEFRAMES period_trade)
  {
//Variable declaration
   string signal = "";

//Create array for RSI Values
   double RSIArray[];
   int myRSIDefinition=iRSI(_Symbol,period_trade,14,PRICE_CLOSE);

//Sort array values and fill the array
   ArraySetAsSeries(RSIArray,true);
   CopyBuffer(myRSIDefinition,0,0,3,RSIArray);

//Get the RSI Value
   double myRSIValue = NormalizeDouble(RSIArray[0],2);

   string time_frame = EnumToString(period_trade);
   if(myRSIValue>rsi_top)
     {
      if(rsi_count<=1)
        {
         Alert(time_frame,": Check Charts");
         SendNotification("Check Charts RSI H1 is above: "+DoubleToString(rsi_top,2)+" \nTimeframe: "+EnumToString(period_trade));
        }
      signal="SELL";
      rsi_count++;
     }
   else
      if(myRSIValue<rsi_bottom)
        {
         if(rsi_count<=1)
           {
            Alert(time_frame,": Check Charts");
            SendNotification("Check Charts RSI H1 is below: "+DoubleToString(rsi_bottom,2)+" \nTimeframe: "+EnumToString(period_trade));
           }
         signal="BUY";
         rsi_count++;
        }

      else
        {
         signal="No signal, Wait";
         rsi_count=0;
        }

//Comment and check
   Comment("MyRSI_Value: ",myRSIValue,"\n",
           "MySignal: ",signal,"\n",
           "TimeFrame: ", time_frame);
  }
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
