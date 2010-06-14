// Agent forager in project FoodSimulation.mas2j

// assume queen's position
queen(10,10).
searching(food).
storage_size(2).

// if we found food and our current load is max capacity, send message to others
//@ff1[atomic]
+step(_): searching(food) &
			food(X,Y,my_pos,_) &
			capacity(C) &
			weight(C) <- +searching(storage);
						  -searching(food);
						  .broadcast(tell, food_here(X,Y)).
												
+step(_) : searching(food) & 
			food(_,_,my_pos,_)
			<- load.
			
+step(_) : searching(food) & food(X,Y,see,_) & not agent(_,X,Y,_,_) <- move(X,Y).

+step(_) : searching(food) & food(X,Y,smell,_) <- move(X,Y).

+step(_) : moving_to(X,Y) & agent(_,_,_,_,_) <- random_move.

+step(_) : moving_to(X,Y) & pos(_,X,Y) <- -moving_to(X,Y); unload.

+step(_) : moving_to(X,Y) <- move(X,Y).

+step(_) : searching(storage) & weight(0) <- +searching(food); -searching(storage).

+step(_) : searching(storage) &
			tried_reserve &
			reserved(-1,-1)
			<- -tried_reserve;
				-searching(storage);
				+eating;
				.broadcast(tell, no_storage).
				
+step(_) : searching(storage) &
			tried_reserve &
			reserved(X,Y) &
			X \== -1
			<- -tried_reserve;
				+moving_to(X,Y).
				
@ss1[atomic]
+step(_) : searching(storage) <- reserve; +tried_reserve.									

// find food and eat it if we started eating
+step(_) : eating & weight(W) & W > 0 <- eat_internal.

+step(_) : eating & food(_,_,my_pos,_) <- eat.

+step(_) : eating & food(X,Y,see,_) & not agent(_,X,Y,_,_) <- move(X,Y).

+step(_) : eating & food(X,Y,smell,_) <- move(X,Y).

// just random move
+step(_) <- random_move.

// if attacked by stronger animal, send SOS to our defenders
+attacked(A,_) : 	agent(A,_,_,S,_) &
					strength(MS) &
					S > MS &
					pos(_,X,Y) <- .broadcast(tell, help_signal(A,X,Y)).

// receive info about food
//+food_here(X,Y) <- .println("Info about food received!").

+no_storage <- -searching(storage); +eating.

+storage_available <- +searching(food); -eating.
