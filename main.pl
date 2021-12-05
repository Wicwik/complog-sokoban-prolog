process_file(File, S0, G):-
    open(File, read, Fd),
    Pos is 1,
    read_file(Fd, S0, [], Pos, NewCurrentPos),
    write(NewCurrentPos).

read_file(Fd, _, _, Pos, Pos):-
    at_end_of_stream(Fd).

read_file(Fd, S0, Map, Pos, NewCurrentPos):-
    \+ at_end_of_stream(Fd),

    get_char(Fd, C),
    process_char(C, S0, Map, NewMap),
    CurrentPos is Pos + 1,
    read_file(Fd, S0, NewMap, CurrentPos, NewCurrentPos).

process_char('#', _, CurrentMap, NewMap):-
    append(CurrentMap, ['#'], NewMap),
    write('#').

process_char('\n',_,_,_):-
    write('\n').

process_char(' ',_,_,_):-
    write(' ').

process_char('C',_,_,_):-
    write('C').

process_char('X',_,_,_):-
    write('X').

process_char('S', _, CurrentMap, NewMap):-
    append(CurrentMap, ['S'], NewMap),
    write('S').
