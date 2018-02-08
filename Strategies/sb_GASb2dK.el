Inputs: NoS(1),KLen(25),K(1.0);

Vars: lowerk(0),upperk(0);


 lowerk = KeltnerChannel(l ,klen,-k) ;
 upperk = KeltnerChannel(h ,klen,k) ;



 
  sellshort("rs") nos shares next bar at upperk stop;
  buy("rl") nos shares next bar at lowerk stop;
 
