//+------------------------------------------------------------------+
//|                                                    ExportData.mq5|
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

input datetime DateStart = 0;
input datetime DateEnd = 0;

//+------------------------------------------------------------------+
//|                    EXPORT DATA TO EXCEL                          |
//+------------------------------------------------------------------+
void OnTick()
  {
   static double LastHigh;
   static double LastLow;

//We create a price array
   MqlRates PriceInfo[];

//We sort the array from the current candle downwards
   ArraySetAsSeries(PriceInfo,true);

//We fill the array with price data
   int PriceData = CopyRates(_Symbol,PERIOD_M1,0,3,PriceInfo);

//Get the start and end dates, and number of days in between
   int startDay = GetDay(DateStart);
   int endDay = GetDay(DateEnd);

   int numberOfDays = endDay - startDay;

//Time for the data to be printed
   MqlDateTime timeofData;
   
   TimeToStruct(PriceInfo[1].time,timeofData);

   int currentTime = timeofData.hour;
   int testTime1 = 17;
   int testTime2 = 18;

//Loop through a specific time period
   for(int i=0; i < numberOfDays; i++)
     {
      //If prices for candles have changed
      if((LastHigh!=PriceInfo[1].high)&&(LastLow!=PriceInfo[1].low)&&(currentTime>=testTime1)&&(currentTime<testTime2))
        {
         //Date of Data collection
         int timeOfInfoDay = GetDay(PriceInfo[1].time);

         //Create a file name
         string mySpreadsheet = "DataSet"+IntegerToString(timeOfInfoDay)+".csv";

         //Open the file for reading and writing, as CSV format, ANSI mode
         int mySpreadsheetHandle = FileOpen(mySpreadsheet,FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI);

         //Go to the end of the file
         FileSeek(mySpreadsheetHandle,0,SEEK_END);

         //Append time, high and low to the file content
         FileWrite(mySpreadsheetHandle,"TimeStamp,",PriceInfo[1].time,",","High,",PriceInfo[1].high,",","Low,",PriceInfo[1].low, ","
                   ,"Open,",PriceInfo[1].open,",","Close,",PriceInfo[1].close, ","
                   ,"Volume,",PriceInfo[1].tick_volume, ",","Real Volume,",PriceInfo[1].real_volume);

         //Close the file
         FileClose(mySpreadsheetHandle);

         //Assign the current value for the next time
         LastHigh = PriceInfo[1].high;
         LastLow = PriceInfo[1].low;

        }

      //Create a chart output
      Comment("LastHigh: ", PriceInfo[1].high, "\n",
              "LastLow: ", PriceInfo[1].low);
     }//End of for loop
  }
// END OF ON TICK FUNCTION
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                        GETDAY FUNCTION                           |
//+------------------------------------------------------------------+
int GetDay(datetime trade_date)
  {
//DateTime Struct
   MqlDateTime TradeDate;

   TimeToStruct(trade_date,TradeDate);

   return TradeDate.day;
   
  }//END OF GETDAY FUNCTION
//+------------------------------------------------------------------+
