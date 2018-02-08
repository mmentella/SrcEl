vars: filename("C:\Portafoglio\Indici Farm\"),s(""),header("<Date>, <Time>, <Open>, <High>, <Low>, <Close>, <Volume>"),id(0);

if currentbar = 1 then begin
 filename = filename + getsymbolname + ".txt";
 FileDelete(filename);
 FileAppend(filename,header+newline);
 id = text_new(d,t,c,"ALL DONE");
end;

s = "";
s = s + MM.ELDateToString_IT(d) + ",";

s = s + ELTimeToString_hhmmss(t) + ",";

s = s + NumToStr(o/100,Intportion(Log(10000)/Log(10))) + ",";
s = s + NumToStr(h/100,Intportion(Log(10000)/Log(10))) + ",";
s = s + NumToStr(l/100,Intportion(Log(10000)/Log(10))) + ",";
s = s + NumToStr(c/100,Intportion(Log(10000)/Log(10))) + ",";
s = s + NumToStr(ticks,0);

FileAppend(filename,s+newline);

if LastBarOnChart then begin
 text_setlocation(id,d,t,c);
 PlaySound("C:\ding.wav");
end;
