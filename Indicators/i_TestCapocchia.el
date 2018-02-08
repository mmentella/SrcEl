vars: tdata2(0,data2);

if barstatus(2) = 2 then begin
 tdata2 = t data2;
end;


if .01*(time_s - barinterval) = tdata2 then plot1(1,"TRUE",green)
else plot1(0,"FALSE",red);
