package main

import (
	_ "embed"
	"math"
	"strings"

	"kevinbarrett.org/aoc2023/aoc"
)

//go:embed input.txt
var input string

func main() {
	aoc.Run(part1, part2)
}

type card struct {
	winners map[int32]bool
	have    map[int32]bool
}

func (c *card) overlaps() []int32 {
	var o []int32
	for n := range c.have {
		if !c.winners[n] {
			continue
		}
		o = append(o, n)
	}
	return o
}

func (c *card) score() int32 {
	return int32(math.Pow(2, float64(len(c.overlaps())-1)))
}

func part1() int32 {
	var t int32
	for _, line := range strings.Split(input, "\n") {
		c := newCard(line)
		t += c.score()
	}
	return t
}

func part2() int32 {
	lines := strings.Split(input, "\n")
	// Build a map of bags of cards.
	var max int
	cards := make(map[int][]*card, len(lines))
	for i, line := range lines {
		cards[i] = append(cards[i], newCard(line))
		max = i
	}

	// Work through the map until there are no cards to process.
	// I realize it would be more efficient to sum the multiplicative value of cards,
	// but I have a long day ahead of me and this was easier to reason about quickly.
	var t int32
	for i := 0; i <= max; i++ {
		for _, c := range cards[i] {
			for j := i + 1; j <= i+len(c.overlaps()); j++ {
				cp := cards[j][0]
				cards[j] = append(cards[j], cp)
			}
			t++
		}
	}
	return t
}

func newCard(line string) *card {
	card := &card{
		winners: make(map[int32]bool),
		have:    make(map[int32]bool),
	}
	// I'm leveraging the grid spacing in the input (not in the sample input, mind!) to index into the line here.
	numsets := strings.Split(line[10:], "|")
	for _, n := range numbers(numsets[0]) {
		card.winners[n] = true
	}
	for _, n := range numbers(numsets[1]) {
		card.have[n] = true
	}
	return card
}

func numbers(s string) []int32 {
	var nums []int32
	for _, n := range strings.Split(s, " ") {
		v := strings.TrimSpace(n)
		if v == "" {
			continue
		}
		nums = append(nums, aoc.MustInt(v))
	}
	return nums
}
