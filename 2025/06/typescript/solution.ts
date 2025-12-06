import { readFileSync } from 'fs';

const inputFile = process.argv[2];
const part = process.argv[3];

const content = readFileSync(inputFile, 'utf-8');

if (part === "1") {
  const lines = content
    .trim()
    .split('\n')
    .map(s => s.trim().split(/\s+/))
    .reverse();

  const values = lines
    .slice(1)
    .map(l => l.map(v => parseInt(v)));

  const total = lines[0].map(
    (_, i) => values
      .map(v => v[i])
      .reduce(lines[0][i] === "+" ? (a, b) => a + b : (a, b) => a * b)
  ).reduce((a, b) => a + b);
  console.log(total);
} else {
  let lines = content
    .trim()
    .split('\n');

  lines = lines.slice(-1).concat(lines.slice(0, -1));

  let total = 0;
  for (let i = 0; i < lines[0].length; i++) {
    if (lines[0][i] === ' ') continue;
    const op = lines[0][i] === "+" ? (a: number, b: number) => a + b : (a: number, b: number) => a * b;
    let value = null;
    while (true) {
      const num = parseInt(lines.slice(1).map(l => l[i]).join(''));
      if (isNaN(num)) break;
      value = value === null ? num : op(value, num);
      i++;
    }
    total += value!;
  }
  console.log(total);
}
