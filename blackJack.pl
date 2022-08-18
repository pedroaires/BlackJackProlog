% incluindo o modulo de cartas
:- [cartas].

main:-
    lobby(100,'s').

jogo(Aposta, TagResult):-
    iniciaJogo(MaoJ,MaoD,Deck),
    naoTeveBlackJack(MaoJ,MaoD,TagBJ),
    nl,write(TagBJ), nl,
    rodadaJogador(Deck, MaoJ, MaoD, Deck1, MaoJ1, Aposta, TagBJ),
    rodadaDealer(Deck1, MaoD, Deck2, MaoD1, TagBJ),
    visaoDaMesa(MaoJ1, MaoD1, Aposta, 'Show'),
    resultado(MaoJ1, MaoD1, TagResult),
    !.

lobby(Banca,'s'):-
    cls,
    printBanca(Banca),
    pegaAposta(Aposta),
    jogo(Aposta, TagResult),
    calculoSaldo(Aposta, TagResult, Saldo),
    imprimeResultado(Saldo, TagResult),
    Banca1 is Banca + Saldo,
    desejaContinuar(Resposta),
    lobby(Banca1, Resposta).

lobby(Banca,'n'):-
    cls,
    write('O jogo acabou!'),
    nl,
    write('Voce terminou com '), write(Banca), write(' Fichas').

calculoSaldo(Aposta, 'D', -Aposta).
calculoSaldo(Aposta, 'J', Aposta).
calculoSaldo(_, 'E', 0).
calculoSaldo(Aposta, 'D/BJ', -Aposta).
calculoSaldo(Aposta, 'J/BJ', Saldo):-
    Saldo is ceiling(Aposta * rational(1.5)).

% Tags de reultado:
% 'D' = Dealer ganhou simples
% 'J' = Jogador ganhou simples
% 'E' = Empate (Push)
% 'D/BJ' = Dealer ganhou Blackjack
% 'J/BJ' = Jogador ganhou Blackjack
resultado(MaoJ, MaoD, 'D/BJ'):-
    maoEhBlackjack(MaoD),
    \+ maoEhBlackjack(MaoJ),
    !.
resultado(MaoJ, MaoD, 'J/BJ'):-
    \+ maoEhBlackjack(MaoD),
    maoEhBlackjack(MaoJ),
    !.
resultado(MaoJ, MaoD, 'E'):-
    maoEhBlackjack(MaoD),
    maoEhBlackjack(MaoJ),
    !.
resultado(MaoJ, MaoD, 'E'):-
    maoValida(MaoJ),
    melhorValor(MaoD, ValorD),
    melhorValor(MaoJ, ValorJ),
    ValorD =:= ValorJ,
    !.
resultado(MaoJ, MaoD, 'D'):- % Se o jogador estourou o dealer ganha direto
    \+ maoValida(MaoJ),
    !.
resultado(MaoJ, MaoD, 'J'):- % Se o jogador estourou o dealer ganha direto
    maoValida(MaoJ),
    \+ maoValida(MaoD),
    !.
resultado(MaoJ, MaoD, Tag):- % se ambas forem válidas, ganha o maior valor
    maoValida(MaoD),
    maoValida(MaoJ),
    melhorValor(MaoD, ValorD),
    melhorValor(MaoJ, ValorJ),
    (ValorJ > ValorD -> Tag = 'J';
    (ValorD > ValorJ -> Tag = 'D';
     Tag = 'E')),
    !.

imprimeResultado(Saldo, 'J/BJ'):-
    write('Blackjack!!'),
    nl,
    write('Voce ganhou '), write(Saldo), write(' Fichas!').
imprimeResultado(Saldo, 'D/BJ'):-
    SaldoAbs is abs(Saldo),
    write('O dealer fez blackjack...'),
    nl,
    write('Voce perdeu '), write(SaldoAbs), write(' Fichas!').
imprimeResultado(Saldo, 'J'):-
    write('Voce ganhou!!'),
    nl,
    write('Voce ganhou '), write(Saldo), write(' Fichas!').
imprimeResultado(Saldo, 'D'):-
    SaldoAbs is abs(Saldo),
    write('O dealer ganhou...'),
    nl,
    write('Voce perdeu '), write(SaldoAbs), write(' Fichas!').
imprimeResultado(_, 'E'):-
    write('A mao foi empate!'),
    nl,
    write('Ninguem ganhou nada').

desejaContinuar(Resposta):-
    nl,
    write("Deseja continuar jogando? (s)im ou (n)ao: "),
    read(Entrada),
    validaResposta(Entrada, Resposta).

validaResposta('n', 'n').
validaResposta('s', 's').    
validaResposta(Entrada, Resposta):-
    Entrada \= 'n',
    Entrada \= 's',
    write("Entrada invalida!! Digite Novamente."),
    desejaContinuar(Resposta).


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

dealerUpcardEhAs([carta('A', _)|_], 'True'):-!.
dealerUpcardEhAs([_|_], 'False').

iniciaJogo(MaoJogador,MaoDealer,Deck5):-
    novoDeck(Deck),
    embaralha(Deck, Deck1),
    darCarta(Deck1, [], MaoJogador1, Deck2),
    darCarta(Deck2, [], MaoDealer1, Deck3),
    darCarta(Deck3, MaoJogador1, MaoJogador, Deck4),
    darCarta(Deck4, MaoDealer1, MaoDealer, Deck5).

