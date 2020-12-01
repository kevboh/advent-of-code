func findProductTwo(search: [Int]) {
    for (outerIndex, outer) in search.enumerated() {
        for (innerIndex, inner) in search[outerIndex.advanced(by: 1)..<search.endIndex].enumerated() {
            if outer + inner == 2020 {
                print("\(outer) + \(inner) = 2020, product = \(outer * inner)")
                print("Found at indices \(outerIndex), \(innerIndex)")
                return
            }
        }
    }
}

func findProductThree(search: [Int]) {
    for (firstIndex, first) in search.enumerated() {
        for (secondIndex, second) in search[firstIndex.advanced(by: 1)..<search.endIndex].enumerated() {
            for (thirdIndex, third) in search[secondIndex.advanced(by: 1)..<search.endIndex].enumerated() {
                if first + second + third == 2020 {
                    print("\(first) + \(second) + \(third) = 2020, product = \(first * second * third)")
                    print("Found at indices \(firstIndex), \(secondIndex), \(thirdIndex)")
                    return
                }
            }
        }
    }
}

findProductTwo(search: input)
findProductThree(search: input)


