[LegacyColorValue = true]; 

Input:Length(240);
Value1=(I_OpenEquity);
Value2=Average(Value1,Length)[1];
Value3=Value1-Value2;
Value4=(I_OpenEquity)[1];
If Value3>0 then begin;
Plot1(I_OpenEquity,"OpenEquity");
end;

If Value3<=0 then begin;
Plot2(Value4,"AsideEquity");
end;
{
Plot2(I_ClosedEquity,"ClosedEquity");}
Plot3(0,"ZeroLine");
Plot4(Value2,"Media");
