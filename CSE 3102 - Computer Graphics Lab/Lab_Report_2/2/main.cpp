#include <windows.h>
#include <GL/glut.h>
#include<bits/stdc++.h>

using namespace std;

void display()
{
    glClear(GL_COLOR_BUFFER_BIT);

    float xs = -0.7, xe = 0.7;
    float y = 0.2;

    if(xs > xe) swap(xs, xe);

    glColor3f(0, 0, 0);
    glPointSize(3);

    glBegin(GL_POINTS);

    for(float x = xs; x <= xe; x += 0.01)
        glVertex2f(x, y);

    glEnd();
    glFlush();
}

int main(int argc, char** argv)
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGB | GLUT_SINGLE);
    glutInitWindowSize(500, 500);
    glutCreateWindow("Horizontal Line");

    glClearColor(1,1,1,1);
    glutDisplayFunc(display);
    glutMainLoop();
}
