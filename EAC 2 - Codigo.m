function = EAC2()

%%%%%%%%%%%%%%

	%PUNTO a) jugadores=5, repeticiones_experimento =1,  optimista = false ;  % Declaro que tipo de sistema que uso para jugar a la ruleta (“optimista” o “pesimista” )

	
	[v_jugador_capital, v_jugadas, jugadas_ganadas, jugadas_perdidas, v_finales_exitosos_por_experimento]= simulacion(5, 1, false);

	% Imprimirá un plot para cada jugador del capital en función de las jugadas. 
		for i=1:1:5
			plot(v_jugador_capital);
		end

	
%%%%%%%%%%%%%

	%PUNTO b) jugadores = 100, repeticiones_experimento = 1, optimista = false

	[v_jugador_capital, v_jugadas, jugadas_ganadas, jugadas_perdidas, v_finales_exitosos_por_experimento]= simulacion(100, 1, false);	

	frecuencia_final_exitoso = v_finales_exitosos_por_experimento[1]/100;
	promedio_jugadas = sum(v_jugadas)/100;
	promedio_jugadas_alcanza_B = jugadas_ganadas/100;
	promedio_jugadas_pierde = jugadas_perdidas/100;

%%%%%%%%%%%%
	
	%PUNTO c) jugadores= 100, repeticiones_experimento = 200, optimista = false

	[v_jugador_capital, v_jugadas, jugadas_ganadas, jugadas_perdidas, v_finales_exitosos_por_experimento]= simulacion(100, 200, false);
	hist(v_finales_exitosos_por_experimento);

end


function [v_jugador_capital, v_jugadas, jugadas_ganadas, jugadas_perdidas, v_finales_exitosos_por_experimento]= simulacion(jugadores, repeticiones_experimento, optimista)

	
	

	%Declaración de variables 

	a=10;
	b=100;
	C=200;
	B=400;
	jugadas = 0;

	apuesta = a;

	ganancia = 0

	acumulado = 0

	p=18/37;

	perdio_juego=0;
	gano_juego=0;
	jugadas_ganadas = 0,
	jugadas_perdidas = 0;

	v_jugador_capital = [];
	v_jugadas = [];
	v_capital = [];
	v_finales_exitosos_por_experimento = [];

	for i=1:1:repeticiones_experimento		

			%Función Principal

			for jugador=1:1:jugadores  %cantidad de personas que juegan

				while capital >0 and ganancia < B

					r=rand;
					%Se gana jugada
					if r==p
						ganancia = ganancia + apuesta ;
						
						if optimista == true
							regla_de_ajuste = regla_de_ajuste+1;
							apuesta = 2*apuesta;
						else
							apuesta = a;
						end
						
					else
				
						capital = capital - apuesta;
						
						if optimista = true
							apuesta = a;	
						else
							apuesta = 2*apuesta ;
						end 
										
					end
					
					if apuesta > b
							apuesta = b;
					end

					if optimista == true and regla_de_ajuste==3
						apuesta = a;
					end

					capital = capital + ganancia;
					v_capital[jugadas]= capital;
					jugadas = jugadas +1;

					
				end %Termina jugada

			 	if capital < 0
			 	
					perdio_juego = perdio_juego +1;
					jugadas_perdidas = jugadas_perdidas +1;

				else ganancia >= B
				
					gano_juego=gano_juego+1;
					jugadas_ganadas=jugadas_ganadas +1;

				end
				
				v_jugadas[jugador] = jugadas;

				%Nos piden plotear en el punto a), el capital vs jugadas de CADA jugador. Es necesario resetear la variable jugadas para cada jugador, 
				%por ésto al finaliza el juego las almacenamos en un vector.
				v_jugador_capital[jugador] = v_capital; 
				
				%Se resetean los valores
				apuesta = a;
				capital = C;
				jugadas = 0;
				v_capital = [];


			end

			v_finales_exitosos_por_experimento[i] = gano_juego;
	end


end			
				
		
	

