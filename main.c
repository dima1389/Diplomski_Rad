// File: main.c

// Uključivanje standardnih definicija za celobrojne tipove sa određenom širinom
#include <stdint.h>

/*
Definisanje baznih adresa za periferijske registre specifične za mikrokontroler.
U ovom slučaju, koristimo CYT3BB/4BB TRAVEO™ T2G 32-bit Automotive MCU zasnovan na Arm® Cortex®-M7.
Važno je konsultovati dokumentaciju (datasheet) mikrokontrolera kako bismo dobili tačne adrese.
*/

// Definisanje baznih adresa i offseta za GPIO portove

// 6 Peripheral I/O map
// Table 6-1 CYT3BB/4BB peripheral I/O map
// Section   | Description                     | Base Address | Instances | Instance Size | Group | Slave
// PERI_PCLK | Peripheral Clock Groups         | 0x4004 0000  | 2         | 0x2000        | 0     | 2
// GPIO      | GPIO port control/configuration | 0x4031 0000  | 33        | 0x80          | 3     | 1

// 22 Peripheral protection unit fixed structure pairs
// Table 22-1 PPU fixed structure pairs (continued)
// Pair no. | PPU fixed structure pair      | Address    | Size       | Description
// 22       | PERI_MS_PPU_FX_PERI_PCLK_MAIN | 0x40040000 | 0x00004000 | Peripheral clock main
// 312      | PERI_MS_PPU_FX_GPIO_PRT12_PRT | 0x40310600 | 0x00000040 | GPIO_STD Port #12
// 345      | PERI_MS_PPU_FX_GPIO_PRT12_CFG | 0x40310640 | 0x00000020 | GPIO_STD Port #12 configuration

#define GPIO_PORT_OFFSET   0x80UL       // Veličina svakog GPIO porta
#define GPIO_BASE          0x40310000UL // Bazna adresa za GPIO portove

// Makro za dobijanje bazne adrese određenog GPIO porta (numerisanog od 0)
#define GPIO_PRT_BASE(N)   (GPIO_BASE + ((N) * GPIO_PORT_OFFSET))

// Bazna adresa za GPIO port 12 (ako numerišete portove od 0, port 12 je zapravo 13. port)
#define GPIO_PRT12_BASE    GPIO_PRT_BASE(12) // Ovo daje 0x40310600UL

// Bazna adresa za Clock Control (PERI)
// Pretpostavimo da je bazna adresa za PERI
#define PERI_BASE          0x40010000UL
// Ova adresa predstavlja početak registara za kontrolu takta perifernih uređaja.

// Offset adrese za specifične registre unutar periferija
#define PERI_CLOCK_CTL_12_OFFSET   0x060CUL  // Offset za kontrolu takta za GPIO port 12
#define GPIO_PRT_CFG_OFFSET        0x0000UL  // Offset za konfiguraciju GPIO porta
#define GPIO_PRT_OUT_OFFSET        0x0008UL  // Offset za izlazne podatke GPIO porta

/*
Definisanje pokazivača na stvarne registre dodavanjem offseta na bazne adrese.
Ove definicije omogućavaju direktan pristup registrima preko njihovih memorijskih adresa.
*/

// Definišemo pokazivač na registar za kontrolu takta za GPIO port 12
#define PERI_CLOCK_CTL_12  (*(volatile uint32_t *)(PERI_BASE + PERI_CLOCK_CTL_12_OFFSET))
// 'volatile' ključna reč označava da se vrednost može promeniti van programa, pa kompajler ne sme da optimizuje pristup.

// Definišemo pokazivač na registar za konfiguraciju GPIO porta 12
#define GPIO_PRT12_CFG     (*(volatile uint32_t *)(GPIO_PRT12_BASE + GPIO_PRT_CFG_OFFSET))
// Ovaj registar omogućava podešavanje režima rada pinova na GPIO portu 12.

// Definišemo pokazivač na registar za izlazne podatke GPIO porta 12
#define GPIO_PRT12_OUT     (*(volatile uint32_t *)(GPIO_PRT12_BASE + GPIO_PRT_OUT_OFFSET))
// Putem ovog registra možemo postaviti ili očitati stanje izlaznih pinova.

// Definisanje pina na koji je povezana LED dioda (pretpostavimo pin 3 numerisan od 0, dakle 4. pin)
#define LED_PIN        3U

/*
Funkcija za kreiranje jednostavnog kašnjenja.
Ova funkcija implementira petlju koja troši vreme i tako stvara pauzu u programu.
Za precizna kašnjenja, preporučuje se korišćenje hardverskih tajmera umesto ovakvih petlji.
*/

