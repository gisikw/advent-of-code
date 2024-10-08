input_file = ARGV[0]
part = ARGV[1]

# Cost, Damage, Armor
weapons = [
  [8, 4, 0],
  [10, 5, 0],
  [25, 6, 0],
  [40, 7, 0],
  [74, 8, 0]
]

armors = [
  [0, 0, 0],
  [13, 0, 1],
  [31, 0, 2],
  [53, 0, 3],
  [75, 0, 4],
  [102, 0, 5]
]

rings = [
  [0, 0, 0],
  [0, 0, 0],
  [25, 1, 0],
  [50, 2, 0],
  [100, 3, 0],
  [20, 0, 1],
  [40, 0, 2],
  [80, 0, 3]
]

loadouts = weapons.flat_map do |weapon|
  armors.flat_map do |armor|
    rings.flat_map do |ring1|
      (rings - [ring1] + (ring1 == [0,0,0] ? [0,0,0] : [])).map do |ring2|
        [
          weapon[0] + armor[0] + ring1[0] + ring2[0],
          weapon[1] + armor[1] + ring1[1] + ring2[1],
          weapon[2] + armor[2] + ring1[2] + ring2[2],
          [weapon, armor, ring1, ring2]
        ]
      end
    end
  end
end.sort_by { |l| l[0] }

def wins_battle?(player, enemy)
  while true
    enemy[0] -= [player[1] - enemy[2], 1].max
    return true if enemy[0] <= 0
    player[0] -= [enemy[1] - player[2], 1].max
    return false if player[0] <= 0
  end
end

# HP, Damage, Armor
enemy = File.read(input_file).lines.map { |l| l.scan(/\d+/)[0].to_i }

if part == "1"
  puts loadouts.detect { |l| wins_battle?([100, l[1], l[2]], enemy.dup) }[0]
else
  puts loadouts.reverse.detect { |l| !wins_battle?([100, l[1], l[2]], enemy.dup) }[0]
end
