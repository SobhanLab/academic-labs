#include <windows.h>
#include <GL/glut.h>

void display()
{
    // drawing code will be written here
}

int main(int argc, char *argv[])
{
    glutInit(&argc, argv);
    glutInitWindowSize(640, 480);
    glutInitWindowPosition(10, 10);
    glutInitDisplayMode(GLUT_RGB | GLUT_SINGLE | GLUT_DEPTH);

    glutCreateWindow("GLUT Shapes");

    glutDisplayFunc(display);

    glutMainLoop();

    return EXIT_SUCCESS;
}
