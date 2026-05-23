// ============================================================
// Autor: Edson Joel Carrera Avila
// main.cpp
// ============================================================

#include <iostream>
#include <vector>

using namespace std;

extern "C" double productoPunto(double* vec1, double* vec2, int N);

int main() {
    int n;

    cout << "Ingresa la dimension de los vectores (N): ";
    cin >> n;

    vector<double> vec1(n);
    vector<double> vec2(n);

    cout << "\n--- DATOS DEL VECTOR 1 ---" << endl;
    for (int i = 0; i < n; i++) {
        cout << "Ingresa el valor para vec1[" << i << "]: ";
        cin >> vec1[i];
    }

    cout << "\n--- DATOS DEL VECTOR 2 ---" << endl;
    for (int i = 0; i < n; i++) {
        cout << "Ingresa el valor para vec2[" << i << "]: ";
        cin >> vec2[i];
    }

    double resultado = productoPunto(vec1.data(), vec2.data(), n);

    cout << "\n----------------------------------------\n";
    cout << "Resultado del Producto Punto: " << resultado << endl;

    return 0;
}
