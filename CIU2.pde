import java.util.ArrayList;

int modocolor =0;

enum State {
  P2D,
  P3D;
}

State dimensionState = State.P2D;
ArrayList<PVector> points;
PVector shapePosition;
PShape object3D;
int multAngle;

void setup(){
  size(1280,720,P3D);
  points = new ArrayList<PVector>();
  shapePosition = new PVector(width/2, height/2);
  multAngle = 10;
}

void draw(){
  background(0);
  
  if (dimensionState == State.P2D){
    drawSplitLine();
    
    PVector last = null;
    for(PVector p : points){
      circle(p.x + width/2,p.y,5);
      if(last != null){
        line(last.x + width/2, last.y, p.x + width/2, p.y);
      }      
      last = p;
    }
    
    textSize(17);
    text("Tecla Enter para ver el modelo 3D \n Tecla espacio para regresar al modelo 2D \n Tecla de borrar para reiniciar \n Con el ratón (Botón izquierdo) colocas los puntos y mueves la figura 3D \n Tecla M para cambiar colores de la figura", 0,17);
    
  } else if (dimensionState == State.P3D){
    translate(shapePosition.x, shapePosition.y - height / 2);
    shape(object3D);
  }
}

void drawSplitLine(){
  if(modocolor==1){
    stroke(255, 0, 0);
    line(width/2,0,width/2,height);
  }else{
    stroke(255, 255, 255);
    line(width/2,0,width/2,height);
  }  
  line(width/2,0,width/2,height);
}

PVector rotatePoint(PVector point){
  PVector result = new PVector(0, 0, 0);
  double r = Math.toRadians(multAngle);
  result.x = (float)(point.x * Math.cos(r) - point.z * Math.sin(r));
  result.z = (float)(point.x * Math.sin(r) + point.z * Math.cos(r));
  result.y = point.y;
  return result;
}

void makeShape(){
  object3D = createShape();
  object3D.beginShape(TRIANGLE_STRIP);
  if (modocolor==0){
    object3D.stroke(255, 255, 255);
  }else{
    object3D.stroke(255, 0, 0);
  }  
  object3D.fill(128, 0, 0);
  double angle = 0;
  
  while (angle < 360){
    ArrayList<PVector> rotated = new ArrayList();
    for (int i = 0; i < points.size(); i++){
      PVector v = points.get(i);
      rotated.add(rotatePoint(v));
    }
    object3D.vertex(rotated.get(0).x, rotated.get(0).y, rotated.get(0).z);
    for (int i = 0; i < rotated.size() - 1; i++){
      object3D.vertex(points.get(i).x, points.get(i).y, points.get(i).z);
      object3D.vertex(rotated.get(i + 1).x, rotated.get(i + 1).y, rotated.get(i + 1).z);
    }
    PVector v = points.get(points.size() - 1);
    object3D.vertex(v.x, v.y, v.z);
    points = rotated;
    angle += multAngle;
  }
  
  object3D.endShape();
}

void drawLine(){
  if (points.isEmpty()) return;
  for(int i = 0; i < points.size() - 1; i++){
    line(width/2 + points.get(i).x, points.get(i).y, width/2 + points.get(i + 1).x, points.get(i + 1).y);
  }
}

void mouseClicked(){
  if(mouseButton == LEFT && mouseX >= width/2 && dimensionState == State.P2D){
    points.add(new PVector(mouseX - width/2,mouseY));
  }
}

void keyPressed(){
  if(keyCode == BACKSPACE){
    object3D = null;
    dimensionState = State.P2D;
    setup();
  }
  
  if(keyCode == ENTER && !points.isEmpty()){
    makeShape();
    dimensionState = State.P3D;
  }
  
  if(key == ' '){
    dimensionState = State.P2D;
  }
  
  if (key == 'm' || key == 'M') {
    if(modocolor==0 ){
      modocolor=1;
    }else{
      modocolor=0;
    
    }
  }
  
}



void mouseDragged(){
  if(mouseButton == LEFT && dimensionState == State.P3D){
    shapePosition.x = mouseX;
    shapePosition.y = mouseY;
  }
}
