% Use this editor as a MiniZinc scratch book
include "table.mzn"; 
include "alldifferent.mzn";

int: min_energy; 
int: min_protein; 
int: max_salt; 
int: max_fat; 

int: nf; 
% number of foods 
set of int: FOODS = 1..nf; 
set of int: DAYS = 1..7; 
set of int: COURSE = 1..3; 
array[FOODS] of string: n;
array[DAYS] of string: d;
array[COURSE] of string: c; 

set of FOODS: desserts; 
set of FOODS: mains; 
set of FOODS: sides;


% food names 
array[FOODS,FEATURES] of int: dd; 


set of int: FEATURES = 1..6; 
int: name = 1; 
int: energy = 2; 
int: protein = 3; 
int: salt = 4; 
int: fat = 5; 
int: cost = 6;

% food database
array[FEATURES] of var int: main; 
array[FEATURES] of var int: side; 
array[FEATURES] of var int: dessert; 

var int: budget;

array[DAYS,COURSE] of var int: mainroutine;
array[DAYS,COURSE] of var int: sideroutine;
array[DAYS,COURSE] of var int: dessertroutine;

      
constraint 
  forall(i in DAYS)(
    forall(j in COURSE)(
      main[name] in mains
      /\
      side[name] in sides
      /\ 
      dessert[name] in desserts
      /\ 
      table(main, dd)
      /\ 
      table(side, dd)
      /\ 
      table(dessert, dd)
      /\
      mainroutine[i,j] = main[name]
      /\
      sideroutine[i,j] = side[name]
      /\
      dessertroutine[i,j] = dessert[name]
      /\
      main[energy] + side[energy] + dessert[energy] >=min_energy
      /\
      main[protein]+side[protein]+dessert[protein] >=min_protein
      /\
      main[salt] + side[salt] + dessert[salt] <= max_salt
      /\
      main[fat] + side[fat] + dessert[fat] <= max_fat
      /\
      main[cost] + side[cost] + dessert[cost] <= budget    
    )
   );

solve satisfy;

output [show(mainroutine),show(sideroutine),show(dessertroutine)];
