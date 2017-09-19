public class Operadores{
  public Operadores(){}
  
  public int aleatorio0o1(int i){
        int v = int(random(i));
        while (v==0 && i!=2) {            
            v=int(random(i));
        }
        return v;
  } 
  
  public double aleatorioRe(double a, double b){        
        return a+random(1)*(b-a);
  }
}