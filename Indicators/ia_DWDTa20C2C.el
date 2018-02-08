vars: maxeq(0),mineq(999999),dwdt(0),maxdwdt(0),count(0),loop(0),found(false);
arrays: dwdts[8](0),temp[8](0);

maxeq = maxlist(maxeq,i_ClosedEquity);
mineq = minlist(mineq,i_ClosedEquity);

if d > d[1] then begin
 if i_ClosedEquity < maxeq then dwdt = dwdt + 1;
 
 if i_ClosedEquity = maxeq then begin 
  found = false;
  count = 0;
  while found = false and count < 8 begin
   if dwdt > dwdts[count] then begin
    found = true;
    if count = 7 then dwdts[count] = dwdt;
    if count < 7 then begin
     for loop = count to 7 begin
      temp[loop] = dwdts[loop];
     end;
     dwdts[count] = dwdt;
     for loop = count + 1 to 7 begin
      dwdts[loop] = temp[loop];
     end;
    end;
   end;
   count = count + 1;
  end;
  
  dwdt = 0;
  
 end;
 
end;

plot1(dwdt,"DWD TEMPORALE");

if LastBarOnChart then begin
 plot2(dwdts[0],"MAX DWDT 1");
 plot3(dwdts[1],"MAX DWDT 2");
 plot4(dwdts[2],"MAX DWDT 3");
 plot5(dwdts[3],"MAX DWDT 4");
 plot6(dwdts[4],"MAX DWDT 5");
 plot7(dwdts[5],"MAX DWDT 6");
 plot8(dwdts[6],"MAX DWDT 7");
 plot9(dwdts[7],"MAX DWDT 8");
end;
