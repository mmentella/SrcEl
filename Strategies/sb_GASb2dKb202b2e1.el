[IntraBarOrderGeneration = true]
Inputs: NoS(2),KLen(25),K(1.5),RLen(24),SLen(5);
Inputs:StopL(2300),StopS(1000),BKS(3000),BKL(1600),TL(.49),TS(.36),TRSL(1000),TRSS(1000);

Vars: lowerk(0,data2),upperk(0,data2),r100(0,data2),slope(0,data3);
Vars: Step(0),level(0),stopp(0),n(0),posprofit(0);
Vars: fl(false),fs(false),rl(false),rs(false);
Vars: _fl(true),_fs(true),_rl(true),_rs(true);

fl = false;
fs = false;
rl = false;
rs = false;

if barstatus(2) = 2 then begin 
 lowerk = KeltnerChannel(l data2,klen,-k) data2;
 upperk = KeltnerChannel(h data2,klen,k) data2;
 r100 = PercentR(rlen) data2;
 slope = LinearRegSlope(c data3,slen) data3;
end;

if slope > 0 and r100 < 10 then fs = true;
if slope < 0 and r100 > 90 then fl = true;
if slope < 0 and low > upperk then rs = true;
if slope > 0 and high < lowerk then rl = true;

if time > 800 and time < 2230 then begin 
 
 setstopshare;
 if marketposition = 1 then begin 
  _fs = true;
  _rs = true;
  _fl = false;
  _rl = false;
  setstoploss(stopl);
 end;
 if marketposition = -1 then begin
  _fl = true;
  _rl = true;
  _fs = false;
  _rs = false;
  setstoploss(stops);
 end;
 if marketposition <> marketposition(1) then posprofit = 0;
  
 if fs and _fs then sellshort("fs") nos shares next bar at lowerk stop;
 if fl and _fl then buy("fl") nos shares next bar at upperk stop;
 if r100 > 20 and r100 < 80 then begin
  if rs and _rs then sellshort("rs") nos shares next bar at upperk stop;
  if rl and _rl then buy("rl") nos shares next bar at lowerk stop;
 end;
 
 if marketposition = 1 then begin
  if maxpositionprofit > bkl then
   sell("bkl") next bar at entryprice + 10 point stop;
  if positionprofit > bkl + 100 then begin
   value1 = entryprice + ((maxpositionprofit)-trsl)/bigpointvalue;
   if value1 > c then sell("trsl@m") next bar at market
   else sell("trsl") next bar at value1 stop;
  end;
  if currentcontracts = nos then sell("tl") next bar at entryprice + tl limit;
 end;
 if marketposition = -1 then begin
  if maxpositionprofit > bks then 
   buytocover("bks") next bar at entryprice - 10 point stop;
  if positionprofit > bks + 100 then begin
   value2 = entryprice - ((maxpositionprofit)-trss)/bigpointvalue;
   if value2 < c then buytocover("trss@m") next bar at market
   else buytocover("trss") next bar at value2 stop;
  end;
  if currentcontracts = nos then buytocover("ts") next bar at entryprice - ts limit;
 end;
 
end;

{vecchi valori
 BKL 4000
 BKS 3100
 StopL 2300
 StopS 1000
 TL .49
 TS .36
}

//sell("rlx") entry("rl") next bar at upperk limit;
 //if positionprofit < 0 then sell("flxs") entry("fl") next bar at lowerk stop;
 //if positionprofit > 0 then sell("flxp") entry("fl") (nos/2) shares next bar at lowerk stop;
 //buytocover("rsx") entry("rs") next bar at lowerk limit;
 //if positionprofit < 0 then buytocover("fsxs") entry("fs") next bar at upperk stop;
 //if positionprofit > 0 then buytocover("fsxp") entry("fs") (nos/2) shares next bar at upperk stop;
//print(File("C:\Users\BT53\Desktop\GAS-K 2.1.txt"),numtostr(date,0),spaces(1),numtostr(time,0),spaces(1),numtostr(marketposition,0),spaces(1),
   //numtostr(entryprice,3),spaces(1),NumToStr(positionprofit,0),entryprice - (positionprofit-trss)/bigpointvalue);
//print(File("C:\Users\BT53\Desktop\GAS-K 2.1.txt"),numtostr(date,0),spaces(1),numtostr(time,0),spaces(1),numtostr(marketposition,0),spaces(1),
   //numtostr(entryprice,3),spaces(1),NumToStr(positionprofit,0),entryprice + (positionprofit-trsl)/bigpointvalue);
