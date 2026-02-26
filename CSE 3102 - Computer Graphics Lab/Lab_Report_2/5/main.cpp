#include <windows.h>
#include <GL/glut.h>

void display()
{
    glClear(GL_COLOR_BUFFER_BIT);

    float xs = -0.7, ys = 0.7;
    float xe = 0.7, ye = -0.7;

    glColor3f(0, 0, 1);
    glPointSize(3);

    glBegin(GL_POINTS);

    float x = xs, y = ys;
    while(x <= xe)
    {
        glVertex2f(x, y);
        x += 0.01;
        y -= 0.01;
    }

    glEnd();
    glFlush();
}

int main(int argc, char** argv)
{
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_RGB | GLUT_SINGLE);
    glutInitWindowSize(500, 500);
    glutCreateWindow("Diagonal m=-1");

    glClearColor(1,1,1,1);
    glutDisplayFunc(display);
    glutMainLoop();
}
