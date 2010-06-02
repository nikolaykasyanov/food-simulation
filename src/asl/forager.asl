// Agent forager in project FoodSimulation.mas2j

/* Initial beliefs and rules */

// assume queen's position
queen(10,10).

//!start.

//+!start : true <- .print("hello world.").

//+step(_) : food(_,_,my_pos,_) <- eat.

// if we found food and our current load is max capacity, send message to others
+step(_) : food(_,_,my_pos,Me) &
			pos(Me,_,_) &
			capacity(C) &
			weight(W) & W < C <- load.
			
/*+step(_) : food(_,_,my_pos,Me) &
			pos(Me,_,_) &
			capacity(C) &
			weight(W) & W == C <- .broadcast*/
			
			
+step(_) <- random_move.
