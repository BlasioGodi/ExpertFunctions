//include the file Trade.mqh
#include<Trade\Trade.mqh>
#include <ExpertFunctions.mqh>

//Create an instance of CTrade
CTrade trade;

//Create an instance of ExpertFunctions
ExpertFunctions expert;

input int DesiredProfitinPips = 75;
input double LevelCheck = 0;
input double LevelCheck2 = 0;
input int ZoneDeviation = 0;
input double LotSize = 0;

input int lineWidth = 1;
input ENUM_LINE_STYLE lineStyle = STYLE_SOLID;
input color lineColor = clrMediumSpringGreen;

input int Time1 = 12;
input int Time2 = 50;
extern int count = 0;

//Temporary Code Measure to draw lines using struct
struct LineName
  {
   string            Name1;
   string            Name2;
  };


//+------------------------------------------------------------------+
//|               OBJECT LINE INITIALIZATION FUNCTION                |
//+------------------------------------------------------------------+
int OnInit()
  {
// struct LineName
   LineName names;
   names.Name1 = "A";
   names.Name2 = "B";

//Create 1st Object Line
   expert.CreateObjectLine(LevelCheck,ZoneDeviation,lineColor,lineStyle,lineWidth,names.Name1);
   expert.CreateObjectLine(LevelCheck2,ZoneDeviation,lineColor,lineStyle,lineWidth,names.Name2);

   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//lv.Delete();
//dvH.Delete();
//dvL.Delete();
  }


//+------------------------------------------------------------------+
//|                    ON-TICK MAIN FUNCTION                         |
//+------------------------------------------------------------------+
void OnTick()
  {
// Get the ask price
   double Ask=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits);

// Get the bid price
   double Bid=NormalizeDouble(SymbolInfoDouble(_Symbol,SYMBOL_BID),_Digits);

//Get the PositionType (Either buy or sell)
   ulong PositionType = PositionGetInteger(POSITION_TYPE);
   

//+------------------------------------------------------------------+
// INSERT THE TRADE SIGNAL TEST CONDITIONS HERE

//Execute trades between the 12th min and 50th min
   if(expert.LapsedTimerEntry(Time1,Time2) == true)
     {

      // Check if price is within the First Zone
      if(expert.ZoneSignal(LevelCheck,ZoneDeviation,count)>=1 && expert.ZoneSignal(LevelCheck,ZoneDeviation,count)<=50 &&(PositionsTotal()==0)&&(OrdersTotal()==0))
        {
         // Buy Limit at support level
         if(Bid<expert.Lows()+(50*_Point) && expert.PriceZone(LevelCheck,ZoneDeviation,Ask)==true && expert.MarketDirection() == "SELL")
            trade.Buy(LotSize,_Symbol,Bid,0,0,NULL);
            //trade.Buy(LotSize,_Symbol,Bid,(Bid-(300*_Point)),Bid+350*_Point,NULL);
            
         // Sell limit at resistance level
         if(Ask>expert.Highs()-(50*_Point) && expert.PriceZone(LevelCheck,ZoneDeviation,Ask)==true && expert.MarketDirection() == "BUY")
            trade.Sell(LotSize,_Symbol,Ask,0,0,NULL);
            //trade.Sell(LotSize,_Symbol,Ask,(Ask+(300*_Point)),Ask-350*_Point,NULL);
            
        }

      if(expert.ZoneSignal(LevelCheck2,ZoneDeviation,count)>=1 && expert.ZoneSignal(LevelCheck2,ZoneDeviation,count)<=50 &&(PositionsTotal()==0)&&(OrdersTotal()==0))
        {
         // Buy Limit at support level
         if(Bid<expert.Lows()+(50*_Point) && expert.PriceZone(LevelCheck2,ZoneDeviation,Ask)==true && expert.MarketDirection() == "SELL")
            trade.Buy(LotSize,_Symbol,Bid,(Bid-(300*_Point)),Bid+350*_Point,NULL);
            //trade.Buy(LotSize,_Symbol,Bid,(Bid-(300*_Point)),Bid+350*_Point,NULL);
            
         // Sell limit at resistance level
         if(Ask>expert.Highs()-(50*_Point) && expert.PriceZone(LevelCheck2,ZoneDeviation,Ask)==true && expert.MarketDirection() == "BUY")
            trade.Sell(LotSize,_Symbol,Ask,(Ask+(300*_Point)),Ask-350*_Point,NULL);
            //trade.Sell(LotSize,_Symbol,Ask,(Ask+(300*_Point)),Ask-350*_Point,NULL);
            
        }

      //Comment("Check: ",NormalizeDouble(expert.Lows()+(70*_Point),_Digits));
     }

// Activate the PositionPipProfit function
   expert.PositionPipProfit(DesiredProfitinPips);


// INSERT THE TRADE SIGNAL TEST CONDITIONS HERE
//+------------------------------------------------------------------+


  }// END OF THE ON-TICK MAIN FUNCTION
//+------------------------------------------------------------------+

//--------TRADE CONDITIONS----------KEEP THESE-----------------+
//(expert.ZoneSignal(LevelCheck, ZoneDeviation, count)==150)&&
//Bid<expert.Lows()+(300*_Point) && (FOR THE BUY/BUY LIMIT CONDITION)
//Ask>expert.Highs()-(300*_Point) && (FOR THE SELL/SELL LIMIT CONDITION)

// trade.Buy(LotSize,_Symbol,Bid,(Bid-(300*_Point)),Bid+350*_Point,NULL);
// trade.Sell(LotSize,_Symbol,Ask,(Ask+(300*_Point)),Ask-350*_Point,NULL);

//trade.BuyLimit(TradeVolume,(Bid-(100*_Point)),_Symbol,Bid-315*_Point,Bid+650*_Point,ORDER_TIME_GTC,0,NULL);
//trade.SellLimit(TradeVolume,(Ask+(100*_Point)),_Symbol,Ask+315*_Point,Ask-650*_Point,ORDER_TIME_GTC,0,NULL);

//--------TRADE CONDITIONS----------KEEP THESE-----------------+


//+------------------------------------------------------------------+
