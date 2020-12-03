import Cocoa

let inputPath = Bundle.main.path(forResource: "input", ofType: "txt")!
let inputData = FileManager.default.contents(atPath: inputPath)!
let input = String(data: inputData, encoding: .utf8)!

func parseRule(_ rule: String) -> (Int, Int) {
    let parts = rule.components(separatedBy: "-")
    return (Int(parts[0])!, Int(parts[1])!)
}

protocol Part {
    func entryIsValid(_ entry: String) -> Bool
}

struct EntryComponents {
    let ruleStart: Int
    let ruleEnd: Int
    let letter: String
    let password: String
}

extension Part {
    func deconstruct(entry: String) -> EntryComponents? {
        guard !entry.isEmpty else { return nil }
        let parts = entry.replacingOccurrences(of: ":", with: "").components(separatedBy: " ")
        let (rule, letter, password) = (parts[0], parts[1], parts[2])
        let (start, end) = parseRule(rule)
        
        return EntryComponents(ruleStart: start, ruleEnd: end, letter: letter, password: password)
    }
    
    func run() -> Int {
        let separatedInputs = input.components(separatedBy: "\n")
        let validInputs = separatedInputs.filter({ entryIsValid($0) })
        let validCount = validInputs.count
        return validCount
    }
}

extension String {
    subscript(offset: Int) -> String {
        return String(self[index(startIndex, offsetBy: offset)])
    }
}

struct PartOne: Part {
    func entryIsValid(_ entry: String) -> Bool {
        guard let e = deconstruct(entry: entry) else { return false }
        let letterCount = e.password.filter({String($0) == e.letter}).count
        return letterCount >= e.ruleStart && letterCount <= e.ruleEnd
    }
}

struct PartTwo: Part {
    func entryIsValid(_ entry: String) -> Bool {
        guard let e = deconstruct(entry: entry) else { return false }
        
        let matchStart = e.password[e.ruleStart - 1] == e.letter
        let matchEnd = e.password[e.ruleEnd - 1] == e.letter
        return matchStart != matchEnd
    }
}



let partOneSolution = PartOne().run()
let partTwoSolution = PartTwo().run()

print("\(partOneSolution) valid passwords in part one.")
print("\(partTwoSolution) valid passwords in part two.")
