//+------------------------------------------------------------------+
//|                                            Request Trade History |
//|                                  Copyright 2022, Godfrey Muhinda |
//|                                      http://tradersliquidity.com |
//+------------------------------------------------------------------+
#include <Trade\OrderInfo.mqh>
#include <Trade\DealInfo.mqh>
#include <Trade\HistoryOrderInfo.mqh>
#include <Arrays\ArrayInt.mqh>
#include <Arrays\ArrayLong.mqh>

COrderInfo orderInfo;
CDealInfo dealInfo;
CHistoryOrderInfo historyInfo;


input datetime                fromDate             = D'2017.08.07 11:06:20';  // From date
input datetime                toDate               = D'2022.10.25 14:00:00';  // To date
input string                  mySpreadSheet        = "DealsHistory_OUT.csv";  // File name
extern datetime               datum                = D'1970.01.01 00:00:00';

//input datetime                toDate               = __DATE__+60*60*24;       // To date

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

   HistorySelect(0,toDate);
   uint     total_Deals      = HistoryDealsTotal();
   ulong    deal_Ticket      = 0;
   string   order_Types      = "";
   long     deal_positionID  = 0;
   
   for(uint i = 1; i < total_Deals; i++)
     {
      deal_Ticket = HistoryDealGetTicket(i);

      if(historyInfo.SelectByIndex(i)||dealInfo.SelectByIndex(i))
        {
         if(HistoryDealGetInteger(deal_Ticket,DEAL_ENTRY)==DEAL_ENTRY_OUT)
           {
            //--Deal Information
            long     deal_order        =HistoryDealGetInteger(deal_Ticket,DEAL_ORDER);
            long     deal_time         =HistoryDealGetInteger(deal_Ticket,DEAL_TIME);
            long     deal_type         =HistoryDealGetInteger(deal_Ticket,DEAL_TYPE);
            long     deal_entry        =HistoryDealGetInteger(deal_Ticket,DEAL_ENTRY);
            long     deal_time_msc     =HistoryDealGetInteger(deal_Ticket,DEAL_TIME_MSC);
            string   deal_symbol       =HistoryDealGetString(deal_Ticket,DEAL_SYMBOL);
            deal_positionID   =HistoryDealGetInteger(deal_Ticket,DEAL_POSITION_ID);
            

            double   deal_volume       =HistoryDealGetDouble(deal_Ticket,DEAL_VOLUME);
            double   deal_price        =HistoryDealGetDouble(deal_Ticket,DEAL_PRICE);
            double   deal_profit       =HistoryDealGetDouble(deal_Ticket,DEAL_PROFIT);

            ulong    order_Ticket      =historyInfo.Ticket();
            long     order_Type        =historyInfo.OrderType();
            datetime order_setupTime   =historyInfo.TimeSetup();

            //--Conversion of types
            datetime deal_realTime     =(datetime)deal_time;
            string   time              =TimeToString((datetime)deal_time,TIME_DATE|TIME_MINUTES|TIME_SECONDS);
            string   type              =EnumToString((ENUM_DEAL_TYPE)deal_type);
            string   entry             =EnumToString((ENUM_DEAL_ENTRY)deal_entry);

            if(deal_type==DEAL_TYPE_BUY)
              {
               order_Types = "BUY";
              }
            else
               if(deal_type==DEAL_TYPE_SELL)
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

            //Append price information to the CSV file
            FileWrite(mySpreadSheetHandle,"SetupTime,",deal_realTime,",Symbol,",deal_symbol,",DealTicket,",deal_Ticket,
                     ",DealType,",order_Types,",Volume,",deal_volume,",DealPrice,",deal_price,",DealProfit,",deal_profit,",PositionID,",deal_positionID);

            //Close the file
            FileClose(mySpreadSheetHandle);

           }
        }
     }
  }
//+------------------------------------------------------------------+
