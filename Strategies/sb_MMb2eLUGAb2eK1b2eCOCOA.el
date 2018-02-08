vars: id(0);

if currentbar > 1 then begin
 if d < 1120501 then begin
 
 
 {--------------------------}
 {--------------------------}
 
 {******* - MM.LUGA.K1.COCOA - *******
 Engine:    Keltner
 Author:    Matteo Mentella
 Portfolio: LUGANO
 Market:    COCOA
 TimeFrame: 60 min.
 BackBars:  50
 Date:      29 Mar 2011
*************************************}
vars: lenl(36),kl(1.0),lens(5),ks(3.0);
vars: stopl(1900),funkl(1600),tl(4450);
vars: stops(1100),funks(1650),ts(3850);

vars: upk(0),lok(0),bs(true),ss(true),trades(0);
vars: stpv(0),stp(true),mkt(true),dru(0),funk(false),nos(1);

if d <> d[1] then begin
 trades = 0;
 funk = false;
end;

if currentbar > maxlist(lenl,lens) then begin

upk      = KeltnerChannel(h,lenl,kl);
lok      = KeltnerChannel(l,lens,-ks);

bs       = c  < upk; 
ss       = c  > lok;

if marketposition <> 0 and barssinceentry = 0 then begin
 trades = trades + 1;
 nos = currentcontracts;
end;
dru = MM.DailyRunup;

if marketposition = 1 then begin

 //STOPLOSS
 stpv = entryprice - stopl/bigpointvalue;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then sell("xl.stp") next bar at stpv stop;
 if mkt then sell("xl.stp.m") this bar c;
 
 //DAILY STOPLOSS
 stpv = c - (dru + funkl*currentcontracts)/bigpointvalue;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then sell("xl.funk") next bar at stpv stop;
 if mkt then sell("xl.funk.m") this bar c;
 
 //PROFIT TARGET
 stpv = entryprice + tl/bigpointvalue;
 stp  = c < stpv;
 mkt  = c >= stpv;
 
 if stp then sell("xl.prft") next bar at stpv limit;
 if mkt then sell("xl.prft.m") this bar c;
 
end else if marketposition = -1 then begin
 
 //STOPLOSS
 stpv = entryprice + stops/bigpointvalue;
 stp  = c < stpv;
 mkt  = c >= stpv;
 
 if stp then buy to cover("xs.stp") next bar at stpv stop;
 if mkt then buy to cover("xs.stp.m") this bar c;
 
 //DAILY STOPLOSS
 stpv = c + (dru + funks*currentcontracts)/bigpointvalue;
 stp  = c < stpv;
 mkt  = c >= stpv;
 
 if stp then buy to cover("xs.funk") next bar stpv stop;
 if mkt then buy to cover("xs.funk.m") this bar c;
 
 //PROFIT TARGET
 stpv = entryprice - ts/bigpointvalue;
 stp  = c > stpv;
 mkt  = c <= stpv;
 
 if stp then buy to cover("xs.prft") next bar at stpv limit;
 if mkt then buy to cover("xs.prft.m") this bar c;
 
end;
{***************************}
{***************************}
funk = dru <= -minlist(funkl,funks)*nos;
{***************************}
{***************************}
//ENGINE
if not funk and trades < 1 then begin
 if marketposition < 1 and bs and c < upk then
  buy("el.s") next bar at upk stop;
 if marketposition > -1 and ss and c > lok then
  sellshort("es.s") next bar at lok stop;
end;

end else begin
 upk = KeltnerChannel(h,lenl,kl);
 lok = KeltnerChannel(l,lens,-ks);
end;

 
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
