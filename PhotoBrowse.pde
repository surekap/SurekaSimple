// ------------PhotoBrowse ----------------
String[] pb_names = {"00.jpg", "01.jpg", "02.jpg", "03.jpg", "04.jpg", "05.jpg", "06.jpg", "07.jpg", "08.jpg", "09.jpg", "10.jpg"};
PImage pb_imgShadow;
Tile[] pb_tiles;
int pb_selectedTile;
float pb_ANI_TIME = 0.5;
float pb_WIDTH = 112.5;
float pb_HEIGHT = 62.5;

void pb_init(Table config){
  size(1400, 800, OPENGL);
  background(0);
  pb_selectedTile = 0;
  pb_imgShadow = loadImage("pb_shadow.png");
  smooth();
  noStroke();
  Ani.init(this);

  pb_names = split(config.findRow("names", 1).getString(2), ",");
  // Init Tiles
  pb_tiles = new Tile[pb_names.length];
  TableRow tr = null;
  
  for (int i=0; i<pb_tiles.length; i++){
    pb_tiles[i] = new Tile(pb_names[i]);
    tr = config.findRow(pb_tiles[i].fn, 1);
    pb_tiles[i].label = tr.getString(2);
    pb_tiles[i].description = tr.getString(3);
  }
 
  pb_initTiles();
}

void pb_draw(){
  background(0);
  image(pb_tiles[pb_selectedTile].img, 0.25*width, 0, 0.75 * width, 0.75 * height);
  pb_imgShadow.resize(int(0.75*width), int(0.75*height));
  image(pb_imgShadow, 0.25*width, 0, 0.75 * width, 0.75 * height);
  
  textFont(FONT, 32);
  fill(231, 231, 231);
  text(pb_tiles[pb_selectedTile].label, 0.07*width, 0.07*height);
  textSize(16);
  fill(170, 170, 170);
  text(pb_tiles[pb_selectedTile].description, 0.07*width, 0.14*height);
  
  pushMatrix();
  translate(0.1 * width, 0.8 * height);
  
  for (int i=0; i<pb_tiles.length; i++){
    pb_tiles[i].selected = false;
  }
  pb_tiles[pb_selectedTile].selected = true;
  for (int i=0; i<pb_tiles.length; i++){
    pb_tiles[i].drawTile();
  }
  popMatrix();
  
}

void pb_keyPressed(){
  if ((key == DELETE) || (key == BACKSPACE)){
    pb_back();
  }
  
  if (key == CODED){
    if (keyCode == RIGHT){
      pb_right();
    }else if (keyCode == LEFT){
      pb_left();
    }
  }
}

public void pb_initTiles(){
  pb_tiles[0].position.set(0.0 - 0.0, 0.0, 0.0);
  pb_tiles[0].rotationY = 0.0;
  for (int i=1; i<pb_tiles.length; i++ ) {
    pb_tiles[i].position.set(((pb_WIDTH * 2) + 10) * i, 0.0, 0.0);
  }
}

public void pb_moveTiles() {

  // left covers
  for (int i=0; i<pb_selectedTile; i++ ) {
    Ani.to(pb_tiles[i].position, pb_ANI_TIME, "x", - ((2 * pb_WIDTH) + 10)*(pb_selectedTile-i), Ani.CIRC_OUT);
    Ani.to(pb_tiles[i].position, pb_ANI_TIME, "y", 0.0, Ani.CIRC_OUT);
    Ani.to(pb_tiles[i].position, pb_ANI_TIME, "z", 0.0, Ani.CIRC_OUT);
  }

  // central cover
  Ani.to(pb_tiles[pb_selectedTile].position, 0.5, "x", 0.0, Ani.CIRC_OUT);
  Ani.to(pb_tiles[pb_selectedTile].position, pb_ANI_TIME, "y", 0.0, Ani.CIRC_OUT);
  
  // right covers
  for (int i=pb_selectedTile + 1; i<pb_tiles.length; i++ ) {
    Ani.to(pb_tiles[i].position, pb_ANI_TIME, "x",  ((2 * pb_WIDTH) + 10)*(i-pb_selectedTile), Ani.CIRC_OUT);
    Ani.to(pb_tiles[i].position, pb_ANI_TIME, "y", 0.0, Ani.CIRC_OUT);
  }
}

void pb_right(){
  pb_selectedTile++;
  if (pb_selectedTile == pb_names.length){
    pb_selectedTile--;
  }
  pb_moveTiles();
}

void pb_left(){
  pb_selectedTile--;
  if (pb_selectedTile < 0){
    pb_selectedTile++;
  }
  pb_moveTiles();
}

void pb_back(){
  switchBack();
}
