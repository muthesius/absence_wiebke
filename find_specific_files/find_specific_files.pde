// find_sepcific_files.pde
// FileWalker.pde
//
// Part of an exlorative process on digital legacy
// Written by Wiebke Wetzger & Jens A. Ewald
// Muthesius Academy of Fine Arts and Design 2015
// 
// CREDITS
// Based on an example of the book:
// Generative Gestaltung, ISBN: 978-3-87439-759-9
// First Edition, Hermann Schmidt, Mainz, 2009
// Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
// Copyright 2009 Hartmut Bohnacker, Benedikt Gross, Julia Laub, Claudius Lazzeroni
//
// http://www.generative-gestaltung.de
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


/**
 * press 'o' to select an input folder!
 *
 * the scetch will walk the whole tree of files
 * and collect information on the found files (only files)
 * see the FileWalker tab for details and modify the
 * collectStats(...) method to record more info on the given entry.
 *
 * WARNING: Folders with deep structures can take minutes to scan!!!
 * 
 * KEYS
 * o                  : select an input folder
 *
 *
 * TODO
 * - add the depth limiting parameter to the Walk(String path); method!
 * - add more information about an entry to the FileWalker class
 * - filter the noisy unkown file extensions
 * - maybe an event would be nice
 * - probably good, if the traversing would be done in the background
 * - the FileSystemItem class from the original example is not used any more
 */


// ------ default folder path ------
String defaultFolderPath = System.getProperty("user.home")+"/Documents";
//String defaultFolderPath = "/Users/admin/Desktop";
//String defaultFolderPath = "C:\\windows";

// ------ program logic ------
int fileCounter = 0;

void setup() {
  size(128,128);
  setInputFolder(defaultFolderPath);
}

void draw() {
  // keep the app running
}


// ------ folder selection dialog + init visualization ------
void setInputFolder(File theFolder) {
  setInputFolder(theFolder.toString());
}

void setInputFolder(String theFolderPath) {
  // get files on harddisk
  println("\n"+theFolderPath);
  FileWalker fw = new FileWalker(theFolderPath);
  long start = millis();
  fw.Walk();
  long end = millis();
  fw.printStatsToConsole();
  // e.g. print the number of PDF documents:
  println("Number of PDFs: " + fw.countForExtension("pdf"));
  println("Scan took " + ((end - start)/1000.0) + " seconds");
}

void keyReleased() {
  if (key == 'o' || key == 'O') {
    selectFolder("please select a folder", "setInputFolder");
  }
}


