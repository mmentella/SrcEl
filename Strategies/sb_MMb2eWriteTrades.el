[IntraBarOrderGeneration = true]
Inputs: Dir("C:\Portafoglio\Sviluppo\WriteTrades\");

vars: f(getsymbolname+"_"+getstrategyname+".txt"),s(""),intrabarpersist n(0),intrabarpersist p(0);

if getappinfo(airealtimecalc) = 1 then begin
 n = marketposition;
 if n <> p then begin
  s = ELDateToString(d)+" "+NumToStr(currenttime,0)+" "+NumToStr(marketposition(1),0)+" "+
      NumToStr(entryprice(1),4)+" "+NumToStr(exitprice(1),4)+" "+
      ELDateToString(entrydate(1))+" "+ELDateToString(exitdate(1))+NewLine;
  FileAppend(dir+f,s);
 end;
end;

p = n;
