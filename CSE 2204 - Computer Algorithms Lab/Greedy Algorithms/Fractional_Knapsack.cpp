#include<bits/stdc++.h>
using namespace std;

int main(){
    int capacity, n;
    cout <<"Knapsack Capacity: ";
    cin >> capacity;
    cout <<"Number of Products: ";
    cin >> n;

    int product[n], value[n], weight[n];
    int v_per_w[n];
    for(int i=0; i<n; i++){
        cout <<"Enter Product " << i+1 <<" Value & Weight (in one line): " << endl;
        cin >> value[i] >> weight[i];
        v_per_w[i] = value[i] / weight[i];
    }

    for(int i=0; i<n; i++){
        for(int j=i+1; j<n; j++){
            if(v_per_w[i] < v_per_w[j]) {
                swap(product[i], product[j]);
                swap(value[i], value[j]);
                swap(weight[i], weight[j]);
                swap (v_per_w[i], v_per_w[j]);
            }
        }
    }

    int total_value = 0, current_weight=0;
    for(int i=0; i<n; i++){
        if(current_weight + weight[i]<=capacity){
            current_weight += weight[i];
            total_value += value[i];
        }
        else{
            int fraction = (capacity - current_weight) * v_per_w[i];
            total_value += fraction;
            break;
        }
    }

    cout <<"Maximum Value: " << total_value;

}