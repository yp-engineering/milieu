// Copyright 2015 YP LLC.
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file.
package main

import (
	"bytes"
	"fmt"
	"log"
	"net/http"
	"os/exec"
	"strings"
)

func main() {
	http.HandleFunc("/", preview)

	log.Fatal(http.ListenAndServe(":80", nil))
}

func env() string {
	environment, err := shPipe("env", "sort")
	if err != nil {
		fmt.Println(err)
	}
	return environment
}

func shPipe(first string, second string) (string, error) {
	c1 := exec.Command(first)
	c2 := exec.Command(second)
	c2.Stdin, _ = c1.StdoutPipe()
	var out bytes.Buffer
	c2.Stdout = &out
	_ = c2.Start()
	err := c1.Run()
	_ = c2.Wait()
	return strings.Trim(out.String(), " \n"), err
}

func preview(w http.ResponseWriter, r *http.Request) {
	r.Write(w)
	env, err := shPipe("env", "sort")
	if err != nil {
		fmt.Println(err)
	}
	fmt.Fprintln(w, env)
}
