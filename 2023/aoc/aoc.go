package aoc

import (
	"flag"
	"log"
	"log/slog"
	"strconv"

	"kevinbarrett.org/aoc2023/clipboard"
)

func Run[A any](p1 func() A, p2 func() A) {
	var part int
	flag.IntVar(&part, "part", 1, "Part 1 or 2")
	flag.Parse()
	slog.Info("Running", "part", part)

	var answer A
	switch part {
	case 1:
		answer = p1()
	case 2:
		answer = p2()
	default:
		slog.Error("Did not recognize part", "part", part)
	}

	clipboard.Copy(answer)
	slog.Info("Done!", "part", part, "result", answer)
}

func MustInt(s string) int32 {
	i, err := strconv.Atoi(s)
	if err != nil {
		log.Fatalf("expected %s to MustInt", s)
	}
	return int32(i)
}

func MustInt64(s string) int64 {
	i, err := strconv.ParseInt(s, 10, 64)
	if err != nil {
		log.Fatalf("expected %s to MustInt", s)
	}
	return i
}
