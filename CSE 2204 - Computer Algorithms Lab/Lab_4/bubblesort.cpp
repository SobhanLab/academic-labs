#include <iostream>
using namespace std;

void bubbleSort(int arr[], int n) {
    bool swapped;
    int c1, c2;

    for (int i = 0; i < n - 1; i++) {
        swapped = false;
        for (int j = 0; j < n - i - 1; j++) {
                c1++;
            if (arr[j] > arr[j + 1]) {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
                swapped = true;
            c2++;
            }
        }
        if (!swapped)
            break;
    }
    cout << "Number of Comparisn: " << c1++ <<endl;
    cout << "Number of Swapping: " << c2++ << endl;
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

    bubbleSort(arr, n);

    cout << "Sorted array:\n";
    for (int i = 0; i < n; i++) {
        cout << arr[i] << " ";
    }
    cout << endl;

    return 0;
}
