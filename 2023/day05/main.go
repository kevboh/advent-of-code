package main

import (
	_ "embed"
	"math"
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
	a := parse()
	lowest := int64(math.MaxInt64)
	for _, seed := range a.seeds {
		lowest = min(lowest, a.forward(seed))
	}
	return lowest
}

func part2() int64 {
	a := parse()

	// Look. I know that the right way to do this is to map the intervals backward
	// through the almanac. But I can also just write the simple reversed versions
	// of my forward() functions and run it all backwards from zero, and it'll take
	// eight seconds to run instead of be ~instant but will cost far less of my life.
	var i int64
	for {
		v := a.back(i)
		if a.hasSeedPart2(v) {
			return i
		}
		i++
	}
}

type almanac struct {
	seeds   []int64
	mappers []*mapper
}

func (a *almanac) forward(v int64) int64 {
	for _, m := range a.mappers {
		v = m.forward(v)
	}
	return v
}

func (a *almanac) back(v int64) int64 {
	for i := len(a.mappers) - 1; i >= 0; i-- {
		v = a.mappers[i].back(v)
	}
	return v
}

func (a *almanac) hasSeedPart2(seed int64) bool {
	for i := 0; i < len(a.seeds); i += 2 {
		if seed >= a.seeds[i] && seed < a.seeds[i]+a.seeds[i+1] {
			return true
		}
	}
	return false
}

type mapper struct {
	from, to string
	ranges   []*rangeMap
}

func (m *mapper) forward(old int64) int64 {
	for _, rm := range m.ranges {
		if new, ok := rm.forward(old); ok {
			return new
		}
	}
	return old
}

func (m *mapper) back(old int64) int64 {
	for _, rm := range m.ranges {
		if new, ok := rm.back(old); ok {
			return new
		}
	}
	return old
}

type rangeMap struct {
	dStart, sStart, length int64
}

func (r *rangeMap) forward(v int64) (int64, bool) {
	if v >= r.sStart && v < r.sStart+r.length {
		return r.dStart + v - r.sStart, true
	}
	return v, false
}

func (r *rangeMap) back(v int64) (int64, bool) {
	if v >= r.dStart && v < r.dStart+r.length {
		return v - r.dStart + r.sStart, true
	}
	return v, false
}

var fromToRegex = regexp.MustCompile(`(?P<from>[^-\s]+)-to-(?P<to>[^-\s]+)`)

func parse() *almanac {
	a := &almanac{}
	lines := strings.Split(input, "\n")

	for _, s := range strings.Split(lines[0][7:], " ") {
		a.seeds = append(a.seeds, aoc.MustInt64(strings.TrimSpace(s)))
	}

	var current *mapper

	for _, l := range lines[2:] {
		if len(l) == 0 {
			continue
		}
		m := fromToRegex.FindStringSubmatch(l)
		if len(m) > 0 {
			// new map
			current = &mapper{
				from: m[1],
				to:   m[2],
			}
			a.mappers = append(a.mappers, current)
			continue
		}
		// range line
		nums := strings.Split(l, " ")
		current.ranges = append(current.ranges, &rangeMap{
			dStart: aoc.MustInt64(nums[0]),
			sStart: aoc.MustInt64(nums[1]),
			length: aoc.MustInt64(nums[2]),
		})
	}

	return a
}
