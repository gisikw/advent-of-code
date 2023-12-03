-- Insert a summary into the output table
INSERT INTO output(text) 
VALUES (
  'Received ' || 
  (SELECT COUNT(*) FROM lines) || 
  ' lines of input for part ' || 
  (SELECT value FROM config WHERE key = 'part')
);

-- Select and display the final output
SELECT text FROM output;
