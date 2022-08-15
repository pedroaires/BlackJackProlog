carta('A', paus).
carta('2', paus).
carta('3', paus).
carta('4', paus).
carta('5', paus).
carta('6', paus).
carta('7', paus).
carta('8', paus).
carta('9', paus).
carta('10',paus).
carta('J', paus).
carta('Q', paus).
carta('K', paus).

carta('A', copas).
carta('2', copas).
carta('3', copas).
carta('4', copas).
carta('5', copas).
carta('6', copas).
carta('7', copas).
carta('8', copas).
carta('9', copas).
carta('10',copas).
carta('J', copas).
carta('Q', copas).
carta('K', copas).

carta('A', espadas).
carta('2', espadas).
carta('3', espadas).
carta('4', espadas).
carta('5', espadas).
carta('6', espadas).
carta('7', espadas).
carta('8', espadas).
carta('9', espadas).
carta('10',espadas).
carta('J', espadas).
carta('Q', espadas).
carta('K', espadas).

carta('A', ouro).
carta('2', ouro).
carta('3', ouro).
carta('4', ouro).
carta('5', ouro).
carta('6', ouro).
carta('7', ouro).
carta('8', ouro).
carta('9', ouro).
carta('10',ouro).
carta('J', ouro).
carta('Q', ouro).
carta('K', ouro).


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


imprimeCarta(carta(Figura, Naipe)):-
    write(Figura),
    write(' de '),
    write(Naipe).

imprimeMao([]).
imprimeMao([H|T]):-
    imprimeCarta(H),
    write(", "),
    imprimeMao(T).

novoDeck(Deck):-
    findall(carta(F,N), carta(F,N), Deck).

embaralha(Deck, NovoDeck):-
    system:random_permutation(Deck, NovoDeck).

darCarta([HDeck|TDeck],CartasP,[HDeck|CartasP] ,TDeck).

teste:- 
    novoDeck(Deck),
    embaralha(Deck, DeckAtualizado),
    darCarta(DeckAtualizado,[] , Participante, [H|_]),
    imprimeCarta(H).