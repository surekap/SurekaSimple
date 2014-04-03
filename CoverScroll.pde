// ----------- CoverScroll ----------------
Cover[] cs_covers;
String[] cs_names = {"00.jpg", "01.jpg", "02.jpg", "03.jpg", "04.jpg", "05.jpg", "06.jpg", "07.jpg", "08.jpg", "09.jpg", "10.jpg"};
float cs_SCROLL_TIME = 10.0f;

void cs_init(Table config){
  
  cs_names = split(config.findRow("names", 1).getString(2), ",");
  // Init covers
  cs_covers = new Cover[cs_names.length];
  for (int i=0; i<cs_covers.length; i++ ) {
    cs_covers[i] = new Cover(cs_names[i]);
    cs_covers[i].disableReflection();
    //covers[i].position.resetCover();
  }
  cs_initCovers();
  
}

void cs_initCovers() {
  
  for (int i=0; i < cs_covers.length; i++ ) {
    
    cs_covers[i].position.set(int(random(0, width)/(SIZE*2)) * SIZE * 2, height + SIZE, 0.0);
    
    Ani a = Ani.to(cs_covers[i].position, cs_SCROLL_TIME, 0.0, "y", -SIZE, Ani.LINEAR, "onEnd:resetCover");
    Ani rot = Ani.to(cs_covers[i], 2.0f, cs_SCROLL_TIME/2.0, "rotationY", 0, Ani.LINEAR, "onEnd:resetRotateCover");
    
    a.pause();
    a.seek(random(0.0, 1.0));
    a.resume();
    //covers[i].rotationY = -QUARTER_PI;
  }
}

public void cs_draw() {
  background(0);
  //hint(ENABLE_DEPTH_TEST);
  
  // move to the center to have easier coordinates
  //pushMatrix();
  //translate(0, height); 
  for( int i=0; i < cs_covers.length; i++ ) {
    cs_covers[i].drawCover();
  }
  
  //popMatrix();  
  
  // disable depth test to draw control interface on top of everything
  //hint(DISABLE_DEPTH_TEST);
  
}

void cs_keyPressed(){
  if ((key == DELETE) || (key == BACKSPACE)){
    cs_back();
  }
}

void cs_back(){
  switchBack();
}
