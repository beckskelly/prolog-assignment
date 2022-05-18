flight(london,dublin,aerlingus,500,45,150).
flight(rome,london,ba,1500,150,400).
flight(rome,paris,airfrance,1200,120,500). 
flight(paris,dublin,airfrance,600,60,200).
flight(berlin,moscow,lufthansa,3000,300,900).
flight(paris,amsterdam,airfrance,400,30,100).
flight(berlin,dublin,lufthansa,1200,120,900).
flight(london,newyork,ba,5000,700,1100).
flight(dublin,newyork,aerlingus,4500,360,800).
flight(dublin,cork,ryanair,300,50,50).
flight(dublin,rome,ryanair,2000,150,70).
flight(dublin,chicago,aerlingus,5500,480,890).
flight(amsterdam,hongkong,klm,7000,660,750).
flight(london,hongkong,ba,7500,700,1000).
flight(dublin,amsterdam,ryanair,1000,90,60).
flight(moscow,newyork,aerflot,9000,720,1000).
flight(moscow,hongkong,aerflot,5500,420,500).
flight(newyork,chicago,aa,3000,240,430).
flight(dublin,london,aerlingus,500,45,150).
flight(london,rome,ba,1500,150,400).
flight(paris,rome,airfrance,1200,120,500). 
flight(dublin,paris,airfrance,600,60,200).
flight(moscow,berlin,lufthansa,3000,300,900).
flight(amsterdam,paris,airfrance,400,30,100).
flight(dublin,berlin,lufthansa,1200,120,900).
flight(newyork,london,ba,5000,700,1100).
flight(newyork,dublin,aerlingus,4500,360,800).
flight(cork,dublin,ryanair,300,50,50).
flight(rome,dublin,ryanair,2000,150,70).
flight(chicago,dublin,aerlingus,5500,480,890).
flight(hongkong,amsterdam,klm,7000,660,750).
flight(hongkong,london,ba,7500,700,1000).
flight(amsterdam,dublin,ryanair,1000,90,60).
flight(newyork,moscow,aerflot,9000,720,1000).
flight(hongkong,moscow,aerflot,5500,420,500).
flight(chicago,newyork,aa,3000,240,430).

country(dublin,ireland).
country(cork,ireland).
country(london,uk).
country(rome,italy).
country(moscow,russia).
country(hongkong,china).
country(amsterdam,holland).
country(berlin,germany).
country(paris,france).
country(newyork,usa).
country(chicago,usa).

%part1_question1
list_airport(X, L) :- findall(Y, country(Y, X), L).

%question2
trip(X,Y,P) :-  fly(X,Y,[],P).
fly(X,Y,V,[X,Y]) :- flight(X,Y,_,_,_,_), not(member(Y,V)).
fly(X,Y,V,[X|P]) :- flight(X,R,_,_,_,_), not(member(R,V)), fly(R,Y,[X|V],P).

%question3
all_trip(X,Y,T):- findall(P, trip(X,Y,P), T).

%question4
trip_dist(Dep,Arr,[Route,Dist]) :-  
	fly(Dep,Arr,[],Route,0,Dist).
fly(Dep,Arr,V,[Dep,Arr],AccDist,FinalDist) :- 
	flight(Dep,Arr,_,Dist,_,_), 
	not(member(Arr,V)),
	FinalDist is AccDist + Dist.
fly(Dep,Arr,V,[Dep|Route], AccDist, FinalDist) :- 
	flight(Dep,R,_,Dist,_,_), 
	not(member(R,V)),
	NewDist is AccDist + Dist,
	fly(R,Arr,[Dep|V],Route, NewDist, FinalDist).

%question5
trip_cost(Dep,Arr,[Route,Cost]) :-  
	fly2(Dep,Arr,[],Route,0,Cost).
fly2(Dep,Arr,V,[Dep,Arr],AccCost,FinalCost) :- 
	flight(Dep,Arr,_,_,_,Cost), 
	not(member(Arr,V)),
	FinalCost is AccCost + Cost.
fly2(Dep,Arr,V,[Dep|Route], AccCost, FinalCost) :- 
	flight(Dep,R,_,_,_,Cost), 
	not(member(R,V)),
	NewCost is AccCost + Cost,
	fly2(R,Arr,[Dep|V],Route, NewCost, FinalCost).
	
%question6
trip_change(X,Y,[P,I]) :-  fly(X,Y,[],P), length(P,L), I is L-2 .

%question7
noairline(X,Y,T,R) :- fly_noairline(X,Y,[],T,R).
fly_noairline(X,Y,T,[X,Y],R) :- flight(X,Y,S,_,_,_), not(member(Y,T)), S\=R.
fly_noairline(X,Y,T,[X|C],R) :- flight(X,A,S,_,_,_), not(member(A,T)), fly_noairline(A,Y,[X|T],C,R), S\=R.
alltrip_noairline(X,Y,T,R) :- findall(A, noairline(X,Y,A,R),T).

%question8
shortest(Dep,Arr,Route,LowestDist) :- findall(Dist, trip_dist(Dep,Arr,[_,Dist]), List), 
									min_list(List,LowestDist), 
									trip_dist(Dep,Arr,[Route,LowestDist]).


cheapest(Dep,Arr,Route,Cheapest) :- findall(Cost, trip_cost(Dep,Arr,[_,Cost]), List),
									min_list(List,Cheapest), 
									trip_cost(Dep,Arr,[Route,Cheapest]).
									
trip_time(Dep,Arr,[Route,Time]) :-  
	fly3(Dep,Arr,[],Route,0,Time).
fly3(Dep,Arr,V,[Dep,Arr],AccTime,FinalTime) :- 
	flight(Dep,Arr,_,_,Time,_), 
	not(member(Arr,V)),
	FinalTime is AccTime + Time.
fly3(Dep,Arr,V,[Dep|Route], AccTime, FinalTime) :- 
	flight(Dep,R,_,_,Time,_), 
	not(member(R,V)),
	NewTime is AccTime + Time,
	fly3(R,Arr,[Dep|V],Route, NewTime, FinalTime).
	
fastest(Dep,Arr,Route,Fastest) :- findall(Time, trip_time(Dep,Arr,[_,Time]), List),
								  min_list(List,Fastest), 
								  trip_time(Dep,Arr,[Route,Fastest]).

%question9
trip_to_nation(X,Y,T) :-
			country(W,Y),
			trip(X,W,T),
			country(Q,Y),
			W\=Q,
			not(member(Q,T)).

%question10
all_trip_to_nation(X,Y,L) :- findall(T, trip_to_nation(X,Y,T), L).