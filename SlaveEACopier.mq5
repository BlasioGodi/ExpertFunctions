//+------------------------------------------------------------------+
//|                                                SlaveEACopier.mq5 |
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

input string                  mySpreadSheet        = "SlaveEASignal1.csv";      // File name
int numValues = 0;
string line = "";
string values[];
string tradeType = "";
long totalPositions = 0;

//+------------------------------------------------------------------+
//|Initialisation function                                           |
//+------------------------------------------------------------------+
void OnInit()
  {
   EventSetMillisecondTimer(50);
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

   double Ask = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid = NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

   ResetLastError();

   int fileHandle = FileOpen(mySpreadSheet,FILE_CSV|FILE_READ|FILE_ANSI,';'); // Replace ';' with your CSV separator if different

   if(fileHandle == INVALID_HANDLE)
     {
      Print("Failed to open file: ", mySpreadSheet);
      return;
     }

   while(!FileIsEnding(fileHandle))
     {
      line = FileReadString(fileHandle);

      if(StringLen(line) > 0)
        {
         // Remove whitespace characters from the line
         int replaced = StringReplace(line, " ", ""); // Replace space with an empty string
         replaced = StringReplace(line, "\t", ""); // Replace tab with an empty string

         numValues = StringSplit(line, ',', values); // Replace ';' with your CSV separator

         if(numValues >= 4)  // Assuming 3 columns in the CSV (adjust this as needed)
           {
            tradeType = values[1];
           }
         else
           {
            Print("Invalid data format in line: ",line);
           }
        }
     }

//If no open positions exist and Buy signal occurs
   if((PositionsTotal()==0))
     {
      if(tradeType=="BUY")
        {
         //Open a Buy position
         trade.Buy(0.1,NULL,Ask,0,(Ask+1000*_Point),NULL);
         Comment("Signal: ",tradeType);
        }
      else
         if(tradeType=="SELL")
           {
            //Open a Sell position
            trade.Sell(0.1,NULL,Bid,0,(Bid-1000*_Point),NULL);
            Comment("Signal: ",tradeType);
           }
     }
   else
     {
      Comment("Signal: ",tradeType);
     }


//If there are no open positions from the MasterEA
   if(tradeType=="NOOPENPOSITIONS")
     {
      expert.SimplePositionClose();
     }

   if(PositionsTotal()>0)
     {
      totalPositions = StringToInteger(values[5]);

      Comment("#Signal: ",tradeType,"\n"
              "#TotalPositions: ",totalPositions);
                  
     }
   FileClose(fileHandle);
  }

//+------------------------------------------------------------------+
