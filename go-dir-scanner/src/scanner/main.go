package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"runtime"
	"sort"

	"github.com/MichaelTJones/walk"
)

type Result struct {
	path string
	info os.FileInfo
}

var exts map[string]int
var unknown map[string]int
var results chan Result

var path = flag.String("path", "", "please provide a path")

type sortedMap struct {
	m map[string]int
	s []string
}

func (sm *sortedMap) Len() int {
	return len(sm.m)
}

func (sm *sortedMap) Less(i, j int) bool {
	return sm.m[sm.s[i]] > sm.m[sm.s[j]]
}

func (sm *sortedMap) Swap(i, j int) {
	sm.s[i], sm.s[j] = sm.s[j], sm.s[i]
}

func sortByValue(m map[string]int) []string {
	sm := new(sortedMap)
	sm.m = m
	sm.s = make([]string, len(m))
	i := 0
	for key, _ := range m {
		sm.s[i] = key
		i++
	}
	sort.Sort(sm)
	return sm.s
}

func collectStats() {
	results = make(chan Result, 4096)
	exts = make(map[string]int)
	unknown = make(map[string]int)
	for rc := range results {
		// fmt.Println(len(results))
		ext := filepath.Ext(rc.path)
		name := rc.info.Name()

		// Fix files which begin with a . and have no extension
		if len(ext) == len(name) {
			ext = ""
		}

		if ext == "" {
			ext = "with no extension"
			// var cmdOut []byte
			// var err error
			// if cmdOut, err = exec.Command("file", []string{"-b", rc.path}...).Output(); err != nil {
			// 	fmt.Fprintln(os.Stderr, "There was an error getting info on file", rc.path, err)
			// }
			// unknown[string(cmdOut)]++
		} else {
			// remove the dot
			ext = ext[1:len(ext)]
		}

		// update the stats
		exts[ext]++
	}
}

func reporter(path string, info os.FileInfo, err error) error {
	if err != nil {
		fmt.Println(err.Error())
		return err
	}
	if info.IsDir() {
	} else {
		results <- Result{path: path, info: info}
	}
	return err
}

func main() {
	runtime.GOMAXPROCS(runtime.NumCPU() * 6)
	flag.Parse()
	var err error
	root := *path
	if root == "" {
		fmt.Printf("No path given, using current dir: %s\n", root)
		root, err = os.Getwd()
		if err != nil {
			log.Fatal(err)
		}
	}

	if !filepath.IsAbs(root) {
		root, err = filepath.Abs(root)
		if err != nil {
			panic("Cannot determine dir")
		}
	}

	fmt.Printf("Scanning: %s\n", root)

	go collectStats()

	walk.Walk(root, reporter)
	close(results)

	for _, ext := range sortByValue(exts) {
		fmt.Println(exts[ext], "\t", ext)
	}

	fmt.Println("Unkown files")
	for _, ext := range sortByValue(unknown) {
		fmt.Println(unknown[ext], "\t", ext)
	}
}
