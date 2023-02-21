//+------------------------------------------------------------------+
//|                                                      DealInfo.mq5|
//|                                      Copyright 2022, Godi Blasio |
//|                                     https://tradersliquidity.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, Godi Blasio"
#property link      "https://tradersliquidity.com"
#property version   "1.00"

#include <Trade\OrderInfo.mqh>
#include <Trade\DealInfo.mqh>
#include <Trade\HistoryOrderInfo.mqh>

COrderInfo orderInfo;
CDealInfo dealInfo;
CHistoryOrderInfo historyInfo;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnStart()
  {
   HistorySelect(0,TimeCurrent());
   int TotalNumberofDeals = HistoryDealsTotal();
   ulong TicketNumber = 0;
   ulong positionTicket = 0;
   double positionVolume,positionPrice, positionProfit = 0;
   string positionTypes = "";
   datetime positionTime = 0;
   long orderType,positionType = 0;


   for(int i = 0; i <= TotalNumberofDeals; i++)
     {
      TicketNumber = HistoryDealGetTicket(i);

      //Get the last order deal type
      orderType = HistoryDealGetInteger(TicketNumber,DEAL_ENTRY);

      if(historyInfo.SelectByIndex(i) && orderType==1)
        {
         //Get the PositionTime
         positionTime = (datetime)HistoryDealGetInteger(TicketNumber,DEAL_TIME);

         //Get the PositionTicket
         positionTicket = historyInfo.Ticket();

         //Get the PositionType
         positionType = historyInfo.OrderType();

         if(positionType == ORDER_TYPE_BUY)
           {
            positionTypes = "BUY";
           }
         else if(positionType == ORDER_TYPE_SELL)
           {
            positionTypes = "SELL";
           }
         else
           {
            positionTypes = "ERROR";
           }

         //Get the PositionVolume
         positionVolume = HistoryDealGetDouble(TicketNumber,DEAL_VOLUME);

         //Get the PositionPrice
         positionPrice = HistoryDealGetDouble(TicketNumber,DEAL_PRICE);

         //Get the PositionProfit
         positionProfit = HistoryDealGetDouble(TicketNumber,DEAL_PROFIT);

         //Create a file name
         string mySpreadsheet = "DataSet.csv";

         //Open the file for reading and writing, as CSV format, ANSI mode
         int mySpreadsheetHandle = FileOpen(mySpreadsheet,FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI);

         //Go to the end of the file
         FileSeek(mySpreadsheetHandle,0,SEEK_END);

         //Append time, high and low to the file content
         FileWrite(mySpreadsheetHandle,"PositionTime,",positionTime,",","PositionTicket,",positionTicket,",","PositionType,",positionTypes,","
                   "PositionVolume,",positionVolume,",","PositionPrice,",positionPrice,",","PositionProfit,",positionProfit);

         //Close the file
         FileClose(mySpreadsheetHandle);

        }
     }
  }
//+------------------------------------------------------------------+
