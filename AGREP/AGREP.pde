import grafica.*;

float x;
float bx;
float by;
final int boxSize = 50;
boolean overBox = false;
boolean locked = false;
boolean iterar =false;
int generacion;
//crea dos instaciias del objeto GPlot
GPlot plotGrafica, plotSol;
GPointsArray points, soluciones, solBin, solGray, solReal;  
//Definicion de las poblaciones que se construran con estos tres tipos de codificacion  

final int numero_de_individuos=4;
final int longitud_de_individuo=5;
final int dominio_de_poblacion=2;

UnaSolCodBin unaSolCodBin=new UnaSolCodBin(numero_de_individuos, longitud_de_individuo, 2);
UnaSolCodGray unaSolCodGray=new UnaSolCodGray(numero_de_individuos, longitud_de_individuo, 2);
//UnaSolCodReal unaSolCodReal = new UnaSolCodReal(numero_de_individuos,longitud_de_individuo,0.1,0.4,-5.12f,5.12f);

void setup() {

  //Tamaño y color de la ventana
  size(1366, 750);
  background(200);
  
  //generacion cuenta la t
  generacion=0;

  //inicioaliza Variables del boton
  //Posicion en X y en Y en el canvas del boton
  bx=10;
  by=640;
  //*************************************************************************************************************
  // Prepara los puntos para la grafica de R1: f(x) = 10 + x^2-10cos(2PIx)
  int nPoints = 1000;
  points = new GPointsArray(nPoints);    
  for (int i = 0; i < nPoints; i++) {
    x=-5.12+0.01024*i;
    points.add(x, 10+pow(x, 2)-10*cos(2*PI*x));
  }   
  //*************************************************************************************************************
  // Prepara los puntos para las gráficas de soluciones encontradas con codificaciones Binaria y de Gray. 
  solBin = new GPointsArray();
  solGray = new GPointsArray();

  //********************************* PLOT 1 ******************************
  // Create a new plot and set its position on the screen
  //This plot is to draw the graphic of f(x)
  plotGrafica = new GPlot(this, 5, 5, 500, 500);

  // Set the plot title and the axis labels
  plotGrafica.setTitleText("Función a optimizar");
  plotGrafica.getXAxis().setAxisLabelText("x");
  plotGrafica.getYAxis().setAxisLabelText("Fitness");

  plotGrafica.setPoints(points);       

  //Create points which are the possible solutions in generation = 0
  soluciones = new GPointsArray(2);
  x=(float)unaSolCodBin.getPob().getMatValorReal()[unaSolCodBin.getPob().getElPeor()]; 
  soluciones.add(0, new GPoint(x, 10+pow(x, 2)-10*cos(2*PI*x)));  //!!!!!!!!!!!!!!!! Possible double calculation !!!!!!!!!!!!!!!!!!!!!
  x=(float)unaSolCodGray.getPob().getMatValorReal()[unaSolCodGray.getPob().getElPeor()];
  soluciones.add(1, new GPoint(x, 10+pow(x, 2)-10*cos(2*PI*x)));  //!!!!!!!!!!!!!!!! Possible double calculation !!!!!!!!!!!!!!!!!!!!!

  //Add a new layer to draw the solutions
  plotGrafica.addLayer("sol", soluciones);
  plotGrafica.getLayer("sol").setPointSize(5);
  
  //********************************* PLOT 2 ******************************
  //Add a second plot
  
  plotSol=new GPlot(this, 510, 5, 700, 240);
  
  //Adds plot's name, X-Axis and Y-Axis labels.
  plotSol.setTitleText("Evolucion de las soluciones");
  plotSol.getXAxis().setAxisLabelText("Generación");
  plotSol.getXAxis().setTicksSeparation(1.0);
  //plotSol.getYAxis().setTicksSeparation(1.0);
  plotSol.getYAxis().setAxisLabelText("Mejor fitness");
  //Draws grid to the plot.
  plotSol.drawGridLines(GPlot.BOTH);

  //
  solBin = new GPointsArray();  
  solBin.add(generacion, (float)unaSolCodBin.getPob().getMatFitness()[unaSolCodBin.getPob().getElPeor()] );  
  plotSol.setPoints(solBin);  
  plotSol.setPointSize(5);

  solGray= new GPointsArray();
  solGray.add(generacion, (float)unaSolCodGray.getPob().getMatFitness()[unaSolCodGray.getPob().getElPeor()] );
  plotSol.addLayer("gray", solGray);
  plotSol.getLayer("gray").setPointSize(5);
  plotSol.getLayer("gray").setPointColor(-10000000);
}


