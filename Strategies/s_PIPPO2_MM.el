Input: StartTime(800),EndTime(1800);
Input: EMALen(136),KLen(3),DLen(3),OverSold(20),OverBougth(80);
Input: StopL(450),TargetL(580);
Input: StopS(450),TargetS(650);

vars: exp(0,data2),kfast(0,data2),dslow(0,data2);
vars: buySetup(false,data2),sellSetup(false,data2);
vars: buySignal(false,data2), sellSignal(false,data2);
vars: canBuy(false,data2), canSell(false,data2);
vars: buyLevel(0,data2), sellLevel(0,data2), risk(0,data2);

vars: cref(0,data2),tdata2(0,data2);
vars: firstTarget(0),secondTarget(0),thirdTarget(0);

vars: mcp(0),stpv(0),stp(false),mkt(false);

if marketposition <> 0 and barssinceentry = 0 then begin
 
 if marketposition = 1 then begin
  
  firstTarget  = buyLevel + cref - risk;
  secondTarget = buyLevel + 2*(cref - risk);
  thirdTarget  = buyLevel + 3*(cref - risk);
  
 end else begin
  
  firstTarget  = sellLevel - risk + cref;
  secondTarget = sellLevel - 2*(risk - cref);
  thirdTarget  = sellLevel - 3*(risk - cref);
  
 end;
 
end;

if barstatus(2) = 2 then begin

 exp = XAverage(c,EMALen)data2;
 Pippo.Stoch(KLen,DLen,kfast,dslow)data2;

 buySetup   = l data2 > exp and kfast cross above OverSold and kfast < OverBougth and kfast > dslow;
 sellSetup  = h data2 < exp and kfast cross below OverBougth and kfast > OverSold and kfast < dslow;

 buySignal  = l data2 > exp and kfast > OverSold and kfast < OverBougth;
 sellSignal = h data2 < exp and kfast > OverSold and kfast < OverBougth;
 
 if buySetup[1] then begin
  buyLevel = (h data2)[1];
  cref     = (c data2)[1];
  risk     = minlist((l data2)[1],(l data2)[2]);
 end else 
 if buySetup[2] then begin
  buyLevel = (h data2)[2];
  cref     = (c data2)[2];
  risk     = minlist((l data2)[2],(l data2)[3]);
 end else 
 if buySetup[3] then begin
  buyLevel = (h data2)[3];
  cref     = (c data2)[3];
  risk     = minlist((l data2)[3],(l data2)[4]);
 end;
 
 if sellSetup[1] then begin
  sellLevel = (l data2)[1];
  cref      = (c data2)[1];
  risk      = maxlist((h data2)[1],(h data2)[2]);
 end else 
 if sellSetup[2] then begin
  sellLevel = (l data2)[2];
  cref      = (c data2)[2];
  risk      = maxlist((h data2)[2],(h data2)[3]);
 end else 
 if sellSetup[3] then begin
  sellLevel = (l data2)[3];
  cref      = (c data2)[3];
  risk      = maxlist((h data2)[3],(h data2)[4]);
 end;

 canBuy  = (buySetup[1] or buySetup[2] or buySetup[3]) and buySignal;
 canSell = (sellSetup[1] or sellSetup[2] or sellSetup[3]) and sellSignal;
 
 tdata2  = t data2;

end;

if bartype_ex = 2 then begin
 value1 = time; 
end else if bartype_ex = 9 then begin
 value1 = .01*time_s;
end;

mcp = MM.MaxContractProfit;

if StartTime < value1 and value1 < EndTime then begin 
 
 if bartype_ex = 2 then begin
  condition3 = ((time - barinterval) = tdata2);
 end else if bartype_ex = 9 then begin
  condition3 = (.01*(time_s - barinterval) = tdata2);
 end;
 
 if condition3 then begin
  condition1 = o <= cref;
  condition2 = o >= cref;
 end;
 
 if marketposition = 0 then begin
 
  if canBuy and condition1 then begin 
   
   if c < buyLevel then buy("el") next bar buyLevel stop;
   
  end else 
  if canSell and condition2 then begin 
   
   if c > sellLevel then sell short("es") next bar sellLevel stop;
  
  end;
 
 end; 

 if marketposition = 1 then begin    
  
  stpv = entryprice - StopL/bigpointvalue;
  stp = c >  stpv;
  mkt = c <= stpv;
  
  if stp then sell("XL.Stp") next bar stpv stop
  else if mkt then sell("XL.Stp.M") this bar c;
  
  stpv = entryprice + TargetL/bigpointvalue;
  stp = c <  stpv;
  mkt = c >= stpv;
  
  if stp then sell("XL.Target") next bar stpv limit
  else if mkt then sell("XL.Target.M") this bar c;
  
 end else begin    
  
  stpv = entryprice + StopS/bigpointvalue;
  stp = c <  stpv;
  mkt = c >= stpv;
  
  if stp then buy to cover("XS.Stp") next bar stpv stop
  else if mkt then buy to cover("XS.Stp.M") this bar c;
  
  stpv = entryprice - TargetS/bigpointvalue;
  stp = c >  stpv;
  mkt = c <= stpv;
  
  if stp then buy to cover("XS.Target") next bar stpv limit
  else if mkt then buy to cover("XS.Target.M") this bar c;
  
 end;

end else if value1 > EndTime then begin
 
 if marketposition = 1 then
  sell("XL.EndTime") this bar c;
 if marketposition = -1 then 
  buy to cover("XS.EndTime") this bar c;
 
end;
