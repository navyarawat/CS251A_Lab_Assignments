/*void function(struct num_array *a) {
    double square = a ->num1 * a->num1 +  a->num2 * a->num2  + 2 * a->num1 * a->num2;
    a->result = log(square)/sin(square);
    return;
}
*/
#include <stdio.h>
#include <math.h>

int main() {
    double a = 60419.7;
    double b = a + 1.0;
    double square = a*a + b*b + 2*a*b;
    double c = log(square)/sin(square);
    printf("%lf\n",c);
    return 0;
}
