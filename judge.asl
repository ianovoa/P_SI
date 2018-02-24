// Agent tom in project saludos.mas2j

/* Initial beliefs and rules */

contador(100).

size(10).

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
	
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : actual(A) & Dir="up" <-
	mueve(F,pos(X1,Y1),pos(X2,Y2)).

+mueve(F,pos(X1,Y1),pos(X2,Y2))[source(A)] : actual(A) & valido(X1,Y1,X2,Y2) <- 
	-mueve(F,pos(X1,Y1),pos(X2,Y2))[source(A)];
	
	.print("Acabo de verificar el movimiento jugador: ",A);
	.send(A,tell,valido);
	if (A = player1) 
		{-+actual(player2);} 
	else 
		{-+actual(player1);};
	.send(A,untell,valido);
	!startGame.
	
	
+mueve(F,pos(X1,Y1),pos(X2,Y2))[source(A)] : actual(A) & mismapos(X1,Y1,X2,Y2) <-
//+mueve(F,pos(X,Y),pos(X,Y))[source(A)] : actual(A) <-//& mismapos(X1,Y1,X2,Y2) <-
	-mueve(F,pos(X1,Y1),pos(X2,Y2))[source(A)];
	//-mueve(F,pos(X,Y),pos(X,Y))[source(A)];
	.print("Jugador: ", A, " Acabo de comprobar que es la misma posicion");
	.send(A,tell,invalido(mismapos));
	.send(A,untell,invalido(mismapos)).

+mueve(F,pos(X1,Y1),pos(X2,Y2))[source(A)] : actual(A) & fueratablero(X1,Y1,X2,Y2) <-
	-mueve(F,pos(X1,Y1),pos(X2,Y2))[source(A)];
	.print("Jugador: ", A, " Acabo de comprobar que hay una posición fuera del tablero");
	.send(A,tell,invalido(fueratablero));
	.send(A,untell,invalido(fueratablero)).

+mueve(F,P1,P2)[source(A)] : not actual (A)<-
	-mueve(F,P1,P2)[source(A)];
	.print("Movimiento no experado del jugador: ",A).

+mueve(F,P1,P2)[source(A)] : actual (A)<-
	-mueve(F,P1,P2)[source(A)];
	.print("Movimiento no controlado del jugador: ",A).
	
+mueve(F,P1,P2)<-
	-mueve(F,P1,P2);
	.print("Movimiento indeterminado").
