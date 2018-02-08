INPUTS: 
   Mlenta(13),
   Mveloce(5),
   Prezzo(c);
   
inputs: protStopL$(400), protStopS$(100);  

{if
      Average(Prezzo,Mlenta) crosses above Average(Prezzo,Mveloce)
      then buy this bar on close;
    
    if marketposition=1 then setstoploss(protStopL$); }
      
      
if     
      Average(Prezzo,Mlenta) crosses below Average(Prezzo,Mveloce)
      then sellshort this bar on close;
      
    if marketposition=-1 then setstoploss(protStopS$); 
      
