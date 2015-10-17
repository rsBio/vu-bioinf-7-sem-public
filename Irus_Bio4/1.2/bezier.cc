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

	for (int i = 0; i < N; i++)
		cin >> a[i] >> b[i];
	
	double min_a = a[0];
	double max_a = a[0];

	for (int i = 1; i < N; i++){
		if (a[i] < min_a) min_a = a[i];
		if (a[i] > max_a) max_a = a[i];
	}
	cout << min_a << ' ' << max_a << '\n';
	
	double wide = (max_a - min_a) / N / N;

	
cout << "wide: " << wide << '\n';
cout << "N:  " << N << '\n';

	int eile = 4;
	double y[N * N + 1];

        for (int j = 1; j <= N * N + 1; j++){
cout << "j: " << j << '\n';

		double x = min_a + (j-1) * wide;
cout << "x: " << x << '\n';
		int jj = j - 3;
		int right = N * N - j + 1 - ( (eile + 1) >> 1);
		int left  = 0     - j + 1 + ( (eile + 1) >> 1);
		if (right < 0) jj += right;
		if (left  > 0) jj += left ;
		
cout << "jj: " << jj << '\n';

		y[j] = 0;

		for (int i = jj; i <= jj + eile; i++){
			double mult = 1;
			for (int ii = jj; ii <= jj + eile; ii++){
				if (ii == i) continue;
				mult *= (x - a[ii]) / (a[i] - a[ii]);
				cout << ":" << x << ' ' << a[ii];
				cout << ' ' << a[i] << ' ' << a[ii] << '\n';
			}
			cout << ' ' << mult << '\n';
			y[j] += mult * b[i];
		}
		cout << "  " << y[j] << '\n';
	}
        


	return 0;
}
