#include<bits/stdc++.h>
#include <GL/glut.h>

#define PI 3.1416

float bikeX = -600;
float wheelAngle = 0;
float roadOffset = 0;

void drawPixel(int x, int y){
    glVertex2i(x, y);
}

void dda(int x1, int y1, int x2, int y2){
    float dx = x2 - x1;
    float dy = y2 - y1;

    float steps = (fabs(dx) > fabs(dy)) ? fabs(dx) : fabs(dy);

    float xInc = dx / steps;
    float yInc = dy / steps;

    float x = x1;
    float y = y1;

    for(int i = 0; i <= steps; i++) {
        drawPixel(round(x), round(y));
        x += xInc;
        y += yInc;
    }
}

void plotCircle(int xc,int yc,int x,int y){
    glVertex2i(xc+x,yc+y);
    glVertex2i(xc-x,yc+y);
    glVertex2i(xc+x,yc-y);
    glVertex2i(xc-x,yc-y);

    glVertex2i(xc+y,yc+x);
    glVertex2i(xc-y,yc+x);
    glVertex2i(xc+y,yc-x);
    glVertex2i(xc-y,yc-x);
}

void midpointCircle(int xc,int yc,int r){
    int x = 0;
    int y = r;
    int p = 1 - r;

    while(x <= y){
        plotCircle(xc,yc,x,y);

        x++;

        if(p < 0)
            p += 2*x + 1;
        else{
            y--;
            p += 2*(x-y) + 1;
        }
    }
}

void drawSpokes(int xc,int yc,int r,float angle){
    float rad = angle * PI / 180.0;
    int x = r * cos(rad);
    int y = r * sin(rad);

    dda(xc-x,yc-y,xc+x,yc+y);
    dda(xc-y,yc+x,xc+y,yc-x);
}

void drawRoad(){
    glColor3f(1,1,1);
    dda(-700,-100,700,-100);
    for(int i=-700;i<700;i+=80){
        int start = i + (int)roadOffset;
        dda(start,-120,start+40,-120);
    }
}

void drawBicycle(float tx){
    int r = 40;

    int rearX = -100 + tx;
    int rearY = -50;

    int frontX = 100 + tx;
    int frontY = -50;

    int seatX = -20 + tx;
    int seatY = 50;

    int handleX = 130 + tx;
    int handleY = 70;

    glColor3f(1,1,1);

    midpointCircle(rearX,rearY,r);
    midpointCircle(frontX,frontY,r);

    drawSpokes(rearX,rearY,r,wheelAngle);
    drawSpokes(frontX,frontY,r,wheelAngle);

    dda(rearX,rearY,seatX,seatY);
    dda(seatX,seatY,frontX,frontY);
    dda(rearX,rearY,frontX,frontY);

    dda(seatX-15,seatY+10,seatX+15,seatY+10);

    dda(frontX,frontY,handleX,handleY);
    dda(handleX-10,handleY,handleX+10,handleY);

    int pedalX = 20 + tx;
    int pedalY = 0;

    midpointCircle(pedalX,pedalY,15);
    float rad = wheelAngle * PI / 180.0;

    int px = 20 * cos(rad);
    int py = 20 * sin(rad);

    dda(pedalX,pedalY,pedalX+px,pedalY+py);
    dda(pedalX,pedalY,pedalX-px,pedalY-py);

    dda(rearX,rearY,pedalX,pedalY);
    dda(frontX,frontY,pedalX,pedalY);
}

void display(){
    glClear(GL_COLOR_BUFFER_BIT);
    glPointSize(2);
    glBegin(GL_POINTS);

    drawRoad();
    drawBicycle(bikeX);

    glEnd();
    glutSwapBuffers();
}

void update(int value){
    bikeX += 2;
    wheelAngle -= 5;
    roadOffset -= 2;

    if(roadOffset < -80)
        roadOffset = 0;

    if(bikeX > 700)
        bikeX = -700;

    glutPostRedisplay();
    glutTimerFunc(20,update,0);
}

void init(){
    glClearColor(0,0,0,1);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluOrtho2D(-700,700,-250,250);
}

int main(int argc,char** argv){
    glutInit(&argc,argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);
    glutInitWindowSize(1000,600);
    glutCreateWindow("Bicycle Riding Animation");
    init();
    glutDisplayFunc(display);
    glutTimerFunc(20,update,0);
    glutMainLoop();

    return 0;
}
