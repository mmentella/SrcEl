{********* - MM.KRBF.GOLD - ***********
 Engine:    Keltner
 Author:    Matteo Mentella
 Portfolio: 
 Market:    GOLD
 TimeFrame: 60 min.
 BackBars:  50
 Date:      15 Feb 2011
**************************************}
Inputs: lenl(20),kl(2),lens(20),ks(2),WLog(0);
Inputs: EndDate(1051230);

vars: upk(0),lok(0),el(true),es(true),trade(0);
vars: var1(0),s(""),filename("C:\MM.LOG\MM.RBF." + symbolroot + " - " + MM.ELDateToString_IT(EndDate) + ".txt"); 
{***************************}
{***************************}
if currentbar = 1 then begin
 var1 = Log(pricescale)/Log(10);
 if wlog = 1 then FileDelete(filename);
end;
{***************************}
{***************************}
if d > d[1] then begin
 trade = 0;
end;
{***************************}
{***************************}
upk = KeltnerChannel(h,lenl,kl);
lok = KeltnerChannel(l,lens,-ks);

el = c < upk; 
es = c > lok;
{***************************}
{***************************}
if marketposition <> 0 and barssinceentry = 0 then trade = trade + 1;
{***************************}
{***************************}
if trade = 0 then begin
 if marketposition < 1 and el then
  buy("el") next bar at upk stop;
  
 if marketposition > -1 and es then
  sellshort("es") next bar at lok stop;
end;
{***************************}
{***************************}
if wlog = 1 and  getappinfo(aioptimizing) = 0 and marketposition <> 0 and barssinceentry = 0 then begin
 FileAppend(filename,NumToStr(High[1],var1) + "," + 
                     NumToStr(Low[1],var1) + "," + 
                     NumToStr(TrueRange[1],var1)+ "," +
 		       NumToStr(lenl,0) + "," + NumToStr(kl,2) + "," + 
 		       NumToStr(lens,0) + "," + NumToStr(ks,2) + "," + 
 		       NumToStr(marketposition,0) + NewLine);
end;
