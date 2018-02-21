String path = "bars/data.csv";
String xName;
String yName;
String[] names;
int[] values;
int max = 0;
int min = 0;
float lineX;
float lineY;
boolean bar = true;
boolean transitioning = false;
float barsize = 100;
float linesize = 0;


void loadTable(){
  String[] lines = loadStrings(path);
  String[] firstLine = split(lines[0], ",");
  xName = firstLine[0];
  yName = firstLine[1];
  names = new String[lines.length - 1];
  values = new int[lines.length - 1];
  
  for(int i = 1; i<lines.length; i++){
    String[] row = split(lines[i], ",");
    names[i-1] = row[0];
    int value = (int) parseFloat(row[1]);
    if (value > max){
      max = value;
    } else if (value < min){
      min = value;
    }
    values[i-1] = value;
  }
  
}

void drawBars(){
  for(int i=0; i<names.length; i++){
    float x = lerp(1.5*lineX, 9*lineX, i/(float)names.length);
    textAlign(CENTER);
    fill(0,0,0);
    text(names[i], x, 4.25*lineY);
    
    strokeWeight(2);
    
    float y = lerp(4*lineY,lineY, (values[i]-min)/(float)(max-min));
    rect(x-lineX/10, y, x+lineX/10, 4*lineY);
    
  }
}

void drawLines(){
  for(int i=0; i<names.length; i++){
    float x = lerp(1.5*lineX, 9*lineX, i/(float)names.length);
    textAlign(CENTER);
    fill(0,0,0);
    text(names[i], x, 4.25*lineY);
    
    strokeWeight(2);
    
    float y = lerp(4*lineY,lineY, (values[i]-min)/(float)(max-min));
    rect(x-lineX/20, y-lineX/20, x+lineX/20, y+lineX/20, lineX/20);
    
    if (i<names.length-1){
      float nextY = lerp(4*lineY,lineY, (values[i+1]-min)/(float)(max-min));
      float nextX = lerp(1.5*lineX, 9*lineX, (i+1)/(float)names.length);
      strokeWeight(3);
      line(x, y, nextX, nextY);
      strokeWeight(2);
      
    }
  }
}

void drawButton(){
   strokeWeight(2);
   fill(119,158,203);
   rect(8*lineX, .3*lineY, 9*lineX, .8*lineY);
   fill(0,0,0);
   textAlign(CENTER,CENTER);
   text("Transform", 8.5*lineX, .55*lineY);
   
   if(!transitioning && mousePressed && mouseX > 8*lineX && mouseX<9*lineX && mouseY>.3*lineY && mouseY<.8*lineY){
     transitioning = true;
     bar = !bar;
   }
   
}

void doTransition(){
  for(int i=0; i<names.length; i++){
        float x = lerp(1.5*lineX, 9*lineX, i/(float)names.length);
        textAlign(CENTER);
        fill(0,0,0);
        text(names[i], x, 4.25*lineY);
  }
  
  if (!bar){
    if (barsize>10){
      for(int i=0; i<names.length; i++){
        float x = lerp(1.5*lineX, 9*lineX, i/(float)names.length);
        fill(0,0,0);
        
        strokeWeight(2);
        barsize-=.1;
        float y = lerp(4*lineY,lineY, (values[i]-min)/(float)(max-min));
        float bottom = lerp(y, 4*lineY, barsize/100.0);
        rect(x-lineX/10, y, x+lineX/10, bottom);
      }
    } else if (barsize<=10 && linesize<100){
      for(int i=0; i<names.length; i++){
        float x = lerp(1.5*lineX, 9*lineX, i/(float)names.length);
        strokeWeight(2);
        
        linesize+=.1;
        float y = lerp(4*lineY,lineY, (values[i]-min)/(float)(max-min));
        float radius = lerp(0, lineX/20, linesize/100.0);
        rect(x-lineX/20, y-lineX/20, x+lineX/20, y+lineX/20, radius);
        
        if (i<names.length-1){
          float nextY = lerp(4*lineY,lineY, (values[i+1]-min)/(float)(max-min));
          float nextX = lerp(1.5*lineX, 9*lineX, (i+1)/(float)names.length);
          
          float lx = lerp(x, nextX, linesize/100.0);
          float ly = lerp(y, nextY, linesize/100.0);
          
          strokeWeight(3);
          line(x, y, lx, ly);
          strokeWeight(2);
      
        }
      }
    } else{
      transitioning = false;
      drawLines();
    }
  }else{
    if(linesize>0){
      for(int i=0; i<names.length; i++){
        float x = lerp(1.5*lineX, 9*lineX, i/(float)names.length);
        strokeWeight(2);
        
        linesize-=.1;
        float y = lerp(4*lineY,lineY, (values[i]-min)/(float)(max-min));
        float radius = lerp(0, lineX/20, linesize/100.0);
        rect(x-lineX/20, y-lineX/20, x+lineX/20, y+lineX/20, radius);
        
        if (i<names.length-1){
          float nextY = lerp(4*lineY,lineY, (values[i+1]-min)/(float)(max-min));
          float nextX = lerp(1.5*lineX, 9*lineX, (i+1)/(float)names.length);
          
          float lx = lerp(x, nextX, linesize/100.0);
          float ly = lerp(y, nextY, linesize/100.0);
          
          strokeWeight(3);
          line(x, y, lx, ly);
          strokeWeight(2);
      }
     }
    } else if (linesize<=0 && barsize<100){
      for(int i=0; i<names.length; i++){
        float x = lerp(1.5*lineX, 9*lineX, i/(float)names.length);
        fill(0,0,0);
        
        strokeWeight(2);
        barsize+=.1;
        float y = lerp(4*lineY,lineY, (values[i]-min)/(float)(max-min));
        float bottom = lerp(y, 4*lineY, barsize/100.0);
        rect(x-lineX/10, y, x+lineX/10, bottom);
      }
    } else{
      transitioning = false;
      drawBars();
    }
  }
  
}

