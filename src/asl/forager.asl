// Agent forager in project FoodSimulation.mas2j

// assume queen's position
queen(10,10).
searching(food).

// if we found food and our current load is max capacity, send message to others
+step(_): searching(food) &
			food(X,Y,my_pos,_) &
			capacity(C) &
			weight(W) & W == C <- +searching(queen); -searching(food); .broadcast(tell, food_here(X,Y)); random_move.
			
+step(_) : searching(food) & 
			food(_,_,my_pos,_)
			<- load.

// approach to food...
+step(_) : searching(food) & food(X,Y,see,_) & not agent(_,X,Y,_,_) <- move(X,Y).

+step(_) : searching(food) & food(X,Y,smell,_) <- move(X,Y).


+step(_) : searching(queen) <- !find_queen;
								+searching(storage);
								-searching(queen).

+!find_queen: queen(_,_,my_pos) <- true.

+!find_queen: queen(X,Y,see) & not agent(_,X,Y,_,_) <- move(X,Y); !find_queen.

+!find_queen: queen(X,Y,smell) <- move(X,Y); !find_queen.

+!find_queen: queen(X,Y) <- move(X,Y); !find_queen.
			
// just random move
+step(_) <- random_move.

// if attacked by stronger animal, send SOS to our defenders
+attacked(A,_) : 	agent(A,_,_,S,_) &
					strength(MS) &
					S > MS &
					pos(_,X,Y) <- .broadcast(tell, help_signal(A,X,Y)).

// if other forager sent SOS signal, just for debug
+help_signal(A,X,Y) <- .println("Forager ",A," attacked at ",X,":",Y).

// receive info about food
+food_here(X,Y) <- .println("Info about food received!").


