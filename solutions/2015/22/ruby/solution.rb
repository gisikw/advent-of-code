input_file = ARGV[0]
part = ARGV[1]

boss_hp, boss_dmg = File.read(input_file).lines.map { |l| l.scan(/\d+/)[0].to_i }

GameState = Struct.new(:boss_hp, :hp, :mana, :spend, :shield, :poison, :recharge)
queue = [GameState.new(boss_hp, 50, 500, 0)]

def apply_effects(gs)
  if gs.shield
    gs.shield = gs.shield == 1 ? nil : gs.shield - 1
  end

  if gs.poison
    gs.boss_hp -= 3
    gs.poison = gs.poison == 1 ? nil : gs.poison - 1
  end

  if gs.recharge
    gs.mana += 101
    gs.recharge = gs.recharge == 1 ? nil : gs.recharge - 1
  end
end

solution = nil
while !solution
  gs = queue.shift

  gs.hp -= 1 if part == "2"
  apply_effects(gs)
  (solution = gs.spend; break) if gs.boss_hp <= 0
  next if gs.hp <= 0 || gs.mana < 53

  # Player turn actions
  next_states = []

  next_states << gs.dup.tap do |magic_missile|
    magic_missile.mana -= 53
    magic_missile.spend += 53
    magic_missile.boss_hp -= 4
  end

  if gs.mana >= 73
    next_states << gs.dup.tap do |drain|
      drain.mana -= 73
      drain.spend += 73
      drain.boss_hp -= 2
      drain.hp += 2
    end
  end

  if gs.mana >= 113 && !gs.shield
    next_states << gs.dup.tap do |shield|
      shield.mana -= 113
      shield.spend += 113
      shield.shield = 6
    end
  end

  if gs.mana >= 173 && !gs.poison
    next_states << gs.dup.tap do |poison|
      poison.mana -= 173
      poison.spend += 173
      poison.poison = 6
    end
  end

  if gs.mana >= 229 && !gs.recharge
    next_states << gs.dup.tap do |recharge|
      recharge.mana -= 229
      recharge.spend += 229
      recharge.recharge = 5
    end
  end

  answer = nil
  next_states.each do |state|
    apply_effects(state)
    (solution = state.spend; break) if state.boss_hp <= 0

    state.hp -= [boss_dmg - (state.shield ? 7 : 0), 1].max
    queue << state if state.hp > 0
  end
end

puts solution
