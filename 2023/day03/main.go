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
	parts, _ := parse()
	var total int32
	for _, p := range parts {
		total += p
	}
	return total
}

func part2() int32 {
	_, gears := parse()
	var total int32
	for _, g := range gears {
		if len(g) != 2 {
			continue
		}
		total += g[0] * g[1]
	}
	return total
}

func parse() ([]int32, map[[2]int][]int32) {
	// Ingest each line, accumulating numbers and checking neighbors for symbols as we go.
	// This ended up being kind of a messy way to do this.
	lines := strings.Split(input, "\n")
	var parts []int32
	gears := make(map[[2]int][]int32)

	for y, line := range lines {
		var c string
		var isPart, sawGear bool
		var gear [2]int
		for x, r := range line {
			if r < 48 || r > 57 {
				// Our rune isn't a digit; check if we've built up a part and if so, record it.
				if isPart {
					n := aoc.MustInt(c)
					parts = append(parts, n)
					if sawGear {
						gears[gear] = append(gears[gear], n)
					}
				}
				c = ""
				isPart = false
				sawGear = false
				continue
			}
			// Our rune is a digit. Check all neighbors to see if we're valid.
			// Also grab the gear if this is the first time we're seeing it for this part.
			c += string(r)
			ok, g, coord := hasNearbySymbol(lines, x, y)
			isPart = isPart || ok
			if g && !sawGear {
				gear = coord
				sawGear = true
			}
		}
		if c == "" || !isPart {
			continue
		}
		n := aoc.MustInt(c)
		parts = append(parts, n)
		if sawGear {
			gears[gear] = append(gears[gear], n)
		}
	}
	return parts, gears
}

func hasNearbySymbol(lines []string, x, y int) (has bool, isGear bool, coord [2]int) {
	l := len(lines[y])
	for dx := max(x-1, 0); dx <= min(x+1, l-1); dx++ {
		for dy := max(y-1, 0); dy <= min(y+1, len(lines)-1); dy++ {
			c := lines[dy][dx]
			isDigit := c >= 48 && c <= 57
			if c != 46 && !isDigit {
				return true, c == 42, [2]int{dx, dy}
			}
		}
	}
	return false, false, coord
}
