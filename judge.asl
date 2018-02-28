// Agent tom in project saludos.mas2j

/* Initial beliefs and rules */

//tablero(celda(ficha(Color,Tipo),pos(X,Y))).

contador(100).

size(10).

vecesNoTurno(player1,0).
vecesNoTurno(player2,0).

vecesInvalido(player1,0).
vecesInvalido(player2,0).

actual(player1).

valido(X1,Y1,X2,Y2):- not fueratablero(X1,Y1,X2,Y2).

fueratablero(X1,Y1,X2,Y2):-
	negativo(X1) | negativo(X2) | negativo(Y1) | negativo(Y2).

fueratablero(X1,Y1,X2,Y2):-
	size(N) & (X1 >= N | X2 >= N | Y1 >= N | Y2 >= N).

negativo(X):- X < 0.

random(X,Max):-
	.random(X1) &
	X = math.round(Max*X1).
	

/* Initial goals */

!startGame.

/* Plans */

+!startGame : contador(N) & N<=0 <-
	.print("Fin de partida").

+!startGame : actual(Player) & contador(N) & N>0 <-
	if(N==100){+rellenarTablero;}
	.send(Player,tell,puedesmover);
	.send(Player,untell,puedesmover).

+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : not actual(A) <-
	-moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)];
	?vecesNoTurno(A,N);
	-+vecesNoTurno(A,N+1).
	
+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : actual(A) & vecesNoTurno(A,N) & N>=3 <-
	-moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)];
	?contador(N);
	.print("El jugador ",A," tiene prohibido seguir jugando");
	-+contador(N-1).

+moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)] : actual(A) <-
	-moverDesdeEnDireccion(pos(X,Y),Dir)[source(A)];
	if(Dir=="up"){
		+mueve(pos(X,Y),pos(X,Y-1),A);
	}
	else{
		if(Dir=="down"){
			+mueve(pos(X,Y),pos(X,Y+1),A);
		}
		else{
			if(Dir=="left"){
				+mueve(pos(X,Y),pos(X-1,Y),A);
			}
			else{
				if(Dir=="right"){
					+mueve(pos(X,Y),pos(X+1,Y),A);
				}
				else{
					.print("Direccion de movimiento indeterminada");
				}
			}
		}
	}.

+mueve(pos(X1,Y1),pos(X2,Y2),A) : valido(X1,Y1,X2,Y2) <- 
	-mueve(pos(X1,Y1),pos(X2,Y2),A);
	?contador(N);
	
	.print("El jugador ",A," a movido de (",X1,",",Y1,") a (",X2,",",Y2,")");
	.send(A,tell,valido);
	.send(A,untell,valido);
	
	-+contador(N-1);
	-+vecesInvalido(A,0);
	
	if (A = player1) 
		{-+actual(player2);} 
	else 
		{-+actual(player1);};
	!startGame.

+mueve(pos(X1,Y1),pos(X2,Y2),A) : fueratablero(X1,Y1,X2,Y2) <-
	-mueve(pos(X1,Y1),pos(X2,Y2),A);
	?vecesInvalido(A,N);
	
	if(N<3){
		-+vecesInvalido(A,N+1);
		.print("Jugador: ", A, " Acabo de comprobar que hay una posicion fuera del tablero");
		.send(A,tell,invalido);
		.send(A,untell,invalido);
	}
	else{
		-+vecesInvalido(A,0);
		.print("Jugador ", A, " se detecto 3 fueras de tablero seguidos.");
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
	
+rellenarTablero : true <-
	?size(N);

	for (.range(I,0,N-1) ) {
		for (.range(J,0,N-1) ) {
			?random(Color,5);
			?random(NTipo,4);
	
			if(NTipo==0){
				Tipo="in";
			}
			if(NTipo==1){
				Tipo="ip";
			}
			if(NTipo==2){
				Tipo="ct";
			}
			if(NTipo==3){
				Tipo="gs";
			}
			if(NTipo==4){
				Tipo="co";
			}
			+celda(ficha(Color,Tipo),pos(I,J),0);
		}
	}.
