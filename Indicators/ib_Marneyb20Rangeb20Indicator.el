
{***********************************************}
{Marney Indicator(TM) - Marney Range Indicator(TM)
Copyright Caspar Marney, Marney Capital 2010(C)} 
{***********************************************}

input: avgLen(10), mins.in.session(1440), autobars(True), upcolor(cyan), dncolor(red); 
var: start(0), end1(0), end2(0), x(0), p(-1), count(0), avg(0), barsinday(0); 
array: xr[50,1440](0);  
 
if bartype < 2 then begin 
 
start= (sessionstarttime(1,1)); 
end1= (sessionendtime(1,1)); 
end2= (sessionendtime(1,2)); 
 
value1 = timetominutes(start); 
value2 = timetominutes(end2); 
if start > end2 then 
value3 = 1440+(value2-value1); 
 
if start < end2 then 
	value3 = -(value1-value2); 
if autobars = false then value3 = mins.in.session; 
	 
barsinday = ceiling(value3/barinterval); 
 
 
if d<>d[1] then begin  
    if count=barsinday then begin  
        p=iff(p<avgLen-1,p+1,0);  
        for x=1 to barsinday begin  
            xr[p,x]=truerange[barsinday+1-x];  
        end;  
    end;  
    count=1;  
end else count=count+1;  
 
if xr[avgLen-1,count]>0 then begin  
    avg=0;  
    for x=0 to avgLen-1 begin  
        avg=avg+xr[x,count];  
    end;  
    avg=avg/avgLen;  
   plot2(truerange,"range",default,1);  
   plot1(avg,"avg",yellow, default,1);  
end; 

if close > open then setplotcolor(2,upcolor); 
if close < open then setplotcolor(2,dncolor); 
 
end; 
 
if bartype > 1 then begin 
    avg = averagefc(truerange,avglen); 
    plot2(truerange,"range",default,1); 
    plot1(avg,"avg",yellow, default,1); 
 
    if close > open then setplotcolor(2,upcolor); 
    if close < open then setplotcolor(2,dncolor); 
end; 
