// ----------- CoverFlow ------------------
Cover[] cf_covers;
String[] cf_names = {"00.jpg", "01.jpg", "02.jpg", "03.jpg", "04.jpg", "05.jpg", "06.jpg", "07.jpg", "08.jpg", "09.jpg", "10.jpg"};
PImage cf_imgMask;
PImage cf_imgShadow;   
Ani cf_coverAnimation;
int cf_selectedCover;
float cf_ANI_TIME = 0.5;
PImage cf_bg;

void cf_init(Table config){
  cf_selectedCover = 0;
  cf_bg = loadImage("cf_bg.jpg");
  smooth();
  noStroke();

  cf_imgMask = loadImage("mask.png");
  cf_imgShadow = loadImage("shadow.png");
  
  cf_names = split(config.findRow("names", 1).getString(2), ",");
  
  TableRow tr = null;
  
  // Init covers
  cf_covers = new Cover[cf_names.length];
  
  for (int i=0; i<cf_covers.length; i++ ) {
    cf_covers[i] = new Cover(cf_names[i]);
    
    tr = config.findRow(cf_covers[i].fn, 1);
    
    cf_covers[i].label = tr.getString(2);
    cf_covers[i].url = tr.getString(3);
  }
  
  cf_initCovers();
}

public void cf_draw() {
  //background(0);
  image(cf_bg, 0, 0, width, height);
  
  hint(ENABLE_DEPTH_TEST);
  
  // move to the center to have easier coordinates
  pushMatrix();
  translate(width / 2, height / 2);
  for( int i=0; i<cf_covers.length; i++ ) {
    cf_covers[i].drawCover();
  }
  
  popMatrix();  

  // disable depth test to draw control interface on top of everything
  hint(DISABLE_DEPTH_TEST);
  cf_imgShadow.resize(width, height);
  image(cf_imgShadow, 0.0, 0.0);
  
  textFont(FONT, 20);
  textAlign(CENTER);
  fill(255, 255, 255);
  text(cf_covers[cf_selectedCover].label, width/2, height/10);
  
}

void cf_keyPressed(){
  if ((key == ENTER) || (key == RETURN)){
    cf_enter();
  }
  
  if ((key == DELETE) || (key == BACKSPACE)){
    cf_back();
  }
  
  if (key == CODED){
    if (keyCode == RIGHT){
      cf_right();
    }else if (keyCode == LEFT){
      cf_left();
    }
  }
  
}

void cf_back(){
  switchBack();
}

void cf_enter(){
  activateLink(cf_covers[cf_selectedCover].url);
}

void cf_left(){
  cf_selectedCover--;
  if (cf_selectedCover < 0){
    cf_selectedCover++;
  }
  cf_moveCovers();
}

void cf_right(){
  cf_selectedCover++;
  if (cf_selectedCover == cf_names.length){
    cf_selectedCover--;
  }
  cf_moveCovers();
}

public void cf_initCovers() {
  cf_covers[0].position.set(0.0 - 0.0, 0.0, 75.0);
  cf_covers[0].rotationY = 0.0;
  for (int i=1; i<cf_covers.length; i++ ) {
    cf_covers[i].position.set(150.0 + 25.0*i, 0.0, 0.0);
    cf_covers[i].rotationY = -QUARTER_PI;
  }
}

public void cf_moveCovers() {

  // left covers
  for (int i=0; i<cf_selectedCover; i++ ) {
    Ani.to(cf_covers[i].position, cf_ANI_TIME, "x", -150.0 - 25.0*(cf_selectedCover-i), Ani.CIRC_OUT);
    Ani.to(cf_covers[i].position, cf_ANI_TIME, "y", 0.0, Ani.CIRC_OUT);
    Ani.to(cf_covers[i].position, cf_ANI_TIME, "z", 0.0, Ani.CIRC_OUT);
    Ani.to(cf_covers[i], cf_ANI_TIME, "rotationY", QUARTER_PI, Ani.CIRC_OUT);
  }

  // central cover
  cf_coverAnimation = Ani.to(cf_covers[cf_selectedCover].position, 0.5, "x", 0.0, Ani.CIRC_OUT);
  Ani.to(cf_covers[cf_selectedCover].position, cf_ANI_TIME, "y", 0.0, Ani.CIRC_OUT);
  Ani.to(cf_covers[cf_selectedCover].position, cf_ANI_TIME, "z", 75.0, Ani.CIRC_OUT);
  Ani.to(cf_covers[cf_selectedCover], cf_ANI_TIME, "rotationY", 0.0, Ani.CIRC_OUT);

  // right covers
  for (int i=cf_selectedCover + 1; i<cf_covers.length; i++ ) {
    Ani.to(cf_covers[i].position, cf_ANI_TIME, "x", 150.0 + 25.0*(i-cf_selectedCover), Ani.CIRC_OUT);
    Ani.to(cf_covers[i].position, cf_ANI_TIME, "y", 0.0, Ani.CIRC_OUT);
    Ani.to(cf_covers[i].position, cf_ANI_TIME, "z", 0.0, Ani.CIRC_OUT);
    Ani.to(cf_covers[i], cf_ANI_TIME, "rotationY", -QUARTER_PI, Ani.CIRC_OUT);
  }
}


