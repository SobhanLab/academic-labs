#include <iostream>
using namespace std;

void insertionSort(int arr[], int n) {
    int c1 = 0;
    int c2 = 0;

    for (int i = 1; i < n; i++) {
        int key = arr[i];
        int j = i - 1;

        while (j >= 0) {
            c1++;
            if (arr[j] > key) {
                arr[j + 1] = arr[j];
                c2++;
                j--;
            } else {
                break;
            }
        }
        arr[j + 1] = key;
        c2++;
    }
    cout << "Number of Comparisons: " << c1 << endl;
    cout << "Number of Swaps: " << c2 << endl;
}

int main() {
    int n;

    cout << "How many elements?: ";
    cin >> n;

    int* arr = new int[n];

    cout << "Enter elements: ";
    for (int i = 0; i < n; i++) {
        cin >> arr[i];
    }
    insertionSort(arr, n);

    cout << "Sorted array:\n";
    for (int i = 0; i < n; i++) {
        cout << arr[i] << " ";
    }
    cout << endl;

    delete[] arr;
    return 0;
}
