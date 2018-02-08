var: id(0);

if id = 0 then begin
 id  = text_new(d,t,c,"");
 
 text_setstyle(id,0,1);
 text_setsize(id,10);
 text_setcolor(id,white);
 text_setattribute(id,2,true);
 text_setattribute(id,1,true);
end;

if LastBarOnChart then begin
 text_setlocation(id,d,t,c);
 text_setstring(id,NumToStr((insideask-insidebid)*bigpointvalue,2));
end;
