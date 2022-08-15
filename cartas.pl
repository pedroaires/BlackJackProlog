carta('A',c).
carta('2',c).
carta('3',c).
carta('4',c).
carta('5',c).
carta('6',c).
carta('7',c).
carta('8',c).
carta('9',c).
carta('10',c).
carta('J',c).
carta('Q',c).
carta('K',c).

carta('A',h).
carta('2',h).
carta('3',h).
carta('4',h).
carta('5',h).
carta('6',h).
carta('7',h).
carta('8',h).
carta('9',h).
carta('10',h).
carta('J',h).
carta('Q',h).
carta('K',h).

carta('A',s).
carta('2',s).
carta('3',s).
carta('4',s).
carta('5',s).
carta('6',s).
carta('7',s).
carta('8',s).
carta('9',s).
carta('10',s).
carta('J',s).
carta('Q',s).
carta('K',s).

carta('A',d).
carta('2',d).
carta('3',d).
carta('4',d).
carta('5',d).
carta('6',d).
carta('7',d).
carta('8',d).
carta('9',d).
carta('10',d).
carta('J',d).
carta('Q',d).
carta('K',d).


valorCarta(carta('K', Naipe), 10)  :- carta('K', Naipe).
valorCarta(carta('Q', Naipe), 10)  :- carta('Q', Naipe).
valorCarta(carta('J', Naipe), 10)  :- carta('J', Naipe).
valorCarta(carta('A', Naipe), 1)   :- carta('A', Naipe).
valorCarta(carta('2', Naipe), 2)   :- carta('2', Naipe).
valorCarta(carta('3', Naipe), 3)   :- carta('3', Naipe).
valorCarta(carta('4', Naipe), 4)   :- carta('4', Naipe).
valorCarta(carta('5', Naipe), 5)   :- carta('5', Naipe).
valorCarta(carta('6', Naipe), 6)   :- carta('6', Naipe).
valorCarta(carta('7', Naipe), 7)   :- carta('7', Naipe).
valorCarta(carta('8', Naipe), 8)   :- carta('8', Naipe).
valorCarta(carta('9', Naipe), 9)   :- carta('9', Naipe).
valorCarta(carta('10',Naipe), 10)  :- carta('10',Naipe).

novoDeck(Deck):-
    findall(carta(F,N), carta(F,N), Deck).

embaralha(Deck, NovoDeck):-
    system:random_permutation(Deck, NovoDeck).

darCarta([HDeck|TDeck],CartasP,[HDeck|CartasP] ,TDeck).

teste:- 
    novoDeck(Deck),
    embaralha(Deck, DeckAtualizado),
    darCarta(DeckAtualizado,[] , Participante, DeckAtualizado1),
    write(DeckAtualizado),
    nl,
    write(DeckAtualizado1),
    nl,
    write(Participante).