void draw() {

  
  background(200);
  //****************************************************** START BUTTON ********************************
  if (mouseX > bx-boxSize && mouseX < bx+boxSize && 
    mouseY > by-boxSize && mouseY < by+boxSize) {
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
  //****************************************************** FINISH BUTTON ********************************

  //**************************************************** START PLOT 1 *********************************
  plotGrafica.beginDraw();
  plotGrafica.drawBackground();
  plotGrafica.drawBox();
  plotGrafica.drawXAxis();
  plotGrafica.drawYAxis();
  plotGrafica.drawTitle();
  plotGrafica.getMainLayer().drawLines();
  plotGrafica.getLayer("sol").drawPoints();
  for (int i=0; i<2; i++) {
    plotGrafica.getLayer("sol").drawLine(soluciones.get(i), new GPoint(soluciones.getX(i), 0), 0, 1);
  }  
  plotGrafica.endDraw();
  //**************************************************** FINISH PLOT 1 *********************************
  
  //**************************************************** START PLOT 2 *********************************
  plotSol.beginDraw();
  plotSol.drawBackground();
  plotSol.drawBox();  
  plotSol.drawXAxis();
  plotSol.drawYAxis();
  plotSol.drawTitle();  
  plotSol.drawGridLines(GPlot.BOTH);
  plotSol.getMainLayer().drawPoints();
  plotSol.getMainLayer().drawLines();
  plotSol.getLayer("gray").drawPoints();
  plotSol.getLayer("gray").drawLines();  
  plotSol.endDraw();
  //**************************************************** FINISH PLOT 2 *********************************
  
  //If iterar == TRUE then creates a new generation
  if (iterar) {    
    generacion++;
    println("Generacion: "+generacion);    
    //Next generation
    unaSolCodBin.nextGen();
    unaSolCodGray.nextGen();
    //*************************************************************************************
    //Borra las soluciones antiguas y añade las nuevas
    soluciones.removeRange(0, 2);
    x=(float)unaSolCodBin.getPob().getMatValorReal()[unaSolCodBin.getPob().getElPeor()];
    plotGrafica.getLayer("sol").removePoint(0);
    soluciones.add(0, new GPoint(x, 10+pow(x, 2)-10*cos(2*PI*x)));
    x=(float)unaSolCodGray.getPob().getMatValorReal()[unaSolCodGray.getPob().getElPeor()];
    plotGrafica.getLayer("sol").removePoint(0);
    soluciones.add(1, new GPoint(x, 10+pow(x, 2)-10*cos(2*PI*x)));
        
    plotGrafica.getLayer("sol").addPoints(soluciones);
    
    solBin.add(generacion, (float)unaSolCodBin.getPob().getMatFitness()[unaSolCodBin.getPob().getElPeor()] );  
    plotSol.setPoints(solBin);  
    solGray.add(generacion, (float)unaSolCodGray.getPob().getMatFitness()[unaSolCodGray.getPob().getElPeor()] );
    plotSol.getLayer("gray").setPoints(solGray);
    
    iterar = false;
  }
}

void mousePressed() {  
  if (overBox) { 
    locked = true; 
    fill(255, 255, 255);
  } else {
    locked = false;
  }
  iterar=true;
}

void mouseReleased() {
  locked = false;
}