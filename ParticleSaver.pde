// Noise Field
// Particle trails via Perlin noise. 
// Move mouse to change particle motion. 
// Click to randomize parameters.
// Built with Processing.js (processingjs.org)
// by Felix Turner (airtightinteractive.com)

int numParticles;
float fadeAmount;
float maxLen = 100;
float strokeAmount;

Particle[] particles;
int FIELDWIDTH = 800;
int FIELDHEIGHT = 600;

void ps_init(Table c){
  ps_init();
}

void ps_init() {
  
  colorMode(HSB, 100);
  background(0);  
  ps_randomize();
}

void ps_randomize(){
  numParticles = int(random(50,500));
  fadeAmount = random(.5,20);
  maxLen = random(30,200);
  strokeAmount = random(0.02,0.3);
  particles = new Particle[numParticles];
  
  //FIELDWIDTH = width;
  //FIELDHEIGHT = height;
  
  for(int i=0; i<numParticles; i++){
    particles[i]=new Particle(i/5000.0);
  }
}

void ps_keyPressed() {
  if ((key == DELETE) || (key == BACKSPACE)){
    ps_back();
  }else{
    ps_randomize();
  }
}

void ps_draw() {
  
  noStroke();
  fill(0,fadeAmount);
  rect(0,0,width,height);//fade background

  translate((width- FIELDWIDTH)/2,(height- FIELDHEIGHT)/2);
    for(int i=0; i<numParticles; i++){
    particles[i].update();//render particles
  } 

}

void ps_back(){
  switchBack();
}

void ps_pause(){
  numParticles = 0;
}

class Particle {
  float id,x,y,xp,yp,s,d,sColor,len,z,zp;
 
  Particle(float _id) {
    id=_id;
    init();
  }

  void init(){
    x=xp=random(0,FIELDWIDTH);
    y=yp=random(0,FIELDHEIGHT);
    z=zp=0;
    s=random(2,7);
    sColor = map(x,0,FIELDWIDTH,0,100);
      len = random(1,maxLen-1);
  }
 
  void update(){
 
    id+=0.01;

    if (mouseY == 0|| mouseX == 0){
      mouseY = 1;
      mouseX = 1;      
    }

    d=(noise(id,x/mouseY,y/mouseY)-0.5)*mouseX;  
    
    x+=cos(radians(d))*s;
    y+=sin(radians(d))*s;
  
    strokeWeight((maxLen - len)*strokeAmount);
    stroke(sColor,80,90);
    line(xp,yp,x,y);
    xp=x;
    yp=y;
    len++;
    if (len >= maxLen) init();
  }
}
