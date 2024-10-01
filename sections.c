/* File: sections.c */

#include <stdint.h>

// Ovo ide u .rodata sekciju
const char example_data_1[] = {0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22, 0x22};
// 16 byte-ova zarad lakšeg uočavanja u S19 fajlu

/* Inicijalizovana globalna promenljiva */
uint32_t global_initialized_var = 0x33333333;        // Ovo ide u .data sekciju

/* Static inicijalizovana promenljiva */
static uint32_t static_initialized_var = 0x44444444; // Ovo ide u .data sekciju

/* Neinicijalizovana globalna promenljiva */
uint32_t global_uninitialized_var;           // Ovo ide u .bss sekciju

/* Static neinicijalizovana promenljiva */
static int static_uninitialized_var;         // Ovo ide u .bss sekciju

/* Funkcija */
void my_function(void)                   // Funkcije idu u .text sekciju
{
    /* Lokalna promenljiva */
    int local_var = 10;                  // Alocirana na stack-u, nije deo definisanih sekcija

    /* Korišćenje konstante */
    const uint16_t example_data_2[] = {0x5555, 0x5555, 0x5555, 0x5555, 0x5555, 0x5555, 0x5555, 0x5555}; // Ovo ide u .rodata sekciju
    // 16 byte-ova zarad lakšeg uočavanja u S19 fajlu

    /* Static lokalna promenljiva inicijalizovana */
    static uint32_t static_local_var = 0x66666666;     // Ovo ide u .data sekciju

    /* Static lokalna promenljiva neinicijalizovana */
    static uint32_t static_local_uninit_var;  // Ovo ide u .bss sekciju


    /* Kod funkcije */
    // ... implementacija
}

/* Definisanje podataka u posebnoj sekciji .example */
__attribute__((section(".example"))) const uint32_t example_data_3[] = {0x77777777, 0x77777777, 0x77777777, 0x77777777};
// 16 byte-ova zarad lakšeg uočavanja u S19 fajlu
