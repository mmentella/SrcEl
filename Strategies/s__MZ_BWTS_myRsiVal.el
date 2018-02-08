
Inputs:  rsilength(14),overBought(70),OverSold(30), moneyManStop(1000);
var:     myRsiVal(0),
         longProtStop(0), ShortProtStop(99999),
         obCount(0), osCount(0);
var:     longProfitStop(99999), shortProfitStop(0), takeProfitStop(2000);

myRsiVal = RSI(C,rsilength);

{--------contatori--------}

If (myRsiVal > overBought and myRsiVal[1] < overBought) then
Begin
   obCount = obCount + 1;
   osCount = 0;  {azzera il contatore OS, dato che siamo in zona OB}
end;

If (myRsiVal < overSold and myRsiVal[1] > overSold) then
Begin
   osCount = osCount + 1;
   obCount = 0;  {azzera il contatore OB, dato che siamo in zona OS}
end;   

If (marketposition=1) then
Begin
     //longProtStop = Entryprice - (moneyManStop/((Ceiling(Pointvalue/Pricescale)))); {approssimato per difetto}
     //longProfitStop = Entryprice + (takeProfitStop/((Floor(Pointvalue/Pricescale)))); {approssimato per eccesso}
     longProtStop = 0.050;
     longProfitStop = 0.050;
     osCount = 0; {dal momento che siamo long,  resettiamo il contatore OS}
end;

If (marketposition=-1) then

Begin
     //shortProtStop  = Entryprice + (moneyManStop/ ((Ceiling(Pointvalue/Pricescale))));
     //shortProfitStop = Entryprice - (takeProfitStop/ ((floor((Pointvalue/Pricescale)))));
     shortProtStop  = 0.050;
     shortProfitStop = 0.050;
     obCount = 0; {dal momento che siamo short,  resettiamo il contatore OB}  
end;
 

{------Modulo di dispaccio per gli ordini Order Placement Module-------}
{il modulo è costruito per identificare esattamente ogni singola entrata la relativa uscita}
If (Marketposition = 0) or (marketposition = 1) then
  If (obCount =2) then sellshort ("RSI-SX") 1 contracts next bar  at open; {ob si è verificato 2 volte}

If (Marketposition = 0) or (marketposition = -1) then
  If (osCount =2) then buy ( "RSI-LX" ) 1 contracts next bar at open; {os si è verificato 2 volte}

If (marketposition = 1) then
Begin
      Sell ("longLoss") from entry ( "RSI-LX" ) 1 contracts next bar at entryprice - longProtStop {- 3 point}  stop;
      Sell ("longProfit") from entry ( "RSI-LX" ) 1 contracts next bar at entryprice + longProfitStop {+ 1 point}  limit;
end;

if (marketposition = -1) then
Begin
      Buytocover ("ShortLoss") from entry ("RSI-SX") 1 contracts next bar at entryprice + shortProtStop {+ 2 point} stop;
      Buytocover ("shortProfit") from entry ("RSI-SX") 1 contracts next bar at entryprice - shortProfitStop {-4 point} limit;
end;

{------Filtro_1 ---}
{chiusura delle operazioni dopo tot tempo se non è in guadagno}

If (marketposition = 1 and barsSinceEntry(0) >= 5 and C < entryPrice) then
Sell ("LongLoss5Days") this bar close;

If (marketposition = -1 and barsSinceEntry(0) >=5 and C > entryprice) then
Buytocover ("ShortLoss5Days") this bar close;



{
If (marketposition = 1) then
Begin 
      If Barssinceentry(0)<5 then
      Begin
                  Sell ("LongLoss") next bar at Lowest(L,10) stop;
           
              
     Else
              
      begin
                  If C< Entryprice then sell("LongLoss5DYA") THIS BAR CLOSE;
              end;
end;
}

























//http://etfprophet.com/tradestation-code-hourly-volume-comparison http://etfprophet.com/easylanguage-relative-volume-indicator/
// http://www.quantifiableedges.com/btsoverview

{
//Relative Volume (c) Market Rewind 2010 inspired by Traderfeed
//Used on SPY 3-min Bars; Requires 20-Days of Data

Variable: NumDay(1), NumBar(0), RelVol(0);

Array: VolArray[200](0);

If Date > Date[1] Then Begin
NumDay = NumDay + 1;
NumBar = 0;
End;

If Time > 0630 AND Time < 1315 Then Begin //Local Time (PST)

If Volume > 0 Then Begin
NumBar = NumBar + 1;
VolArray[NumBar] = VolArray[NumBar] + Volume;
RelVol = Volume / (VolArray[NumBar]/ NumDay);
End;

Plot1(jtHMA(average(RelVol,6),6), "RelVol", Iff( Time > 1310, Black, White)) ; //Local Time

End;

If you don't have the Hull Moving Average function (search jtHMA on the TS forums), the plot line may be changed as follows:

Plot1(average(RelVol,8), "RelVol", Iff( Time > 1310, Black, White)) ; //Local Time}


   

