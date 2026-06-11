#include<bits/stdc++.h>
#include<GL/glut.h>

int tx=5, ty=3;

void drawRectangle(int x1, int y1, int x2, int y2) {
    glBegin(GL_LINE_LOOP);
    glVertex2i(x1,y1);
    glVertex2i(x2,y1);
    glVertex2i(x2,y2);
    glVertex2i(x1,y2);
    glEnd();
}

void display() {
    glClear(GL_COLOR_BUFFER_BIT);

    glColor3f(0,0,0);
    drawRectangle(100,100,220,150);
    drawRectangle(120,140,180,180);

    glColor3f(1,0,0);
    drawRectangle(100+tx, 100+ty, 220+tx, 150+ty);
    drawRectangle(120+tx, 140+ty, 180+tx, 180+ty);

    glFlush();
}

void init() {
    glClearColor(1,1,1,1);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluOrtho2D(0,400,0,400);
}

int main(int argc,char** argv) {
    glutInit(&argc,argv);
    glutInitDisplayMode(GLUT_RGB|GLUT_SINGLE);
    glutInitWindowSize(640,480);

    glutCreateWindow("Smart Parking");

    init();
    glutDisplayFunc(display);
    glutMainLoop();
    return 0;
}
