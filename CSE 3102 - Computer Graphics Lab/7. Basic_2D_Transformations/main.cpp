#include <GL/glut.h>
#include <bits/stdc++.h>

using namespace std;

int ax1,ay1;
int ax2,ay2;
int ax3,ay3;

int tx,ty;

float sx,sy;
float angle;
float shx;

void drawTriangle(int x1,int y1,
                  int x2,int y2,
                  int x3,int y3) {

    glBegin(GL_LINES);

    glVertex2i(x1,y1);
    glVertex2i(x2,y2);

    glVertex2i(x2,y2);
    glVertex2i(x3,y3);

    glVertex2i(x3,y3);
    glVertex2i(x1,y1);

    glEnd();
}

void originalTriangle() {

    glColor3f(0,0,0);

    drawTriangle(ax1,ay1,
                 ax2,ay2,
                 ax3,ay3);
}

void init() {

    glClearColor(1,1,1,1);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();

    gluOrtho2D(-1000,1000,-1000,1000);
}

void originalDisplay() {

    glClear(GL_COLOR_BUFFER_BIT);
    originalTriangle();

    glFlush();
}

void translationDisplay() {

    glClear(GL_COLOR_BUFFER_BIT);
    originalTriangle();
    glColor3f(1,0,0);

    drawTriangle(ax1+tx,ay1+ty,
                 ax2+tx,ay2+ty,
                 ax3+tx,ay3+ty);

    glFlush();
}

void scalingDisplay() {

    glClear(GL_COLOR_BUFFER_BIT);
    originalTriangle();
    glColor3f(0,0,1);

    drawTriangle(ax1*sx,ay1*sy,
                 ax2*sx,ay2*sy,
                 ax3*sx,ay3*sy);

    glFlush();
}

void rotationDisplay() {

    glClear(GL_COLOR_BUFFER_BIT);
    originalTriangle();

    float rad=angle*3.1416/180;

    int rx1=ax1*cos(rad)-ay1*sin(rad);
    int ry1=ax1*sin(rad)+ay1*cos(rad);

    int rx2=ax2*cos(rad)-ay2*sin(rad);
    int ry2=ax2*sin(rad)+ay2*cos(rad);

    int rx3=ax3*cos(rad)-ay3*sin(rad);
    int ry3=ax3*sin(rad)+ay3*cos(rad);

    glColor3f(0,1,0);

    drawTriangle(rx1,ry1,
                 rx2,ry2,
                 rx3,ry3);

    glFlush();
}

void reflectionDisplay() {

    glClear(GL_COLOR_BUFFER_BIT);
    originalTriangle();
    glColor3f(1,0,1);

    drawTriangle(ax1,-ay1,
                 ax2,-ay2,
                 ax3,-ay3);

    glFlush();
}

void shearingDisplay() {

    glClear(GL_COLOR_BUFFER_BIT);
    originalTriangle();
    glColor3f(1,0.5,0);

    drawTriangle(ax1+shx*ay1,ay1,
                 ax2+shx*ay2,ay2,
                 ax3+shx*ay3,ay3);

    glFlush();
}

int main(int argc,char *argv[]) {

    cout<<"Enter x1 y1: ";
    cin>>ax1>>ay1;

    cout<<"Enter x2 y2: ";
    cin>>ax2>>ay2;

    cout<<"Enter x3 y3: ";
    cin>>ax3>>ay3;

    cout<<"Enter tx: ";
    cin>>tx;

    cout<<"Enter ty: ";
    cin>>ty;

    cout<<"Enter sx: ";
    cin>>sx;

    cout<<"Enter sy: ";
    cin>>sy;

    cout<<"Enter rotation angle: ";
    cin>>angle;

    cout<<"Enter shearing factor: ";
    cin>>shx;

    glutInit(&argc,argv);
    glutInitDisplayMode(GLUT_RGB|GLUT_SINGLE);
    glutInitWindowSize(640,480);

    glutInitWindowPosition(50,50);
    glutCreateWindow("Original");
    init();
    glutDisplayFunc(originalDisplay);

    glutInitWindowPosition(750,50);
    glutCreateWindow("Translation");
    init();
    glutDisplayFunc(translationDisplay);

    glutInitWindowPosition(1450,50);
    glutCreateWindow("Scaling");
    init();
    glutDisplayFunc(scalingDisplay);

    glutInitWindowPosition(50,600);
    glutCreateWindow("Rotation");
    init();
    glutDisplayFunc(rotationDisplay);

    glutInitWindowPosition(750,600);
    glutCreateWindow("Reflection");
    init();
    glutDisplayFunc(reflectionDisplay);

    glutInitWindowPosition(1450,600);
    glutCreateWindow("Shearing");
    init();
    glutDisplayFunc(shearingDisplay);

    glutMainLoop();

    return 0;
}
