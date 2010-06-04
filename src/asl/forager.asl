// Agent forager in project FoodSimulation.mas2j

/* Initial beliefs and rules */

// assume queen's position
queen(10,10).

//!start.

//+!start : true <- .print("hello world.").

//+step(_) : food(_,_,my_pos,_) <- eat.

// if we found food and our current load is max capacity, send message to others
+step(_) : food(_,_,my_pos,_) &
			capacity(C) &
			weight(W) & W < C <- load.
			
+step(_) : food(X,Y,see,_) & not agent(_,X,Y,_,_) <- move(X,Y).
			
+step(_) <- random_move.

// if attacked by stronger animal, send SOS
+attacked(A,_) : agent(A,_,_,S,_) &
					strength(MS) &
					S > MS &
					pos(_,X,Y) <- .broadcast(tell, help_signal(A,X,Y)).

// if other forager sent SOS signal
+help_signal(A,X,Y) <- .println("Forager ",A," attacked at ",X,":",Y).
