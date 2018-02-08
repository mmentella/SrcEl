Inputs: name("");

vars: start(0),now(0),s(""),filename("C:\Portafoglio\Piattaforma\Output\"+name+".txt");

if d <> d[1] then begin
 s = MM.ELDateToString_IT(d[1]) + " " + NumToStr(now-start,2);
 print(file(filename),s);
 start = now;
end;

now = Portfolio_NetProfit + Portfolio_OpenPositionProfit;
