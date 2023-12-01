package main

import (
	_ "embed"
	"fmt"
	"log/slog"
	"math"
	"strconv"
	"strings"

	"kevinbarrett.org/aoc2023/aoc"
)

//go:embed input.txt
var input string

func main() {
	aoc.Run(part1, part2)
}

func part1() int32 {
	var total int32
	lines := strings.Split(input, "\n")
	for _, line := range lines {
		var f, l rune
		for _, r := range line {
			if r < 49 || r > 57 {
				continue
			}
			if f == 0 {
				f = r
			}
			l = r
		}
		total += toInt(f, l)
	}
	return total
}

var digits = map[string]rune{
	"one":   '1',
	"1":     '1',
	"two":   '2',
	"2":     '2',
	"three": '3',
	"3":     '3',
	"four":  '4',
	"4":     '4',
	"five":  '5',
	"5":     '5',
	"six":   '6',
	"6":     '6',
	"seven": '7',
	"7":     '7',
	"eight": '8',
	"8":     '8',
	"nine":  '9',
	"9":     '9',
}

func part2() int32 {
	var total int32
	lines := strings.Split(input, "\n")
	for _, line := range lines {
		var f, l rune
		fi := math.MaxInt
		li := -1
		for k, v := range digits {
			if j := strings.Index(line, k); j >= 0 && j < fi {
				f = v
				fi = j
			}

			if j := strings.LastIndex(line, k); j >= 0 && j > li {
				l = v
				li = j
			}
		}
		total += toInt(f, l)
	}
	return total
}

func toInt(f, l rune) int32 {
	s := fmt.Sprintf("%c%c", f, l)
	d, err := strconv.Atoi(s)
	if err != nil {
		slog.Error("error converting to integer", "in", s, "err", err)
	}
	return int32(d)
}
