#include <GL/glut.h>
#include <bits/stdc++.h>
using namespace std;

int r;

void dda(int xs, int ys, int xe, int ye) {
    float dx = xe - xs;
    float dy = ye - ys;
    float m = dy / dx;
    cout << "Slope (m): " << m << endl;

    if (fabs(m) < 1) {
        if (xs > xe) {
            swap(xs, xe);
            swap(ys, ye);
        }
        float y = ys;
        for (int x = xs; x <= xe; x++) {
            glVertex2i(x, round(y));
            y += m;
        }
    } else {
        if (ys > ye) {
            swap(xs, xe);
            swap(ys, ye);
        }
        float x = xs;
        for (int y = ys; y <= ye; y++) {
            glVertex2i(round(x), y);
            x += (1 / m);
        }
    }
}

void drawCircle(int xc, int yc, int r) {
    int x = 0;
    int y = r;
    int p = 1 - r;

    while (x <= y) {
        glVertex2i(xc + x, yc + y);
        glVertex2i(xc + y, yc + x);
        glVertex2i(xc + y, yc - x);
        glVertex2i(xc + x, yc - y);

        glVertex2i(xc - x, yc - y);
        glVertex2i(xc - y, yc - x);
        glVertex2i(xc - y, yc + x);
        glVertex2i(xc - x, yc + y);

        x++;

        if (p < 0) {
            p += 2 * x + 1;
        } else {
            y--;
            p += 2 * (x - y) + 1;
        }
    }
}

void display() {
    glClear(GL_COLOR_BUFFER_BIT);
    glPointSize(3);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();

    gluOrtho2D(-300.0, 300.0, -200.0, 200.0);

    glBegin(GL_POINTS);

    glColor3f(0.53, 0.81, 0.98);
    dda(-100, 0, 100, 0);
    dda(-100, 0, 0, -150);
    dda(100, 0, 0, -150);

    glColor3f(1, 0, 0);
    drawCircle(0, 100, r);

    glEnd();
    glFlush();
}

int main(int argc, char** argv) {
    cout << "Enter radius: ";
    cin >> r;

    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_SINGLE | GLUT_RGB);
    glutInitWindowSize(640, 480);
    glutCreateWindow("Centered DDA + Midpoint Circle");

    glClearColor(0, 0, 0, 1);

    glutDisplayFunc(display);
    glutMainLoop();

    return 0;
}
