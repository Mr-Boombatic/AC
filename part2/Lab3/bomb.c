#include <stdio.h>

#define COMPARE_WITH_KEY 2751

int main() {
    // Для всех 4 значных чисел
    for (int i = 1000; i < 10000; i++) {
        int reversed = 0;
        int original = i;

        // 1. Разворачиваем число
        while (original > 0) {
            int digit = original % 10;
            reversed *= 10;
            reversed += digit;
            original /= 10;
        }

        // 2. Квадрат суммы исходного числа и развернутого
        int result = (reversed + i) * (reversed + i);

        // Откидываем числа, в которых больше 8 цифр
        if (result >= 100000000) continue;

        // 3. Убираем 2 цифры справа
        result = result / 100;

        // 4. Убираем 2 цифры слева
        result = result % 10000;

        // 5. Меняем местами первые 2 и последние 2 цифры
        int left = result / 100;
        int right = result % 100;

        result = right * 100 + left;

        if (result == COMPARE_WITH_KEY) {
            printf("%d \n", i);
        }
    }
}