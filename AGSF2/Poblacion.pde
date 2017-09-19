public class Poblacion {  
  private final int numIndiv, longIndiv, dominio;    
  private final float probMutar, probReprod;
  private final int dimRastr = 2;
  private int elMejor, elPeor, corte, orden, longDef, numRep;    
  private int[][] matPoblacion, matPoblacion01, mat_desp_sel, mat_desp_cruz, mat_desp_mut;    
  private double[][] intervalos;
  private Operadores operadores;
  private double[] matFitness, minMAX, matValorReal;       
  private double sumaFitness, promFitness, sumaEsq, promEsq; 

  public Poblacion(int n, int l) {               
    operadores = new Operadores();
    numIndiv = n;
    longIndiv = l;      
    matPoblacion = new int[numIndiv][longIndiv];
    matPoblacion01 = new int[numIndiv][longIndiv];

    mat_desp_sel =  new int[numIndiv][longIndiv+1];
    mat_desp_cruz =  new int[numIndiv][longIndiv+2];
    mat_desp_mut =  new int[numIndiv][longIndiv];

    matFitness = new double[numIndiv];
    matValorReal = new double[numIndiv];
    intervalos = new double[numIndiv][2];
    probMutar = 0.01f;
    probReprod = 0.3f;     
    dominio = 2;
  }
  
  public Poblacion(int n, int l, float mut, float cruz) {               
    operadores = new Operadores();
    numIndiv = n;
    longIndiv = l;      
    matPoblacion = new int[numIndiv][longIndiv];
    matPoblacion01 = new int[numIndiv][longIndiv];

    mat_desp_sel =  new int[numIndiv][longIndiv+1];
    mat_desp_cruz =  new int[numIndiv][longIndiv+2];
    mat_desp_mut =  new int[numIndiv][longIndiv];

    matFitness = new double[numIndiv];
    matValorReal = new double[numIndiv];
    intervalos = new double[numIndiv][2];
    probMutar = mut;
    probReprod = cruz;     
    dominio = 2;
  }
  
  public Poblacion(int n, int l, int dom) {
    operadores = new Operadores();
    numIndiv = n;
    longIndiv = l;      
    matPoblacion = new int[numIndiv][longIndiv];
    matPoblacion01 = new int[numIndiv][longIndiv];

    mat_desp_sel =  new int[numIndiv][longIndiv+1];
    mat_desp_cruz =  new int[numIndiv][longIndiv+2];
    mat_desp_mut =  new int[numIndiv][longIndiv];

    matFitness = new double[numIndiv];
    matValorReal = new double[numIndiv];
    intervalos = new double[numIndiv][2];
    probMutar = 0.1f;
    probReprod = 0.5f;  //Lo mismo que la probabilidad de cruzarse
    dominio = dom;
  }
  
  public Poblacion(int n, int l, int dom, float mut, float cruz) {
    operadores = new Operadores();
    numIndiv = n;
    longIndiv = l;      
    matPoblacion = new int[numIndiv][longIndiv];
    matPoblacion01 = new int[numIndiv][longIndiv];

    mat_desp_sel =  new int[numIndiv][longIndiv+1];
    mat_desp_cruz =  new int[numIndiv][longIndiv+2];
    mat_desp_mut =  new int[numIndiv][longIndiv];

    matFitness = new double[numIndiv];
    matValorReal = new double[numIndiv];
    intervalos = new double[numIndiv][2];
    probMutar = mut;
    probReprod = cruz;  //Lo mismo que la probabilidad de cruzarse
    dominio = dom;
  }
  
  public void generarPrimerPob() {
    for (int i = 0; i < numIndiv; i++) {    //Para cada individuo
      for (int j = 0; j < longIndiv; j++) {   //iniciar los valores de la matriz aletoriamente
        matPoblacion[i][j]=operadores.aleatorio0o1(dominio);
      }
    }
  }

  //***************** ALGUNOS EJEMPLOS ***************************************  

  //***************** Black Box y Funciones R-->R ***************** 
  private void fitnessBlackBox(int ind) {    
    matFitness[ind]=36-Math.pow(Math.pow(6*indEnInterv(ind)-3, 2)-3,2);
    //matFitness[ind] = (1-Math.pow(5.5*indEnInterv(ind)-3.5, 2))*(Math.cos(5.5*indEnInterv(ind)-3.5) + 1) + 2;
  }

  public void calificarPoblacionBlackB() {

    double sum=0;

    for (int i = 0; i < numIndiv; i++) {
      fitnessBlackBox(i);
      sum=sum+matFitness[i];
    }

    for (int i = 0; i < numIndiv; i++) {
      if (i==0) {
        intervalos[i][0]=0;
        intervalos[i][1]=matFitness[i]/sum;
      } else {
        intervalos[i][0]=intervalos[i-1][1];
        intervalos[i][1]=intervalos[i][0] + matFitness[i]/sum;
      }
    }
  }

  //Funcion para mostrar num Binarios a Decimales
  //numInd es la posicion en la matriz de poblacion, matPoblacion
  public int deBinADec(int numInd) {
    int dec=0;
    for (int i=0; i<longIndiv; i++) {
      dec = dec + (int)( matPoblacion[numInd][i]*(Math.pow(2, longIndiv-i-1) ) );
    }
    return dec;
  }
  
  //Funcion para mostrar num Binarios a Decimales
  //numInd es la posicion en la matriz de poblacion en la matriz: matriz
  public int deBinADec(int numInd, int[][] matriz) {
    int dec =0;
    for (int i=0; i<longIndiv; i++) {
      dec = dec + (int)( matriz[numInd][i]*(Math.pow(2, longIndiv-i-1) ) );
    }
    return dec;
  }

  //Poner al individuo en el intervalo
  //El por que de este metodo se debe a que 
  public double indEnInterv(int ind) {   
    double valorInt = ((double)deBinADec(ind))/Math.pow(dominio, longIndiv);
    matValorReal[ind]=valorInt;
    return valorInt;
  }   
  
  public double indEnIntervalo(int ind, int[][] matriz){
    double valorInt = ((double)deBinADec(ind, matriz))/Math.pow(dominio, longIndiv);
    return valorInt;
  }
  //***************** Black Box y Funciones R-->R *****************  

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

  public void seleccion(int lug) {
    boolean t;
    int contador, contador01;
    double sel;

    contador=0;             
    contador01=0;
    sel=Math.random();
    t=true;
    while (t==true) {
      //Seleccion del primer individuo.
      if (sel>intervalos[contador][0] && sel<intervalos[contador][1]) {

        System.arraycopy(matPoblacion[contador], 0, mat_desp_sel[lug], 0, longIndiv);
        mat_desp_sel[lug][longIndiv]=contador;
        //Seleccion del segundo individuo.
        sel=Math.random();
        while (true) {
          if (sel>intervalos[contador01][0] && sel<intervalos[contador01][1]) {

            //Cuando ya se escogieron a los dos individuos se almacenan en la matSeleccion_antesdeRep                        
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

  public void mutacion(int lug) {
    char val;
    double sel;
    if ( mat_desp_cruz[lug][longIndiv+1]!=-1) {
      System.arraycopy(mat_desp_cruz[lug], 0, mat_desp_mut[lug], 0, longIndiv);
      for (int i = 0; i < longIndiv; i++) {
        sel=Math.random();
        if (sel<probMutar) {                       
          val = (char) operadores.aleatorio0o1(dominio);
          while (val==mat_desp_mut[lug][i]) {
            mat_desp_mut[lug][i]=operadores.aleatorio0o1(dominio);
          }
        }
      }
    } else {
      System.arraycopy(mat_desp_cruz[lug], 0, mat_desp_mut[lug], 0, longIndiv);
    }
  }

  private void puntoCorte() {
    corte = operadores.aleatorio0o1(longIndiv);
  } 

  public void copiarYReiniciar() {
    for (int i = 0; i < numIndiv; i++) {
      System.arraycopy(mat_desp_mut[i], 0, matPoblacion[i], 0, longIndiv);
    }
  }

  public int ContarRep_de_Esquema(char[] esq, int[][] mat) {
    numRep=0;
    boolean b;
    int cont;
    for (int i = 0; i < numIndiv; i++) {
      b=true;
      cont=0;

      while (b==true && cont<longIndiv) {                
        if (esq[cont]!='*' && esq[cont]!=Integer.toString(mat[i][cont]).charAt(0)) {
          b=false;
        } 
        cont++;
      }
      if (b==true) {
        numRep++;
      }
    }

    return numRep;
  }

  public int ContarRep_de_Esquema(int[] esq, int[][] mat) {
    numRep=0;
    boolean b;
    int cont;
    for (int i = 0; i < numIndiv; i++) {
      b=true;
      cont=0;

      while (b==true && cont<longIndiv) {                
        if ((char)esq[cont]!='*' && esq[cont]!=mat[i][cont]) {
          b=false;
        } 
        cont++;
      }
      if (b==true) {
        numRep++;
      }
    }

    return numRep;
  }

  public int ordenEsquema(char[] esq) {
    orden=0;
    for (int i = 0; i < longIndiv; i++) {
      if (esq[i]!='*') {
        orden++;
      }
    }
    return orden;
  }

  public int longEsquema(char[] esq) {

    //Encuentra el primer y ultimo caracteres definidos y resta su posición.
    int primer_car_esp=0;
    while (esq[primer_car_esp]=='*') {
      primer_car_esp++;
      if (primer_car_esp==longIndiv) {
        primer_car_esp=0;
        break;
      }
    }

    int ultimo_car_esp=longIndiv-1;
    while (esq[ultimo_car_esp]=='*') {            
      ultimo_car_esp--;
      if (ultimo_car_esp==-1) {
        ultimo_car_esp=0;
        break;
      }
    }

    return ultimo_car_esp-primer_car_esp;
  }

  public void sumaFit() {
    sumaFitness=0;
    for (int i = 0; i < numIndiv; i++) {
      sumaFitness=sumaFitness+matFitness[i];
    }
  }

  public double promFitness() {
    sumaFit();
    promFitness = sumaFitness/numIndiv;
    return promFitness;
  }

  public void sumaEsquema(char[] esq) {
    sumaEsq=0;
    for (int i = 0; i < repDeEsqInt(esq, matPoblacion).length; i++) {
      sumaEsq=sumaEsq+matFitness[i];
    }
  }   

  public double promEsq(char[] esq) {                
    sumaEsquema(esq);        
    promEsq=sumaEsq/(double)esq.length;
    return promEsq;
  }

  public String repDeEsq(char[] esq, int[][] mat) {
    String cadena="";
    boolean b;
    int cont;

    for (int i = 0; i < numIndiv; i++) {
      b=true;
      cont=0;

      while (b==true && cont<longIndiv) {                
        if (esq[cont]!='*' && esq[cont]!=Integer.toString(mat[i][cont]).charAt(0)) {
          b=false;
        } 
        cont++;
      }

      if (b==true) {
        cadena=cadena.concat(Integer.toString(i));
      }
    }

    return cadena;
  }

  public int[] repDeEsqInt(char[] esq, int[][] mat) {
    int[] vec=new int[ContarRep_de_Esquema(esq, mat)];
    boolean b;
    int cont;
    int contLug=0;

    for (int i = 0; i < numIndiv; i++) {
      b=true;
      cont=0;          

      while (b==true && cont<longIndiv) {                
        if (esq[cont]!='*' && esq[cont]!=Integer.toString(mat[i][cont]).charAt(0)) {
          b=false;
        } 
        cont++;
      }

      if (b==true) {
        vec[contLug]=i;
        contLug++;
      }
    }

    return vec;
  }

  public double getSumaFitness() {
    return sumaFitness;
  }        

  public int[][] getMat_desp_sel() {
    return mat_desp_sel;
  }

  public int[][] getMat_desp_cruz() {
    return mat_desp_cruz;
  }

  public int[][] getMat_desp_mut() {
    return mat_desp_mut;
  }

  public int getNumIndiv() {
    return numIndiv;
  }

  public int getLongIndiv() {
    return longIndiv;
  }

  public int getCorte() {
    return corte;
  }

  public int[][] getMatPoblacion() {
    return matPoblacion;
  }

  public void setMatPoblacion(int[][] matPoblacion) {
    this.matPoblacion = matPoblacion;
  }

  public int[][] getMatPoblacion01() {
    return matPoblacion01;
  }

  public void setMatPoblacion01(int[][] matPoblacion01) {
    this.matPoblacion01 = matPoblacion01;
  }

  public double[][] getIntervalos() {
    return intervalos;
  }

  public void setIntervalos(double[][] intervalos) {
    this.intervalos = intervalos;
  }

  public double[] getMatFitness() {
    return matFitness;
  }

  public void setMatFitness(double[] matFitness) {
    this.matFitness = matFitness;
  }

  public float getProbMutar() {
    return probMutar;
  }

  public float getProbReprod() {
    return probReprod;
  }      

  public int getElMejor() {
    return elMejor;
  }

  public void setCorte(int corte) {
    this.corte = corte;
  }

  public void setElMejor(int elMejor) {
    this.elMejor = elMejor;
  }    

  public double[] getMatValorReal() {
    return matValorReal;
  }

  public int getNumRep() {
    return numRep;
  }
}