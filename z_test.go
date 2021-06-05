package main

import (
	"os/exec"
	"testing"
)

// todo: easier tests without the duplication

func TestVersion(t *testing.T) {
	want := "v0.2.0\n"

	out, err := exec.Command("bin/z", "-V").CombinedOutput()
	output := string(out)
	if err != nil {
		t.Errorf("error: %s", err)
	}
	if got := output; got != want {
		t.Errorf("Got: '%s', expected '%s'", got, want)
	}
}
