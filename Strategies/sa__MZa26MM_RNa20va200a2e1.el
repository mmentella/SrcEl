{TI riporto quanto avevo fatto, non mi ricordo piu da dove presi spunto  comunque ti riporto una serei di link, in particolarmodo,
per creare una funzione di back-propagazione, che di base ? poi il  fulcro.

Allora Mat la rete neurale sai che Matematicamente, sono un modo per  adattarsi a un modello non lineare di un insieme di dati.
Qui Mat possiamo utilizzare un modello di regressione lineare piu  avanzato di quello semplice, polinomiale o altro,
ci metterei il piu evoluto che esiste a livello  ingegneristico,Fouriere,ecc.. sai quale ??

Infatti la costruzione di una rete neurale ? simile - ma pi? complessa  - con una retta per un insieme di punti utilizzando la regressione  lineare. 
Nel codice che ti ho messo vedu che
l'uscita, O, ? prodotto dalle equazioni seguenti 
 
    H1 = tanh (W11 W21 * I1 + I2 *)  H1 = tanh(W11*I1 + W21*I2)
    H2 = tanh (W12 W22 * I1 + I2 *)  H2 = tanh(W12*I1 + W22*I2)
    H3 = tanh (W13 W23 * I1 + I2 *)  H3 = tanh(W13*I1 + W23*I2)
    O = tanh(c1*c2H1+H2* + c3 H3 *)  O  = tanh(C1*H1 + C2*H2 + C3*H3)

I1 e I2 sono i due ingressi. Questi potrebbero essere qualsiasi cosa  che potrebbe avere qualche valore predittivo per la negoziazione, 
la  quantit? di moto, lo stocastico, ADX, medie mobili, il parlato bid,ask
potremmo metterci anche il tuio filtro smooth antilag a 13 baree ecc...

I pesi sono W12, W12, W13, W21, W22, W23, C1, C2 e C3. determinati  dalll'adattamento del modello, la sua struttura.
Ho scelto la tangente iperbolica tanh perch? da valori compresi tra
 -1 e +1, in maniera da avere una output interpretabile a livello  binario, boleano,buy,sell,flat ecc... e anche in modo da limitare i  calcoli, del pc.
C'e da dire che gli input ? bene metterli in scala achessi tra -1 e 1,
per dare uniformit? e semplificare i calcoli da fare sul pc, anche per  poter collegare piu reti tra loro in maniera che dialoghino tra loro,  
se tu hai idee migliori ben vengano.

I valori dei dati di allenamento sono:
(I1-1, I2-1, O-1), (I1-2, I2-2, O-2), (I1-3, I2-3, O-3) , ecc

Nel caso i pesi dovrebbero regolare un modello che identifica momenti  di mercato rialzista o ribassista.

La rete va addestrata e utilizzata sulla funzione di multicharts walk- forward in modo da avere dati in-sample di allenamento e out sample per  vederne
l'efffettivo comportamento, e quindi qui non ci sono problemi,   nel senso che funziona bene anche li siamo ok.l'unica cosa, 
non so se  hai mai fatto del walk forward, i tempi che ci mette a elaborare, sono  veramenrte biblici.
Se la rete nei out sample da bion i risultati allora sdiamo ok.

La tecnica per regolare i pesi come sai si chiama back-propagation.
Se i valori del ts sono buoni allora si puo fare del paper.

Un problema grosso ? che Multicharts non ha una funzione algoritmica di  back propagation, e questo ? un bel problema.
Ne ho trovati tanti, qui meglio che ci pensi tu e fra tutti metti  in easylanguage quello piu idoneo, io ci ho rpovato, ma non sono  riuscito a 
tirare fuori un algoritmo di back propagation che fosse  soddisfacente.
Non avendo un buon algoritmo di back-prop cosa ho fatto,a llora ho  utilizzato la sua funzione di ottimizzazione normale (e qui ci mette  una vita) 
poi quella genetica di mc, per fare i pesi.
Cosi il peso viene derminato dal processo di ottimizzazzione genetico.

Poi qui stavo a rompere il pc perch? ho avuto questo problema.

In mc non c'? un modo facile per fornire dati di training set al  modello. Allora addestreremo la rete la rete direttamente sui dati di  prezzo 
incorporando la rete nel ts un  e l'ottimizzazione dei pesi  della rete come parte del sistema.
Questo approccio non ? l'ideale dal punto di vista di ottimizzazione,  ma ? pi? diretto.

Allora definiamo gli input basandomi sul momentum, normalizzato per  tenerli nel range [-1, 1].
 I1 = (C - C [2]) / 33
 I2 = (C - C [10]) / 64
e l'uscita sar? interpretato come un segnal rialzista / ribassista  segnale, se il risultato sar?

O >= 0.5 -> rialzista
O <= -0,5 -> ribassista

Come ci si comporta, compriamo se abbiamo un segnale rialzista e  vendiamo se se il segnale ? ribassista, mentre tra -0.5 e 0.5 possiamo  
fare flat o chiudere le posizioni.


Quindi di seguito il codice gli input con tutti i vari pesi}


Inputs:  w11     (1),    { weights }
         w12     (1),
         w13     (1),
         w21     (1),
         w22     (0),
         w23     (-1),
         c1      (-1),
         c2      (1),
         c3      (0);
 
//Le variabili che defeiniscono il layer nascosti, 

 Var:    I1      (0),    { input 1 }
         I2      (0),    { input 2 }
         H1      (0),    { hidden node 1 }
         H2      (0),    { hidden node 2 }
         H3      (0),    { hidden node 3 }
	  NNOut   (0);    { function output }

//I due input definito come sopra tti ho spiegato

 I1 = (C - C[2])/33;
 I2 = (C - C[10])/64;

//Le funzioni, chiaramente va aggiunto anche nei pesi se il numero input aumeta

 H1 = tanh(w11*I1 + w21*I2, 50);
 H2 = tanh(w12*I1 + w22*I2, 50);
 H3 = tanh(w13*I1 + w23*I2, 50);
 NNOut = tanh(c1*H1 + c2*H2 + c3*H3, 50);

 Print("date: ", date:8:0, " NN Output: ", NNOut:6:3);
 
 {qui puoi mettere l'out pot dell'easylangugae print log }

//E le decisoni di entrata uscita e flat sulla base output

If NNOut >= 0.5 then
    Buy next bar at High stop;
 If NNOut <= -0.5 then
    Sellshort next bar at low stop;
If -0.5 < NNOut and NNOut < 0.5 then Begin
    Sell this bar on close;
    Buytocover this bar on close; 
 End;

{I valori dei pesi ottimali, dopo li prendi e li metti nei campi  corretti, ovvimante tra -1 0 1.

Questa procedura di export e reimport vorrei automatizzarla,
utilizzando tipo filewrtestring o qualcosa di simile, tu sei capace?


A questo ? importante aggiungere secondom,e una un terzo I3, che  definirei tempo, ovviamente la rete va ristrutturate per un input  maggiore, 
come anche in numero dei nodi e pesi.

Ti allego gi? la funzione per convertire il tempo data nel nostro  formato corretto, sono impazzito qua a riuscirla
tireare fuori.}
{
Var: strVar(""), pDateTime(0);

if (lastBarOnchart) then
begin	
pDateTime = DateToJulian( Date ) + ( TimeToMinutes( Time ) / 60 / 24 )  ; 
strVar =(FormatTime("hh:mm:ss tt",pDateTime));
print(strvar);
end;

}
