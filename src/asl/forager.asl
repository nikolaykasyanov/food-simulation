// Agent forager in project FoodSimulation.mas2j

/* Initial beliefs and rules */

// assume queen's position
queen(10,10).

/* Initial goals */

!start.

/* Plans */

+!start : true <- .print("hello world.").

