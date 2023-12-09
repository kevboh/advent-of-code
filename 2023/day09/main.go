package main

import (
	_ "embed"
	"strings"

	"kevinbarrett.org/aoc2023/aoc"
)

//go:embed input.txt
var input string

func main() {
	aoc.Run(part1, part2)
}

func part1() int32 {
	return run(next)
}

func part2() int32 {
	return run(previous)
}

func run(direction func(s []int32) int32) int32 {
	series := parse(input)
	var t int32
	for _, s := range series {
		t += direction(s)
	}
	return t
}

func next(series []int32) int32 {
	diffs, allZeroes := deriv(series)
	if allZeroes {
		return 0
	}

	return series[len(series)-1] + next(diffs)
}

func previous(series []int32) int32 {
	diffs, allZeroes := deriv(series)
	if allZeroes {
		return 0
	}

	return series[0] - previous(diffs)
}

func deriv(series []int32) ([]int32, bool) {
	allZeroes := true
	var diffs []int32
	for i, v := range series {
		if v != 0 {
			allZeroes = false
		}
		if i < len(series)-1 {
			diffs = append(diffs, series[i+1]-v)
		}
	}
	return diffs, allZeroes
}

func parse(in string) [][]int32 {
	var out [][]int32
	for _, line := range strings.Split(in, "\n") {
		var nums []int32
		for _, v := range strings.Split(line, " ") {
			nums = append(nums, aoc.MustInt(v))
		}
		out = append(out, nums)
	}
	return out
}
