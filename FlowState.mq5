// include the file Trade.mqh
#include<Trade\Trade.mqh>
#include <ExpertFunctions.mqh>

//Create an instance of CTrade
CTrade trade;

//Create an instance of COrderInfo
COrderInfo orderInfo;

//Create an instance of CPositionInfo
CPositionInfo positionInfo;

//Create an instance of ExpertFunctions
ExpertFunctions expert;

// Input variables for Takeprofit, TradeVolume and TradingTime
input double PipProfitsBUY = 50;
input double PipProfitsSELL = 50;
input int DesiredProfitinPips = 50;
input double TradeVolume = 0.1;
input int TradingTimeStart = 18;
input int TradingTimeEnd = 21;
input double LevelCheck = 0;
input int ZoneDeviation = 0;

input int lineWidth = 1;
input ENUM_LINE_STYLE lineStyle = STYLE_SOLID;
input color lineColor = clrMediumSpringGreen;


input double SandR1 = 1940.00;
input double SandR2 = 1935.00;
input double SandR3 = 1930.00;
input double SandR4 = 1925.00;
input double SandR5 = 1920.00;
input double SandR6 = 1915.00;
input double SandR7 = 1910.00;
input double SandR8 = 1905.00;


extern int TimeLapsed = 5;
extern int PointDeviation = 65;
extern int count = 0;

//+------------------------------------------------------------------+
//|               OBJECT LINE INITIALIZATION FUNCTION                |
//+------------------------------------------------------------------+
int OnInit()
  {

//Create 1st Object Line
   expert.CreateObjectLine(SandR1,ZoneDeviation,lineColor,lineStyle,lineWidth);
   expert.CreateObjectLine(SandR2,ZoneDeviation,lineColor,lineStyle,lineWidth);
   expert.CreateObjectLine(SandR3,ZoneDeviation,lineColor,lineStyle,lineWidth);

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

// Get the Ticket Number
   ulong PositionTicket = PositionGetInteger(POSITION_TICKET);

//Get the PositionType (Either buy or sell)
   ulong PositionType = PositionGetInteger(POSITION_TYPE);

//+------------------------------------------------------------------+
// INSERT THE TRADE SIGNAL TEST CONDITIONS HERE

   if(expert.TimeFrame(TradingTimeStart,TradingTimeEnd)=="Perfect Session")
     {
      if((expert.SupportAndResistance(Ask,Bid,PointDeviation,SandR1,SandR2,SandR3,SandR4,SandR5,SandR6,SandR7,SandR8) == "EXECUTE BUY")&&(PositionsTotal()==0)&&(OrdersTotal()==0)) //Test Conditions to be revised
        {

         if(expert.Lows()==Bid)
           {
            trade.Buy(TradeVolume,_Symbol,Bid,(Bid-(300*_Point)),Bid+600*_Point,NULL);
            //trade.BuyLimit(TradeVolume,(Bid-(100*_Point)),_Symbol,Bid-315*_Point,Bid+650*_Point,ORDER_TIME_GTC,0,NULL);
           }
        }

      if((expert.SupportAndResistance(Ask,Bid,PointDeviation,SandR1,SandR2,SandR3,SandR4,SandR5,SandR6,SandR7,SandR8) == "EXECUTE SELL")&&(PositionsTotal()==0)&&(OrdersTotal()==0))
        {

         if(expert.Highs()==Ask)
           {
            trade.Sell(TradeVolume,_Symbol,Ask,(Ask+(300*_Point)),Ask-600*_Point,NULL);
            //trade.SellLimit(TradeVolume,(Ask+(100*_Point)),_Symbol,Ask+315*_Point,Ask-650*_Point,ORDER_TIME_GTC,0,NULL);
           }
        }
     }

// INSERT THE TRADE SIGNAL TEST CONDITIONS HERE
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//Activate the PositionDetails function
   expert.SimplePositionDetails();

// Check if the currrent Position is a BUY
   if(PositionType==POSITION_TYPE_BUY)
     {
      // Activate the PositionPipProfit function
      expert.PositionPipProfit(DesiredProfitinPips);

      //Activate the BuyTrailingStop function
      //expert.BuyTrailingStop(Ask);
     }

// Check if the current Position is a SELL
   if(PositionType==POSITION_TYPE_SELL)
     {
      // Activate the PositionPipProfit function
      expert.PositionPipProfit(DesiredProfitinPips);

      //Activate the SellTrailingStop function
      //expert.SellTrailingStop(Bid);
     }

  }// END OF THE ON-TICK MAIN FUNCTION
//+------------------------------------------------------------------+
