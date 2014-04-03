import java.util.Map;
import processing.opengl.*;
import de.looksgood.ani.*;
import processing.video.*;

HashMap<String,Table> CONFIG_CACHE = new HashMap<String,Table>();
int SELECTED = 0;
StringList CURRENT_APP = new StringList();
float SIZE = 200;
PFont FONT;

StringList wordWrap(String s, int maxWidth){
  // Make an empty ArrayList
  StringList a = new StringList();
  float w = 0;    // Accumulate width of chars
  int i = 0;      // Count through chars
  int rememberSpace = 0; // Remember where the last space was
  // As long as we are not at the end of the String
  while (i < s.length()) {
    // Current char
    char c = s.charAt(i);
    w += textWidth(c); // accumulate width
    if (c == ' ') rememberSpace = i; // Are we a blank space?
    if (w > maxWidth) {  // Have we reached the end of a line?
      String sub = s.substring(0,rememberSpace); // Make a substring
      // Chop off space at beginning
      if (sub.length() > 0 && sub.charAt(0) == ' ') sub = sub.substring(1,sub.length());
      // Add substring to the list
      a.append(sub);
      // Reset everything
      s = s.substring(rememberSpace,s.length());
      i = 0;
      w = 0;
    } 
    else {
      i++;  // Keep going!
    }
  }
 
  // Take care of the last remaining line
  if (s.length() > 0 && s.charAt(0) == ' ') s = s.substring(1,s.length());
  a.append(s);
 
  return a;
}

void setup() {
  size(1400, 800, OPENGL);
  background(0);
  rectMode(CENTER);
  FONT = loadFont("ScalaSans-RegularLF-28.vlw");
  Ani.init(this);
  parseConfig();
  
  switchApp("home");
}

void draw(){
  if (SELECTED == 0){
    cf_draw();
  }else if (SELECTED == 1){
    cs_draw();
  }else if (SELECTED == 2){
    va_draw();
  }else if (SELECTED == 3){
    ia_draw();
  }else if (SELECTED == 4){
    pb_draw();
  }
}

void keyPressed(){
  if (SELECTED == 0){
    cf_keyPressed();
  }else if (SELECTED == 1){
    cs_keyPressed();
  }else if (SELECTED == 2){
    va_keyPressed();
  }else if (SELECTED == 3){
    ia_keyPressed();
  }else if (SELECTED == 4){
    pb_keyPressed();
  }

}

void parseConfig(){
  Table config = loadTable("config/config.csv");
  Table t = new Table();
  String lastApp = "";
  for (TableRow row: config.rows()){
    if (((row.getString(0)).length() > 0) && (!row.getString(0).equals(lastApp))){
      // Create new entry
      t = new Table();
      CONFIG_CACHE.put(row.getString(0), t);
    }
    t.addRow(row);
  }
  
}

public void activateLink(String url){
    String[] scheme = split(url, "://");
    if (scheme[0].equals("module")){
      // Switch the app
      String fn = scheme[1];
      switchApp(fn);
    }
}

void switchApp(String fn){
  Table c = CONFIG_CACHE.get(fn);
  String appName = c.findRow("app", 1).getString(2);
  CURRENT_APP.append(fn);
  
  if (appName.equals("CoverFlow")){
    cf_init(c);
    SELECTED = 0;
  }else if (appName.equals("CoverScroll")){
    cs_init(c);
    SELECTED = 1;
  }else if (appName.equals("VideoApp")){
    va_init(c);
    SELECTED = 2;
  }else if (appName.equals("ImageApp")){
    ia_init(c);
    SELECTED = 3;
  }else if (appName.equals("PhotoBrowse")){
    pb_init(c);
    SELECTED = 4;
  }
}

void switchBack(){
  if (CURRENT_APP.size() == 1){
    return;  // Don't do anything if we are already at the home level
  }
  
  CURRENT_APP.remove(CURRENT_APP.size()-1);
  String last_app = CURRENT_APP.remove(CURRENT_APP.size()-1);
  switchApp(last_app);
}

