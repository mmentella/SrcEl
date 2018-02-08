Inputs: NoS(2),KLen(25),K(2.2);
Inputs: stoploss(2700),tl(150),ts(250),PctL(2),PctS(2);

Vars: lowerk(0,data2),upperk(0,data2),hh(0),ll(0);

lowerk = KeltnerChannel(l,klen,-k)data2;
upperk = KeltnerChannel(h,klen,k)data2;

if marketposition <> 1 then hh = 0;
if marketposition <> -1 then ll = 0;

if time > 800 and time < 2230 then begin 
  
 buy nos shares next bar at upperk stop;
 sellshort nos shares next bar at lowerk stop;
 
 if marketposition <> 0 then begin
  setstopshare;
  setstoploss(stoploss);
  
  if marketposition <> 0 then begin
   if currentcontracts = nos then begin
    if marketposition = 1 then sell("tl") nos/2 shares next bar at entryprice + tl point limit;
    if marketposition = -1 then buytocover("ts") nos/2 shares next bar at entryprice - ts point limit;
   end;
   
   
   
  end;
  
 end;
  
end;
