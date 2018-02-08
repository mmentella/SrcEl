[RecoverDrawings = false];

if not LastBarOnChart_s then #return;

Inputs: UpdateSpeed_seconds(0.1);

RecalcLastBarAfter(UpdateSpeed_seconds);

repeat

if not dom_isconnected then 
	break;
	
value11 = 0;
value12 = 0;
for value1 = 0 to dom_askscount - 1 begin
	value12 = dom_asksize(value1);
	if value12 > value11 then value11 = value12;
end;

for value1 = 0 to dom_bidscount - 1 begin
	value12 = dom_bidsize(value1);
	if value12 > value11 then value11 = value12;
end;

if 0 >= value11 then
	break;	

for value1 = 0 to dom_askscount - 1 begin
	draw_DOM_level(
		dom_askprice(value1), dom_asksize(value1), value1, value11,
		gradientcolor( value1, 0, 10, RGB(255,0,0), RGB(80,0,0) ),
		dom_askscount - 1 = value1
	);
end;

for value1 = 0 to dom_bidscount - 1 begin
	draw_DOM_level(
		dom_bidprice(value1), dom_bidsize(value1), value1, value11,
		gradientcolor( value1, 0, 10, RGB(0,0,255), RGB(0,0,80) ),
		dom_bidscount - 1 = value1
	);
end;

plot1("OK", "Status", white);

#return;

until(False);

plot1("Level2 data is not avaliable", "Status", red);
