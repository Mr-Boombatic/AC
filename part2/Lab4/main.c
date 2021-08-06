#include <stdio.h>

extern void calc_pi_1(double* res);
extern void calc_pi_2(double* res);
extern void calc_pi_3(double* res);

int main() {
    double res;
    calc_pi_1(&res);
    printf("%f \n", res); res = 0;
    calc_pi_2(&res);
    printf("%f \n", res); res = 0;
    calc_pi_3(&res);
    printf("%f \n", res);
}
