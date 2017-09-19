public class EsquemasEv {
  public final Poblacion poblacion;
  private final int numPob;
  private int numRep;

  /************************************** ESQUEMA ***************************************/
  private char[] matEsquema={'0', '0', '*', '*', '*'};
  //private char[] matEsquema={'0', '*', '*', '*', '*'};
  //private char[] matEsquema={'1', '0', '*', '*', '*'};
  //private char[] matEsquema={'0', '1', '*', '*', '*'};
  //private char[] matEsquema={'0', '0', '*', '*', '*'};
  //private char[] matEsquema={'0', '1', '*', '*', '*'};
  
  public EsquemasEv(int n, int l) {        
    numPob = n;
    poblacion = new Poblacion(n, l);
  }
  
  public EsquemasEv(int n, int l, float mut, float cruz) {        
    numPob = n;
    poblacion = new Poblacion(n, l, mut, cruz);
  }
  
  public EsquemasEv(int n, int l, int d) {        
    numPob = n;
    poblacion = new Poblacion(n, l, d);
  }
  public void generar_tabla_d_Ev() {
    poblacion.generarPrimerPob();
    //impPobInicial();
    poblacion.calificarPoblacionBlackB();

    //*****************************
    //SELECCION
    for (int j = 0; j < poblacion.getNumIndiv()/2; j++) {
      poblacion.seleccion(2*j);
    }

    //*****************************
    //CRUZAMIENTO           
    for (int i = 0; i < poblacion.getNumIndiv()/2; i++) {
      poblacion.reproduccion(2*i, 2*i+1, 2*i);
    }

    //*****************************
    //MUTACION
    for (int i = 0; i < poblacion.getNumIndiv(); i++) {
      poblacion.mutacion(i);
    }

    System.out.print("---------------------------------------------------------------------------------------------------------------------------------------");
    System.out.println("-------------------------------------------------------------------------------------------------");
    System.out.print("No. Cadena      " + "Pob. Inicial       " + "Valor x            " + "       f(x)      "+"         pselect            "+"Cuenta esp.          "+"Cuenta real          ");
    System.out.println("Mating pool             "+"Pareja               "+"Nueva Pob");
    System.out.print("---------------------------------------------------------------------------------------------------------------------------------------");
    System.out.println("-------------------------------------------------------------------------------------------------");

    //*****************************
    //SUMA DE LOS FITNESS DE LA POBLACION.
    poblacion.sumaFit();
    for (int i = 0; i < poblacion.getNumIndiv(); i++) {  //Imprime, para cada individuo:
      System.out.print(i);
      System.out.print("              ");
      for (int imp=0; imp<poblacion.getLongIndiv(); imp++) {
        System.out.print(poblacion.getMatPoblacion()[i][imp]);
      }
      System.out.print("      "+ poblacion.getMatValorReal()[i]);
      System.out.print("          "+ poblacion.getMatFitness()[i]);                

      //Calcula e imprime la probabilidad proporcional de seleccion.
      System.out.print("  " + (poblacion.getMatFitness()[i]/poblacion.getSumaFitness()));
      //Calcula e imprime la cuenta esperada.
      System.out.print("  " + ((poblacion.getMatFitness()[i]*numPob)/poblacion.getSumaFitness()));

      //Calcula los rep de cada ind despues de la seleccion.                              
      System.out.print("               " + poblacion.ContarRep_de_Esquema(poblacion.getMatPoblacion()[i], poblacion.getMat_desp_sel()));

      //Imprime los puntos de corte
      //System.out.print("               "+Arrays.toString(poblacion.getMat_desp_cruz()[i]));
      System.out.print("              ");
      imprimirCruz(i);

      //Imprime las parejas
      if ((i%2)==0) {
        System.out.print("                "+poblacion.getMat_desp_cruz()[i+1][poblacion.getLongIndiv()]);
      } else {
        System.out.print("                "+poblacion.getMat_desp_cruz()[i-1][poblacion.getLongIndiv()]);
      }

      //Imprime la nueva poblacion.
      System.out.print("              ");
      for (int imp=0; imp<poblacion.getLongIndiv(); imp++) {
        System.out.print(poblacion.getMat_desp_mut()[i][imp]);
      }
      println();
      //Imprime nuevos valores x y f(x)
      //System.out.print("              "+poblacion.);
    }

    System.out.print("---------------------------------------------------------------------------------------------------------------------------------------");
    System.out.println("-------------------------------------------------------------------------------------------------");
    System.out.print("Suma:                                               ");            
    System.out.println(poblacion.getSumaFitness());
    System.out.print("Promedio:                                           ");
    System.out.print(poblacion.getSumaFitness()/poblacion.getNumIndiv()+"         ");
    System.out.println(1/(double)poblacion.getNumIndiv());
    System.out.print("Maximo:                                             ");
    poblacion.elMejor();
    System.out.print(poblacion.getMatFitness()[poblacion.getElMejor()]);
    System.out.print("      "+poblacion.getMatFitness()[poblacion.getElMejor()]/poblacion.getSumaFitness());
    System.out.println("      "+poblacion.getMatFitness()[poblacion.getElMejor()]*4/poblacion.getSumaFitness());            
    System.out.print("---------------------------------------------------------------------------------------------------------------------------------------");
    System.out.println("-------------------------------------------------------------------------------------------------"); 
    System.out.println();
    System.out.println("                                                                                                              Procesamiento de esquemas");            
    System.out.print("---------------------------------------------------------------------------------------------------------------------------------------");
    System.out.println("-------------------------------------------------------------------------------------------------"); 
    System.out.print("                                                    Antes de reproduccion");
    System.out.print("                                              Despues de Reproduccion");
    System.out.println("                                            Despues de todos los Op.");
    System.out.print("                                      ------------------------------------------------------------ ------------------------------------");
    System.out.println("-------------------------- ----------------------------------------------------------------------");
    System.out.print("                                        Representantes               Promedio de esquema: f(H)");
    System.out.print("          Cuenta esperada      Cuenta real      Representantes");
    System.out.println("                Cuenta esperada      Cuenta real      Representantes");
    System.out.print("---------------------------------------------------------------------------------------------------------------------------------------");
    System.out.println("-------------------------------------------------------------------------------------------------");
    System.out.print("H1:   ");
    for (int imp=0; imp<poblacion.getLongIndiv(); imp++) {
      System.out.print(matEsquema[imp]);
    }
    System.out.print("                         ");
    System.out.print(poblacion.repDeEsq(matEsquema, poblacion.getMatPoblacion())+"                        "+poblacion.promEsq(matEsquema));              
    System.out.print("            "+teoEsqSel(matEsquema));
    System.out.print("            "+poblacion.ContarRep_de_Esquema(matEsquema, poblacion.getMat_desp_sel()));
    System.out.print("            "+poblacion.repDeEsq(matEsquema, poblacion.getMat_desp_sel()));
    System.out.print("                          "+teoEsqMut(matEsquema));
    System.out.print("            "+poblacion.ContarRep_de_Esquema(matEsquema, poblacion.getMat_desp_mut()));
    System.out.println("            "+poblacion.repDeEsq(matEsquema, poblacion.getMat_desp_mut()));
    numRep=poblacion.getNumRep(); //Se guarda el numero de representantes de la poblacion cuando esta ya se muto
    System.out.print("---------------------------------------------------------------------------------------------------------------------------------------");
    System.out.println("-------------------------------------------------------------------------------------------------");
  }

  //Genera la tabla de evolucion para la siguiente generacion.
  public void generar_tabla_dEv_sigGen() {
    poblacion.copiarYReiniciar();    
    poblacion.calificarPoblacionBlackB();

    //*****************************
    //SELECCION
    for (int j = 0; j < poblacion.getNumIndiv()/2; j++) {
      poblacion.seleccion(2*j);
    }

    //*****************************
    //CRUZAMIENTO           
    for (int i = 0; i < poblacion.getNumIndiv()/2; i++) {
      poblacion.reproduccion(2*i, 2*i+1, 2*i);
    }

    //*****************************
    //MUTACION
    for (int i = 0; i < poblacion.getNumIndiv(); i++) {
      poblacion.mutacion(i);
    }

    System.out.print("---------------------------------------------------------------------------------------------------------------------------------------");
    System.out.println("-------------------------------------------------------------------------------------------------");
    System.out.print("No. Cadena      " + "Pob. Inicial       " + "Valor x            " + "       f(x)      "+"         pselect            "+"Cuenta esp.          "+"Cuenta real          ");
    System.out.println("Mating pool             "+"Pareja               "+"Nueva Pob");
    System.out.print("---------------------------------------------------------------------------------------------------------------------------------------");
    System.out.println("-------------------------------------------------------------------------------------------------");

    //*****************************
    //SUMA DE LOS FITNESS DE LA POBLACION.
    poblacion.sumaFit();
    for (int i = 0; i < poblacion.getNumIndiv(); i++) {  //Imprime, para cada individuo:
      System.out.print(i);
      System.out.print("              ");
      for (int imp=0; imp<poblacion.getLongIndiv(); imp++) {
        System.out.print(poblacion.getMatPoblacion()[i][imp]);
      }
      System.out.print("      "+ poblacion.getMatValorReal()[i]);
      System.out.print("          "+ poblacion.getMatFitness()[i]);                

      //Calcula e imprime la probabilidad proporcional de seleccion.
      System.out.print("  " + (poblacion.getMatFitness()[i]/poblacion.getSumaFitness()));
      //Calcula e imprime la cuenta esperada.
      System.out.print("  " + ((poblacion.getMatFitness()[i]*numPob)/poblacion.getSumaFitness()));

      //Calcula los rep de cada ind despues de la seleccion.                              
      System.out.print("               " + poblacion.ContarRep_de_Esquema(poblacion.getMatPoblacion()[i], poblacion.getMat_desp_sel()));

      //Imprime los puntos de corte
      //System.out.print("               "+Arrays.toString(poblacion.getMat_desp_cruz()[i]));
      System.out.print("              ");
      imprimirCruz(i);

      //Imprime las parejas
      if ((i%2)==0) {
        System.out.print("                "+poblacion.getMat_desp_cruz()[i+1][poblacion.getLongIndiv()]);
      } else {
        System.out.print("                "+poblacion.getMat_desp_cruz()[i-1][poblacion.getLongIndiv()]);
      }

      //Imprime la nueva poblacion.
      System.out.print("              ");
      for (int imp=0; imp<poblacion.getLongIndiv(); imp++) {
        System.out.print(poblacion.getMat_desp_mut()[i][imp]);
      }
      println();
      //Imprime nuevos valores x y f(x)
      //System.out.print("              "+poblacion.);
    }

    System.out.print("---------------------------------------------------------------------------------------------------------------------------------------");
    System.out.println("-------------------------------------------------------------------------------------------------");
    System.out.print("Suma:                                               ");            
    System.out.println(poblacion.getSumaFitness());
    System.out.print("Promedio:                                           ");
    System.out.print(poblacion.getSumaFitness()/poblacion.getNumIndiv()+"         ");
    System.out.println(1/(double)poblacion.getNumIndiv());
    System.out.print("Maximo:                                             ");
    poblacion.elMejor();
    System.out.print(poblacion.getMatFitness()[poblacion.getElMejor()]);
    System.out.print("      "+poblacion.getMatFitness()[poblacion.getElMejor()]/poblacion.getSumaFitness());
    System.out.println("      "+poblacion.getMatFitness()[poblacion.getElMejor()]*4/poblacion.getSumaFitness());            
    System.out.print("---------------------------------------------------------------------------------------------------------------------------------------");
    System.out.println("-------------------------------------------------------------------------------------------------"); 
    System.out.println();
    System.out.println("                                                                                                              Procesamiento de esquemas");            
    System.out.print("---------------------------------------------------------------------------------------------------------------------------------------");
    System.out.println("-------------------------------------------------------------------------------------------------"); 
    System.out.print("                                                    Antes de reproduccion");
    System.out.print("                                              Despues de Reproduccion");
    System.out.println("                                            Despues de todos los Op.");
    System.out.print("                                      ------------------------------------------------------------ ------------------------------------");
    System.out.println("-------------------------- ----------------------------------------------------------------------");
    System.out.print("                                        Representantes               Promedio de esquema: f(H)");
    System.out.print("          Cuenta esperada      Cuenta real      Representantes");
    System.out.println("                Cuenta esperada      Cuenta real      Representantes");
    System.out.print("---------------------------------------------------------------------------------------------------------------------------------------");
    System.out.println("-------------------------------------------------------------------------------------------------");
    System.out.print("H1:   ");
    for (int imp=0; imp<poblacion.getLongIndiv(); imp++) {
      System.out.print(matEsquema[imp]);
    }
    System.out.print("                         ");
    System.out.print(poblacion.repDeEsq(matEsquema, poblacion.getMatPoblacion())+"                        "+poblacion.promEsq(matEsquema));              
    System.out.print("            "+teoEsqSel(matEsquema));
    System.out.print("            "+poblacion.ContarRep_de_Esquema(matEsquema, poblacion.getMat_desp_sel()));
    System.out.print("            "+poblacion.repDeEsq(matEsquema, poblacion.getMat_desp_sel()));
    System.out.print("                          "+teoEsqMut(matEsquema));
    System.out.print("            "+poblacion.ContarRep_de_Esquema(matEsquema, poblacion.getMat_desp_mut()));
    System.out.println("            "+poblacion.repDeEsq(matEsquema, poblacion.getMat_desp_mut()));
    numRep=poblacion.getNumRep();
    System.out.print("---------------------------------------------------------------------------------------------------------------------------------------");
    System.out.println("-------------------------------------------------------------------------------------------------");
  }

  private void impPobInicial() {
    println("Población inicial: ");
    for (int i = 0; i < numPob; i++) {
      print("Individuo " + (i+1) + ": "); 
      for (int j =0; j<poblacion.getLongIndiv(); j++) {
        print(poblacion.getMatPoblacion()[i][j]);
      }
      println();
    }
    println("*************************************");
  }


  //Esquema de seleccion para un solo individuo
  private double teoEsqSel(int ind) {
    return poblacion.getMatFitness()[ind]*numPob/poblacion.getSumaFitness();
  }        

  //Funcion que calcula m(H, t + sel)
  private double teoEsqSel(char[] esq) {
    return poblacion.ContarRep_de_Esquema(esq, poblacion.getMatPoblacion())*poblacion.promEsq(esq)/poblacion.promFitness();
  }

  //Funcion que calcula m(H, t + sel + cruz)
  private double teoEsqCruz(char[] esq) {
    return poblacion.ContarRep_de_Esquema(esq, poblacion.getMatPoblacion())*(poblacion.promEsq(esq)/poblacion.promFitness())*(1-poblacion.getProbReprod()*poblacion.ordenEsquema(esq)/(poblacion.getLongIndiv()-1));
  }

  //Funcion que calcula m(H, t + 1)
  private double teoEsqMut(char[] esq) {
    return poblacion.ContarRep_de_Esquema(esq, poblacion.getMatPoblacion())*(poblacion.promEsq(esq)/poblacion.promFitness())*(1-poblacion.getProbReprod()*poblacion.ordenEsquema(esq)/(poblacion.getLongIndiv()-1))*Math.pow(1-poblacion.getProbMutar(), poblacion.ordenEsquema(esq));
  }

  private void imprimirCruz(int ind) {
    System.out.print("[");
    for (int i=0; i<poblacion.getLongIndiv(); i++) {                        

      if (i==poblacion.getMat_desp_cruz()[ind][poblacion.getLongIndiv()+1]) {
        System.out.print("|");
      }

      System.out.print(poblacion.getMat_desp_sel()[ind][i]);

      if (i<poblacion.getLongIndiv()-1 && i!=poblacion.getMat_desp_cruz()[ind][poblacion.getLongIndiv()+1]-1) {
        System.out.print(",");
      }
    }
    System.out.print("]");
  }

  public int getNumRep() {
    return numRep;
  }
  
  public char[] getMatEsquema(){
    return matEsquema;
  }
}