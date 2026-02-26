#include <windows.h>
#include <GL/glut.h>
#include<bits/stdc++.h>

using namespace std;

void display()
{
    glClear(GL_COLOR_BUFFER_BIT);

    float x = 0.0;
    float ys = -0.7, ye = 0.7;

    if(ys > ye) swap(ys, ye);

    glColor3f(0, 0, 0);
    glPointSize(3);

    glBegin(GL_POINTS);

    for(float y = ys; y <= ye; y += 0.01)
        glVertex2f(x, y);

    glEnd();
    glFlush();
}

int main(int argc, char** argv)
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGB | GLUT_SINGLE);
    glutInitWindowSize(500, 500);
    glutCreateWindow("Vertical Line");

    glClearColor(1,1,1,1);
    glutDisplayFunc(display);
    glutMainLoop();
}
