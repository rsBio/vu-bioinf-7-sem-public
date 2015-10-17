#include <math.h>
#include <iostream>

using namespace std;

double f (double x, double a){
	return pow( (a * x + 1), x );
}

int main(void) {
	
	int N;
	cin >> N;
	double a[N], b[N];

	for (int i = 1; i <= N; i++)
		cin >> a[i] >> b[i];
	
	double min_a = a[1];
	double max_a = a[1];

	for (int i = 2; i <= N; i++){
		if (a[i] < min_a) min_a = a[i];
		if (a[i] > max_a) max_a = a[i];
	}

cout << "min_a: " << min_a << " max_a: " << max_a << '\n';
	
	double wide = (max_a - min_a) / N / N;

	
cout << "wide: " << wide << '\n';
cout << "N:  " << N << '\n';

	int eile = 4;
	double x[N * N + 1];
	double y[N * N + 1];

        for (int j = 1; j <= N * N + 1; j++){
		x[j] = min_a + (j-1) * wide;
cout << "x[" << j << "]: " << x[j] << '\n';
	}

	int move = 0;

	double koef = 0;

        for (int j = 1; j <= N * N + 1; j++){

cout << "j: " << j << '\n';

		while (a[ (eile + 2) / 2 + move ] < x[j]
			&& eile + 1 + move < N
			){
			move ++;
cout << "!!!! move: " << move << '\n';
		}
		
//		if (move > eile + 2) move = eile + 2;
//		int jj = move;
		
cout << "move: " << move << '\n';

		y[j] = 0;

		for (int i = move + 1; i <= move + eile + 1; i++){
cout << "    -> " << i << " ";
			double mult = 1;
			for (int ii = move + 1; ii <= move + 1 + eile; ii++){
				if (ii == i) continue;
				mult *= (x[j] - a[ii]) / (a[i] - a[ii]);
				cout << ":" << x[j] << ' ' << a[ii];
				cout << " > " << a[i] << ' ' << a[ii] << '\n';
			}
			cout << " mult: " << mult << '\n';
			y[j] += mult * b[i];
			koef += mult;
		}
		cout << " y[j]: " << y[j] << '\n';
		cout << " koef: " << koef << '\n';
	}


	for (int j = 1; j <= N * N + 1; j++){
		cout << x[j] << " " << y[j] << " "<< sin(x[j]) << '\n';
	}
        


	return 0;
}
