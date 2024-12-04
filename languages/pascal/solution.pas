program Solution;

var
  inputFileName: string;
  part: string;
  inputFile: Text;
  line: string;
  lineCount: Integer;
begin
  inputFileName := ParamStr(1);
  part := ParamStr(2);
  lineCount := 0;

  Assign(inputFile, inputFileName);
  Reset(inputFile);

  while not Eof(inputFile) do
  begin
    ReadLn(inputFile, line);
    Inc(lineCount);
  end;

  Close(inputFile);

  WriteLn('Received ', lineCount, ' lines of input for part ', part);
end.
