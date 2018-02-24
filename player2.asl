// Agent tom in project saludos.mas2j



/* Initial beliefs and rules */

valido(pos(4,3),pos(5,4)).

invalidoA(pos(-3,4),pos(4,5)).

invalidoB(pos(1000,3), pos(4,5)).

invalidoC(pos(3,2),pos(3,2)).


/* Initial goals */



//!start.



/* Plans */

+puedesmover[source(judge)] : invalidoC(P1,P2) <- 
	.print("Acabo de recibir del juez el testigo de mover");
	-invalidoC(P1,P2);
	.send(judge,tell,mueve(ficha,P1,P2)).
	
+invalido(mismapos)[source(judge)] : invalidoA(P1,P2) <-
	.print("Acabo de recibir del juez que he intentado mover la misma ficha");
	-invalidoA(P1,P2);
	.send(judge,tell,mueve(ficha,P1,P2)).
+invalido(mismapos)[source(judge)].

+invalido(fueratablero)[source(judge)] : invalidoB(P1,P2) <-
	//-invalido(fueratablero);
	.print("Acabo de recibir del juez que he intentado mover fuera del tablero");
	-invalidoB(P1,P2);
	.send(judge,tell,mueve(ficha,P1,P2)).
+invalido(fueratablero)[source(judge)] : valido(P1,P2) <-
	//-invalido(fueratablero);
	.print("Acabo de recibir del juez que he intentado mover fuera del tablero");
	-valido(P1,P2);
	.send(judge,tell,mueve(ficha,P1,P2)).
+invalido(fueratablero)[source(judge)].

+valido[source(judge)] <- .print("Mi movimiento ha sido aceptado por el jueZ.").
