import Foundation

if CommandLine.arguments.count > 2 {
    let inputFile = CommandLine.arguments[1]
    let part = CommandLine.arguments[2]

    if let content = try? String(contentsOfFile: inputFile) {
        let lines = content.split(whereSeparator: \.isNewline)
        let linesCount = lines.count

        print("Received \(linesCount) lines of input for part \(part)")
    }
}
