import java.io.File

fun main(args: Array<String>) {
    val inputFile = args[0]
    val part = args[1]

    val lines = File(inputFile).readLines()

    val connections = mutableMapOf<String, MutableSet<String>>()
    for (line in lines) {
        val nodes = line.split("-")

        if (!connections.containsKey(nodes[0])) 
            connections.put(nodes[0], mutableSetOf<String>())
        connections.get(nodes[0])?.add(nodes[1])

        if (!connections.containsKey(nodes[1])) 
            connections.put(nodes[1], mutableSetOf<String>())
        connections.get(nodes[1])?.add(nodes[0])
    }

    val trios = mutableSetOf<Set<String>>()
    for (key in connections.keys) {
        if (!key.startsWith("t") && part.equals("1")) continue
        val peers = connections[key]!!
        for (peer in peers) {
            for (peerPeer in connections[peer]!!) {
                if (peerPeer != peer && peers.contains(peerPeer)) {
                    val trio = setOf(key, peer, peerPeer)
                    trios.add(trio)
                }
            }
        }
    }

    if (part.equals("1")) {
        println(trios.size)
        return
    }

    var maxSet = mutableSetOf<String>()
    for (trio in trios) {
        val set = trio.toMutableSet()
        val queue = trio.toMutableList()
        while (!queue.isEmpty()) {
            val node = queue.removeAt(0)
            neighbor@ for (neighbor in connections[node]!!) {
                for (peer in set) {
                    if (!connections[peer]!!.contains(neighbor)) continue@neighbor
                }
                set.add(neighbor)
                queue.add(neighbor)
            }
        }
        if (set.size > maxSet.size) maxSet = set
    }

    val result = maxSet.toMutableList()
    result.sort()
    println(result.joinToString(separator = ","))
}
