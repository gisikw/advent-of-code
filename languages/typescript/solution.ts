import { readFileSync } from 'fs';

const inputFile = process.argv[2];
const part = process.argv[3];

const content = readFileSync(inputFile, 'utf-8');
const lines = content.trimEnd().split('\n');
const linesCount = lines.length;

console.log(`Received ${linesCount} lines of input for part ${part}`);
