//+------------------------------------------------------------------+
//|                                                SlaveEACopier.mq5 |
//|                                  Copyright 2023, Godfrey Muhinda |
//|                                               https://xauman.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, Godfrey Muhinda"
#property link      "https://xauman.com"
#property version   "1.00"

input string                  mySpreadSheet        = "SlaveEASignal1.csv";      // File name
int numValues = 0;
string line = "";
string values[];
string tradeType = "";

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
   ResetLastError();

   int fileHandle = FileOpen(mySpreadSheet, FILE_CSV|FILE_READ, ','); // Replace ';' with your CSV separator if different

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
         numValues = StringSplit(line, ',', values); // Replace ';' with your CSV separator

         if(numValues >= 4)  // Assuming 3 columns in the CSV (adjust this as needed)
           {
            tradeType = values[0];
           }
         else
           {
            Print("Invalid data format in line: ", line);
           }
        }
     }
     
     Comment("Values: ",tradeType);

   FileClose(fileHandle);
  }

//+------------------------------------------------------------------+
