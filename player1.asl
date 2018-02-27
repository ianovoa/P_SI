// Agent tom in project saludos.mas2j



/* Initial beliefs and rules */

valido(pos(X1,Y1),pos(X2,Y2)):-
	.random(X11,10) &
	.random(Y11,10) &
	.random(X12,10) &
	.random(Y12,10) &
	X1 = math.round(10*X11) &
	Y1 = math.round(10*Y11) &
	X2 = math.round(10*X12) &
	Y2 = math.round(10*Y12).

invalidoA(pos(3,-4),pos(4,5)).

invalidoB(pos(3,1000), pos(4,5)).

invalidoC(pos(2,3),pos(2,3)).


/* Initial goals */



//!start.



/* Plans */

+puedesmover[source(judge)] : true <-
	.print("Acabo de recibir del juez el testigo de mover");
	.send(judge,tell,moverDesdeEnDireccion(pos(1,1),"left")).

/*+puedesmover[source(judge)] : invalidoC(P1,P2) <- 
	.print("Acabo de recibir del juez el testigo de mover");
	-invalidoC(P1,P2);
	//.send(judge,tell,mueve(ficha,P1,P2)).
	send(judge,tell,moverDesdeEnDireccion(pos(X,Y),Dir)).
	
+puedesmover[source(judge)] : not invalidoC(P1,P2) <- 
	.print("Acabo de recibir nuevamente del juez el testigo de mover");
	.print("Procedo a actualizar los conocimientos sobre movimientos");
	+invalidoA(pos(-3,4),pos(5,4));
	+invalidoB(pos(1000,3), pos(5,4));
	+invalidoC(pos(3,2),pos(3,2));
	P1 = pos(3,2);
	P2 = pos(3,2);
	-invalidoC(pos(3,2),pos(3,2));
	.send(judge,tell,mueve(ficha,P1,P2)).
	
+invalido(mismapos)[source(judge)] : invalidoA(P1,P2) <-
	.print("Acabo de recibir del juez que he intentado mover la misma ficha");
	-invalidoA(P1,P2);
	.send(judge,tell,mueve(ficha,P1,P2)).
	
+invalido(mismapos)[source(judge)].

+invalido(fueratablero)[source(judge)] : invalidoB(P1,P2) <-
	//-invalido(fueratablero);
	.print("Acabo de recibir del juez que he intentado mover fuera del tablero 1 vez");
	-invalidoB(P1,P2);
	.send(judge,tell,mueve(ficha,P1,P2)).
	
+invalido(fueratablero)[source(judge)] : valido(P1,P2) <-
	//-invalido(fueratablero);
	.print("Acabo de recibir del juez que he intentado mover fuera del tablero 2 veces");
	//-valido(P1,P2);
	.send(judge,tell,mueve(ficha,P1,P2)).
	
+invalido(fueratablero)[source(judge)].

+valido[source(judge)] <- .print("Mi ultimo movimiento ha sido valido").*/

