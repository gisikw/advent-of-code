% solution.pl

% Entry point
start(FilePath, Part) :-
    read_file_lines(FilePath, Lines),
    length(Lines, LinesCount),
    format('Received ~w lines of input for part ~w~n', [LinesCount, Part]),
    halt.

% Read all lines from a file into a list
read_file_lines(FilePath, Lines) :-
    setup_call_cleanup(
        open(FilePath, read, Stream),
        read_lines(Stream, Lines),
        close(Stream)
    ).

% Read lines from a stream into a list
read_lines(Stream, Lines) :-
    read_line_to_string(Stream, Line),
    (   Line \= end_of_file
    ->  Lines = [Line|RestLines],
        read_lines(Stream, RestLines)
    ;   Lines = []
    ).

% Start the program with arguments
:- current_prolog_flag(argv, [FilePath, PartAtom]),
   atom_number(PartAtom, Part),
   start(FilePath, Part).
