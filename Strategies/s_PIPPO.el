Input: StartTime(1500),EndTime(2215),OverSold(20),OverBougth(80);

vars: exp(0),kfast(0),dslow(0);
vars: buySetup(false),sellSetup(false);
vars: buySignal(false), sellSignal(false);
vars: canBuy(false), canSell(false);
vars: buyLevel(0), sellLevel(0), risk(0);

vars: cref(0);

vars: signals(0),id(0);
 
exp = XAverage(c,200);
Pippo.Stoch(5,3,kfast,dslow);

buySetup = l  > exp and kfast cross above OverSold and kfast < OverBougth and kfast > dslow;
sellSetup = h < exp and kfast cross below OverBougth and kfast > OverSold and kfast < dslow;

buySignal = l  > exp and kfast > OverSold and kfast < OverBougth;
sellSignal = h  < exp and kfast > OverSold and kfast < OverBougth;
 
if buySetup[1] then begin
 buyLevel = h[1];
 cref = c[1];
 risk = l[1];
end else 
if buySetup[2] then begin
 buyLevel = h[2];
 cref = c[2];
 risk = l[2];
end else 
if buySetup[3] then begin
 buyLevel = h[3];
 cref = c[3];
 risk = l[3];
end;
 
if sellSetup[1] then begin
 sellLevel = l[1];
 cref = c[1];
 risk = h[1];
end else 
if sellSetup[2] then begin
 sellLevel = l[2];
 cref = c[2];
 risk = h[2];
end else 
if sellSetup[3] then begin
 sellLevel = l[3];
 cref = c[3];
 risk = h[3];
end;

canBuy = (buySetup[1] or buySetup[2] or buySetup[3]) and buySignal and o <= cref;
canSell = (sellSetup[1] or sellSetup[2] or sellSetup[3]) and sellSignal and o >= cref; 

if StartTime < t and t < EndTime then begin
 
 if canBuy then begin   
   
  signals = signals + 1;
  arw_new(d,time,l,false);
   
 end else 
 if canSell then begin   
   
  signals = signals + 1;
  arw_new(d,time,h,true);
  
 end;

 
end else if t > EndTime then begin
 
 if marketposition = 1 then
  sell("XL.EndTime") this bar c;
 if marketposition = -1 then 
  buy to cover("XS.EndTime") this bar c;
 
end;

if LastBarOnChart then begin
 
 if id = 0 then begin
  id = text_new(d,t + barinterval,c,NumToStr(signals,0));  
  text_setstyle(id,0,2);
  text_setsize(id,10);
  text_setcolor(id,white);
  text_setattribute(id,2,true);
  text_setattribute(id,1,true);
 end else begin
  text_setlocation(id,d,time,c);
  text_setstring(id,NumToStr(signals,0));
 end;
 
end;
