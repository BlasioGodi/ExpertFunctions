//+------------------------------------------------------------------+
//|                                                 Inception-CAD.mq5|
//|                                      Copyright 2022, Godi Blasio |
//|                                     https://tradersliquidity.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Godi Blasio"
#property link      "https://tradersliquidity.com"
#property version   "1.00"

// include the file Trade.mqh
#include<Trade\Trade.mqh>

//Create an instance of CTrade
CTrade trade;

//Trade Input Value
input datetime TradingTime = D'06.05.2021 13:59:50';

//Trade Expiration Date/Time
input datetime ExpiryDate = D'06.05.2021 15:00:00';

//Trade Take Profit Value
input int MyTakeProfitValue;

//Trade Distance from BID/ASK price
input int TradeDistance;

//TakeProfit Amount if need be
input string TakeProposedProfit;
input double DesiredProfit1;

//Macros for Touch Levels
#define CurrencyTouch1 5
#define CurrencyTouch2 4
#define CurrencyTouch3 3
#define CurrencyTouch4 2

//Trade Settings
#define tradeVolume 0.55
#define StopLossValue 150

//Macros for Touch Levels
#define GOLDENRATIO 1.61803
#define FIBLEVEL1 125
#define FIBLEVEL2 450
#define FIBLEVEL3 565
#define FIBLEVEL4 650

//Fib Values for CAD
//FIBLEVEL1 200
//FIBLEVEL2 450
//FIBLEVEL3 565
//FIBLEVEL4 650

//+------------------------------------------------------------------+
//|                    On Tick Function Start                        |
//+------------------------------------------------------------------+
void OnTick()
  {
// Get the ask price
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);

// Get the bid price
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

// Get the local date and time
   datetime OfficialTime = TimeLocal();

// Trade Time
   datetime d1 = TradingTime;

   if(OfficialTime==d1)
     {
      if((OrdersTotal()==0)&&(PositionsTotal()==0))
        {

         trade.BuyStop(tradeVolume,Ask+TradeDistance*_Point,_Symbol,Ask-StopLossValue*_Point,Ask+MyTakeProfitValue*_Point,ORDER_TIME_SPECIFIED,ExpiryDate,NULL);
         trade.SellStop(tradeVolume,Ask-TradeDistance*_Point,_Symbol,Ask+StopLossValue*_Point,Ask-MyTakeProfitValue*_Point,ORDER_TIME_SPECIFIED,ExpiryDate,NULL);

        }
     }

// Call the CloseCurrentPosition function
   CloseCurrentPosition(Ask);

