// Agent tom in project saludos.mas2j



/* Initial beliefs and rules */

random(X,Max):-
	.random(X1) &
	X = math.round(Max*X1).

/* Initial goals */



//!start.



/* Plans */

+puedesmover[source(judge)] : true <-
	?random(X,9);
	?random(Y,9);
	
	.print("Acabo de recibir del juez el testigo de mover");
	.send(judge,tell,moverDesdeEnDireccion(pos(X,Y),"right")).
	
+invalido(fueraTablero,N)[source(judge)] : true <-
	?random(X,9);
	?random(Y,9);
	
	.print("Acabo de recibir del juez que he intentado mover fuera del tablero por ",N,"º vez");
	.send(judge,tell,moverDesdeEnDireccion(pos(X,Y),"right")).
	
+valido[source(judge)] <- .print("Mi ultimo movimiento ha sido valido").

+tryAgain[source(judge)] <- .print("Mi ultimo movimiento ha tocado 2 fichas del mismo color").

+invalido(fueraTurno,N)[source(judge)] <- .print("He intentado hacer trampa moviendo fuera de mi turno").
