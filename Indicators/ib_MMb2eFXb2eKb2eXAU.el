{***** - MM.FX.K.XAU - *******
 Engine:    Keltner
 Author:    Matteo Mentella
 Portfolio: MMFX
 Market:    XAUUSD
 TimeFrame: 1 min.
 BackBars:  2
 Date:      08 Gen 2011
**************************************}
vars: lenl(1),kl(.1),lens(1),ks(.1);
vars: upk(0),lok(0),el(true),es(true),id(0);
{***************************}
{***************************}
if currentbar = 1 then id = text_new(d,t,c,"");
{***************************}
{***************************}
upk = KeltnerChannel(h,lenl,kl);
lok = KeltnerChannel(l,lens,-ks);

el = c < upk;
es = c > lok;
{***************************}
{***************************}
if i_marketposition < 1 then begin
 if el then begin
  plot1[-1](upk,"EntryLevel",darkyellow);
  text_setstring(id,NumToStr(upk,log(pricescale)/log(10)));
  text_setlocation(id,d,t,upk);
 end else NoPlot(1);
end else if i_marketposition > -1 then begin
 if es then begin
  plot2[-1](lok,"EntryLevel",lightgray);
  text_setstring(id,NumToStr(lok,log(pricescale)/log(10)));
  text_setlocation(id,d,t,lok);
 end else NoPlot(2);
end;
{***************************}
{***************************}
