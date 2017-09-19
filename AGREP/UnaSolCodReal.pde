public class UnaSolCodReal {
  private PoblacionReal pob;
  public UnaSolCodReal (int n, int l, float m, float c, float li, float ls){
    pob = new PoblacionReal(n,l,m,c,li,ls);
    pob.generarPrimerPob();
    pob.calificarPoblacionRastr();    
    pob.elPeor();
    seleccion();
    //cruzamiento();
    //mutacion();
  }
  
  public void nextGen(){
    pob.copiarYReiniciar();
    pob.calificarPoblacionRastr();    
    pob.elPeor();
    seleccion();
    cruzamiento();
    mutacion();
  }
  
  private void seleccion() {
    for (int j = 0; j < pob.getNumIndiv()/2; j++) {
      pob.seleccion(2*j);
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
  
  public PoblacionReal getPob(){
    return pob;
  }
}