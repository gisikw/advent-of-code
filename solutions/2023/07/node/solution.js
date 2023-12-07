const fs = require('fs');
const path = require('path');

const main = (inputFile, part) => {
  const content = fs.readFileSync(inputFile, 'utf8');
  const lines = content.split('\n').filter(Boolean);

  const hands = lines.map(line => {
    const [str, bet] = line.split(' ');
    let rankable = str
      .replaceAll('T','V')
      .replaceAll('J','W')
      .replaceAll('Q','X')
      .replaceAll('K','Y')
      .replaceAll('A','Z')
    if (part == "2") rankable = rankable.replaceAll('W', '1');
    const groups = rankable
      .split('')
      .sort()
      .join('')
      .matchAll(/(.)\1*/g);
    let hand = [...groups].map(g => g[0]).sort(pokerSort).join('');

    if (part == "2") {
      hand = hand.replaceAll('1', '');
      const jokers = 5 - hand.length;
      hand = `${(hand[0]||'Z').repeat(jokers)}${hand}`;
    }

    return [
      rankable,
      hand,
      parseInt(bet),
      handKind(hand)
    ];
  });

  hands.sort(pokerHandSort);

  const sum = hands.reduce((acc, [_, __, bet], idx) => {
    return acc + ((idx + 1) * bet)
  }, 0);

  console.log(sum);
};

const pokerSort = (a, b) => {
  const lenCpr = b.length - a.length;
  if (lenCpr != 0) return lenCpr;
  return b[0] < a[0] ? -1 : 1;
}

const pokerHandSort = (a, b) => {
  handTypeCpr = a[3] - b[3];
  if (handTypeCpr != 0) return handTypeCpr;
  return a[0] < b[0] ? -1 : 1;
}

const handKind = (hand) => {
  if (hand.match(/(.)\1{4}/)) return 7; // Five of a kind
  if (hand.match(/(.)\1{3}/)) return 6; // Four of a kind
  if (hand.match(/(.)\1{2}(.)\2/)) return 5; // Full house
  if (hand.match(/(.)\1{2}/)) return 4; // Three of a kind
  if (hand.match(/(.)\1(.)\2/)) return 3; // Two pair
  if (hand.match(/(.)\1/)) return 2; // Pair
  return 1; // High Card
}

const inputFile = process.argv[2];
const part = process.argv[3];
main(inputFile, part);
