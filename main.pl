main:-
    process_file('map4.txt', S0, G),

    write('S0 = '),
    writeln(S0),

    write('G = '),
    writeln(G).

process_file(File, S0, G):-
    open(File, read, Fd),
    get_map_width(Fd, Width),

    writeln('Current map:'),
    seek(Fd, 0, bof, _),
    read_file(Fd, [], Map),
    seen(),
    
    write('\n\n'),
    %% writeln(Map),
    %% writeln(Width),

    get_S0(0, Width, Map, [], S0),
    get_G(S0, G).

read_file(Fd, Map, Map):-
    at_end_of_stream(Fd).

read_file(Fd, Map, FinalMap):-
    \+ at_end_of_stream(Fd),

    get_char(Fd, C),
    process_char(C, Map, NewMap),
    read_file(Fd, NewMap, FinalMap).

process_char('#', Map, NewMap):-
    append(Map, ['#'], NewMap),
    write('#').

process_char('\n', Map, Map):-
    write('\n').

process_char(' ', Map, NewMap):-
    append(Map, [' '], NewMap),
    write(' ').

process_char('C' ,Map, NewMap):-
    append(Map, ['C'], NewMap),
    write('C').

process_char('c' ,Map, NewMap):-
    append(Map, ['c'], NewMap),
    write('c').

process_char('X', Map, NewMap):-
    append(Map, ['X'], NewMap),
    write('X').

process_char('S', Map, NewMap):-
    append(Map, ['S'], NewMap),
    write('S').

process_char('s', Map, NewMap):-
    append(Map, ['s'], NewMap),
    write('s').

get_map_width(Fd, Width):-
    read_line_to_codes(Fd,Line),
    length(Line,Width).


get_S0(Pos, _, Map, S0, S0):-
    length(Map, MapSize),
    Pos is MapSize.

get_S0(Pos, Width, Map, S0, NewS0):-
    get_next_right(Pos, Map, S0, NewRightS0),
    get_next_left(Pos, Map, NewRightS0, NewLeftS0),
    get_next_up(Pos, Width, Map, NewLeftS0, NewUpS0),
    get_next_down(Pos, Width, Map, NewUpS0, NewDownS0),

    get_free(Pos, Map, NewDownS0, NewFreeS0),
    get_crate(Pos, Map, NewFreeS0, NewCS0),
    get_sokoban(Pos, Map, NewCS0, NewSS0),
    get_x(Pos, Map, NewSS0, NewXS0),

    NewPos is Pos + 1,
    get_S0(NewPos, Width, Map, NewXS0, NewS0),!.

get_free(Pos, Map, S0, NewS0):-
    nth0(Pos, Map, C),
    C \== '#',
    C \== 'C',
    C \== 'c',
    C \== 'S',
    C \== 's',

    append(S0, [free(Pos)], NewS0),!.

get_free(_, _, S0, S0).

get_next_right(Pos, Map, S0, NewS0):-
    nth0(Pos, Map, C),
    C \== '#',

    NextPos is Pos + 1,
    nth0(NextPos, Map, NextC),
    NextC \== '#',

    \+ member(next(Pos, NextPos), S0),
    \+ member(next(NextPos, Pos), S0),

    append(S0, [next(Pos, NextPos)], NewS0),!.

get_next_right(_, _, S0, S0).

get_next_left(Pos, Map, S0, NewS0):-
    nth0(Pos, Map, C),
    C \== '#',

    NextPos is Pos - 1,
    nth0(NextPos, Map, NextC),
    NextC \== '#',

    \+ member(next(Pos, NextPos), S0),
    \+ member(next(NextPos, Pos), S0),

    append(S0, [next(Pos, NextPos)], NewS0),!.

get_next_left(_, _, S0, S0).

get_next_up(Pos, Width, Map, S0, NewS0):-
    nth0(Pos ,Map, C),
    C \== '#',

    NextPos is Pos - Width,
    nth0(NextPos, Map, NextC),
    NextC \== '#',

    \+ member(next(Pos, NextPos), S0),
    \+ member(next(NextPos, Pos), S0),


    append(S0, [next(Pos, NextPos)], NewS0),!.

get_next_up(_, _, _, S0, S0).

get_next_down(Pos, Width, Map, S0, NewS0):-
    nth0(Pos, Map, C),
    C \== '#',

    NextPos is Pos + Width,
    nth0(NextPos, Map, NextC),
    NextC \== '#',

    \+ member(next(Pos, NextPos), S0),
    \+ member(next(NextPos, Pos), S0),

    append(S0, [next(Pos, NextPos)], NewS0),!.

get_next_down(_, _, _, S0, S0).


get_crate(Pos, Map, S0, NewS0):-
    nth0(Pos, Map, C),
    C == 'C',

    \+ member(at(C, Pos), S0),
    append(S0, [at(C, Pos)], NewS0),!.

get_crate(Pos, Map, S0, NewS0):-
    nth0(Pos, Map, C),
    C == 'c',

    \+ member(at('C', Pos), S0),
    \+ member(at('X', Pos), S0),

    append(S0, [at('C', Pos)], NewCS0),
    append(NewCS0, [at('X', Pos)], NewS0),!.

get_crate(_, _, S0, S0).

get_sokoban(Pos, Map, S0, NewS0):-
    nth0(Pos, Map, C),
    C == 'S',

    \+ member(at(C, Pos), S0),
    append(S0, [at(C, Pos)], NewS0),!.

get_sokoban(Pos, Map, S0, NewS0):-
    nth0(Pos, Map, C),
    C == 's',

    \+ member(at('S', Pos), S0),
    \+ member(at('X', Pos), S0),

    append(S0, [at('S', Pos)], NewSS0),
    append(NewSS0, [at('X', Pos)], NewS0),!.

get_sokoban(_, _, S0, S0).

get_x(Pos, Map, S0, NewS0):-
    nth0(Pos, Map, C),
    C == 'X',

    \+ member(at(C, Pos), S0),
    append(S0, [at(C, Pos)], NewS0),!.

get_x(_, _, S0, S0).

get_pos(at(_,X),X).

get_G(S0,G):-
    delete_list([at('X',_)],S0,Del),
    subtract(S0, Del, Xs),
    c_to_x(Xs,G).

c_to_x([],[]).
c_to_x([X|Xs],Cs):- get_pos(X, Y), append(Ys, [at('c',Y)], Cs), c_to_x(Xs, Ys),!.

is_subset([],_).
is_subset([X|Xs], Ys):- member(X, Ys), is_subset(Xs, Ys).

delete_list([],Xs,Xs).
delete_list([X|Xs], Ys, Zs):- delete(Ys, X, As), delete_list(Xs, As, Zs).