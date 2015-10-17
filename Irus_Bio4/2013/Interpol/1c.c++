#include <iostream> 
#include <fstream>

using namespace std;

int main ( int argc, char *argv[] )
{
  double sk1, sk2, in;
  ifstream fin("in.dat"); 

  double up1, up2, dn1, dn2;
  double up1y, up2y, dn1y, dn2y;
  double ats;
  bool noInterpol = false;
  bool up1b, up2b, dn1b, dn2b = false;
  
  cin >> in;
  
  while ( !fin.eof()  ){
  
    fin >> sk1 >> sk2;
  
    if (!fin.eof()){
      cout << sk1 <<"  " << sk2 << endl;
      if (sk1==in){ noInterpol = true; ats = sk2; }
      else if (sk1>in){ 
        if (!up1b){ up1b = true; up1=sk1; up1y=sk2; } 
        else {
          if (sk1>up1){
            if (!up2b){ up2b = true; up2=sk1; up2y=sk2; }
            else if (sk1<up2){ up2=sk1; up2y=sk2; }
            else if (sk1==up2){ cout << "bad data!" << endl; }
          }
          else if (sk1<up1){ up2=up1; up2y=up1y; up1=sk1; up1y=sk2; }
          else {cout << "bad data!" << endl;}
        }
      }
      else if (sk1<in){
        if (!dn1b){ dn1b = true; dn1=sk1; dn1y=sk2; } 
        else {
          if (sk1<dn1){
            if (!dn2b){ dn2b = true; dn2=sk1; dn2y=sk2; }
            else if (sk1>dn2){ dn2=sk1; dn2y=sk2; }
            else if (sk1==dn2){ cout << "bad data!" << endl; }
          }
          else if (sk1>dn1){ dn2=dn1; dn2y=dn1y; dn1=sk1; dn1y=sk2; }
          else {cout << "bad data!" << endl;}
        }
      }
    }
  cout << "...." << endl;
  }

  cout << dn2 <<" "<<dn1<<" "<<up1<<" "<<up2<< endl;
  cout << "...." << endl;

  fin.close();
  return 0;
}
