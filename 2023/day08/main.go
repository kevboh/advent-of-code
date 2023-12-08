package main

import (
	_ "embed"
	"regexp"
	"strings"

	"kevinbarrett.org/aoc2023/aoc"
)

//go:embed input.txt
var input string

func main() {
	aoc.Run(part1, part2Alt)
}

func part1() int64 {
	turns, nodes := parse(input)
	var steps int64
	at := "AAA"
	for {
		turn := turns[int(steps)%len(turns)]
		at = nodes[at][turn]
		steps++
		if at == "ZZZ" {
			break
		}
	}
	return steps
}

// I originally wrote this brute-force approach for part 2, as I couldn't see another way.
// When it became clear that it would take way too long to complete, I tried to think of shortcuts.
// Nothing stood out, so I called it on today's puzzle and went to the Reddit to see if people
// had found faster ways. They had, by noting that each path was a cycle and then finding the
// least common multiple of the collected cycle lengths.
// It's pretty frustrating that that's the solution, since nothing in the puzzle description
// would indicate that the inputs _have_ to be cycles. I noticed that the example was a cycle,
// but assumed that was for simplicity since it was hand-written. I suppose in future I should
// prod at my input more and take whatever shortcuts present themselves, but I've been trying
// to write general solutions for what I assumed were well-circumscribed problems.
func part2() int64 {
	turns, nodes := parse(input)
	var steps int64
	var ats []string
	for k := range nodes {
		if strings.HasSuffix(k, "A") {
			ats = append(ats, k)
		}
	}
	for {
		turn := turns[int(steps)%len(turns)]
		var ended int
		for i, at := range ats {
			ats[i] = nodes[at][turn]
			if strings.HasSuffix(ats[i], "Z") {
				ended++
			}
		}
		steps++
		if ended == len(ats) {
			break
		}
	}
	return steps
}

func part2Alt() int64 {
	turns, nodes := parse(input)
	var ats []string
	for k := range nodes {
		if strings.HasSuffix(k, "A") {
			ats = append(ats, k)
		}
	}
	// For each starting node, find the length of its cycle.
	var cycles []int64
	for _, original := range ats {
		var cycle int64
		at := original
		for {
			turn := turns[int(cycle)%len(turns)]
			at = nodes[at][turn]
			cycle++
			if at[len(at)-1] == 'Z' {
				break
			}
		}
		cycles = append(cycles, cycle)
	}
	return LCM(cycles[0], cycles[1], cycles[2:]...)
}

// GCD and LCM funcs via https://go.dev/play/p/SmzvkDjYlb.
func GCD(a, b int64) int64 {
	for b != 0 {
		t := b
		b = a % b
		a = t
	}
	return a
}

func LCM(a, b int64, integers ...int64) int64 {
	result := a * b / GCD(a, b)

	for i := 0; i < len(integers); i++ {
		result = LCM(result, integers[i])
	}

	return result
}

var regex = regexp.MustCompile(`(\w{3}) = \((\w{3}), (\w{3})\)`)

func parse(in string) (turns string, nodes map[string]map[byte]string) {
	lines := strings.Split(in, "\n")
	turns = lines[0]

	nodes = make(map[string]map[byte]string, len(lines[2:]))
	for _, line := range lines[2:] {
		m := regex.FindStringSubmatch(line)
		nodes[m[1]] = map[byte]string{
			byte('L'): m[2],
			byte('R'): m[3],
		}
	}
	return turns, nodes
}
