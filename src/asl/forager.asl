// Agent forager in project FoodSimulation.mas2j

// assume queen's position
queen(10,10).
searching(food).
storage_size(2).

// if we found food and our current load is max capacity, send message to others
@ff1[atomic]
+step(_): searching(food) &
			food(X,Y,my_pos,_) &
			capacity(C) &
			weight(C) <- +searching(queen); -searching(food); .broadcast(tell, food_here(X,Y)); random_move.
			
+step(_) : searching(food) & 
			food(_,_,my_pos,_)
			<- load.
			
+step(_) : searching(food) & food(X,Y,see,_) & not agent(_,X,Y,_,_) <- move(X,Y).

+step(_) : searching(food) & food(X,Y,smell,_) <- move(X,Y).

// find food and eat it if we started eating
+step(_) : eating & food(_,_,my_pos,_) <- eat.

+step(_) : eating & food(X,Y,see,_) & not agent(_,X,Y,_,_) <- move(X,Y).

+step(_) : eating & food(X,Y,smell,_) <- move(X,Y).

// searching queen
@qf1[atomic]
+step(_) : searching(queen) <- !find_queen;
								-searching(queen);
								?queen(X,Y);
								?storage_size(S);
								!move_to(X-S,Y-S);
								+searching(storage).

+!find_queen: queen(_,_,my_pos) <- true.

+!find_queen: queen(X,Y,see) & not agent(_,X,Y,_,_) <- move(X,Y); !find_queen.

+!find_queen: queen(X,Y,see) & agent(_,X,Y,_,_) <- random_move; !find_queen.

+!find_queen: queen(X,Y,smell) <- move(X,Y); !find_queen.

+!find_queen: queen(X,Y) <- move(X,Y); !find_queen.

+!move_to(X,Y) : pos(_,X,Y) <- true.

+!move_to(X,Y) : pos(_,Xc,Yc) & (X == Xc & (Y-Yc == 1 | Y-Yc == -1)) & not agent(_,X,Y,_,_) <- move(X,Y); !move_to(X,Y).

+!move_to(X,Y) : pos(_,Xc,Yc) & (X == Xc & (Y-Yc == 1 | Y-Yc == -1)) & agent(_,X,Y,_,_) <- random_move; !move_to(X,Y).

+!move_to(X,Y) <- move(X,Y); !move_to(X,Y).

// searching free storage cell
@sf2[atomic]
+step(_) : searching(storage) & weight(W) & W == 0 & not no_storage <- +searching(food); -searching(storage).

+step(_) : searching(storage) & no_storage <- +eating.

@sf1[atomic]
+step(_) : searching(storage) <- !find_storage;
								  unload.
								  
+!find_storage: pos(_,X,Y) & not food_storage(X,Y) <- true.

+!find_storage <- next_food_storage; !find_storage.

// if subgoal failed...
-!find_storage <- .broadcast(tell, no_storage).

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

+no_storage <- -searching(storage); +eating.

+storage_available <- +searching(food); -eating.


