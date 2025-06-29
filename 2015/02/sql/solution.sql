DO $$
DECLARE
  part char;
  result int;
BEGIN
  SELECT value INTO part FROM config WHERE key = 'part';
  CREATE TABLE presents (l int, w int, h int);
  INSERT INTO presents (l, w, h)
  SELECT 
    split_part(line, 'x', 1)::int,
    split_part(line, 'x', 2)::int,
    split_part(line, 'x', 3)::int
  FROM lines;

  IF part = '1' THEN
    SELECT INTO result SUM(2*l*w + 2*w*h + 2*h*l + LEAST(l*w, l*h, w*h)) FROM presents;
  ELSE
    SELECT INTO result SUM(LEAST(l+l+w+w, w+w+h+h, h+h+l+l) + l*w*h) FROM presents;
  END IF;
  INSERT INTO output(text) VALUES(result);
END$$;


SELECT text FROM output;
