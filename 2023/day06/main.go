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
	aoc.Run(part1, part2)
}

func part1() int64 {
	// Let's solve this the naive way first.
	// I'm positive you can solve this with a bit of geometry,
	// but it's been twenty years.
	times, distances := parse1()
	total := int32(1)
	for i := 0; i < len(times); i++ {
		time := times[i]
		distance := distances[i]
		total *= winCount(time, distance)
	}

	return int64(total)
}

func part2() int64 {
	time, distance := parse2()
	return winCount(time, distance)
}

func winCount[U ~int32 | ~int64](time, distance U) U {
	var winners U
	for held := U(0); held <= time; held++ {
		traveled := held * (time - held)
		if traveled > distance {
			winners++
		}
	}

	return winners
}

var regex = regexp.MustCompile(`\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)`)

func parse1() ([]int32, []int32) {
	lines := strings.Split(input, "\n")
	var times, distances []int32
	for _, t := range regex.FindStringSubmatch(lines[0][5:])[1:] {
		times = append(times, aoc.MustInt(t))
	}
	for _, d := range regex.FindStringSubmatch(lines[1][9:])[1:] {
		distances = append(distances, aoc.MustInt(d))
	}
	return times, distances
}

func parse2() (int64, int64) {
	lines := strings.Split(input, "\n")
	time := aoc.MustInt64(strings.ReplaceAll(lines[0][5:], " ", ""))
	distance := aoc.MustInt64(strings.ReplaceAll(lines[1][9:], " ", ""))
	return time, distance
}
