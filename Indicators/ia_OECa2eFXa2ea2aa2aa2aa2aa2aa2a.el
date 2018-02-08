{******** - MM.FX.K.EURUSD - *********
 Engine:    MicroWave
 Author:    Matteo Mentella
 Portfolio: MMFX
 Market:    EURUSD
 TimeFrame: 1 min.
 BackBars:  2
 Date:      08 Gen 2011
**************************************}
Inputs: lenl(20),kl(2),lens(20),ks(2);
vars: upk(0,data2),lok(0,data2),el(true,data2),es(true,data2),id(0);
{***************************}
{***************************}
if currentbar = 1 then id = text_new(d,t,c,"");
{***************************}
{***************************}
if barstatus(2) = 2 then begin
 upk = KeltnerChannel(h,lenl,kl)data2;
 lok = KeltnerChannel(l,lens,-ks)data2;
 
 el = c data2 < upk;
 es = c data2 > lok;
end;
{***************************}
{***************************}
if i_marketposition < 1 then begin
 //if el and c < upk then begin
  plot1(upk,"EntryLevel",darkyellow);
  text_setstring(id,NumToStr(upk,log(pricescale)/log(10)));
  text_setlocation(id,d,t,upk);
 //end else NoPlot(1);
end;
if i_marketposition > -1 then begin
 //if es and c > lok then begin
  plot2(lok,"EntryLevel",lightgray);
  text_setstring(id,NumToStr(lok,log(pricescale)/log(10)));
  text_setlocation(id,d,t,lok);
 //end else NoPlot(2);
end;
