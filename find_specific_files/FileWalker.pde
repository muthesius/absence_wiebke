
import java.io.File;
import java.nio.file.*;
// Docs on the Files class: http://docs.oracle.com/javase/7/docs/api/index.html?overview-summary.html

class FileWalker extends FileSystemItem {
  int level = -1;
  int maxDepth = -1;
  
  ArrayList<String> names;
  HashMap<String,Integer> extensions;
  
  FileWalker(String path) {
    super(new File(path));
    names = new ArrayList<String>();
    extensions = new HashMap<String, Integer>();
  }
  
  void Walk() {
    names.clear();
    extensions.clear();
    breadthFirst();
  }
  
  @Override
  void onEntry(File entry) {
    if (entry.isFile()) collectStats(entry);
  }
    
  void collectStats(File entry) {
    // get the 
    Path path = entry.toPath();
    String name = entry.getName();
    
    // Get the extension of the file name
    String extension = "";
    int i = name.lastIndexOf('.');
    if (i >= 0) {
        extension = name.substring(i+1);
    }
    
    // Skip files without an extension
    if (extension == "") return;
    
    names.add(name);
    addExtension(extension);
  }
  
  void addExtension(String ext) {
    Integer counter = extensions.get(ext);
    if (counter == null) {
      extensions.put(ext, 1);
    } else {
      extensions.put(ext, counter+1);
    }
  }
  
  int countForExtension(String ext) {
    Integer count = extensions.get(ext);
    return count == null ? 0 : count.intValue();
  }
  
  void printStatsToConsole() {
    println(extensions);
  }
}
