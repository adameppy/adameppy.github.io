String path = "parco/data.csv";
String[] labels;
String[] names;
float[][] values;
float[] max;
float[] min;
float[] lineX;
float lineY;
int numColumns;
int numEntries;
boolean[] axis;
int colorCol = 0;
int lastPress = 0;

float boxx1 = -1;
float boxx2 = -1;
float boxy1 = -1;
float boxy2 = -1;
float startx;
float starty;
float endx;
float endy;

boolean dragging;

//ArrayList<Integer> hoverList = new ArrayList<Integer>();


void loadString() {
  String[] lines = loadStrings(path);
  String[] firstline = split(lines[0], ",");
  labels = new String[firstline.length-1];
  for (int i = 1; i<firstline.length; i++){
	labels[i-1] = firstline[i];
  }
  numColumns = labels.length;
  numEntries = lines.length-1;
  names = new String[numEntries];
  values = new float[numColumns][numEntries];
  min = new float[numColumns];
  max = new float[numColumns];
  axis = new boolean[numColumns];
  lineX = new float[numColumns];

  for(int i = 0; i<numColumns; i++){
	min[i] = 10000000000;
	max[i] = -10000000000;
  }

  for (int i = 1; i<=numEntries; i++) {
    String[] row = split(lines[i], ",");
    names[i-1] = row[0];
    for (int j=1; j<=numColumns; j++) {
      float value = parseFloat(row[j]);
      if (value > max[j-1]) {
        max[j-1] = value;
      }
      if (value < min[j-1]) {
        min[j-1] = value;
      }
      values[j-1][i-1] = value;
    }
  }
}

void drawAxis() {

  strokeWeight(7);
  stroke(0, 0, 0);
  lineY = height/5;
  for (int i = 0; i<numColumns; i++) {
    float x = lerp(width/10.0, 9*width/10.0, i/(float)(numColumns-1));
    line(x, .9*height/5, x, 4*height/5);
    lineX[i] = x;

    fill(0, 0, 0);
    textAlign(CENTER, CENTER);
    textSize(15);
    float y = .6*height/5;

    text(labels[i], x, y);
    float twidth = textWidth(labels[i]);
    float theight = 15;
    if( mouseX>x-twidth/2 && mouseX<x+twidth/2 && mouseY>y-theight/2 && mouseY<y+theight/2 && mousePressed && !dragging){
      colorCol = i;
    }
    
    if (MouseInsideLine(x, .9*height/5, x, 4*height/5, .5) && mousePressed && lastPress>30 && !dragging){
      lastPress = 0;
      axis[i] = !axis[i];
    }
    
    
    
    textSize(12);
    if (!axis[i]) {
      text(min[i], x, .8*height/5);
      text(max[i], x, 4.1*height/5);
    } else {
      text(max[i], x, .8*height/5);
      text(min[i], x, 4.1*height/5);
    }
  }
}

void drawLines() {

  color from = color(0, 0, 255);
  color to = color(255, 0, 0);
  strokeWeight(3);
  for (int i = 0; i<numEntries; i++) {
    color linec = lerpColor(from, to, (values[colorCol][i]-min[colorCol])/(max[colorCol]-min[colorCol]));
    stroke(linec);

    boolean highlighted = false;
    for (int j=0; j<numColumns-1; j++) {

      float xFrom = lineX[j];
      float xTo = lineX[j+1];
      float yFrom;
      float yTo;
      if (!axis[j]){
        yFrom = lerp(.9*height/5, 4*height/5, (values[j][i]-min[j])/(max[j]-min[j]));
      }else{
        yFrom = lerp(4*height/5, .9*height/5, (values[j][i]-min[j])/(max[j]-min[j]));
      }
      if(!axis[j+1]){
        yTo = lerp(.9*height/5, 4*height/5, (values[j+1][i]-min[j+1])/(max[j+1]-min[j+1]));
      } else{
        yTo = lerp(4*height/5, .9*height/5, (values[j+1][i]-min[j+1])/(max[j+1]-min[j+1]));
      }

      if (MouseInsideLine(xFrom, yFrom, xTo, yTo, .6) && !highlighted) {
        highlighted = true;
        //hoverList.add(i);
        j = -1;
      }
      
      if (lineInsideBox(xFrom, yFrom, xTo, yTo) && !highlighted){
        highlighted = true;
        j = -1;
      }
      stroke(linec);
      line(xFrom, yFrom, xTo, yTo);
      if (highlighted){
        stroke(255, 255, 0);
        line(xFrom, yFrom, xTo, yTo);
      }
    }
  }
}

boolean MouseInsideLine(float x1, float y1, float x2, float y2, float tolerance) {
  double totaldist = Math.sqrt(Math.pow(x1-x2, 2)+Math.pow(y1-y2, 2));
  double aToMouse = Math.sqrt(Math.pow(x1-mouseX, 2)+Math.pow(y1-mouseY, 2));
  double bToMouse = Math.sqrt(Math.pow(x2-mouseX, 2)+Math.pow(y2-mouseY, 2));

  double distance = Math.abs(totaldist-aToMouse-bToMouse);
  return (distance<tolerance);
}

boolean linesIntersect(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {

  // calculate the direction of the lines
  float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
  float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
  
  return (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1);
}

boolean lineInsideBox(float x1, float y1, float x2, float y2){
  
  boolean c1 = linesIntersect(x1, y1, x2, y2, boxx1, boxy1, boxx1, boxy2);
  boolean c2 = linesIntersect(x1, y1, x2, y2, boxx1, boxy1, boxx2, boxy1);
  boolean c3 = linesIntersect(x1, y1, x2, y2, boxx2, boxy2, boxx1, boxy2);
  boolean c4 = linesIntersect(x1, y1, x2, y2, boxx2, boxy2, boxx2, boxy1);
  
  return (c1 || c2 || c3 || c4);
}

void drawBox(){
  rectMode(CORNERS);
  noFill();
  strokeWeight(2);
  if (!mousePressed){
    dragging = false;  
  } else if (mousePressed && !dragging){
    boxx1 = mouseX;
    boxy1 = mouseY;
    boxx2 = mouseX;
    boxy2 = mouseY;
    dragging = true;
  }else{
    boxx2 = mouseX;
    boxy2 = mouseY;
    rect(boxx1, boxy1, boxx2, boxy2);
  }
  
  
}


void setup() {
  size(1000, 500);
  loadString();
}

void draw() {
  //hoverList.clear();
  background(255, 255, 255);
  drawLines();
  drawAxis();
  drawBox();
  
 
  lastPress++;
  
  textSize(12);
  textAlign(LEFT, CENTER);
  text("To change colors, click column label. To flip dimension orientation, click axis." , 5,height-10);
}