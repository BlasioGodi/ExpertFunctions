//+------------------------------------------------------------------+
//|                                            Request Trade History |
//|                                  Copyright 2022, Godfrey Muhinda |
//|                                      http://tradersliquidity.com |
//+------------------------------------------------------------------+

#property script_show_inputs
#property description "TickData Retrieval"

//include the file Trade.mqh
#include<Trade\Trade.mqh>
#include <Trade\OrderInfo.mqh>

//Create Object instances
CTrade trade;

//--External input values
input datetime                fromDate             = D'2022.11.02 10:10:00';  // From date
input datetime                toDate               = D'2022.11.02 10:15:00';       // To date
input string                  mySpreadSheet        = "TickData.csv";      // File name

//---
int mySpreadSheetHandle = 0;
int get_ticks = 10000;

//+------------------------------------------------------------------+
//|                 HISTORY SELECT SCRIPT FUNCTION                   |
//+------------------------------------------------------------------+

//int init()   { fileHandle = FileOpen(Symbol()+" - "+FileName,FILE_WRITE|FILE_SHARE_READ|FILE_CSV); return(0); }
//int deinit() {              FileClose(fileHandle);                                 return(0); }

int OnStart()
  {
// Get the Ask and Bid price
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);
   
   double price_ask[10];
   double price_bid[10];

//Delete Previous file and reset last error
   FileDelete(mySpreadSheet);
   ResetLastError();

//Open the file for reading and writing, as CSV format, ANSI mode
   mySpreadSheetHandle = FileOpen(mySpreadSheet,FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI);

   if(mySpreadSheetHandle==INVALID_HANDLE)
     {
      PrintFormat("Failed to open %s file, Error code = %d",mySpreadSheet+".csv",GetLastError());
     }

//Go to the end of the file
   FileSeek(mySpreadSheetHandle,0,SEEK_END);

//Append price information to the CSV file
   FileWriteString(mySpreadSheetHandle,"Time,"+TimeToString(TimeCurrent())+","+DoubleToString(Bid,_Digits)+","+DoubleToString(Ask,_Digits));

//Close the file
   FileClose(mySpreadSheetHandle);
   
   return (0);
  }

//+------------------------------------------------------------------+

//TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS)+","+DoubleToString(Bid,Digits)+","+DoubleToString(Ask,Digits)+","+DoubleToString(Volume[0],0)+"\n")