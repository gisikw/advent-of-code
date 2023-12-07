const fs = require('fs');
const path = require('path');

const main = (inputFile, part) => {
  const content = fs.readFileSync(inputFile, 'utf8');
  const lines = content.split('\n').filter(Boolean);

  const hands = lines.map(line => {
    const [str, bet] = line.split(' ');
    let sortableHand = renameFaceCards(str, part);
    const groups = sortableHand.split('').sort().join('').matchAll(/(.)\1*/g);
    let hand = [...groups].map(g => g[0]).sort(pokerSort).join('');

    if (part == "2") {
      hand = hand.replaceAll('1', '');
      const jokers = 5 - hand.length;
      hand = `${(hand[0]||'Z').repeat(jokers)}${hand}`;
    }

    return [sortableHand, parseInt(bet), handKind(hand)];
  });

  hands.sort(pokerHandSort);

  const sum = hands.reduce((acc, [_, bet], idx) => acc + (idx + 1) * bet, 0);
  console.log(sum);
};

const renameFaceCards = (str, part) =>
    str
      .replaceAll('T','V')
      .replaceAll('J',part == "1" ? 'W' : '1')
      .replaceAll('Q','X')
      .replaceAll('K','Y')
      .replaceAll('A','Z');

const pokerSort = (a, b) => {
  const lenCpr = b.length - a.length;
  if (lenCpr != 0) return lenCpr;
  return b[0] < a[0] ? -1 : 1;
}

const pokerHandSort = (a, b) => {
  handTypeCpr = a[2] - b[2];
  if (handTypeCpr != 0) return handTypeCpr;
  return a[0] < b[0] ? -1 : 1;
}

const handKind = (hand) => {
  if (hand.match(/(.)\1{4}/)) return 7;
  if (hand.match(/(.)\1{3}/)) return 6;
  if (hand.match(/(.)\1{2}(.)\2/)) return 5;
  if (hand.match(/(.)\1{2}/)) return 4;
  if (hand.match(/(.)\1(.)\2/)) return 3;
  if (hand.match(/(.)\1/)) return 2;
  return 1;
}

const inputFile = process.argv[2];
const part = process.argv[3];
main(inputFile, part);