void delay(volatile uint32_t count)
{
    // 'volatile' ključna reč sprečava kompajler da optimizuje ovu petlju i ukloni je
    while (count--)
    {
        // Petlja koja se ponavlja sve dok 'count' ne dostigne nulu
        // Svaka iteracija predstavlja jednu jedinicu vremena zavisno od brzine procesora
        // Ova petlja ne radi ništa osim što troši vreme
    }
}

/*
Glavna funkcija programa gde počinje izvršavanje.
Ova funkcija inicijalizuje potrebne periferije i ulazi u beskonačnu petlju.
*/

int main(void)
{
    // -----------------------------
    // Konfiguracija takta periferija
    // -----------------------------

    // Omogućavanje takta za GPIO port 12 u PERI_CLOCK_CTL registru
    PERI_CLOCK_CTL_12 |= (1U << 31);
    /*
    - Postavljamo bit 31 u PERI_CLOCK_CTL_12 registru na 1.
    - '1U << 31' pomera jedinicu na najviši bit, što omogućava takt za odgovarajući port.
    - Operatorom OR ('|=') omogućavamo takt bez uticaja na ostale bitove.
    - Ovo je neophodno pre korišćenja GPIO porta jer periferija mora biti aktivirana.
    */

    // -----------------------------
    // Konfiguracija GPIO porta
    // -----------------------------

    // Konfigurisanje LED pina kao izlaznog
    // Brišemo postojeće postavke za taj pin u CFG registru
    GPIO_PRT12_CFG &= ~(0x7U << (LED_PIN * 3U));
    /*
    - Svaki pin zauzima 3 bita u CFG registru (jer može imati više režima rada).
    - Za pin 3, pomnožimo 3 * 3 da dobijemo pomeraj od 9 bita.
    - '0x7U' predstavlja binarno '111', a negacijom dobijamo masku koja ima nule na poziciji našeg pina i jedinice svuda drugde.
    - Operatorom AND ('&=') postavljamo ta 3 bita na 0, čime resetujemo postavke za taj pin.
    */

    // Postavljamo CFG vrednost za LED pin da bi bio izlazni
    GPIO_PRT12_CFG |= (0x1U << (LED_PIN * 3U));
    /*
    - Postavljamo odgovarajuće bitove na '001' da bismo konfigurirali pin kao snažni izlazni buffer.
    - Ostatak ostaje na 0, što daje željenu konfiguraciju za taj pin.
    - Operatorom OR ('|=') osiguravamo da ne promenimo druge pinove.
    */

    // -----------------------------
    // Glavna petlja programa
    // -----------------------------

    // Beskonačna petlja koja će naizmenično paliti i gasiti LED diodu
    while (1)
    {
        // Uključivanje LED diode
        GPIO_PRT12_OUT |= (1U << LED_PIN);
        /*
        - Postavljamo bit u OUT registru koji odgovara LED pinu na 1.
        - '1U << LED_PIN' pomera jedinicu na poziciju pina 3.
        - Operatorom OR ('|=') osiguravamo da ne promenimo stanje drugih pinova.
        */

        // Zovemo funkciju za kašnjenje da bi LED ostala uključena neko vreme
        delay(1000000U);  // Možete prilagoditi vrednost da promenite dužinu kašnjenja
        /*
        - Vrednost '1000000U' određuje trajanje kašnjenja.
        - Veća vrednost znači duže vreme čekanja.
        - Ovo kašnjenje nije precizno i zavisi od brzine procesora i optimizacije.
        */

        // Isključivanje LED diode
        GPIO_PRT12_OUT &= ~(1U << LED_PIN);
        /*
        - Brišemo bit u OUT registru koji odgovara LED pinu.
        - Negacijom ('~') maske dobijamo broj koji ima sve jedinice osim na mestu našeg pina.
        - Operatorom AND ('&=') postavljamo taj bit na 0, gaseći LED.
        */

        // Ponovo zovemo funkciju za kašnjenje da bi LED ostala isključena neko vreme
        delay(1000000U);  // Prilagodite vrednost po potrebi
        /*
        - Ovo kašnjenje omogućava da LED bude isključena određeni period pre ponovnog paljenja.
        - Time dobijamo efekat treptanja LED diode.
        */
    }

    // Program nikada ne bi trebalo da stigne do ove tačke
    // U ugradbenim sistemima, 'main' funkcija obično ne vraća vrednost
    return 0;
}
