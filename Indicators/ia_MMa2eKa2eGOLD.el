Inputs: lenl(29),kl(1.2),lens(2),ks(4.1),wlog(1);

vars: upk(0),lok(0),filename("C:\MM.LOG\" + symbol + getstrategyname + ".txt");
vars: num(0);

upk = KeltnerChannel(h,lenl,kl);
lok = KeltnerChannel(l,lens,-ks);

plot1(upk,"UPK");
plot2(lok,"LOK");

if wlog = 1 then begin
 
 if currentbar > 1 then begin
 
  FileAppend(filename,NumToStr(h,num[0]) + "," + 
                      NumToStr(TrueRange,num[0]) + "," +
                      NumToStr(upk,num[0]) + NewLine);
 
 end else begin
  FileDelete(filename);
  
  if Mod(PriceScale,10) = 0 then num = Log(PriceScale)/Log(10)
  else if Mod(PriceScale,2) = 0 then num = Log(PriceScale)/Log(2);
 end;

end;
