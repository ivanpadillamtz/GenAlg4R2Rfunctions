import grafica.*;

float x;
float bx;
float by;
private String cadenita="";
final int boxSize = 50;
boolean overBox = false;
boolean locked = false;
boolean iterar =false;
int generacion;
GPlot plot, plotNumEsquemas, plotNumEsqSel, plotNumEsqReprod;
GPointsArray points, soluciones, num_de_rep, num_de_rep_sel, num_de_rep_reprod, 
  cuenta_esp, cuenta_esp_sel, cuenta_esp_reprod;
EsquemasEv esquemasDEvol;

/*********************************************************************/
/************************* PARAMETROS ********************************/
/*********************************************************************/

//Cambiar aquí eltamaño de poblacion, longitud del individuo, probabilidad de mutacion
//Y probabilidad de cruzamiento

final int numero_de_individuos=4;  //Tamaño de la Poblacion

/*!!!!!!!!!!   SI SE CAMBIA EL PARAMETRO longitud_de_individuo !!!!!!!!!!!!!*/
/*!!!!!!!!!!   SE DEBE CAMBIAR EN LA CLASE EsquemasEv EL ESQUEMA USADO !!!!!!!!!!!!!*/
final int longitud_de_individuo=5;  //Longitud de las cadenas

final float probMutacion=0.001;  //Probabilidad de mutación
final float probCruzamiento=0.6;  //Probabilidad de cruzamiento



/*********************************************************************/
/************************* PARAMETROS ********************************/
/*********************************************************************/

int plot_position_x, plot_position_y;

