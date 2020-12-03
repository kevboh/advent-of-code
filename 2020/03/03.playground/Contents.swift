import Cocoa

let inputPath = Bundle.main.path(forResource: "input", ofType: "txt")!
let inputData = FileManager.default.contents(atPath: inputPath)!
let input = String(data: inputData, encoding: .utf8)!
let map = input.components(separatedBy: "\n").filter({!$0.isEmpty})

extension String {
    subscript(offset: Int) -> String {
        String(self[index(startIndex, offsetBy: offset)])
    }
    
    var treeValue: Int { self == "#" ? 1 : 0 }
}

func traverse(terrain: [String], index: (x: Int, y: Int), slope: (right: Int, down: Int)) -> Int {
    let next = (x: index.x + slope.right, y: index.y + slope.down)
    guard next.y < terrain.count else { return 0 }
    let line = terrain[next.y]
    return line[next.x % line.utf8.count].treeValue
        +
        traverse(
            terrain: terrain,
            index: next,
            slope: slope
        )
    
}

let partOne = traverse(terrain: map, index: (x: 0, y: 0), slope: (right: 3, down: 1))
print(partOne)

let partTwo = [
    (right: 1, down: 1),
    (right: 3, down: 1),
    (right: 5, down: 1),
    (right: 7, down: 1),
    (right: 1, down: 2)
].map({traverse(terrain: map, index: (x: 0, y: 0), slope: $0)}).reduce(1, *)
print(partTwo)