void mouseHover(){
  if (bar){
    for(int i=0; i<names.length; i++){
      float x = lerp(1.5*lineX, 9*lineX, i/(float)names.length);
      float y = lerp(4*lineY,lineY, (values[i]-min)/(float)(max-min));
      if(mouseX > x-lineX/10 && mouseX<x+lineX/10 && mouseY>y-15 && mouseY<4.05*lineY){
        fill(0,0,255);
        rect(x-lineX/10, y, x+lineX/10, 4*lineY);
        fill(255,255,255);
        float twidth = textWidth("(" + names[i] + ", " + values[i] + ")");
        rect(mouseX+15,mouseY,mouseX+25+twidth,mouseY+lineY/5+5);
        textAlign(LEFT, CENTER);
        fill(0,0,0);
        text("(" + names[i] + ", " + values[i] + ")", mouseX + 20, mouseY+lineY/10);
      }
    }
  } else{
    for(int i=0; i<names.length; i++){
      float x = lerp(1.5*lineX, 9*lineX, i/(float)names.length);
      float y = lerp(4*lineY,lineY, (values[i]-min)/(float)(max-min));
      if(mouseX > x-lineX/20 && mouseX<x+lineX/20 && mouseY>y-15 && mouseY<y+15){
        fill(0,0,255);
        rect(x-lineX/20, y-lineX/20, x+lineX/20, y+lineX/20, lineX/20);
        fill(255,255,255);
        float twidth = textWidth("(" + names[i] + ", " + values[i] + ")");
        rect(mouseX+15,mouseY,mouseX+25+twidth,mouseY+lineY/5+5);
        textAlign(LEFT, CENTER);
        fill(0,0,0);
        text("(" + names[i] + ", " + values[i] + ")", mouseX + 20, mouseY+lineY/10);
      }
    }
  }
}


void setup(){
  size(1000,500);
  loadTable();
}

void draw(){
  background(255,255,255);
  strokeWeight(7);
  lineX = width/10;
  lineY = height/5;
  line(width/10,.9*height/5,width/10,4*height/5);
  line(width/10,4*height/5, 9*width/10,4*height/5);
  rectMode(CORNERS);
  
  textAlign(CENTER);
  textSize(30);
  text(xName, width/2, 9.5*height/10);
  
  float nameX = .35*lineX;
  float nameY = .5*height;
  pushMatrix();
  translate(nameX,nameY);
  rotate(-HALF_PI);
  translate(-nameX,-nameY);
  text(yName, nameX,nameY);
  popMatrix();
 
  textSize(15);
  
  for(int i=0; i<=10; i++){
    float textY = lerp(4*lineY,lineY, i/10);
    textAlign(RIGHT);
    text(Math.round((i/10.0) * (max-min) + min), .9*lineX, textY);
  }
  
  drawButton();
  if (!transitioning){
    if(bar){
      drawBars();
    }else{
      drawLines();
    }
    mouseHover();
  } else{
    doTransition();
  }
  
}