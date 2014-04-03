// ---------- ImageApp ------------------
String ia_imageFile, ia_description, ia_url;
PImage ia_im;
int ia_status = 0;
float ia_ANI_TIME = 2.0;

void ia_init(Table config){
  ia_imageFile = config.findRow("image", 1).getString(2);
  ia_description = config.findRow("description", 1).getString(2);
  ia_url = config.findRow("url", 1).getString(2);
  background(0);
  String last = CURRENT_APP.remove(CURRENT_APP.size()-1);
  String path = join(CURRENT_APP.array(), "/");
  CURRENT_APP.append(last);
  ia_im = loadImage(path + "/" + ia_imageFile);
  ia_im.resize(0, 0);
  
  Ani.to(ia_im, ia_ANI_TIME, "resize", width, Ani.CIRC_OUT);
}

void ia_draw(){
  background(0);
  imageMode(CENTER);
  image(ia_im, width/2, height/2);
}

void ia_keyPressed(){
  
  if ((key == ENTER) || (key == RETURN) || (key == ' ') || (keyCode == 32)){
    
  }
  
  if ((key == DELETE) || (key == BACKSPACE)){
    ia_back();
  }
  
  if (key == CODED){
    if (keyCode == RIGHT){
      
    }else if (keyCode == LEFT){
      
    }
  }
  
}

void ia_back(){
  switchBack();
}
