#include <windows.h>
#include <GL/glut.h>
#include<bits/stdc++.h>

void display()
{
    glClear(GL_COLOR_BUFFER_BIT);

    glPointSize(5);
    glBegin(GL_POINTS);

    glColor3f(1, 0, 0);
    glVertex2f(-0.5, 0.5);

    glColor3f(0, 1, 0);
    glVertex2f(-0.5, -0.5);

    glColor3f(0, 0, 1);
    glVertex2f(0.5, 0.5);

    glColor3f(1, 0.5, 0);
    glVertex2f(0.5, -0.5);

    glEnd();
    glFlush();
}

int main(int argc, char** argv)
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGB | GLUT_SINGLE);
    glutInitWindowSize(500, 500);
    glutCreateWindow("Multiple Points");

    glClearColor(1,1,1,1);
    glutDisplayFunc(display);
    glutMainLoop();
}
