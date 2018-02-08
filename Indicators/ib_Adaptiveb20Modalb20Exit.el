vars: VolD(0,data2),VolW(0,data2),VolM(0,data2);

if barstatus(2) = 2 then begin

 VolD = (Range data2)*PriceScale/MinMove;
 VolW = IntPortion(Average(VolD,5)data2);
 VolM = IntPortion(Average(VolD,22)data2);

end;

plot1(VolD,"Vol Daily");
plot2(VolW,"Vol Weekly");
plot3(VolM,"Vol Monthly");
