public class PoblacionReal {

  private final int numIndiv, longIndiv;
  private int elMejor, elPeor, corte;
  private double[][] intervalos, matPoblacion, mat_desp_sel, mat_desp_cruz, mat_desp_mut;
  private Operadores operadores;
  private double[] matFitness;
  private final float probMutar, probReprod, limiteI, limiteS;  

  //Constructor
  public PoblacionReal(int n, int l, float m, float c, float li, float ls) {
    operadores = new Operadores();
    numIndiv = n;
    longIndiv = l;        
    matPoblacion = new double[numIndiv][longIndiv];
    mat_desp_sel = new double[numIndiv][longIndiv+1];
    mat_desp_cruz = new double[numIndiv][longIndiv+2];
    mat_desp_mut = new double[numIndiv][longIndiv];
    matFitness = new double[numIndiv];
    intervalos = new double[numIndiv][2];
    probMutar = m;
    probReprod = c;
    limiteI = li;
    limiteS = ls;
  }

  //Crear Poblacion inicial.
  public void generarPrimerPob() {
    for (int i = 0; i < numIndiv; i++) {    //Para cada individuo      
      for (int j = 0; j < longIndiv; j++) {   //iniciar los valores de la matriz aletoriamente
        matPoblacion[i][j]=operadores.aleatorioRe((double)limiteI, (double)limiteS);
      }
    }
  }
  
  //Calcula Fitness de rastrigin 
  public void fitnessRastrigin(int ind) {
    double sumaRas =0;
    //for..de 0..a dimension.
    for (int i = 0; i < longIndiv; i++) {
      sumaRas = sumaRas + (Math.pow(matPoblacion[ind][i], 2) - 10*Math.cos(2*Math.PI*matPoblacion[ind][i]) );
    }
    //10*dimension + sumaRas
    matFitness[ind]= longIndiv*10 + sumaRas;
  }

  public void calificarPoblacionRastr() {
    double sum=0;

    for (int i = 0; i < numIndiv; i++) {
      fitnessRastrigin(i);
      sum=sum+1/(matFitness[i]+1);
    }
    
    //                        Intervalos     
    // p = (1-fi/(Sfi) )/(n-1)
    //Donde n:= la cantidad de individuos
    for (int i = 0; i < numIndiv; i++) {   
      if (i!=0) {
        intervalos[i][0]=intervalos[i-1][1];
        intervalos[i][1]=intervalos[i][0]+1/(sum*(matFitness[i]+1));
      } else {
        intervalos[i][0]=0;
        intervalos[i][1]=1/(sum*(matFitness[i]+1));                
      }
    }
    
    
    //for(int k=0;k<4;k++){
    //  print("Punto: [");
    //  for(int i=0; i<longIndiv;i++){      
    //    print(matPoblacion[k][i]+", ");
    //  }
    //  print("]");
    //  println(", "+matFitness[k]+ " | Intervalo:"+intervalos[k][0]+", "+intervalos[k][1]+" | Longitud: "+(intervalos[k][1]-intervalos[k][0]));
    //}
    
  }    

  public void seleccion(int lug) {
    boolean t;
    int contador, contador01;
    double sel;
    
    contador=0;             
    contador01=0;
    sel=Math.random();
    //println(sel);
    
    t=true;
    while (t==true) {
      //Seleccion del primer individuo.
      if (sel>intervalos[contador][0] && sel<intervalos[contador][1]) {
        //println(contador);
        System.arraycopy(matPoblacion[contador], 0, mat_desp_sel[lug], 0, longIndiv);
        mat_desp_sel[lug][longIndiv]=contador;
        //Seleccion del segundo individuo.
        sel=Math.random();
        while (true) {
          if (sel>intervalos[contador01][0] && sel<intervalos[contador01][1]) {

            //Cuando ya se escogieron a los dos individuos se almacenan en la mat_desp_sel                        
            System.arraycopy(matPoblacion[contador01], 0, mat_desp_sel[lug+1], 0, longIndiv);
            mat_desp_sel[lug+1][longIndiv]=contador01;
            t=false;
            break;
          } else {
            contador01++;
          }
        }
      } else {
        contador++;
      }
    }
  }

