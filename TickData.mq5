//+------------------------------------------------------------------+
//|                                            Request Trade History |
//|                                  Copyright 2022, Godfrey Muhinda |
//|                                      http://tradersliquidity.com |
//+------------------------------------------------------------------+

//include the file Trade.mqh
#include<Trade\Trade.mqh>
#include <Trade\OrderInfo.mqh>
#include <ExpertFunctions.mqh>

//Create Object instances
CTrade trade;
ExpertFunctions expert;
COrderInfo orderInfo;

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
void OnTick()
  {
  MqlTick tick_data[];
  
  ulong fromTime = (ulong)fromDate;
  ulong toTime = (ulong)toDate;
  
  CopyTicksRange(_Symbol,tick_data,COPY_TICKS_ALL,fromDate,toDate);
  
    Comment("AskPrice: ",tick_data[fromTime].ask);
  
  //Comment("AskPrice: ",tick_data[0].ask,"\n"
  //        "BidPrice: ",tick_data[0].bid,"\n"
  //        "Time: ",tick_data[0].time,"\n"
  //        "Volume: ",tick_data[0].volume_real
  //          );
  }

//+------------------------------------------------------------------+

////Delete Previous file and reset last error
//   FileDelete(mySpreadSheet);
//   ResetLastError();
//
////Open the file for reading and writing, as CSV format, ANSI mode
//   mySpreadSheetHandle = FileOpen(mySpreadSheet,FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI);
//
//   if(mySpreadSheetHandle==INVALID_HANDLE)
//     {
//      PrintFormat("Failed to open %s file, Error code = %d",mySpreadSheet+".csv",GetLastError());
//      return;
//     }
//
////Go to the end of the file
//   FileSeek(mySpreadSheetHandle,0,SEEK_END);
//
////Append price information to the CSV file
//   FileWrite(mySpreadSheetHandle,"TickData,",tick_data[1].ask);
//
////Close the file
//   FileClose(mySpreadSheetHandle);

