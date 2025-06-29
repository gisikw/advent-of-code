import Foundation

struct Gate {
    var a: String
    var op: String
    var b: String
}

var wires: [String: Int] = [:]
var gates: [String: Gate] = [:]

func value(wire: String) -> Int {
    if wires[wire] == nil {
        let gate = gates[wire]!
        let a = value(wire: gate.a)
        let b = value(wire: gate.b)
        if (gate.op == "AND") {
            wires[wire] = (a & b)
        } else if (gate.op == "OR") {
            wires[wire] = (a | b)
        } else if (gate.op == "XOR") {
            wires[wire] = (a ^ b)
        }
    }
    return wires[wire]!
}

func clearWires() {
    wires = [:]
    for i in 0...45 {
        wires[String(format: "x%02d", i)] = 0
        wires[String(format: "y%02d", i)] = 0
    }
}

func readZ() -> String{
    var str = ""
    for i in 0...45 {
        let wire = String(format: "z%02d", 45 - i)
        str += String(value(wire: wire))
    }
    return str
}

if CommandLine.arguments.count > 2 {
    let inputFile = CommandLine.arguments[1]
    let part = CommandLine.arguments[2]

    var maxZ = 0

    if let content = try? String(contentsOfFile: inputFile) {
        let lines = content.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")

        var i = 0
        while true {
            if lines[i].isEmpty { break }
            let parts = lines[i].components(separatedBy: ": ")
            wires[parts[0]] = Int(parts[1])
            i += 1
        }

        i += 1
        while i < lines.count {
            let parts = lines[i].components(separatedBy: " ")
            gates[parts[4]] = Gate(a: parts[0], op: parts[1], b: parts[2])
            if parts[4].prefix(1) == "z" {
                let index = parts[4].index(parts[4].startIndex, offsetBy: 1)
                let num = Int(parts[4][index...])!
                if num > maxZ { maxZ = num }
            }
            i += 1
        }

        if (part == "1") {
            print(Int(readZ(), radix: 2)!)
            exit(0)
        }

        // for i in 0...44 {
        //     clearWires()
        //     wires[String(format: "x%02d", i)] = 1
        //     if value(wire: String(format: "z%02d", i)) != 1 {
        //         print("S for X bad at \(i)")
        //     }
        //     clearWires()
        //     wires[String(format: "y%02d", i)] = 1
        //     if value(wire: String(format: "z%02d", i)) != 1 {
        //         print("S for Y bad at \(i)")
        //     }
        //     clearWires()
        //     wires[String(format: "y%02d", i)] = 1
        //     wires[String(format: "x%02d", i)] = 1
        //     if value(wire: String(format: "z%02d", i + 1)) != 1 {
        //         print("Carry bad at \(i)")
        //     }
        // }

        // After manually tracing the broken bits, identified the invalid gates in each full adder
        var broken = [
            "qdg", "z12",
            "vvf", "z19",
            "dck", "fgn",
            "nvh", "z37",
        ]
        broken.sort()
        print(broken.joined(separator: ","))
    }
}
