program Solution;

Uses sysutils;

var
  inputFileName: string;
  part: string;
  inputFile: Text;
  line: AnsiString;
  seq: array of int64;
  claims: array of int64;
  leftPointer: int64;
  rightPointer: int64;
  checksum: int64;
  blockPos: int64;
  i: int64;
begin
  inputFileName := ParamStr(1);
  part := ParamStr(2);

  Assign(inputFile, inputFileName);
  Reset(inputFile);
  ReadLn(inputFile, line);
  Close(inputFile);

  setlength(seq, 20000);
  setlength(claims, 20000);
  for i := 1 to length(line) do
    begin
      seq[i] := StrToInt(line[i]);
      claims[i] := StrToInt(line[i]);
    end;

  blockPos := 0;
  checksum := 0;
  leftPointer := 1;
  rightPointer := Length(line);

  if part = '1' then
  begin
    while leftPointer < rightPointer do
    begin
      // Add checksum for placed file
      for i := blockPos to blockPos + seq[leftPointer] - 1 do
      begin
        checksum += (leftPointer - 1) div 2 * blockPos;
        blockPos += 1;
      end;
      leftPointer += 1;

      // Process empty space
      for i := 0 to seq[leftPointer] - 1 do
      begin
        while seq[rightPointer] < 1 do
        begin
          rightPointer -= 2;
        end;
        checksum += (rightPointer - 1) div 2 * blockPos;
        blockPos += 1;
        seq[rightPointer] -= 1;
      end;

      leftPointer += 1;
    end;

    while seq[rightPointer] > 0 do
    begin
      checksum += (rightPointer - 1) div 2 * blockPos;
      blockPos += 1;
      seq[rightPointer] -= 1;
    end;
  end;
  
  if part = '2' then
  begin
    while rightPointer > 2 do
    begin
      // Find the first block with enough space
      leftPointer := 2;
      blockPos := seq[1];
      while leftPointer < rightPointer do
      begin
        if claims[leftPointer] >= seq[rightPointer] then
          break;
        blockPos += seq[leftPointer] + seq[leftPointer + 1];
        leftPointer += 2;
      end;

      // Scroll back if we skipped it
      if leftPointer > rightPointer then
      begin
        leftPointer -= 1;
        blockPos -= seq[leftPointer];
      end;

      // Advance block if it's partially filled
      if claims[leftPointer] <> seq[leftPointer] then
      begin
        blockPos += seq[leftPointer] - claims[leftPointer];
      end;

      for i := blockPos to blockPos + seq[rightPointer] - 1 do
      begin
        checksum += (rightPointer - 1) div 2 * blockPos;
        blockPos += 1;
      end;

      claims[leftPointer] -= seq[rightPointer];

      rightPointer -= 2;
    end;
  end;

  WriteLn(checksum);
end.
