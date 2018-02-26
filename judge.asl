// Agent tom in project saludos.mas2j

/* Initial beliefs and rules */

contador(100).

size(10).

vecesNoTurno(player1,0).
vecesNoTurno(player2,0).

actual(player1).

valido(X1,Y1,X2,Y2):-
	not mismapos(X1,Y1,X2,Y2) &
	not fueratablero(X1,Y1,X2,Y2).

mismapos(X,Y,X,Y).

fueratablero(X1,Y1,X2,Y2):-
	negativo(X1) | negativo(X2) | negativo(Y1) | negativo(Y2).

fueratablero(X1,Y1,X2,Y2):-
	size(N) & (X1 >= N | X2 >= N | Y1 >= N | Y2 >= N).

negativo(X):- X < 0.

/* Initial goals */

!startGame.

/* Plans */

+!startGame : actual(Player) & contador(N) & N>0 <-
	.send(Player,tell,puedesmover);
	.send(Player,untell,puedesmover).

+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : not actual(A) <-
	+noTurno(A).
	
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : actual(A) & vecesNoTurno(A,N) & N>=3 <-
	?contador(N);
	
	.print("El jugador ",A," tiene prohibido seguir jugando");
	-+contador(N-1).

+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : actual(A) <-
	if(Dir=="up"){
		+mueve(pos(X,Y),pos(X,Y-1),A);
	}
	if(Dir=="down"){
		+mueve(pos(X,Y),pos(X,Y+1),A);
	}
	if(Dir=="left"){
		+mueve(pos(X,Y),pos(X-1,Y),A);
	}
	if(Dir=="right"){
		+mueve(pos(X,Y),pos(X+1,Y),A);
	}
	else{
		.print("Direccion de movimiento indeterminada");
	}.

+mueve(pos(X1,Y1),pos(X2,Y2),A) : valido(X1,Y1,X2,Y2) <- 
	-mueve(pos(X1,Y1),pos(X2,Y2),A);
	?contador(N);
	
	.print("Acabo de verificar el movimiento jugador: ",A);
	.send(A,tell,valido);
	
	-+contador(N-1);
	-+vecesInvalido(A,0);
	
	if (A = player1) 
		{-+actual(player2);} 
	else 
		{-+actual(player1);};
	.send(A,untell,valido);
	!startGame.

+mueve(pos(X1,Y1),pos(X2,Y2),A) : fueratablero(X1,Y1,X2,Y2) <-
	-mueve(pos(X1,Y1),pos(X2,Y2),A);
	?vecesInvalido(A,N);
	
	if(N<3){
		-+vecesInvalido(A,N+1);
		.print("Jugador: ", A, " Acabo de comprobar que hay una posición fuera del tablero");
		.send(A,tell,invalido(fueratablero));
		.send(A,untell,invalido(fueratablero));
	}
	else{
		-+vecesInvalido(A,0);
		if (A = player1) 
			{-+actual(player2);} 
		else 
			{-+actual(player1);};
		!startGame;
	}.

+mueve(P1,P2)[source(A)] : actual (A)<-
	-mueve(P1,P2)[source(A)];
	.print("Movimiento no controlado del jugador: ",A).
	
+mueve(P1,P2)<-
	-mueve(P1,P2);
	.print("Movimiento indeterminado").
