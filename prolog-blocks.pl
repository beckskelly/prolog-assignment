% There are some messy letter blocks on the floor (8 in total). The blocks can only be stacked in three 
% different places on the floor. You have to program a set of PROLOG predicates for a robot working with 
% the blocks. Each pile is a list of element where the element on the left is the one on the ground. The 
% status of your blocks is identified by a list containing three lists, one for each stack of blocks.


%part2_question1 Print the status of the blocks

list_bars([]):- write('|'). 
list_bars([X|R]):- write('|'),write(X),list_bars(R).

print_status([]). 
print_status([X|R]):- list_bars(X),nl,print_status(R).

%question2
% You are required to produce a predicate high(X,H) where B describes the three piles of blocks, X is 
% a block and H is the height of the block from the ground. A block directly on the ground has height 
% equal to zero

count_blocks(C,R) :- maplist(length, C,R).

find_index([X|_],X,0).
find_index([_|T],X,H) :- find_index(T,X,H1), H is H1 + 1.

high([Head|_],X,H) :- find_index(Head,X,H).
high([_|Tail],X,H) :- high(Tail,X,H).


%question3
% Write a PROLOG predicate that returns a list of all the blocks at a specific heights (from all the 3 stacks). 

all_same_height(B,H,L):- findall(X, high(B,X,H),L).

%question4
% Write a PROLOG predicate same_height(B,X,Y) that is true if block X and block Y have the same height

same_height(L,X,Y):-
    find_height(L,X,N),
    find_height(L,Y,N).

find_height(A,E,N):-
    member(L,A),
    nth0(N,L,E).

%question5
% Write a PROLOG predicate moveblock(B,X,S1,S2) to move a block from the stack S1 to the 
% stack S2. S1 and S2 are integer numbers identifying one of the three stacks (1,2 or 3). A block can 
% be moved only if it is at the top of a stack (otherwise it cannot be moved) and it can be only placed on 
% top of another stack (or on the ground if the stack is empty). The predicate has to print the status of 
% the blocks before and after the move (only if the block can be moved!). 

check_last(X,[X]).
check_last(X,[_|Z]) :- check_last(X,Z).

move(L, X, F, T) :- 
          write('before'),nl,
          print_status(L),
          nth1(F, L, Lf),
          nth1(T, L, Lt),
		  check_last(X,Lf),
		  delete(Lf, X, Rf),
		  append(Lt, [X], Rt),
		  select(Lf, L, Rf, NewB),
		  select(Lt, NewB, Rt,NewC),
		  nl,
		  write('after'),nl,
		  		  print_status(NewC).
