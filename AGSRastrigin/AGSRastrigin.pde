import grafica.*;

float x;
float bx;
float by;

float bPlayX;
float bPlayY;

final int boxSize = 50;
boolean overBox = false;
boolean overPButton = false;
boolean locked = false;
boolean iterar =false;
boolean play = false;
int generacion;
GPlot plotSol;
GPointsArray soluciones, solReal;  
//Definicion de las poblaciones que se construran con estos tres tipos de codificacion  

final int numero_de_individuos=100; //Tamaño de la poblacion
final int dimension = 10; //Hablando de la funcion de rastrigin

UnaSolReal unaSolReal = new UnaSolReal(numero_de_individuos,dimension,0.1,0.4,-5.12f,5.12f);

void setup() {
  fullScreen();
  background(200);
  
  bx=10;
  by=displayHeight-60;
  
  bPlayX= boxSize + 10 + bx;
  bPlayY=displayHeight-60;
  
  generacion=0;
  print("Generación: " + generacion + ", ");
  println("Mejor solucion: " + unaSolReal.getPob().getMatFitness()[unaSolReal.getPob().elPeor()]);
  
  //********************************* PLOT ******************************
  //Add a second plot
  
  plotSol=new GPlot(this, 5, 5, displayWidth-100, displayHeight-300);
  plotSol.setTitleText("Evolucion de las soluciones");
  plotSol.getXAxis().setAxisLabelText("Generación");
  plotSol.getXAxis().setTicksSeparation(1.0);
  plotSol.getYAxis().setAxisLabelText("Mejor fitness");
  plotSol.drawGridLines(GPlot.BOTH);
  
  solReal = new GPointsArray();
  solReal.add(generacion, (float)unaSolReal.getPob().getMatFitness()[unaSolReal.getPob().getElPeor()] );
  plotSol.setPoints(solReal);
  plotSol.setPointSize(5);
  plotSol.setPointColor(-10000000);

}

void draw(){
  
  background(200);
  //****************************************************** BUTTON Una Generacion ********************************
  if (mouseX > bx && mouseX < bx+boxSize && 
    mouseY > by && mouseY < by+boxSize) {
    overBox = true;  
    if (!locked) { 
      stroke(255); 
      fill(153);
    }
  } else {
    stroke(153);
    fill(153);
    overBox = false;
  }
  
  rect(bx, by, boxSize, boxSize);
  stroke(255);
  triangle(bx+10,by+10, bx+10,by+40,bx+35,by+25);
  triangle(bx+20,by+10, bx+20,by+40,bx+45,by+25);
  //****************************************************** BUTTON Una Generacion ********************************   
  
  //****************************************************** BUTTON Play/Pause ********************************
  if (mouseX > bPlayX && mouseX < bPlayX+boxSize && 
    mouseY > bPlayY && mouseY < bPlayY+boxSize) {
    overPButton = true;  
    if (!locked) { 
      stroke(255); 
      fill(153);
    }
  } else {
    stroke(153);
    fill(153);
    overPButton = false;
  }
  
  rect(bPlayX, bPlayY, boxSize, boxSize);
  
  stroke(255);
  triangle(bPlayX+10,bPlayY+10, bPlayX+10,bPlayY+40,bPlayX+35,bPlayY+25);
  
  //****************************************************** BUTTON Play/Pause ********************************
  
  //****************************************************** BUTTON RESET ********************************
  //****************************************************** BUTTON RESET ********************************
  
  //**************************************************** PLOT 2 *********************************
  plotSol.beginDraw();
  plotSol.drawBackground();
  plotSol.drawBox();  
  plotSol.drawXAxis();
  plotSol.drawYAxis();
  plotSol.drawTitle();  
  plotSol.drawGridLines(GPlot.BOTH);
  plotSol.getMainLayer().drawPoints();
  plotSol.getMainLayer().drawLines();
  plotSol.endDraw();
  //**************************************************** PLOT 2 *********************************
  
  //Cuando iteraccon == true debido al boton, entonce, se calcula una nueva generacion y se
  //Grafican los puntos en el segundo plot
  if (iterar) {    
    generacion++;
    print("Generacion: "+generacion + ", ");   
    println("Mejor solucion: " + unaSolReal.getPob().getMatFitness()[unaSolReal.getPob().elPeor()]);
    ////Next generation
    unaSolReal.nextGen();
    
    ////*************************************************************************************
    
    solReal.add(generacion, (float)unaSolReal.getPob().getMatFitness()[unaSolReal.getPob().getElPeor()] );
    plotSol.setPoints(solReal);

    iterar = false;
  }else if(play){
    generacion++;
    print("Generacion: "+generacion + ", ");   
    println("Mejor solucion: " + unaSolReal.getPob().getMatFitness()[unaSolReal.getPob().elPeor()]);
    ////Next generation
    unaSolReal.nextGen();
    
    ////*************************************************************************************
    
    solReal.add(generacion, (float)unaSolReal.getPob().getMatFitness()[unaSolReal.getPob().getElPeor()] );
    plotSol.setPoints(solReal);
    delay(150);
  }
}

void mousePressed() {  
  if (overBox) { 
    locked = true; 
    fill(255, 255, 255);
    iterar=true;
  } else {
    locked = false;
  }
  
  if (overPButton) { 
    locked = true; 
    fill(255, 255, 255);
    play=!play;
  } else {
    locked = false;
  }
}

void mouseReleased() {
  locked = false;
}

private void dibujarSig(){
}