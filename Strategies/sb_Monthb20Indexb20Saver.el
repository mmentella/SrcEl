vars: filename("C:\Portafoglio\Indici Farm\"),s(""),header("<Date>, <Time>, <Open>, <High>, <Low>, <Close>, <Volume>");

if currentbar = 1 then begin
 filename = filename + getsymbolname + "_" + NumToStr(year(currentdate),0) + "." + NumToStr(month(currentdate)-1,0) + ".txt";
 FileDelete(filename);
 FileAppend(filename,header+newline);
end;

if Year(d) = Year(currentdate) and Month(d) = Month(currentdate) - 1 or
 ((Year(d) = Year(currentdate) - 1) and Month(d) = 12 and Month(currentdate) = 1) then begin

 s = "";
 s = s + MM.ELDateToString_IT(d) + ",";
 
 s = s + ELTimeToString_hhmmss(t) + ",";
 
 s = s + NumToStr(o,Intportion(Log(pricescale)/Log(10))) + ",";
 s = s + NumToStr(h,Intportion(Log(pricescale)/Log(10))) + ",";
 s = s + NumToStr(l,Intportion(Log(pricescale)/Log(10))) + ",";
 s = s + NumToStr(c,Intportion(Log(pricescale)/Log(10))) + ",";
 s = s + NumToStr(ticks,0);
 
 FileAppend(filename,s+newline);

end else PlaySound("C:\notify.wav"); 
 //01/06/2009,00:01:00,2.2010,2.2050,2.2010,2.2050,14
