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

type cubeSet struct {
	red, blue, green int32
}

var r *regexp.Regexp

func init() {
	r = regexp.MustCompile(`(?P<count>\d+) (?P<color>red|green|blue)`)
}

func newCubeSet(s string) *cubeSet {
	set := &cubeSet{}
	colors := strings.Split(s, ",")
	for _, cs := range colors {
		rs := r.FindStringSubmatch(strings.TrimSpace(cs))
		i := aoc.MustInt(rs[1])
		switch rs[2] {
		case "red":
			set.red = i
		case "blue":
			set.blue = i
		case "green":
			set.green = i
		}
	}
	return set
}

type game struct {
	id   int32
	sets []*cubeSet
}

func newGame(s string) *game {
	g := &game{}
	s = s[5:]
	colon := strings.Index(s, ":")
	g.id = aoc.MustInt(s[:colon])
	for _, v := range strings.Split(s[colon+2:], ";") {
		g.sets = append(g.sets, newCubeSet(v))
	}
	return g
}

func part1() int32 {
	var t int32
	for _, l := range strings.Split(input, "\n") {
		t += newGame(l).score()
	}
	return t
}

func (gm *game) score() int32 {
	p := true
	for _, s := range gm.sets {
		p = p && s.red <= 12 && s.green <= 13 && s.blue <= 14
	}
	if p {
		return int32(gm.id)
	}
	return 0
}

func part2() int32 {
	var t int32
	for _, l := range strings.Split(input, "\n") {
		t += newGame(l).power()
	}
	return t
}

func (gm *game) power() int32 {
	var r, g, b int32
	for _, s := range gm.sets {
		r = max(s.red, r)
		g = max(s.green, g)
		b = max(s.blue, b)
	}
	return r * g * b
}
