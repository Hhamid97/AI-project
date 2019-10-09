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

array[FOODS] of string: n;
array[FOODS] of int: e;
array[FOODS] of int: p;
array[FOODS] of int: s;
array[FOODS] of int: f;
array[FOODS] of int: c;  
    
set of int: DAYS = 1..7; 
set of int: COURSE = 1..3; 
array[DAYS] of string: day;
array[COURSE] of string: course; 

set of FOODS: desserts; 
set of FOODS: mains; 
set of FOODS: sides;

var int: budget;

array[DAYS,COURSE] of var int: mainroutine;
array[DAYS,COURSE] of var int: sideroutine;
array[DAYS,COURSE] of var int: dessertroutine;

      
constraint 
  forall(i in DAYS)(
    forall(j in COURSE)(
      mainroutine[i,j] in mains
      /\
      sideroutine[i,j] in sides
      /\ 
      dessertroutine[i,j] in desserts
      /\ 
      e[mainroutine[i,j]] + e[sideroutine[i,j]] + e[dessertroutine[i,j]] >=min_energy
      /\
      p[mainroutine[i,j]]+p[sideroutine[i,j]]+p[dessertroutine[i,j]] >=min_protein
      /\
      s[mainroutine[i,j]] + s[sideroutine[i,j]] + s[dessertroutine[i,j]] <= max_salt
      /\
      f[mainroutine[i,j]] + f[sideroutine[i,j]] + f[dessertroutine[i,j]] <= max_fat
      /\
      c[mainroutine[i,j]] + c[sideroutine[i,j]] + c[dessertroutine[i,j]] <= budget   
    )
   );

constraint forall(i in 1..7)(
              (alldifferent(j in 1..3)(dessertroutine[i,j]))/\ 
              (alldifferent(j in 1..3)(sideroutine[i,j]))/\ 
              (alldifferent(j in 1..3)(mainroutine[i,j]))              
              ); 
constraint forall(i in 1..6)(
                forall(j in 1..3)(
                  dessertroutine[i,j] != dessertroutine[i+1,j]/\
                  sideroutine[i,j] != sideroutine[i+1,j]/\
                  mainroutine[i,j] != mainroutine[i+1,j]
                )              
              ); 

solve satisfy;


output [if j==1 then day[fix(i)] else " " endif ++"::"++course[fix(j)] ++ ": Main:"++n[fix(mainroutine[i,j])] ++", Side:"++n[fix(sideroutine[i,j])] ++", Dessert:"++n[fix(dessertroutine[i,j])] ++ if j==3 then "\n" else " " endif | i in DAYS, j in COURSE ];

%output [ name[fix(roster[i,j])] ++ if j==num_days then "\n" else " " endif | i in NURSES, j in DAYS ];

%output [show(mainroutine),show(sideroutine),show(dessertroutine)];
