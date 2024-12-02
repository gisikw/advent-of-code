&fras ⊡ 1 &args
∵(□⋕◇⊜□⊸≠@ ) ⊜□⊸≠@\n
SafeTrend ← <0/×⍉◫2
SafeMag   ← /↥⊟⊃(>3)(<1)⌵
Deltas    ← /-⍉◫2
Safe      ← /↧⊟⊃(=0/+SafeTrend) (=0/+SafeMag) Deltas

TrendDrop      ← +[0 1 2] ⊗ 1 SafeTrend
MagDrop        ← +[0 1] ⊗ 1 SafeMag
DropIndices    ← ◌:▽<⧻:⊙, . ◴⊂⊃MagDrop TrendDrop Deltas .°□
DropAt         ← ⊂⊃↙(↘+1):°□:
Drops          ← ⊞DropAt DropIndices . □
SafeDrop       ← >0/+≡(Safe ♭) Drops
SafeOrSafeDrop ← ↥Safe⟜SafeDrop

/+≡◇⨬(Safe)(SafeOrSafeDrop) -1⋕ ⊡ 2 &args