void setup() {
  fullScreen();
  background(200);

  generacion=1;

  //Initializes button variables 
  bx=10;
  by=displayHeight - 60;
  //*************************************************************************************************************
  // Prepare the points for the graph
  int nPoints = 100;
  points = new GPointsArray(nPoints);    
  for (int i = 0; i < nPoints; i++) {
    x=0.01*i;
    points.add(x,floor(10*x));
  }   

  //*************************************************************************************************************
  //Create instance of object EsquemasEv
  esquemasDEvol = new EsquemasEv(numero_de_individuos, longitud_de_individuo, probMutacion, probCruzamiento);

  println("Generacion: "+(generacion-1));
  esquemasDEvol.generar_tabla_d_Ev();    //Genera la tabla de evolucion de la primer generacion

  //*************************************************************************************************************
  // Create a new plot and set its position on the screen
  plot = new GPlot(this, 5, 5, displayWidth/2 , displayHeight/2 + 100);

  // Set the plot title and the axis labels
  plot.setTitleText("Función a optimizar");
  plot.getXAxis().setAxisLabelText("x");
  plot.getYAxis().setAxisLabelText("Fitness");

  // Add the points of the graph
  //plot.setPointSize(0.5f);
  plot.setPoints(points);       

  //Create points which are the possible solutions in generation = 0
  soluciones = new GPointsArray(esquemasDEvol.poblacion.getNumIndiv());
  for (int i=0; i<esquemasDEvol.poblacion.getNumIndiv(); i++) {
    x=(float)esquemasDEvol.poblacion.indEnIntervalo(i, esquemasDEvol.poblacion.getMat_desp_mut());
    soluciones.add(new GPoint(x, floor(10*x)));
  }     

  //Add a new layer to draw the solutions
  plot.addLayer("sol", soluciones);
  plot.getLayer("sol").setPointSize(5);  

  //*************************************************************************************************************
  //Add a second plot
  plotNumEsquemas=new GPlot(this, displayWidth/2 + 10, 5, displayWidth/2 -15, displayHeight/3 - 4);
  plotNumEsquemas.setTitleText("Esquemas en t+1: ");
  plotNumEsquemas.getXAxis().setAxisLabelText("Generación");
  plotNumEsquemas.getXAxis().setTicksSeparation(1.0);
  plotNumEsquemas.getYAxis().setTicksSeparation(1.0);
  plotNumEsquemas.getYAxis().setAxisLabelText("N. de Representantes");
  plotNumEsquemas.drawGridLines(GPlot.BOTH);

  //Calculate the number of representatives os the schemata and add them to the plotNumEsquemas.
  num_de_rep = new GPointsArray();  
  num_de_rep.add(0, esquemasDEvol.poblacion.ContarRep_de_Esquema(esquemasDEvol.getMatEsquema(), esquemasDEvol.poblacion.getMatPoblacion()));
  num_de_rep.add(generacion, esquemasDEvol.getNumRep());  
  plotNumEsquemas.setPoints(num_de_rep);  
  plotNumEsquemas.setPointSize(5);

  cuenta_esp = new GPointsArray();
  cuenta_esp.add(generacion, (float)esquemasDEvol.teoEsqMut(esquemasDEvol.getMatEsquema()));
  plotNumEsquemas.addLayer("predict", cuenta_esp);
  plotNumEsquemas.getLayer("predict").setPointSize(5);
  plotNumEsquemas.getLayer("predict").setPointColor(-10000000);

  //*************************************************************************************************************
  //Add a third plot
  plotNumEsqSel=new GPlot(this, displayWidth/2+10, displayHeight /3 +6, displayWidth/2 -15, displayHeight/3 - 4);
  plotNumEsqSel.setTitleText("Esquemas despues de selección: ");
  plotNumEsqSel.getXAxis().setAxisLabelText("Generación");
  plotNumEsqSel.getXAxis().setTicksSeparation(1.0);
  plotNumEsqSel.getYAxis().setTicksSeparation(1.0);
  plotNumEsqSel.getYAxis().setAxisLabelText("N. de Rep. Sel.");
  plotNumEsqSel.drawGridLines(GPlot.BOTH);

  num_de_rep_sel=new GPointsArray();
  num_de_rep_sel.add(generacion, esquemasDEvol.poblacion.ContarRep_de_Esquema(esquemasDEvol.getMatEsquema(), esquemasDEvol.poblacion.getMat_desp_sel()));
  plotNumEsqSel.setPoints(num_de_rep_sel);
  plotNumEsqSel.setPointSize(5);

  cuenta_esp_sel = new GPointsArray();
  cuenta_esp_sel.add(generacion, (float)esquemasDEvol.teoEsqSel(esquemasDEvol.getMatEsquema() ) );
  plotNumEsqSel.addLayer("predict", cuenta_esp_sel);
  plotNumEsqSel.getLayer("predict").setPointSize(5);
  plotNumEsqSel.getLayer("predict").setPointColor(-10000000);

  //*************************************************************************************************************
  //Add a fourth plot
  plotNumEsqReprod=new GPlot(this, displayWidth/2+ 10, 2*displayHeight/3 +6, displayWidth/2-15, displayHeight/3 - 10);
  plotNumEsqReprod.setTitleText("Esquemas despues de cruzamiento: ");
  plotNumEsqReprod.getXAxis().setAxisLabelText("Generación");
  plotNumEsqReprod.getXAxis().setTicksSeparation(1.0);
  plotNumEsqReprod.getYAxis().setTicksSeparation(1.0);
  plotNumEsqReprod.getYAxis().setAxisLabelText("N. de Rep. Cruz.");
  plotNumEsqReprod.drawGridLines(GPlot.BOTH);   

  num_de_rep_reprod=new GPointsArray();
  num_de_rep_reprod.add(generacion, esquemasDEvol.poblacion.ContarRep_de_Esquema(esquemasDEvol.getMatEsquema(), esquemasDEvol.poblacion.getMat_desp_cruz()));
  plotNumEsqReprod.setPoints(num_de_rep_reprod);
  plotNumEsqReprod.setPointSize(5);

  cuenta_esp_reprod = new GPointsArray();
  cuenta_esp_reprod.add(generacion, (float)esquemasDEvol.teoEsqCruz(esquemasDEvol.getMatEsquema() ) );
  plotNumEsqReprod.addLayer("predict", cuenta_esp_reprod);
  plotNumEsqReprod.getLayer("predict").setPointSize(5);
  plotNumEsqReprod.getLayer("predict").setPointColor(-10000000);

  //*************************************************************************************************************
  for(int i=0;i<esquemasDEvol.getMatEsquema().length;i++){
    cadenita=cadenita+esquemasDEvol.getMatEsquema()[i];
  }
  //println("Numero de representantes en al generacion 0: "+esquemasDEvol.poblacion.ContarRep_de_Esquema(esquemasDEvol.getMatEsquema(),esquemasDEvol.poblacion.getMatPoblacion()));
  //println("Numero de representantes despues de mutacion: "+esquemasDEvol.getNumRep());
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
  plot.beginDraw();
  plot.drawBackground();
  plot.drawBox();
  plot.drawXAxis();
  plot.drawYAxis();
  plot.drawTitle();
  plot.getMainLayer().drawLines();
  plot.getLayer("sol").drawPoints();
  for (int i=0; i<numero_de_individuos; i++) {
    plot.getLayer("sol").drawLine(soluciones.get(i), new GPoint(soluciones.getX(i), 0), 0, 1);
  }  
  plot.endDraw();
  //**************************************************** FINISH PLOT 1 *********************************

  //**************************************************** START PLOT 2 *********************************

  plotNumEsquemas.beginDraw();
  plotNumEsquemas.drawBackground();
  plotNumEsquemas.drawBox();  
  plotNumEsquemas.drawXAxis();
  plotNumEsquemas.drawYAxis();
  plotNumEsquemas.drawTitle();  
  plotNumEsquemas.drawGridLines(GPlot.BOTH);
  plotNumEsquemas.getMainLayer().drawPoints();
  plotNumEsquemas.getMainLayer().drawLines();
  plotNumEsquemas.getLayer("predict").drawPoints();
  plotNumEsquemas.getLayer("predict").drawLines();
  plotNumEsquemas.endDraw();

  //**************************************************** FINISH PLOT 2 *********************************

  //**************************************************** START PLOT 3 *********************************

  plotNumEsqSel.beginDraw();
  plotNumEsqSel.drawBackground();
  plotNumEsqSel.drawBox();  
  plotNumEsqSel.drawXAxis();
  plotNumEsqSel.drawYAxis();
  plotNumEsqSel.drawTitle();
  plotNumEsqSel.drawGridLines(GPlot.BOTH);
  plotNumEsqSel.getMainLayer().drawPoints();
  plotNumEsqSel.getMainLayer().drawLines();
  plotNumEsqSel.getLayer("predict").drawPoints();
  plotNumEsqSel.getLayer("predict").drawLines();
  plotNumEsqSel.endDraw();

  //**************************************************** FINISH PLOT 3 *********************************

  //**************************************************** START PLOT 4 *********************************

  plotNumEsqReprod.beginDraw();
  plotNumEsqReprod.drawBackground();
  plotNumEsqReprod.drawBox();  
  plotNumEsqReprod.drawXAxis();
  plotNumEsqReprod.drawYAxis();
  plotNumEsqReprod.drawTitle();
  plotNumEsqReprod.drawGridLines(GPlot.BOTH);
  plotNumEsqReprod.getMainLayer().drawPoints();
  plotNumEsqReprod.getMainLayer().drawLines();
  plotNumEsqReprod.getLayer("predict").drawPoints();
  plotNumEsqReprod.getLayer("predict").drawLines();
  plotNumEsqReprod.endDraw();

  //**************************************************** FINISH PLOT 4 *********************************

  //****************************************************** START TEXT ********************************
  textSize(15);
  fill(0);
  text("AGS:", 20, displayHeight/2 + 150);
  text("-Seleccion porporcional o de ruleta.", 20, displayHeight/2 + 170);
  text("-Cruzamiento de un punto con prob. "+esquemasDEvol.poblacion.getProbReprod(), 20, displayHeight/2 + 190);
  text("-Mutacion con prob "+esquemasDEvol.poblacion.getProbMutar(), 20, displayHeight/2 + 210);  
  text("-Generacion: "+generacion, 20, displayHeight/2 +230);
  text("-Esquema: "+ cadenita,20,displayHeight/2 + 250);
  //****************************************************** FINISH TEXT ********************************

  //*************************************************************************************
  //Executed code if the button is clicked
  if (iterar) {    
    generacion++;
    println("Generacion: "+generacion);    
    //Next generation
    esquemasDEvol.generar_tabla_dEv_sigGen();
    //*************************************************************************************
    soluciones.removeRange(0, numero_de_individuos);

    for (int i=0; i<numero_de_individuos; i++) {      
      x=(float)esquemasDEvol.poblacion.indEnIntervalo(i, esquemasDEvol.poblacion.getMat_desp_mut());      
      plot.getLayer("sol").removePoint(0);
      soluciones.add(new GPoint(x, floor(10*x)));
    }    
    plot.getLayer("sol").addPoints(soluciones);
    //*************************************************************************************
    num_de_rep.add(generacion, esquemasDEvol.getNumRep());
    plotNumEsquemas.addPoint(num_de_rep.getLastPoint());
    cuenta_esp.add(generacion, (float)esquemasDEvol.teoEsqMut(esquemasDEvol.getMatEsquema()));
    plotNumEsquemas.getLayer("predict").addPoint(cuenta_esp.getLastPoint());
    //*************************************************************************************
    num_de_rep_sel.add(generacion, esquemasDEvol.poblacion.ContarRep_de_Esquema(esquemasDEvol.getMatEsquema(), esquemasDEvol.poblacion.getMat_desp_sel()));
    plotNumEsqSel.addPoint(num_de_rep_sel.getLastPoint());
    cuenta_esp_sel.add(generacion, (float)esquemasDEvol.teoEsqSel(esquemasDEvol.getMatEsquema()));
    plotNumEsqSel.getLayer("predict").addPoint(cuenta_esp_sel.getLastPoint());
    //*************************************************************************************
    num_de_rep_reprod.add(generacion, esquemasDEvol.poblacion.ContarRep_de_Esquema(esquemasDEvol.getMatEsquema(), esquemasDEvol.poblacion.getMat_desp_cruz()));
    plotNumEsqReprod.addPoint(num_de_rep_reprod.getLastPoint());
    cuenta_esp_reprod.add(generacion, (float)esquemasDEvol.teoEsqCruz(esquemasDEvol.getMatEsquema()));
    plotNumEsqReprod.getLayer("predict").addPoint(cuenta_esp_reprod.getLastPoint());
    
  }

  //Finishes code if the button is clicked
  iterar=false;
  //**************************************************** CODIGO *********************************
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