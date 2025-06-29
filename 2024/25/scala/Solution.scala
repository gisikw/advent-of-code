package aoc

object Solution extends App {
    val inputFile = args(0)
    val lines = scala.io.Source.fromFile(inputFile).getLines().toList

    val indices = List.range(0, 5)
    val groups = lines.filter(s => s.length > 0).grouped(7)
    val (lockGroups, keyGroups) = groups.partition(g => g.head == "#####")

    val locks = lockGroups.map(g => 
        indices.map(i => g.count(l => l.apply(i) == '#'))).toList
    val keys = keyGroups.map(g => 
        indices.map(i => g.count(l => l.apply(i) == '#'))).toList

    val combos = locks.map(lock =>
        keys.count(key =>
            indices.forall(i => lock.apply(i) + key.apply(i) <= 7)
        )
    ).sum

    println(combos)
}
