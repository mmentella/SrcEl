[LegacyColorValue = true]; 


vars: Barre(0),CBarre(0);


if {d[1]<>d}currentbar = 1 then
begin
	CBarre=Barre;
	Barre=0;
end;

Barre=Barre+1;

Plot1(Barre);

