//+------------------------------------------------------------------+
//|                                            Request Trade History |
//|                                  Copyright 2022, Godfrey Muhinda |
//|                                      http://tradersliquidity.com |
//+------------------------------------------------------------------+
#include <Trade\OrderInfo.mqh>
#include <Trade\DealInfo.mqh>
#include <Trade\HistoryOrderInfo.mqh>

COrderInfo orderInfo;
CDealInfo dealInfo;
CHistoryOrderInfo historyInfo;

input datetime                fromDate             = D'2017.08.07 11:06:20';  // From date
input datetime                toDate               = __DATE__+60*60*24;       // To date
input string                  mySpreadSheet        = "DealsHistory.csv";      // File name

//---
int mySpreadSheetHandle = 0;

//+------------------------------------------------------------------+
//|                 HISTORY SELECT SCRIPT FUNCTION                   |
//+------------------------------------------------------------------+
void OnStart()
  {

//Delete Previous file and reset last error
   FileDelete(mySpreadSheet);
   ResetLastError();

   HistorySelect(0,TimeCurrent());
   uint total_Deals = HistoryDealsTotal();
   ulong deal_Ticket,deal_Ticket2 = 0;
   string order_Types = "";

   for(uint i = 0; i < total_Deals; i++)
     {
      deal_Ticket = HistoryDealGetTicket(i);

      if(historyInfo.SelectByIndex(i)||dealInfo.SelectByIndex(i))
        {
         //--Deal Information
         long     deal_order        =HistoryDealGetInteger(deal_Ticket,DEAL_ORDER);
         long     deal_time         =HistoryDealGetInteger(deal_Ticket,DEAL_TIME);
         long     deal_type         =HistoryDealGetInteger(deal_Ticket,DEAL_TYPE);
         long     deal_entry        =HistoryDealGetInteger(deal_Ticket,DEAL_ENTRY);
         long     deal_time_msc     =HistoryDealGetInteger(deal_Ticket,DEAL_TIME_MSC);

         double   deal_volume       =HistoryDealGetDouble(deal_Ticket,DEAL_VOLUME);
         double   deal_price        =HistoryDealGetDouble(deal_Ticket,DEAL_PRICE);
         double   deal_profit       =HistoryDealGetDouble(deal_Ticket,DEAL_PROFIT);

         ulong    order_Ticket      =historyInfo.Ticket();
         long     order_Type        =historyInfo.OrderType();
         datetime order_setupTime   =historyInfo.TimeSetup();
         datetime order_realTime    =historyInfo.TimeDone();


         //--Conversion of types
         datetime deal_realTime     =(datetime)deal_time;
         datetime deal_realTime_msc = (datetime)deal_time_msc;
         string   time              =TimeToString((datetime)deal_time,TIME_DATE|TIME_MINUTES|TIME_SECONDS);
         string   type              =EnumToString((ENUM_DEAL_TYPE)deal_type);
         string   entry             =EnumToString((ENUM_DEAL_ENTRY)deal_entry);

         if(order_Type == ORDER_TYPE_BUY)
           {
            order_Types = "BUY";
           }
         else
            if(order_Type == ORDER_TYPE_SELL)
              {
               order_Types = "SELL";
              }

         //Open the file for reading and writing, as CSV format, ANSI mode
         mySpreadSheetHandle = FileOpen(mySpreadSheet,FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI);

         if(mySpreadSheetHandle==INVALID_HANDLE)
           {
            PrintFormat("Failed to open %s file, Error code = %d",mySpreadSheet+".csv",GetLastError());
            return;
           }

         //Go to the end of the file
         FileSeek(mySpreadSheetHandle,0,SEEK_END);

         //Append time, high and low to the file content
         FileWrite(mySpreadSheetHandle,"SetupTime,",deal_realTime,",","OrderTimeDone,",order_realTime,",","DealTicket,",deal_Ticket,",","OrderType,",order_Types,","
                   "DealVolume,",deal_volume,",","DealPrice,",deal_price,",","DealProfit,",deal_profit);

         //Close the file
         FileClose(mySpreadSheetHandle);

        }
     }
  }
//+------------------------------------------------------------------+

