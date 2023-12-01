package clipboard

import (
	"bytes"
	"fmt"
	"os/exec"
)

// cheers https://github.com/alexchao26/advent-of-code-go/blob/main/util/CopyToClipboard.go
func Copy(thing any) error {
	var text string
	switch v := thing.(type) {
	case string:
		text = v
	case int, int32:
		text = fmt.Sprintf("%d", v)
	}

	command := exec.Command("pbcopy")
	command.Stdin = bytes.NewReader([]byte(text))

	if err := command.Start(); err != nil {
		return fmt.Errorf("error starting pbcopy: %w", err)
	}

	err := command.Wait()
	if err != nil {
		return fmt.Errorf("error running pbcopy %w", err)
	}

	return nil
}
