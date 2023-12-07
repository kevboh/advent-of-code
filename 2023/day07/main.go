package main

import (
	"cmp"
	_ "embed"
	"fmt"
	"regexp"
	"slices"
	"strings"

	"kevinbarrett.org/aoc2023/aoc"
)

//go:embed input.txt
var input string

func main() {
	aoc.Run(part1, part2)
}

func part1() int64 {
	return winnings(false)
}

func part2() int64 {
	return winnings(true)
}

func winnings(wilds bool) int64 {
	hands := allHands(wilds)
	// Sort hands by kind, then card strength, in rank ascending.
	slices.SortFunc(hands, func(a, b *hand) int {
		k := cmp.Compare(b.kind, a.kind)
		if k != 0 {
			return k
		}
		for i := 0; i < 5; i++ {
			r := cmp.Compare(a.cards[i].value(wilds), b.cards[i].value(wilds))
			if r != 0 {
				return r
			}
		}
		panic("two identical hands! this doesn't happen in our inputs, and isn't specified in the puzzle.")
	})
	var t int64
	for i := 0; i < len(hands); i++ {
		hand := hands[i]
		t += int64(i+1) * int64(hand.bid)
	}
	return t
}

func allHands(wilds bool) []*hand {
	var hands []*hand
	for _, line := range strings.Split(input, "\n") {
		hands = append(hands, newHand(line, wilds))
	}
	return hands
}

type card rune

func (c card) value(wilds bool) int32 {
	switch c {
	case 'A':
		return 14
	case 'K':
		return 13
	case 'Q':
		return 12
	case 'J':
		if wilds {
			return 1
		}
		return 11
	case 'T':
		return 10
	default:
		return aoc.MustInt(string(c))
	}
}

type kind int32

const (
	KindFiveOfAKind  = kind(0)
	KindFourOfAKind  = kind(1)
	KindFullHouse    = kind(2)
	KindThreeOfAKind = kind(3)
	KindTwoPair      = kind(4)
	KindOnePair      = kind(5)
	KindHighCard     = kind(6)
)

type hand struct {
	cards []card
	kind  kind
	bid   int32
}

func (h *hand) String() string {
	return fmt.Sprintf("%d: %v (%d)", h.kind, h.cards, h.bid)
}

var regex = regexp.MustCompile(`(\w{5})\s(\d+)`)

func newHand(line string, wilds bool) *hand {
	h := &hand{}
	m := regex.FindStringSubmatch(line)
	for _, r := range m[1] {
		h.cards = append(h.cards, card(r))
	}

	h.bid = aoc.MustInt(m[2])
	h.kind = kindFrom(h.cards, wilds)

	return h
}

func kindFrom(cards []card, wilds bool) kind {
	km := make(map[card]int32)
	var numWilds int32
	for _, c := range cards {
		if wilds && c == 'J' {
			// Don't count jokers directly;
			// instead we'll add them to hands later.
			numWilds++
		} else {
			km[c]++
		}
	}
	// This would all be so much easier in Elixir.
	// Imagine all the pattern-matching!
	var bits []int32
	for _, v := range km {
		bits = append(bits, v)
	}
	// All jokers! Lucky you!
	if len(bits) == 0 {
		return KindFiveOfAKind
	}
	// Sort in descending order.
	slices.SortFunc(bits, func(a, b int32) int {
		return cmp.Compare(b, a)
	})
	// Okay, all of that was because we really only care about the two highest-order bits, plus wilds.
	switch bits[0] + numWilds {
	case 5:
		return KindFiveOfAKind
	case 4:
		return KindFourOfAKind
	case 3:
		switch bits[1] {
		case 2:
			return KindFullHouse
		case 1:
			return KindThreeOfAKind
		}
	case 2:
		switch bits[1] {
		case 2:
			return KindTwoPair
		case 1:
			return KindOnePair
		}
	case 1:
		return KindHighCard
	}
	panic(fmt.Sprintf("don't know how to make a hand type from %v!", cards))
}
