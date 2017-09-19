public class UnaSolCodGray {
  private Poblacion pob;
  public UnaSolCodGray(int n, int l, int d) {
    pob = new Poblacion(n, l, d);
    pob.generarPrimerPob();
    pob.calificarPoblacionRastrGray();    
    pob.elPeor();
    seleccion();
    cruzamiento();
    mutacion();
  }  

  public void nextGen() {
    pob.copiarYReiniciar();
    pob.calificarPoblacionRastrGray();    
    pob.elPeor();
    seleccion();
    cruzamiento();
    mutacion();
  }

  private void seleccion() {
    for (int i = 0; i < pob.getNumIndiv()/2; i++) {
      pob.seleccion(2*i);
    }
  }

  private void cruzamiento() {
    for (int i = 0; i < pob.getNumIndiv()/2; i++) {
      pob.reproduccion(2*i, 2*i+1, 2*i);
    }
  }

  private void mutacion() {

    for (int i = 0; i < pob.getNumIndiv(); i++) {
      pob.mutacion(i);
    }
  }

  public Poblacion getPob() {
    return pob;
  }
}