visaoDaMesa(MaoJogador, MaoDealer, Aposta, 'Show'):-
    nl,
    write("Aposta: "),
    write(Aposta),
    nl,
    write("Sua Mao: "),
    imprimeMao(MaoJogador),
    write(" "), printPontuacaoFinal(MaoJogador),
    nl,
    write("Mao do Dealer: "),
    imprimeMao(MaoDealer),
    write(" "), printPontuacaoFinal(MaoDealer),
    nl,
    !.
visaoDaMesa(MaoJogador, [Show|_], Aposta, 'Hide'):-
    nl,
    valores_Mao(MaoJogador, ValoresJ),
    write("Aposta: "),
    write(Aposta),
    nl,
    write("Sua Mao: "),
    imprimeMao(MaoJogador),
    write(" "), printPontuacaoParcial(ValoresJ),
    nl,
    write("Mao do Dealer: "),
    imprimeCarta(Show),
    write(", * de *"),
    nl,
    !.


rodadaDealer(Deck, MaoD, Deck, MaoD, 'False').
rodadaDealer(Deck, MaoDealer, DeckAtualizado, MaoDealerAtualizada, 'True'):-
    decideJogadaDealer(MaoDealer, Jogada),
    fazJogada(Jogada, Deck, MaoDealer, Deck1, MaoDealer1),
    continua(Jogada, MaoDealer1, Flag),
    rodadaDealer(Deck1, MaoDealer1, DeckAtualizado, MaoDealerAtualizada, Flag).

decideJogadaDealer(MaoDealer, Jogada):-
    melhorValor(MaoDealer, Valor),
    decideJogadaD(Valor, Jogada).
decideJogadaD(Valor, 's'):-
    Valor >= 17.
decideJogadaD(Valor, 'h'):-
    Valor < 17.


rodadaJogador(Deck, MaoJ, _, Deck, MaoJ, _, 'False').
rodadaJogador(Deck, MaoJogador, MaoD, DeckAtualizado, MaoJogadorAtualizada, Aposta, 'True'):-
    visaoDaMesa(MaoJogador, MaoD, Aposta, 'Hide'),
    decideJogadaJogador(Jogada),
    fazJogada(Jogada, Deck, MaoJogador, Deck1, MaoJogador1),
    continua(Jogada, MaoJogador1, Flag),
    rodadaJogador(Deck1, MaoJogador1, MaoD, DeckAtualizado, MaoJogadorAtualizada, Aposta, Flag).

fazJogada('h', Deck, MaoJogador, DeckAtualizado, MaoJogadorAtualizada):-
    darCarta(Deck, MaoJogador, MaoJogadorAtualizada, DeckAtualizado).
fazJogada('s', Deck, MaoJogador, Deck, MaoJogador).

continua('s', _, 'False'):-!.
continua(_, Mao, 'False'):-
    valor_Mao(Mao, Valor),
    Valor >= 21,
    !.
continua('h', _, 'True'):-!.
continua(Entrada, _, 'True'):-
    Entrada \= 'h',
    Entrada \= 's',
    write("Ocorreu algum erro!").

decideJogadaJogador(Jogada):-
    write("(h)it ou (s)tand? "),
    read(Entrada),
    validaJogada(Entrada, Jogada).

validaJogada('h', 'h').
validaJogada('s', 's').    
validaJogada(Entrada, Jogada):-
    Entrada \= 'h',
    Entrada \= 's',
    write("Jogada invalida!! Digite Novamente."),
    decideJogadaJogador(Jogada).

temAs([carta('A',Naipe)|_], 'True'):-
    carta('A',Naipe).
temAs([], 'False').
temAs([_|T], Flag):-
    temAs(T, Flag).

temAsUsavel(Mao, 'True'):- 
    temAs(Mao,'True'),
    valor_Mao(Mao, V), 
    V =< 11,!.
temAsUsavel(_,'False').

valor_Mao([], 0).
valor_Mao([H|T], ValorMao):-
   valor_Mao(T, ValorMao1),
   valorCarta(H, ValorCarta),
   ValorMao is ValorCarta + ValorMao1.

valores_Mao(Mao, [Val,Val2|[]]):- % Se tem um As usavel, a mao tem dois valores possíveis
    temAsUsavel(Mao, 'True'),
    valor_Mao(Mao, Val),
    Val2 is Val + 10.
valores_Mao(Mao, [Val]):-
    valor_Mao(Mao, Val).

printPontuacaoParcial([V1|[]]):-
    write("total: "), write(V1).
printPontuacaoParcial([V1,V2|[]]):-
    write("total: "),
    write(V1),
    write(" ou "),
    write(V2).

printPontuacaoFinal(Mao):-
    melhorValor(Mao, Valor),
    write("total: "), write(Valor).


melhorValor(Mao, Valor):-
    valores_Mao(Mao,Valores),
    melhorValorAux(Valores,Valor).

melhorValorAux([V1|[]], V1).
melhorValorAux([_,V2|[]], V2).

maoValida(Mao):-
    melhorValor(Mao, Valor),
    Valor =< 21.

maoEhBlackjack(Mao):-
    temAs(Mao,'True'),
    melhorValor(Mao, 21),
    length(Mao, 2),
    !.
naoTeveBlackJack(MaoJ, MaoD, 'False'):-
    maoEhBlackjack(MaoJ);
    maoEhBlackjack(MaoD),
    !.
naoTeveBlackJack(_, _, 'True').

cls :- write('\33\[2J').