function [] = tp2()

%%%%%%%%%%%%%%

	%PUNTO a) jugadores=5, repeticiones_experimento =1 , Declaro que tipo de sistema que uso para jugar a la ruleta (“optimista” o “pesimista” )

	
   	[v_jugador_capital_pesimista, v_jugadas_pesimista, jugadas_ganadas, jugadas_perdidas, v_finales_exitosos_por_experimento]= simulacion(5, 1, false);

	[v_jugador_capital_optimista, v_jugadas_optimista, jugadas_ganadas, jugadas_perdidas, v_finales_exitosos_por_experimento]= simulacion(5, 1, true);

	% Imprimirá un plot para cada jugador del capital en función de las jugadas. 
		for jugador=1:1:5
            jugadas_pesimista = v_jugadas_pesimista(jugador);
            [v_jugador_pesimista]= calcular_capital_por_jugador(jugador, jugadas_pesimista, v_jugador_capital_pesimista);
            
            jugadas_optimista= v_jugadas_optimista(jugador);
            [v_jugador_optimista]= calcular_capital_por_jugador(jugador, jugadas_optimista, v_jugador_capital_optimista);
                        
            x_pesimista = [1:jugadas_pesimista];
            x_optimista = [1:jugadas_optimista];
          
            plot(x_pesimista, v_jugador_pesimista, x_optimista, v_jugador_optimista);
            grid on
            title('Capital --->>  Optimista Vs Pesimista')
          
            xlabel('Numero de jugadas');
            ylabel('Capital');
            
        end
        
        

	
%%%%%%%%%%%%%

	%PUNTO b) jugadores = 100, repeticiones_experimento = 1

	%%Corrida para pesimista
	[v_jugador_capital_pesimista, v_jugadas, jugadas_ganadas, jugadas_perdidas, v_finales_exitosos_por_experimento]= simulacion(100, 1, false);	

	frecuencia_final_exitoso = v_finales_exitosos_por_experimento(1);
	promedio_jugadas = sum(v_jugadas)/100;
	promedio_jugadas_alcanza_B = jugadas_ganadas/100;
	promedio_jugadas_pierde = jugadas_perdidas/100;
    
    disp('Corrida para PESIMISTA');
    disp(frecuencia_final_exitoso);
    disp(promedio_jugadas);
    disp(promedio_jugadas_alcanza_B);
    disp(promedio_jugadas_pierde);
	%%Corrida para optimista
	[v_jugador_capital_optimista, v_jugadas, jugadas_ganadas, jugadas_perdidas, v_finales_exitosos_por_experimento]= simulacion(100, 1, true);	

	frecuencia_final_exitoso = v_finales_exitosos_por_experimento(1);
	promedio_jugadas = sum(v_jugadas)/100;
	promedio_jugadas_alcanza_B = jugadas_ganadas/100;
	promedio_jugadas_pierde = jugadas_perdidas/100;

    disp('Corrida para OPTIMISTA');
    disp(frecuencia_final_exitoso);
    disp(promedio_jugadas);
    disp(promedio_jugadas_alcanza_B);
    disp(promedio_jugadas_pierde);
%%%%%%%%%%%%
	
	%PUNTO c) jugadores= 100, repeticiones_experimento = 200
	
	%%Corrida pesimista

	[v_jugador_capital_pesimista, v_jugadas, jugadas_ganadas, jugadas_perdidas, v_finales_exitosos_por_experimento]= simulacion(100, 200, false);
	hist(v_finales_exitosos_por_experimento);
	
	%%Corrida optimista

	[v_jugador_capital_optimista, v_jugadas, jugadas_ganadas, jugadas_perdidas, v_finales_exitosos_por_experimento]= simulacion(100, 200, true);

	hist(v_finales_exitosos_por_experimento);

end

function [v_jugador] = calcular_capital_por_jugador(jugador, jugadas, matriz_jugadas_capital)
    v_jugador = [1,jugadas];
    
    for jugada=1:1:jugadas
        v_jugador(jugada) = matriz_jugadas_capital(jugador,jugada);
    end
    
end

function [v_jugador_capital, v_jugadas, jugadas_ganadas, jugadas_perdidas, v_finales_exitosos_por_experimento]= simulacion(jugadores, repeticiones_experimento, optimista)

	v_finales_exitosos_por_experimento = zeros(1, repeticiones_experimento);  

    for repeticion=1:1:repeticiones_experimento		

        %Declaración de variables 

        a=10;
        b=100;
        C=200;
        B=400;
        jugadas = 1;

        capital=C;

        apuesta = a;

        ganancia = 0;

        regla_de_ajuste = 0;
        gano_juego=0;
        jugadas_ganadas = 0;
        jugadas_perdidas = 0;

        v_jugador_capital = zeros(jugadores, 1000);
        v_jugadas = zeros(1, jugadores);
        v_capital = zeros(1, 1000);

        for jugador=1:1:jugadores  %cantidad de personas que juegan

            while (capital >0) && (ganancia < B)

                r=rand;
                %Se gana jugada
                if r<0.5
                    ganancia = ganancia + apuesta ;
                    %Para que no se vaya del juego habiendo obtenido una ganancia mayor a la que impone el limite B.
                    if(ganancia>B)
                        ganancia = B;
                    end
                    capital = capital + apuesta;

                    if optimista == true
                        regla_de_ajuste = regla_de_ajuste+1;
                        apuesta = 2*apuesta;
                    else
                        apuesta = a;
                    end

                else

                    capital = capital - apuesta;

                    if optimista == (true)
                        apuesta = a;	
                    else
                        apuesta = 2*apuesta ;
                    end 

                end

                if apuesta > b
                        apuesta = b;
                end

                if optimista == true && regla_de_ajuste==3
                    apuesta = a;
                    regla_de_ajuste = 0;
                end


                v_capital(jugadas)= capital;
                jugadas = jugadas +1;


            end %Termina jugada

            if capital < 0

                jugadas_perdidas = jugadas_perdidas +jugadas;

            else 

                gano_juego=gano_juego+1;
                jugadas_ganadas=jugadas_ganadas +jugadas;

            end

            %Nos piden plotear en el punto a), el capital vs jugadas de CADA jugador. Es necesario resetear la variable jugadas para cada jugador, 
            %por ésto al finaliza el juego las almacenamos en un vector.

            v_jugadas(jugador) = jugadas-1;

            v_jugador_capital(jugador,:) = v_capital; 

            %Se resetean los valores
            apuesta = a;
            capital = C;
            jugadas = 1;
            ganancia = 0;
            v_capital = zeros(1, 1000);


        end
        %Guardamos una entrada de la frecuencia de juegos exitosos por cada repeticion del experimento.
        v_finales_exitosos_por_experimento(repeticion) = gano_juego/jugadores;
                    
	end


end			