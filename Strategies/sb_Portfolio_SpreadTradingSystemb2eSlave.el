var: master_mp(0), my_mp(0);

value1 = pmms_from_portfolio_currency( pmm_get_my_named_num("MPMoney") ); // master's position cost. convert it to my contracts

value33 = c;
if marketposition <> 0 then
	value33 = entryprice;

master_mp = IntPortion( value1 / ( value33 * bigpointvalue) );
my_mp = currentcontracts*marketposition;

if sign(my_mp) <> sign(master_mp) then begin

	if 0 = value1 then begin // need close position
		if my_mp > 0 then
			sell all contracts this bar c
		else
			buytocover all contracts this bar c;
		#return;
	end;

	value2 = master_mp - my_mp;
	
	if 0 < value2 then begin // we must to buy
		if Sign(master_mp) <> Sign(my_mp) then // master in long, we are in short/flat
			buy absvalue(master_mp) contracts this bar c
		else
			buytocover value1 contracts this bar c;
	end else begin // we must sell
		if Sign(master_mp) <> Sign(my_mp) then // master in short, we are in long/flat
			sell short absvalue(master_mp) contracts this bar c
		else
			sell absvalue(value2) contracts this bar c;
	end;
end;

