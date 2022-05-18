%part2_question1
list_bars([]):- write('|'). 
list_bars([X|R]):- write('|'),write(X),list_bars(R).

print_status([]). 
print_status([X|R]):- list_bars(X),nl,print_status(R).

%question2
count_blocks(C,R) :- maplist(length, C,R).


%question3
find_index([X|_],X,0).
find_index([_|T],X,H) :- find_index(T,X,H1), H is H1 + 1.

high([Head|_],X,H) :- find_index(Head,X,H).
high([_|Tail],X,H) :- high(Tail,X,H).


%question3
all_same_height(B,H,L):- findall(X, high(B,X,H),L).

%question4
same_height(L,X,Y):-
    find_height(L,X,N),
    find_height(L,Y,N).

find_height(A,E,N):-
    member(L,A),
    nth0(N,L,E).

%question5
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