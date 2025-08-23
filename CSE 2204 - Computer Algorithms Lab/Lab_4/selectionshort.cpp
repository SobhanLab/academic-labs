#include <iostream>
using namespace std;

void selectionSort(int arr[], int n) {

    for (int i = 0; i < n - 1; i++) {
        int min = i;
        for (int j = i + 1; j < n; j++) {
            c1++;
            if (arr[j] < arr[min]) {
                min = j;
            }
        }
        if (min != i) {
            int temp = arr[i];
            arr[i] = arr[min];
            arr[min] = temp;
            c2++;
        }
    }
}

int main() {
    int n;

    cout << "How many elements? ";
    cin >> n;

    int* arr = new int[n];

    cout << "Enter elements:\n";
    for (int i = 0; i < n; i++) {
        cin >> arr[i];
    }

    selectionSort(arr, n);

    cout << "Sorted array:\n";
    for (int i = 0; i < n; i++) {
        cout << arr[i] << " ";
    }
    cout << endl;

    return 0;
}

