Inputs: ELReleaseDate(Date);

vars: iNetProfit(0),ITrades(0),iWTrades(0),iLTrades(0),iGrossProfit(0),iGrossLoss(0),iOpenEquity(0),iClosedEquity(0);
vars: nNetProfit(0),nTrades(0),nWTrades(0),nLTrades(0),nGrossProfit(0),nGrossLoss(0),nOpenEquity(0),nClosedEquity(0);
vars: nProfitFactor(0),nProfitability(0),nAvgTrade(0),nAvgWTrades(0),nAvgLTrades(0),maxeq(-999999),dwdq(0),maxeqc(-999999),count(0),dwdt(0);
vars: idTrades(0),s("");

if currentbar = 1 then begin
 
 idTrades     = text_new(0,0,0,"");
 
 text_setstyle(idTrades,1,0);
 text_setsize(idTrades,10);
 text_setcolor(idTrades,white);
 text_setattribute(idTrades,2,true);
 text_setattribute(idTrades,1,true);
 
end;

if d = ELReleaseDate and d <> d[1] then begin
 iNetProfit    = netprofit;
 iTrades       = totaltrades;
 iWTrades      = numwintrades;
 iLTrades      = numlostrades;
 iGrossProfit  = grossprofit;
 iGrossLoss    = grossloss;
 iOpenEquity   = i_OpenEquity;
 iClosedEquity = i_ClosedEquity;
 
 //RELEASE
 if d = ELReleaseDate and d <> d[1] then begin
  value1 = text_new(d,t,h + 10*minmove points,"Inizio Equity Reale: "+NewLine+MM.ELDateToString_IT(ELReleaseDate));
  text_setstyle(value1,1,0);
  text_setsize(value1,10);
  text_setcolor(value1,white);
  text_setattribute(value1,2,true);
  text_setattribute(value1,1,true);
 end;
end;

if d >= ELReleaseDate then begin
 
 nNetProfit     = netprofit      - iNetProfit;
 nTrades        = totaltrades    - iTrades;
 nWTrades       = numwintrades   - iWTrades;
 nLTrades       = numlostrades   - iLTrades;
 nGrossProfit   = grossprofit    - iGrossProfit;
 nGrossLoss     = grossloss      - iGrossLoss;
 nOpenEquity    = i_OpenEquity   - iOpenEquity;
 nClosedEquity  = i_ClosedEquity - iClosedEquity;
 
 nProfitFactor  = iff(nGrossLoss<>0,-1*nGrossProfit/nGrossLoss,0);
 nProfitability = iff(nTrades<>0   ,nWTrades/nTrades          ,0);
 nAvgTrade      = iff(nTrades<>0   ,nNetProfit/nTrades        ,0);
 nAvgWTrades    = iff(nTrades<>0   ,nGrossProfit/nTrades      ,0);
 nAvgLTrades    = iff(nTrades<>0   ,nGrossLoss/nTrades        ,0);
 
 maxeq          = maxlist(maxeq ,nOpenEquity);
 dwdq           = maxlist(dwdq  ,maxeq-nOpenEquity);
 
 maxeqc         = maxlist(maxeqc,nClosedEquity);
 
 if d > d[1] then begin
  if nClosedEquity < maxeqc then begin
   count        = count + 1;
   dwdt         = maxlist(dwdt,count);
  end else begin
   count        = 0;
  end;
 end;
 s = "";
 
 s = "Net Profit: " + NumToStr(nNetProfit,0) + " \nGross Profit: " + NumToStr(nGrossProfit,0) + 
     " \nGross Loss: " + NumToStr(nGrossLoss,0) + " \nProfit Factor: " + NumToStr(nProfitFactor,2);
 
 s = s + "\nTotal Trades: " + NumToStr(nTrades,0) + " \nWinning Trades: " + NumToStr(nWTrades,0) + 
     " \nLosing Trades: " + NumToStr(nLTrades,0) + " \nProfitability: " + NumToStr(100*nProfitability,2) + "%";
 
 text_setstring  (idTrades,s);
 text_setlocation(idTrades,d,time,getappinfo(aihighestdispvalue));
  
end;
