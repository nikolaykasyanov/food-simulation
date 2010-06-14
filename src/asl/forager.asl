// Agent forager in project FoodSimulation.mas2j

// initial beliefs
queen(10,10). // queen position
searching(food). // our initial task
storage_size(2). // size of area around queen intented to store food

// if we found food but can't load it, tell others about it and start storage search
+step(_): searching(food) &
			food(X,Y,my_pos,_) &
			capacity(C) &
			weight(C) <- +searching(storage);
						  -searching(food);
						  .broadcast(tell, food_here(X,Y)).

// otherwise, load food						  
+step(_) : searching(food) & 
			food(_,_,my_pos,_)
			<- load.

// approach to food...			
+step(_) : searching(food) & food(X,Y,see,_) & not agent(_,X,Y,_,_) <- move(X,Y).

+step(_) : searching(food) & food(X,Y,smell,_) <- move(X,Y).

// moving to reserved storage slot
// random_move if some agent is near to avoid deadlocks
+step(_) : moving_to(X,Y) & agent(_,_,_,_,_) <- random_move.

// if we finally at target point, unload food to storage cell
+step(_) : moving_to(X,Y) & pos(_,X,Y) <- -moving_to(X,Y); unload.

// just move towards target point
+step(_) : moving_to(X,Y) <- move(X,Y).

// if we unloaded all food, starting food search again
+step(_) : searching(storage) & weight(0) <- +searching(food); -searching(storage).

// if we already tried to reserve storage cell and no storage available,
// start eating and tell others about lack of storage
+step(_) : searching(storage) &
			tried_reserve &
			reserved(-1,-1)
			<- -tried_reserve;
				-searching(storage);
				+eating;
				.broadcast(tell, no_storage).
				
// if reservation was successful, start moving to reserved cell
+step(_) : searching(storage) &
			tried_reserve &
			reserved(X,Y) &
			X \== -1
			<- -tried_reserve;
				+moving_to(X,Y).
				
// if searching storage, try to reserve storage cell
@ss1[atomic]
+step(_) : searching(storage) <- reserve; +tried_reserve.									

// find food and eat it if we started eating

// if we carry food, eat it first
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

// message about storage lack received
+no_storage <- -searching(storage); +eating.

// free storage cells available
+storage_available <- +searching(food); -eating.
