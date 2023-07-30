//+------------------------------------------------------------------+
//|                                              TradeCopierTest.mq5 |
//|                                  Copyright 2023, Godfrey Muhinda |
//|                                               https://xauman.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Godfrey Muhinda"
#property link      "https://xauman.com"
#property version   "1.00"

//include the file Trade.mqh
#include<Trade\Trade.mqh>
#include <ExpertFunctions.mqh>

//Create an instance of CTrade
CTrade trade;

//Create an instance of ExpertFunctions
ExpertFunctions expert;

input string                  mySpreadSheet        = "MasterEASignal.csv";      // File name
datetime TimeNow = 0;
string positionType = "";


//+------------------------------------------------------------------+
//|Initialisation function                                           |
//+------------------------------------------------------------------+
void OnInit()
  {
   EventSetMillisecondTimer(100);
   return;
  }
//+------------------------------------------------------------------+
//|Deinitialisation function                                         |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
   return;
  }

//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnTimer()
  {
   
//Get the Ask and Bid Prices
   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

//Variable declaration
   double CurrentStopLoss = 0;
   double PositionPriceOpen = 0;
   ulong  PositionTicket = 0;
   double CurrentTakeProfit = 0;
   ulong  PositionType = 0;

//Check all open positions for the current symbol
   for(int i=PositionsTotal()-1; i>=0; i--) // count all currency pair positions
     {
      string symbol=PositionGetSymbol(i); //get position symbol

      if(_Symbol==symbol)  //if chart symbol equals position symbol
        {
         PositionTicket=PositionGetInteger(POSITION_TICKET);
         CurrentStopLoss=PositionGetDouble(POSITION_SL);
         CurrentTakeProfit=PositionGetDouble(POSITION_TP);
         PositionPriceOpen = PositionGetDouble(POSITION_PRICE_OPEN);
         PositionType = PositionGetInteger(POSITION_TYPE);

         //Check if the current Position is a BUY
         if(PositionType == POSITION_TYPE_BUY)
           {
            positionType = "BUY";
           }
         else
            if(PositionType==POSITION_TYPE_SELL)
              {
               positionType = "SELL";
              }

        } // End Symbol If loop
     }// End For Loop

   if(PositionsTotal()==0 && OrdersTotal()==0)
     {
      positionType = "NO OPEN POSITIONS";
     }
//Delete Previous file and reset last error
   FileDelete(mySpreadSheet);
   ResetLastError();

   TimeNow = TimeLocal();
   string localTime = TimeToString(TimeNow);


// Check if the file exists
   if(!FileIsExist(mySpreadSheet))
     {
      // If the file doesn't exist, create it
      int fileHandle = FileOpen(mySpreadSheet,FILE_WRITE|FILE_CSV|FILE_ANSI);
      if(fileHandle != INVALID_HANDLE)
        {
         // Write the header row (optional)
         FileWrite(fileHandle, "Signal:,",positionType,",Time:,",localTime,",PositionsOpen:,",PositionsTotal());
         FileFlush(fileHandle);
         FileClose(fileHandle);
         Comment("Executed as planned");
        }
      else
        {
         Print("Failed to create the CSV file");
         Comment("Dint execute as planned");
         FileClose(fileHandle);
         return;
        }
     }
  }

//+------------------------------------------------------------------+