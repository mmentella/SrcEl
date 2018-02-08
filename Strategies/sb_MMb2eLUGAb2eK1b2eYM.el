vars: id(0);

if currentbar > 1 then begin
 if d < 1120501 then begin
 
 
 {--------------------------}
 {--------------------------}
 
{********* - MM.H1.K.DOWJ - **********
 Engine:    KELTNER
 Author:    Matteo Mentella
 Portfolio: H1
 Market:    mini Dow Jones
 TimeFrame: 2 + 60 min.
 BackBars:  50
 Date:      11 Feb 2011
**************************************}
vars: lenl(15),kl(3.6),lens(11),ks(4.8),mnymngmnt(1);
vars: stopl(2800),funkl(1900),tl(1200);
vars: stops(2600),funks(2200),ts(1750);

vars: upk(0),lok(0),el(true),es(true),engine(true),trades(0);
vars: dru(0),bpv(1/bigpointvalue),stpv(0),stp(true),mkt(true),funk(true),nos(1);
{***************************}
{***************************}
if d <> d[1] then begin
 trades = 0;
 funk   = false;
end;

if marketposition <> 0 and barssinceentry = 0 then begin
 trades = trades + 1;
 nos = currentcontracts;
end;

dru = MM.DailyRunup;
{***************************}
{***************************}

 upk = KeltnerChannel(h,lenl,kl);
 lok = KeltnerChannel(l,lens,-ks);
 
 el = c  < upk;
 es = c  > lok;
 
 engine = 700 < t  and t  < 2100;

{***************************}
{***************************}
if mnymngmnt = 1 and 800 < t and t < 2300 then begin
 
 if marketposition = 1 then begin
 
  //STOPLOSS
  stpv = entryprice - stopl*bpv;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then sell("xl.stp") next bar at stpv stop
  else if mkt then sell("xl.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c - (dru + funkl*currentcontracts)*bpv;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then sell("xl.funk") next bar at stpv stop
  else if mkt then sell("xl.funk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice + tl*bpv;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then sell("xl.prft") next bar at stpv limit
  else if mkt then sell("xl.prft.m") this bar c;
  
 end else if marketposition = -1 then begin
  
  //STOPLOSS
  stpv = entryprice + stops*bpv;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then buy to cover("xs.stp") next bar stpv stop
  else if mkt then buy to cover("xs.stp.m") this bar c;
  
  //DAILY STOPLOSS
  stpv = c + (dru + funks*currentcontracts)*bpv;
  stp  = c < stpv;
  mkt  = c >= stpv;
  
  if stp then buy to cover("xs.funk") next bar stpv stop
  else if mkt then buy to cover("xs.funk.m") this bar c;
  
  //PROFIT TARGET
  stpv = entryprice - ts*bpv;
  stp  = c > stpv;
  mkt  = c <= stpv;
  
  if stp then buy to cover("xs.prft") next bar stpv limit
  else if mkt then buy to cover("xs.prft.m") this bar c;
  
 end;
end;
{***************************}
{***************************}
funk = (dru <= - maxlist(funkl,funks)*nos);
{***************************}
{***************************}
if not funk and trades = 0 and engine then begin
 
 if marketposition < 1 and el then
  buy("el") next bar upk stop;
 
 if marketposition > -1 and es then
  sell short("es") next bar lok stop;
   
end;
{***************************}
{***************************}

 
 {--------------------------}
 {--------------------------}
 
 
end else begin
 text_setlocation(id,d,t,c);
 text_setstring(id,"Periodo di Trading scaduto. Aggiornare la Licenza o contattare 'm.mentella@gmail.com'. " + 
                   "Potrebbero essere rimaste delle posizioni aperte in Banca.");
end;

end else begin
 id = text_new(d,t,c,"");
 text_setcolor(id,white);
 text_setsize(id,10);
 text_setstyle(id,1,1);
end;
