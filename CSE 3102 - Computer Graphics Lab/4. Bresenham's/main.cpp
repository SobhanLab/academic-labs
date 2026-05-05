#include <GL/glut.h>
#include <stdlib.h>
#include<bits/stdc++.h>
using namespace std;

int xs, ys, xe, ye;

void display() {

    glClear(GL_COLOR_BUFFER_BIT);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluOrtho2D(0.0, 640.0, 0.0, 480.0);

    glPointSize(3);
    glColor3f(0, 0, 1);

    int dx = xe - xs;
    int dy = ye - ys;

    float m = (float)dy / dx;
    cout << "Slope (m) = " << m << endl;

    glBegin(GL_POINTS);

    if (abs(m) <= 1){

        if (xs > xe){
            swap(xs, xe);
            swap(ys, ye);
        }

        int x = xs;
        int y = ys;

        int p = 2*abs(dy) - abs(dx);

        while (x <= xe){

            glVertex2i(x, y);

            x = x + 1;

            if (p < 0){
                p = p + 2*abs(dy);
            }
            else{
                if(dy > 0)
                    y = y + 1;
                else
                    y = y - 1;

                p = p + 2*abs(dy) - 2*abs(dx);
            }
        }
    }

    else{

        if (ys > ye){
            swap(xs, xe);
            swap(ys, ye);
        }

        int x = xs;
        int y = ys;

        int p = 2*abs(dx) - abs(dy);

        while (y <= ye){

            glVertex2i(x, y);

            y = y + 1;

            if (p < 0){
                p = p + 2*abs(dx);
            }
            else{
                if(dx > 0)
                    x = x + 1;
                else
                    x = x - 1;

                p = p + 2*abs(dx) - 2*abs(dy);
            }
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
    glutCreateWindow("Bresenham Line Drawing Algorithm");

    init();
    glutDisplayFunc(display);
    glutMainLoop();
}
