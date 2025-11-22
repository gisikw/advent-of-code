:- module solution.
:- interface.
:- import_module io.

:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module list, string, int.

main(!IO) :-
    io.command_line_arguments(Args, !IO),
    ( if Args = [InputFile, Part] then
        io.read_named_file_as_lines(InputFile, Result, !IO),
        ( if Result = ok(Lines) then
            LinesCount = length(Lines),
            io.format("Received %d lines of input for part %s\n",
                [i(LinesCount), s(Part)], !IO)
        else
            io.write_string("Error reading file\n", !IO)
        )
    else
        io.write_string("Usage: solution <input_file> <part>\n", !IO)
    ).