// Get the Position Details
   PositionDetails();

  }//End of the OnTick Main function
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                CloseCurrentPosition function                     |
//+------------------------------------------------------------------+
void CloseCurrentPosition(double Ask)
  {
// Initialize variable Count with value = 0
   int Count=0;

// From the number of positions count down to zero and go through all Open Positions.
   for(int i=PositionsTotal()-1; i>=0; i--)
     {
      // Get the position currency pair
      string symbol = PositionGetSymbol(i);

      // If chart equals position currency pair
      if(_Symbol == symbol)
        {
         //Get the Ticket Number
         ulong PositionTicket = PositionGetInteger(POSITION_TICKET);

         //Get the Position Direction
         long PositionDirection = PositionGetInteger(POSITION_TYPE);

         //Calculate the open price for the position
         double PositionPriceOpen = PositionGetDouble(POSITION_PRICE_OPEN);

         //Calculate the current price for the position
         double PositionPriceCurrent = PositionGetDouble(POSITION_PRICE_CURRENT);

         if(TakeProposedProfit == "YES"){
            //Close the position once the DesireTakeProfit Value is met
            TakeProfit(PositionTicket, DesiredProfit1);
            break;
         }   
         else{

         //TakeProfitLevel1 function
         TakeProfitLevel1(PositionTicket,PositionDirection,PositionPriceOpen,PositionPriceCurrent);

         //TakeProfitLevel2 function
         TakeProfitLevel2(PositionTicket,PositionDirection,PositionPriceOpen,PositionPriceCurrent);

         //TakeProfitLevel3 function
         TakeProfitLevel3(PositionTicket,PositionDirection,PositionPriceOpen,PositionPriceCurrent);

         //TakeProfitLevel4 function
         TakeProfitLevel4(PositionTicket,PositionDirection,PositionPriceOpen,PositionPriceCurrent);
         }

        }

     }//End of the for loop

  } //End of the ChangePositionSize function
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                TakeProfitLevel1 function                         |
//+------------------------------------------------------------------+
void TakeProfitLevel1(ulong PositionTicket, long PositionDirection, double PositionPriceOpen, double PositionPriceCurrent)
  {
// Initialize variable Count with value = 0
   int Count=0;

//If it is a Buy position
   if(PositionDirection == POSITION_TYPE_BUY)
      for(int j = 1; j<=CurrencyTouch1; j++)
        {
         if(PositionPriceCurrent == (PositionPriceOpen+FIBLEVEL1*_Point))
           {
            Count++;
            if(Count == CurrencyTouch1)

               trade.PositionClose(PositionTicket);
           }
        }//End of the for loop

//If it is a Sell position
   if(PositionDirection == POSITION_TYPE_SELL)
      for(int j = 1; j<=CurrencyTouch1; j++)
        {
         if(PositionPriceCurrent == (PositionPriceOpen-FIBLEVEL1*_Point))
           {
            Count++;
            if(Count == CurrencyTouch1)

               trade.PositionClose(PositionTicket);
           }
        }//End of the for loop


  } //End of the TakeProfitLevel1 function
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                TakeProfitLevel2 function                         |
//+------------------------------------------------------------------+
void TakeProfitLevel2(ulong PositionTicket, long PositionDirection, double PositionPriceOpen, double PositionPriceCurrent)
  {
// Initialize variable Count with value = 0
   int Count=0;

//If it is a Buy position
   if(PositionDirection == POSITION_TYPE_BUY)
      for(int j = 1; j<=CurrencyTouch2; j++)
        {
         if(PositionPriceCurrent == (PositionPriceOpen+FIBLEVEL2*_Point))
           {
            Count++;
            if(Count == CurrencyTouch2)

               trade.PositionClose(PositionTicket);
           }
        }//End of the for loop

//If it is a Sell position
   if(PositionDirection == POSITION_TYPE_SELL)
      for(int j = 1; j<=CurrencyTouch2; j++)
        {
         if(PositionPriceCurrent == (PositionPriceOpen-FIBLEVEL2*_Point))
           {
            Count++;
            if(Count == CurrencyTouch2)

               trade.PositionClose(PositionTicket);
           }
        }//End of the for loop

  } //End of the TakeProfitLevel2 function
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                TakeProfitLevel3 function                         |
//+------------------------------------------------------------------+
void TakeProfitLevel3(ulong PositionTicket, long PositionDirection, double PositionPriceOpen, double PositionPriceCurrent)
  {
// Initialize variable Count with value = 0
   int Count=0;

//If it is a Buy position
   if(PositionDirection == POSITION_TYPE_BUY)
      for(int j = 1; j<=CurrencyTouch3; j++)
        {
         if(PositionPriceCurrent == (PositionPriceOpen+FIBLEVEL3*_Point))
           {
            Count++;
            if(Count == CurrencyTouch3)

               trade.PositionClose(PositionTicket);
           }
        }//End of the for loop

//If it is a Sell position
   if(PositionDirection == POSITION_TYPE_SELL)
      for(int j = 1; j<=CurrencyTouch3; j++)
        {
         if(PositionPriceCurrent == (PositionPriceOpen-FIBLEVEL3*_Point))
           {
            Count++;
            if(Count == CurrencyTouch3)

               trade.PositionClose(PositionTicket);
           }
        }//End of the for loop

  } //End of the TakeProfitLevel3 function
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                TakeProfitLevel4 function                         |
//+------------------------------------------------------------------+
void TakeProfitLevel4(ulong PositionTicket, long PositionDirection, double PositionPriceOpen, double PositionPriceCurrent)
  {
// Initialize variable Count with value = 0
   int Count=0;

//If it is a Buy position
   if(PositionDirection == POSITION_TYPE_BUY)
      for(int j = 1; j<=CurrencyTouch4; j++)
        {
         if(PositionPriceCurrent == (PositionPriceOpen+FIBLEVEL4*_Point))
           {
            Count++;
            if(Count == CurrencyTouch4)

               trade.PositionClose(PositionTicket);
           }
        }//End of the for loop

//If it is a Sell position
   if(PositionDirection == POSITION_TYPE_SELL)
      for(int j = 1; j<=CurrencyTouch4; j++)
        {
         if(PositionPriceCurrent == (PositionPriceOpen-FIBLEVEL4*_Point))
           {
            Count++;
            if(Count == CurrencyTouch4)

               trade.PositionClose(PositionTicket);
           }
        }//End of the for loop

  } //End of the TakeProfitLevel4 function
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                PositionDetails function                          |
//+------------------------------------------------------------------+
void PositionDetails()
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

         //Calculate the current position profit
         double PositionProfit = PositionGetDouble(POSITION_PROFIT);

         //Get the current Position Details
         double PositionDetails = PositionPriceOpen-(FIBLEVEL3*_Point);

         //Get the tickvalue
         double SymbolInfo = SymbolInfoDouble(Symbol(),SYMBOL_TRADE_TICK_VALUE);

         if(PositionSymbol==_Symbol)
           {
            Comment(
               "Position Ticket: ", PositionTicket, "\n",
               "Position Symbol: ", PositionSymbol, "\n",
               "Position Profit: ", PositionProfit, "\n",
               "Position Price Open: ", PositionPriceOpen, "\n",
               "Position Price Current: ", PositionPriceCurrent, "\n",
               "Position Price Details: ", PositionDetails, "\n",
               "Position Tick Value: ", SymbolInfo
            );
           }

        }
     }
  } //End of the PositionDetails function
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                TakeProfit function                               |
//+------------------------------------------------------------------+
void TakeProfit(ulong PositionTicket, double DesiredProfit)
  {

//Calculate the current position profit
   double PositionProfit = PositionGetDouble(POSITION_PROFIT);

//If the PositionProfit is greater than the DesiredProfit
   if(PositionProfit > DesiredProfit)

      //Close the position
      trade.PositionClose(PositionTicket);

  } //End of the TakeProfit function
//+------------------------------------------------------------------+

