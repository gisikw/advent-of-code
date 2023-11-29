const fs = require('fs');
const path = require('path');

const main = (inputFile, part) => {
  const content = fs.readFileSync(inputFile, 'utf8');
  const lines = content.split('\n').filter(Boolean);
  const linesCount = lines.length;

  console.log(`Received ${linesCount} lines of input for part ${part}`);
};

const inputFile = process.argv[2];
const part = process.argv[3];
main(inputFile, part);
