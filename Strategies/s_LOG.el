[IntrabarOrderGeneration = true];

vars: intrabarpersist mp(0), intrabarpersist cc(0), intrabarpersist nos(0);
vars: id(0), intrabarpersist message(""), intrabarpersist price(0), intrabarpersist wlog(true), 
      intrabarpersist modx(false), intrabarpersist posn(false), intrabarpersist flat(false);
vars: filename("C:\MCLOG\LOG_"),header("["),footer(";"+NewLine);

if currentbar = 1 then begin 
 filename = filename + NumToStr(dayofmonth(currentdate),0) + ".";
 filename = filename + NumToStr(Month(currentdate),0) + ".";
 filename = filename + NumToStr(Year(currentdate)+1900,0) + ".txt";
end;

mp  = marketposition;
cc  = currentcontracts;
if mp <> 0 and barssinceentry = 0 then begin
 nos = currentcontracts; 
 modx = false; 
end;

if getappinfo(airealtimecalc) = 1 then begin
 
 if mp*cc = mp[1]*cc[1] then begin
  posn = false;
  flat = false;
  modx = false;
 end;
 
 if mp*cc <> mp[1]*cc[1] then begin
  header   = "[" + MM.CurrentDateTimeToStr_IT + " => " + getsymbolname+ "] :: ";
  
  if not flat and mp = 0 then begin
   flat = true;
   wlog = false;
   price = exitprice(1);
   message = "POSITION FLAT " + NumToStr(exitprice(1),log(pricescale)/log(10));
  end else begin
   if not posn and mp <> mp[1] then begin
    posn = true;
    wlog = false;
    price = entryprice;
    message = "POSITION " + NumToStr(mp*cc,0) + " " + NumToStr(entryprice,log(pricescale)/log(10));
   end;
   if not modx and mp = mp[1] and cc < nos then begin
    modx = true;
    wlog = false;
    price = c;
    message = "MODAL EXIT " + NumToStr(price,log(pricescale)/log(10));
   end;
  end;
  
  if not wlog then begin
   FileAppend(filename,header+message+footer);
   wlog = true;
  end;
  
 end;
 
end;