  public void reproduccion(int a, int b, int lug) {
    double sel=Math.random();  // variable sel para saber si un individuo se cruza o no.
    if (sel<probReprod) {//...<probReprod significa que se reproducen con cruzamiento
      //System.out.println("Hay cruzamiento");
      puntoCorte();
      //Crea primer hibrido en mat_desp_cruz
      System.arraycopy(mat_desp_sel[a], 0, mat_desp_cruz[lug], 0, corte);
      System.arraycopy(mat_desp_sel[b], corte, mat_desp_cruz[lug], corte, longIndiv-corte); 
      mat_desp_cruz[lug][longIndiv]=mat_desp_sel[lug][longIndiv];
      mat_desp_cruz[lug][longIndiv+1]=corte;

      //Crea segundo hibrido en mat_desp_cruz
      System.arraycopy(mat_desp_sel[b], 0, mat_desp_cruz[lug + 1], 0, corte);
      System.arraycopy(mat_desp_sel[a], corte, mat_desp_cruz[lug + 1], corte, longIndiv-corte);
      mat_desp_cruz[lug+1][longIndiv]=mat_desp_sel[lug+1][longIndiv];
      mat_desp_cruz[lug+1][longIndiv+1]=corte;
    } else {//..>probReprod significa que solo se copian sin cruzamiento
      //System.out.println("NO Hay cruzamiento");
      System.arraycopy(mat_desp_sel[a], 0, mat_desp_cruz[lug], 0, longIndiv);                
      System.arraycopy(mat_desp_sel[b], 0, mat_desp_cruz[lug + 1], 0, longIndiv);    
      mat_desp_cruz[lug][longIndiv]=mat_desp_sel[lug][longIndiv];
      mat_desp_cruz[lug][longIndiv+1]=-1;            
      mat_desp_cruz[lug+1][longIndiv]=mat_desp_sel[lug+1][longIndiv];
      mat_desp_cruz[lug+1][longIndiv+1]=-1;
    }
  }

  /*private void mutacion(double[] vec){
   for (int i = 0; i < longIndiv; i++) {
   if (Math.random()<probMutar) {//Probabilidad de mutar de 10%
   vec[i]=operadores.aleatorioRe(limiteI, limiteS);
   }
   }
   }*/

  public void mutacion(int lug) {

    double sel;
    if ( mat_desp_cruz[lug][longIndiv+1]!=-1) {
      System.arraycopy(mat_desp_cruz[lug], 0, mat_desp_mut[lug], 0, longIndiv);
      for (int i = 0; i < longIndiv; i++) {
        sel=Math.random();
        if (sel<probMutar) {
          mat_desp_mut[lug][i]=operadores.aleatorioRe(limiteI, limiteS);
        }
      }
    } else {
      System.arraycopy(mat_desp_cruz[lug], 0, mat_desp_mut[lug], 0, longIndiv);
    }
  }

  public int elMejor() {
    //int cont=0;
    elMejor=0;

    for (int i = 1; i < numIndiv; i++) {
      if (matFitness[i]>matFitness[elMejor]) {
        elMejor=i;
      }
    }
    return elMejor;
  }

  public int elPeor() {
    elPeor=0;

    for (int i = 1; i < numIndiv; i++) {
      if (matFitness[i]<matFitness[elPeor]) {
        elPeor=i;
      }
    }

    return elPeor;
  }    

  private void puntoCorte() {
    corte = operadores.aleatorio0o1(longIndiv);
  }   

  public void copiarYReiniciar() {
    for (int i = 0; i < numIndiv; i++) {
      System.arraycopy(mat_desp_mut[i], 0, matPoblacion[i], 0, longIndiv);
    }
  }

  public int getElMejor() {
    return elMejor;
  }

  public void setElMejor(int elMejor) {
    this.elMejor = elMejor;
  }

  public int getElPeor() {
    return elPeor;
  }

  public void setElPeor(int elPeor) {
    this.elPeor = elPeor;
  }

  public int getCorte() {
    return corte;
  }

  public void setCorte(int corte) {
    this.corte = corte;
  }

  public double[][] getIntervalos() {
    return intervalos;
  }

  public void setIntervalos(double[][] intervalos) {
    this.intervalos = intervalos;
  }

  public double[][] getMatPoblacion() {
    return matPoblacion;
  }

  public void setMatPoblacion(double[][] matPoblacion) {
    this.matPoblacion = matPoblacion;
  }

  public Operadores getOperadores() {
    return operadores;
  }

  public void setOperadores(Operadores operadores) {
    this.operadores = operadores;
  }

  public double[] getMatFitness() {
    return matFitness;
  }

  public void setMatFitness(double[] matFitness) {
    this.matFitness = matFitness;
  }

  public int getNumIndiv() {
    return numIndiv;
  }
}