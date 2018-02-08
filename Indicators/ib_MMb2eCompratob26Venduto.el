var: id(0);

if currentbar = 1 then begin
 
 id  = text_new(d,t,c,"");
 
 text_setstyle(id,0,2);
 text_setsize(id,10);
 text_setcolor(id,white);
 text_setattribute(id,2,true);
 text_setattribute(id,1,true);

end;

if getappinfo(airealtimecalc) = 1 then begin
 
 if c = insideask then
  text_setstring(id,"Comprato")
 else if c = insidebid then
  text_setstring(id,"Venduto");
 
 text_setlocation(id,d,t,c);

end;
