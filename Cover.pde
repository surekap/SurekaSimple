/**
 Quick Cover Flow in Processing
 by Adrià Navarro http://adrianavarro.net 
 USING: 3D (openGL), events (controlp5) and animation (ani)
 TODO: image resize, background image loading
 */

/*
 This class is used by the CoverScroll app for the Animation callback 
*/
class CPVector extends PVector{
  
  CPVector(float x, float y, float z){
     super(x, y, z);
  }
  
  public void resetCover(Ani a){
    this.set(int(random(0, width)/(SIZE*2)) * SIZE * 2, height + SIZE, 0.0);
    
    a.pause();
    a.seek(0);
    a.resume();
  }
  
}

class Cover {
  PVector position;
  float rotationY;
  int transparency;
  PImage img;
  boolean reflection;
  String label;
  String url;
  String fn;

  Cover( String name ) {
    this.position = new CPVector(0.0, 0.0, 0.0);
    this.rotationY = 0.0;
    this.transparency = 255;
    this.reflection = true;
    // this.img = resizeImage(loadImage(name));
    this.img = loadImage(join(CURRENT_APP.array(), "/") + "/" + name);
    
    this.fn = name;
  }
  
  public void enableReflection(){
    this.reflection = true;
  }

  public void disableReflection(){
    this.reflection = false;
  }
  
  public boolean isReflected(){
    return this.reflection;
  }
  
  public void drawCover() {

    pushMatrix();
    translate(position.x, position.y, position.z);
    rotateY(rotationY);
    
    // Main quad
    noTint();
    beginShape();
      textureMode(NORMAL);
      texture(img);
      vertex(-SIZE, -SIZE, 0, 0, 0);
      vertex(SIZE, -SIZE, 0, 1, 0);
      vertex(SIZE, SIZE, 0, 1, 1);
      vertex(-SIZE, SIZE, 0, 0, 1);
    endShape();

    if (this.isReflected()){
      // Reflection
      tint(50);
      beginShape();
        textureMode(NORMAL);
        texture(img);
        vertex(-SIZE, SIZE, 0, 0, 1);
        vertex(SIZE, SIZE, 0, 1, 1);
        vertex(SIZE, 3 * SIZE, 0, 1, 0);
        vertex(-SIZE, 3 * SIZE, 0, 0, 0);
      endShape();
    }
    
    noTint();
    popMatrix();
  }

  // Function to call if images are not square
  // Not being used at the moment, might need some tweaking
  public void resizeImage(PImage img) {
    float ratio = 0.0;
    int newWidth = 0;
    int newHeight = 0;

    ratio = (float)img.width / (float)img.height;

    if( ratio > 1 ) {   // img is wider than tall
      newWidth = 255;
      newHeight = (int) (255.0/ratio);
    }
    else {              // img is taller than wide
      newHeight = 255;
      newHeight = (int)(255.0*ratio);
    }
    //println ("width: " + newWidth + "height: " + newHeight + "ratio: " + ratio);
    img.resize(newWidth,newHeight);
  }
  
  // This is used only by the CoverScroll app for periodic image rotation
  public void resetRotateCover(Ani a){
    a.setEnd(0);
    if (int(random(0, 10)) == 5){
      a.setEnd(2*PI);
    }
    a.pause();
    a.seek(0);
    a.resume();
  }
}
