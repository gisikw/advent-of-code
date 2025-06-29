-- Transform the list into north -> south columns
CREATE TABLE columns (id int, text TEXT);
INSERT INTO columns
WITH idx AS (SELECT * from generate_series(1,100000) AS i)
SELECT i, STRING_AGG(SUBSTR(line, i, 1),'') FROM lines JOIN idx on 1=1
WHERE i <= (SELECT COUNT(*) FROM lines)
GROUP BY i
ORDER BY i;

-- Move the rocks to the north via sorting [O\.]+ segments
CREATE SEQUENCE n;
CREATE TABLE sorted_columns (id int, text TEXT);
INSERT INTO sorted_columns (id, text)
SELECT id, string_agg(sorted_piece, '') text FROM (
  SELECT id, string_agg(char,'') AS sorted_piece FROM (
    SELECT id, string_to_table(piece, NULL) AS char, n FROM (
      SELECT id, unnest(regexp_matches(text, '[\.O]+|#+', 'g')) piece, nextval('n') AS n FROM columns
    ) ORDER BY char DESC
  ) GROUP BY (n, id) order by n
) GROUP BY (id);

-- Rotate back to rows, using id as weight
CREATE TABLE rows (id int, text TEXT);
INSERT INTO rows
WITH idx AS (SELECT * from generate_series(1,100000) AS i)
SELECT (SELECT COUNT(*) FROM sorted_columns) - i + 1, STRING_AGG(SUBSTR(text, i, 1),'') FROM sorted_columns JOIN idx on 1=1
WHERE i <= (SELECT COUNT(*) FROM sorted_columns)
GROUP BY i
ORDER BY i;

-- Sum the weights * rock counts
SELECT SUM(row_weight) FROM (
  SELECT id * length(regexp_replace(text, '[^O]', '', 'g')) AS row_weight FROM rows
);
