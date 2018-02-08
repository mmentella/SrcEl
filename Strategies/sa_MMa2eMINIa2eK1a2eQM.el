vars: id(0);

if currentbar > 1 then begin
 if d < 1110501 then begin
 
 
 {--------------------------}
 {--------------------------}
 
 {****** - MM. - ********
  Engine:    Kletner
  Author:    Matteo Mentella
  Portfolio: Mini
  Market:    E-Mini Crude Oil - QM
  TimeFrame: 60 min.
  BackBars:  50
  Date:      5 Apr 2011
 *************************************}
 
 {--------------------------}
 {--------------------------}
 Inputs: lenl(20),kl(2),lens(20),ks(2);
 
 vars: upk(0),lok(0),el(true),es(true),trade(0);
 
 if d > d[1] then begin
  trade = 0;
 end;
 
 upk = KeltnerChannel(h,lenl,kl);
 lok = KeltnerChannel(l,lens,-ks);
 
 el = c < upk;
 es = c > lok;
 
 if marketposition <> 0 and barssinceentry = 0 then begin
  trade = trade + 1;
 end;
 
 if trade = 0 then begin
  
  if marketposition < 1 and el then
   buy("el") next bar upk stop;
  
  if marketposition > -1 and es then
   sell short("es") next bar lok stop;
  
 end;
 
 
end else begin
 text_setlocation(id,d,t,c);
 text_setstring(id,"Periodo di Trading scaduto. Aggiornare la Licenza o contattare 'm.mentella@gmail.com'. " + 
                   "Potrebbero essere rimaste delle posizioni aperte in Banca.");
end;

end else begin
 id = text_new(d,t,c,"");
 text_setcolor(id,white);
 text_setsize(id,10);
 text_setstyle(id,1,1);
end;

