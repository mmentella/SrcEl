vars: level(0);

level = XAverage(c,2);

if d < 1100101 then begin
 buy next bar at level stop;
 sellshort next bar at level stop;
end else setexitonclose;

if LastBarOnChart then buy this bar c;
