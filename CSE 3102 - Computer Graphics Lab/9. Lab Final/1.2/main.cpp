#include<bits/stdc++.h>
#include<GL/glut.h>

float angle=120;
float rad=angle*3.1416/180;

void drawRectangle(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
    glBegin(GL_LINE_LOOP);
    glVertex2f(x1, y1);
    glVertex2f(x2, y2);
    glVertex2f(x3, y3);
    glVertex2f(x4, y4);
    glEnd();
}

void transform(float &x, float &y) {
    float rx= x*cos(rad) - y*sin(rad);
    float ry= x*sin(rad) + y*cos(rad);

    x=rx+3;
    y=-ry;
}

void display()
{
    glClear(GL_COLOR_BUFFER_BIT);

    float x1=50, y1=50;
    float x2=100, y2=50;
    float x3=100, y3=150;
    float x4=50, y4=150;

    glColor3f(0,0,0);
    drawRectangle(x1,y1,x2,y2,x3,y3,x4,y4);

    transform(x1,y1);
    transform(x2,y2);
    transform(x3,y3);
    transform(x4,y4);

    glColor3f(1,0,0);
    drawRectangle(x1,y1,x2,y2,x3,y3,x4,y4);

    glFlush();
}

void init()
{
    glClearColor(1,1,1,1);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluOrtho2D(-300,300,-300,300);
}

int main(int argc,char** argv)
{
    glutInit(&argc,argv);
    glutInitDisplayMode(GLUT_RGB|GLUT_SINGLE);
    glutInitWindowSize(640,480);

    glutCreateWindow("Door");
    init();

    glutDisplayFunc(display);
    glutMainLoop();
    return 0;
}
