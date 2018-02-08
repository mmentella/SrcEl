inputs: Length( 14 ), OverBought( 80 ), OverSold( 20 );

inputs: stopl(100000),tl(100000);
inputs: stops(100000),ts(100000);

variables: var0( 0 ), var1( 0 ), var2( 0 ), var3( 0 ) ;

vars: stpv(0),stp(true),mkt(false),bpv(1/bigpointvalue);

Value1 = Stochastic( H, L, C, Length, 3, 3, 1, var0, var1, var2, var3 ) ;

condition1 = CurrentBar > 2 and var2 crosses under var3 and var2 > OverBought ;
condition2 = CurrentBar > 2 and var2 crosses over  var3 and var2 < OverSold   ;

if marketposition <> 0 then begin
 
 if marketposition = 1 then begin
  
  //STOPLOSS
  stpv = entryprice - stopl*bpv;
  stp  = c >  stpv;
  mkt  = c <= stpv;
  
  if stp then sell("xl.stp") next bar stpv stop
  else if mkt then sell("xl.stp.m") this bar c;
  
  //TARGET
  stpv = entryprice + tl*bpv;
  stp  = c <  stpv;
  mkt  = c >= stpv;
  
  if stp then sell("xl.trgt") next bar stpv limit
  else if mkt then sell("xl.trgt.m") this bar c;
  
 end else begin
  
  //STOPLOSS
  stpv = entryprice + stops*bpv;
  stp  = c <  stpv;
  mkt  = c >= stpv;
  
  if stp then buy to cover("xs.stp") next bar stpv stop
  else if mkt then buy to cover("xs.stp.m") this bar c;
  
  //TARGET
  stpv = entryprice - ts*bpv;
  stp  = c >  stpv;
  mkt  = c <= stpv;
  
  if stp then buy to cover("xs.trgt") next bar stpv limit
  else if mkt then buy to cover("xs.trgt.m") this bar c;
  
 end;
 
end;

if condition1 then                                                     
Sell Short ( "StochSE" ) next bar at market ;

if condition2 then                                                     
Buy ( "StochLE" ) next bar at market ;



