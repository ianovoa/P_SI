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
	?random(Z,3);
	
	if(Z==0){
		Dir="up";
	}
	if(Z==1){
		Dir="down";
	}
	if(Z==2){
		Dir="left";
	}
	if(Z==3){
		Dir="right";
	}
	
	.print("Acabo de recibir del juez el testigo de mover");
	.send(judge,tell,moverDesdeEnDireccion(pos(X,Y),Dir)).
	
+invalido(fueraTablero,N)[source(judge)] : true <-
	?random(X,9);
	?random(Y,9);
	?random(Z,3);
	
	if(Z==0){
		Dir="up";
	}
	if(Z==1){
		Dir="down";
	}
	if(Z==2){
		Dir="left";
	}
	if(Z==3){
		Dir="right";
	}
	
	.print("Acabo de recibir del juez el testigo de mover");
	.send(judge,tell,moverDesdeEnDireccion(pos(X,Y),Dir)).
	
+valido[source(judge)] <- .print("Mi ultimo movimiento ha sido valido").

+tryAgain[source(judge)] <- .print("Mi ultimo movimiento ha tocado 2 fichas del mismo color").

+invalido(fueraTurno,N)[source(judge)] <- .print("He intentado hacer trampa moviendo fuera de mi turno").
