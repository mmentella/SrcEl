vars: filename("C:\Portafoglio\Indici Storici\"),s(""),header("<Date>, <Time>, <Open>, <High>, <Low>, <Close>, <Volume>");
vars: id(0),var0(0);

if currentbar = 1 then begin
 filename = filename + getsymbolname + ".txt";
 FileDelete(filename);
 FileAppend(filename,header+newline);
 
 id = text_new(d,t,c,"ALL DONE");
 
 if Mod(PriceScale,10) = 0 then var0 = Intportion(Log(PriceScale)/Log(10))
 else if Mod(PriceScale,2) = 0 then var0 = Intportion(Log(PriceScale)/Log(2));
end;

s = "";
s = s + MM.ELDateToString_IT(d) + ",";

s = s + ELTimeToString_hhmmss(t) + ",";

s = s + NumToStr(o,var0) + ",";
s = s + NumToStr(h,var0) + ",";
s = s + NumToStr(l,var0) + ",";
s = s + NumToStr(c,var0) + ",";
s = s + NumToStr(ticks,0);

FileAppend(filename,s+newline);

if LastBarOnChart then begin
 text_setlocation(id,d,t,c);
 PlaySound("C:\ding.wav");
end;
