//+------------------------------------------------------------------+
//|                                              TradeCopierTest.mq5 |
//|                                  Copyright 2023, Godfrey Muhinda |
//|                                               https://xauman.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Godfrey Muhinda"
#property link      "https://xauman.com"
#property version   "1.00"

input string                  mySpreadSheet        = "MasterEASignal.csv";      // File name
datetime CurrentTime = 0;

//+------------------------------------------------------------------+
//|Initialisation function                                           |
//+------------------------------------------------------------------+
void OnInit()
  {
   EventSetTimer(1);
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
  
  //Delete Previous file and reset last error
   FileDelete(mySpreadSheet);
   ResetLastError();
   
   CurrentTime = TimeLocal();
   string localTime = TimeToString(CurrentTime);
   

// Check if the file exists
   if(!FileIsExist(mySpreadSheet))
     {
      // If the file doesn't exist, create it
      int fileHandle = FileOpen(mySpreadSheet,FILE_READ|FILE_WRITE|FILE_CSV|FILE_ANSI);
      if(fileHandle != INVALID_HANDLE)
        {
         // Write the header row (optional)
         FileWrite(fileHandle, "TradeType,","OrderID,","Time:,",localTime);
         FileFlush(fileHandle);
         FileClose(fileHandle);
         Comment("Executed as planned");
        }
      else
        {
         Print("Failed to create the CSV file");
         Comment("Dint execute as planned");
         return;
        }
     }
  }

//+------------------------------------------------------------------+
