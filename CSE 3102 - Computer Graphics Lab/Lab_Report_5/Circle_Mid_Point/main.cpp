#include <windows.h>
#include <GL/glut.h>
#include <iostream>
using namespace std;

int r;

void drawCircle() {
    int x = 0;
    int y = r;
    int p = 1 - r;

    int xc = 300, yc = 200;

    glBegin(GL_POINTS);

    while (x <= y) {
        glVertex2i(xc + x, yc + y);
        glVertex2i(xc - x, yc + y);
        glVertex2i(xc + x, yc - y);
        glVertex2i(xc - x, yc - y);

        glVertex2i(xc + y, yc + x);
        glVertex2i(xc - y, yc + x);
        glVertex2i(xc + y, yc - x);
        glVertex2i(xc - y, yc - x);

        if (p < 0) {
            p = p + 2*x + 3;
        }
        else {
            p = p + 2*(x - y) + 5;
            y--;
        }

        x++;
    }

    glEnd();
}

void display() {
    glClear(GL_COLOR_BUFFER_BIT);
    glColor3f(1, 1, 0);

    drawCircle();

    glFlush();
}

int main(int argc, char** argv) {
    cout << "Enter radius (r): ";
    cin >> r;

    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowSize(640, 480);
    glutCreateWindow("Midpoint Circle");

    gluOrtho2D(0, 640, 0, 480);

    glClearColor(0, 0, 0, 1);

    glutDisplayFunc(display);
    glutMainLoop();

    return 0;
}
