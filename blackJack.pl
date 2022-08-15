% incluindo o modulo de cartas
:- [cartas].

main:-
    iniciaJogo(MaoJogador,MaoDealer,Deck),
    write(MaoJogador),
    nl,
    write(MaoDealer),
    nl,
    write(Deck),
    nl,
    length(Deck, Len),
    write(Len).

lobby:-
    printBanca(100),
    pegaAposta(Aposta),
    write("Voce apostou "), write(Aposta), write(" fichas.").


pegaAposta(Aposta):-
    write("Quanto sera a proxima aposta? "),
    read(Entrada),
    (Entrada =< 0 -> nl, 
                    write("Aposta invalida!! Digite Novamente."),
                    nl,
                    pegaAposta(Aposta1),
                    Aposta is Aposta1;
    Aposta is Entrada
    ).
    
printBanca(N):-
    write("Voce tem "), write(N), write(" fichas.").

iniciaJogo(MaoJogador,MaoDealer,Deck5):-
    novoDeck(Deck),
    embaralha(Deck, Deck1),
    darCarta(Deck1, [], MaoJogador1, Deck2),
    darCarta(Deck2, [], MaoDealer1, Deck3),
    darCarta(Deck3, MaoJogador1, MaoJogador, Deck4),
    darCarta(Deck4, MaoDealer1, MaoDealer, Deck5).

temAs([carta('A',Naipe)|_], Flag):-
    carta('A',Naipe), 
    Flag = 'True',
    !.
temAs([], Flag):- Flag = 'False'.
temAs([_|T], Flag):-
    temAs(T, Flag1),
    Flag = Flag1.

temAsUsavel(Mao, Flag):- temAs(Mao,'True'),valor_Mao(Mao, V), V =< 11, Flag = 'True',!.
temAsUsavel(_,'False').

valor_Mao([], 0).
valor_Mao([H|T], ValorMao):-
   valor_Mao(T, ValorMao1),
   valorCarta(H, ValorCarta),
   ValorMao is ValorCarta + ValorMao1.

valores_Mao(Mao, [Val|[Val10]]):-
    temAsUsavel(Mao, 'True'),
    valor_Mao(Mao, Val),
    Val10 is Val + 10.
valores_Mao(Mao, [Val]):-
    valor_Mao(Mao, Val).

printPontuacao([V1|[]]):-
    write(V1).
printPontuacao([V1|[V2]]):-
    write(V1),
    write(" ou "),
    write(V2).

cls :- write('\33\[2J').