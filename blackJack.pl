% incluindo o modulo de cartas
:- [cartas].

main:-
    MaoComAs = [carta('A',c),carta('2',h),carta('3',h),carta('2',h),carta('3',h)],
    MaoSemAs = [carta('2',c),carta('3',c),carta('4',c),carta('5',c),carta('2',c)],
    MaoComAsUsavel = [carta('A',d),carta('9',h),carta('A',s)],
    MaoComAsNaoUsavel = [carta('K',d),carta('4',c),carta('A',c)],
    valores_Mao(MaoComAs, V1),
    valores_Mao(MaoSemAs, V2),
    valores_Mao(MaoComAsUsavel, V3),
    valores_Mao(MaoComAsNaoUsavel, V4),
    printPontuacao(V1),
    nl,
    printPontuacao(V2),
    nl,
    printPontuacao(V3),
    nl,
    printPontuacao(V4).

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

