% solution.pl

% Entry point
start(FilePath, Part) :-
  read_file_lines(FilePath, Lines),
  answer(Part, Lines, AnswerString),
  format('~w~n', [AnswerString]),
  halt.

answer(Part, Lines, AnswerString) :-
  (Part = 1 -> answer_part_1(AnswerString, Lines); answer_part_2(AnswerString, Lines)).

answer_part_1(AnswerString, Lines) :- 
  card_scores(Lines, Scores),
  sum_list(Scores, Sum),
  AnswerString = Sum.

card_scores([], []).
card_scores(Lines, Scores) :-
  Lines = [Line|RestLines],
  Scores = [Score|RestScores],
  card_score(Line, Score),
  card_scores(RestLines, RestScores).

card_score(Line, Score) :- 
  split_string(Line, ":", " ", [_|NumberStringTail]),
  [NumberString] = NumberStringTail,
  split_string(NumberString, "|", " ", [WinningString|HaveStringTail]),
  [HaveString] = HaveStringTail,
  split_string(WinningString, " ", " ", WinningNumbers),
  split_string(HaveString, " ", " ", CardNumbers),
  score_nums(Score, CardNumbers, WinningNumbers).

score_nums(Score, [Num], WinningNumbers) :-
  (member(Num, WinningNumbers) -> Score = 1; Score = 0).

score_nums(Score, [Num|Rest], WinningNumbers) :-
  score_nums(Subscore, Rest, WinningNumbers),
  (   member(Num, WinningNumbers)
  ->  (Subscore = 0 -> Score = 1; Score = Subscore * 2)
  ;   Score = Subscore
  ).

answer_part_2(AnswerString, Lines) :-
  build_top_level_indices(Lines, 0, AllIndices),
  assertz(reward(0, AllIndices)),
  build_rewards(Lines, 1),
  recursive_reward_count(0, AllRewards),
  AllRewardsExceptFakeStartCard is AllRewards - 1,
  AnswerString = AllRewardsExceptFakeStartCard.

build_top_level_indices([], _, Indices) :- Indices = [].
build_top_level_indices([_|Rest], Index, Indices) :-
  NextIndex is Index + 1,
  build_top_level_indices(Rest, NextIndex, NextIndices),
  Indices = [NextIndex | NextIndices].

recursive_reward_count(Index, Sum) :-
  reward(Index, Children),
  length(Children, ChildLen),
  (   ChildLen = 0
  ->  Sum = 1
  ;   maplist(recursive_reward_count, Children, Subsums),
      foldl(acc_sum, Subsums, 1, Sum)
  ).

acc_sum(AccIn, X, AccOut) :- AccOut is AccIn + X.

build_rewards([], _) :- true.
build_rewards([Line|Rest], Index) :-
  card_score(Line, Score),
  score_to_count(Score, Count),
  next_n_indices(Index, Count, NextIndices),
  assertz(reward(Index, NextIndices)),
  NextIndex is Index + 1,
  build_rewards(Rest, NextIndex).

score_to_count(Score, Count) :-
  (Score < 2 -> Count = Score; score_to_count(Score / 2, Subcount), Count is Subcount + 1).

next_n_indices(_, 0, NextIndices) :- NextIndices = [].
next_n_indices(Index, Count, NextIndices) :-
  NextIndex is Index + 1,
  NextCount is Count - 1,
  next_n_indices(NextIndex, NextCount, OtherIndices),
  NextIndices = [NextIndex | OtherIndices].

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
:- 
  current_prolog_flag(argv, [FilePath, PartAtom]),
  atom_number(PartAtom, Part),
  start(FilePath, Part).
