#include <GL/glut.h>
#include <stdlib.h>
#include<bits/stdc++.h>
using namespace std;

float xs, ys, xe, ye;

void display() {
    glClear(GL_COLOR_BUFFER_BIT);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluOrtho2D(0.0, 640.0, 0.0, 480.0);

    glPointSize(3);
    glColor3f(.4, 0, 1);

    float dx = xe - xs;
    float dy = ye - ys;
    float m = dy / dx;
    cout << "Slope (m) = " << m << endl;

    glBegin(GL_POINTS);

    if (abs(m) <= 1){
        if (xs > xe){
            swap(xs, xe);
            swap(ys, ye);
        }

        float x = xs;
        float y = ys;

        while (x <= xe){
            glVertex2i(round(x), round(y));
            x = x + 1;
            y = y + m;
        }
    }
    else{
        if (ys > ye){
            swap(xs, xe);
            swap(ys, ye);
        }

        float x = xs;
        float y = ys;
        float inv_m = dx / dy;

        while (y <= ye){
            glVertex2i(round(x), round(y));
            y = y + 1;
            x = x + inv_m;
        }
    }

    glEnd();
    glFlush();
}

void init(){
    glClearColor(1,1,1,1);
}

int main(int argc, char** argv){
    cout << "Enter starting point (xs ys): ";
    cin >> xs >> ys;

    cout << "Enter ending point (xe ye): ";
    cin >> xe >> ye;

    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGB | GLUT_SINGLE);
    glutInitWindowSize(640, 480);
    glutCreateWindow("DDA Line Drawing Algorithm");

    init();
    glutDisplayFunc(display);
    glutMainLoop();
}
