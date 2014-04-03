
// ------------- VideoApp -----------------

String va_videoFile, va_description, va_url;
Movie va_m;
int va_status = 0;
PImage va_overlay;
PImage va_qr;
int va_QRSIZE = 100;

float va_height, va_width, va_top = -1.0;

void va_init(Table config){
  
  va_overlay = loadImage("black.gif");
  va_videoFile = config.findRow("video", 1).getString(2);
  va_description = config.findRow("description", 1).getString(2);
  va_url = config.findRow("url", 1).getString(2);
  background(0);
  String last = CURRENT_APP.remove(CURRENT_APP.size()-1);
  String path = join(CURRENT_APP.array(), "/");
  CURRENT_APP.append(last);
  va_m = new Movie(this, path + "/" + va_videoFile);
  
  if (va_url.length() > 0){
    va_qr = loadImage(path + "/" + "qr_" + va_videoFile.substring(0, va_videoFile.length() - 4) + ".png");
    //va_qr.resize(va_QRSIZE, va_QRSIZE);
  }
  
  va_m.loop();
}

String va_totime(float ss){
  int h = int(ss/60/60);
  int m = int((ss - (h * 60))/60);
  int s = int((ss - (h * 60)) - (m * 60));
  return nf(h, 2) + ":" + nf(m, 2) + ":" + nf(s, 2);
}

void va_draw(){
  if (va_top == -1){
    va_width = va_m.width;
    va_height = va_m.height;
    va_height = (width/va_width) * va_height;  // Adjust the size
    va_top = (height - va_height)/2.0;
  }
  
  image(va_m, 0, va_top, width, va_height);
  
  if (va_qr != null){
      blend(va_qr, 0, 0, va_QRSIZE, va_QRSIZE, width - va_QRSIZE - 50, 50, va_QRSIZE, va_QRSIZE, HARD_LIGHT);
  }
    
  if (va_status == 1){
    blend(va_overlay, 0, 0, width, int(0.3 * height), 0, int(0.7 * height), width, int(0.3 * height), OVERLAY);
    textFont(FONT, 20);
    textAlign(LEFT);
    fill(255, 255, 255);
    text(va_totime(va_m.time()) + " / " + va_totime(va_m.duration()), width/20.0, (0.78) * height);
    StringList a = wordWrap(va_description, int(width * 0.9));
    String t = null;
    for (int i=0; i<a.size(); i++){
      t = a.get(i);
      text(t, width/20.0, ((0.85) * height) + (i * 25));
    }
    
    
  }
}

void movieEvent(Movie m) {
  m.read();
}

void va_keyPressed(){
  
  if ((key == ENTER) || (key == RETURN) || (key == ' ') || (keyCode == 32)){
    va_enter();
  }
  
  if ((key == DELETE) || (key == BACKSPACE)){
    va_back();
  }
  
  if (key == CODED){
    if (keyCode == RIGHT){
      va_right();
    }else if (keyCode == LEFT){
      va_left();
    }
  }
  
}


void va_enter(){
  if (va_status == 0){
    va_m.pause();
    va_status = 1;      
  }else if (va_status == 1){
    va_m.play();
    va_status = 0;
  }
}

void va_back(){
  va_m.stop();
  switchBack();
}

void va_right(){
  va_m.jump(min(va_m.time() + 10.0, va_m.duration()));   // Jump Forward 10s
}

void va_left(){
  va_m.jump(max(va_m.time() - 10.0, 0));    // Jump Back 10s
}
