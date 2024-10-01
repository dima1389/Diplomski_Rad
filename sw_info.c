// sw_info_copy.c

#include <stdint.h>

/* Definicije verzije softvera */
#define MAJOR_RELEASE_VERSION 0x11  // Glavna verzija izdanja softvera
#define MINOR_RELEASE_VERSION 0x11  // Manja verzija izdanja softvera

/* Datum izdanja softvera */
#define SW_BUILD_DAY       0x11  // Dan izgradnje softvera
#define SW_BUILD_MONTH     0x11  // Mesec izgradnje softvera
#define SW_BUILD_YEAR_HI   0x11  // Viši bajt godine izgradnje softvera
#define SW_BUILD_YEAR_LO   0x11  // Niži bajt godine izgradnje softvera

/* Opšta konfiguracija */
#define CUSTOMER_ID    0x11  // ID kupca
#define PRODUCT_ID     0x11  // ID proizvoda
#define PRODUCT_TYPE   0x11  // Tip proizvoda

/* Indeksi kompatibilnosti */
#define BOOT_APP_INDEX   0x11  // Indeks za boot aplikaciju
#define APP_CALIB_INDEX  0x11  // Indeks za kalibracionu aplikaciju

/* Definicija strukture za informacije o softveru */
typedef struct
{
    uint8_t major_release_version;  // Glavna verzija izdanja
    uint8_t minor_release_version;  // Manja verzija izdanja
    uint8_t sw_build_day;           // Dan izgradnje softvera
    uint8_t sw_build_month;         // Mesec izgradnje softvera
    uint8_t sw_build_year_hi;       // Viši bajt godine izgradnje
    uint8_t sw_build_year_lo;       // Niži bajt godine izgradnje
    uint8_t customer_id;            // ID kupca
    uint8_t product_id;             // ID proizvoda
    uint8_t product_type;           // Tip proizvoda
    uint8_t boot_app_index;         // Indeks boot aplikacije
    uint8_t app_calib_index;        // Indeks kalibracione aplikacije
} sw_info;

/* Smeštanje promenljive u '.sw_info' sekciju i obeležavanje kao korišćene */
const sw_info id __attribute__((section(".sw_info"), used)) =
{
    MAJOR_RELEASE_VERSION,  // Glavna verzija izdanja
    MINOR_RELEASE_VERSION,  // Manja verzija izdanja
    SW_BUILD_DAY,           // Dan izgradnje softvera
    SW_BUILD_MONTH,         // Mesec izgradnje softvera
    SW_BUILD_YEAR_HI,       // Viši bajt godine izgradnje
    SW_BUILD_YEAR_LO,       // Niži bajt godine izgradnje
    CUSTOMER_ID,            // ID kupca
    PRODUCT_ID,             // ID proizvoda
    PRODUCT_TYPE,           // Tip proizvoda
    BOOT_APP_INDEX,         // Indeks boot aplikacije
    APP_CALIB_INDEX         // Indeks kalibracione aplikacije
};
