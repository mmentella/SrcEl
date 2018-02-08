Inputs: stopl(2300),funkl(3100),tl(5200);
Inputs: stops(2000),funks(3100),ts(1300);
{***************************}
{***************************}
vars: upk(0),lok(0),el(true),es(true),trade(0);
vars: rbfLenL(0),rbfKL(0),rbfLenS(0),rbfKS(0);

vars: stpv(0),mkt(true),stp(true),dru(0),fnkl(false),fnks(false),bpv(1/bigpointvalue),nos(1);
{***************************}
{***************************}
DEFINEDLLFUNC: "MCDLL.dll", void, "Initialize";
DEFINEDLLFUNC: "MCDLL.dll", double, "GetRBFLenL", double, double;
DEFINEDLLFUNC: "MCDLL.dll", double, "GetRBFKL", double, double;
DEFINEDLLFUNC: "MCDLL.dll", double, "GetRBFLenS", double, double;
DEFINEDLLFUNC: "MCDLL.dll", double, "GetRBFKS", double, double;
{***************************}
{***************************}
once begin
 Initialize;
end;
{***************************}
{***************************}
if d > d[1] then begin
 trade = 0;
 fnkl  = false;
 fnks  = false;
end;
{***************************}
{***************************}
rbfLenL = maxlist(1,minlist(MaxBarsBack, IntPortion(GetRBFLenL(h,truerange) + 0.5)));
rbfKL   = GetRBFKL(h,truerange);
rbfLenS = maxlist(1,minlist(MaxBarsBack, IntPortion(GetRBFLenS(l,truerange) + 0.5)));
rbfKS   = GetRBFKS(l,truerange);

upk = KeltnerChannel(h,rbfLenL,rbfKL);
lok = KeltnerChannel(l,rbfLenS,-rbfKS);

el = c < upk; 
es = c > lok;
{***************************}
{***************************}
if marketposition <> 0 and barssinceentry = 0 then begin
 trade = trade + 1;
 nos = currentcontracts;
end;

dru = MM.DailyRunup;
{***************************}
{***************************}
if marketposition = 1 then begin
 
 //STOPLOSS
 stpv = entryprice - stopl*bpv;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then sell("xl.stp") next bar stpv stop
 else if mkt then sell("xl.stp.m") this bar c;
 
 //DAILY STOPLOSS
 stpv = c - (dru + funkl)*bpv;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then sell("xl.funk") next bar stpv stop
 else if mkt then sell("xl.funk.m") this bar c;
   
 //PROFIT TARGET
 stpv = entryprice + tl*bpv;
 stp  = c < stpv;
 mkt  = c >= stpv;
   
 if stp then sell("xl.trgt") next bar stpv limit
 else if mkt then sell("xl.trgt.m") this bar c;
 
end else if marketposition = -1 then begin
 
 //STOPLOSS
 stpv = entryprice + stops*bpv;
 stp  = c < stpv;
 mkt  = c >= stpv;
   
 if stp then buy to cover("xs.stp") next bar stpv stop
 else if mkt then buy to cover("xs.stp.m") this bar c;
   
 //DAILY STOPLOSS
 stpv = c + (dru + funks)*bpv;
 stp  = c < stpv;
 mkt  = c >= stpv;
 
 if stp then buy to cover("xs.funk") next bar stpv stop
 else if mkt then buy to cover("xs.funk.m") this bar c;
   
 //PROFIT TARGET
 stpv = entryprice - ts*bpv;
 stp  = c > stpv;
 mkt  = c <= stpv;
   
 if stp then buy to cover("xs.trgt") next bar stpv limit
 else if mkt then buy to cover("xs.trgt.m") this bar c; 
 
end;
{***************************}
{***************************}
fnkl = dru <= -funkl*nos;
fnks = dru <= -funks*nos;
{*************************************}
{*************************************}
if trade = 0 then begin

 if not fnkl and marketposition < 1 and el then
  buy("el") next bar at upk stop;
  
 if not fnks and marketposition > -1 and es then
  sell short("es") next bar at lok stop;
  
end;
{***************************}
{***************************}
