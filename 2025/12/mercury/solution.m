:- module solution.
:- interface.
:- import_module io.
:- import_module require.

:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module list, string, int.

main(!IO) :-
    io.command_line_arguments(Args, !IO),
    ( if Args = [InputFile, _Part] then
        io.read_named_file_as_lines(InputFile, Result, !IO),
        ( if Result = ok(Lines) then
            list.det_drop(30, Lines, PuzzleLines),
            Results = map(fits, PuzzleLines),
            list.foldl(sum, Results, 0, Sum),
            io.format("%d\n", [i(Sum)], !IO)
        else
            error("this won't happen")
        )
    else
        error("this won't happen")
    ).

:- pred sum(int::in, int::in, int::out) is det.
sum(X, Y, Result) :- Result = X + Y.

:- func fits(string) = int.
fits(Line) = Result :-
  ( if string.split_at_string(": ", Line) = [AreaStr, PieceStr] then
      Result = ( if area(AreaStr) >= piece_area(PieceStr) then 1 else 0 )
  else
      error("this won't happen")
  ).

:- func area(string) = int.
area(Str) = Result :-
  ( if 
      string.split_at_string("x", Str) = [XStr, YStr],
      string.to_int(XStr, X),
      string.to_int(YStr, Y)
  then
      Result = X * Y
  else
      error("this won't happen")
  ).

:- func piece_area(string) = int.
piece_area(Str) = Result :-
  ( if 
      string.split_at_string(" ", Str) = [AStr, BStr, CStr, DStr, EStr, FStr],
      string.to_int(AStr, A),
      string.to_int(BStr, B),
      string.to_int(CStr, C),
      string.to_int(DStr, D),
      string.to_int(EStr, E),
      string.to_int(FStr, F)
  then
      % Parsing is a young person's game
      Result = A * 5 + B * 7 + C * 7 + D * 7 + E * 7 + F * 7
  else
      error("this won't happen")
  ).
