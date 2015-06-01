# absence_wiebke
analysing data via processing and trying to get the number of the different sort of files.


## the go-dir-scanner

### using the scanner

Use the _terminal_ application and drag in the `scanner` file in  the `bin` directory. then append the `-path` option so your commandline looks something like this:

```
…/bin/scanner -path=/Users/jens/Documents
```


### building the scanner binary

This is only needed, if you have to change the code. It is written in [go](http://golang.org) and uses the [`gb`](http://getgb.io/) build tool. Please ask for details if you have to re-build the binary - one version for osx is checked in.
