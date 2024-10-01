/* linker_script.ld */

/* ***********************************************
   * Definisanje memorijskih blokova na osnovu specifikacija mikrokontrolera
   * Ovaj deo linker skripte definiše raspoložive memorijske regione u mikrokontroleru.
   * Ovo uključuje memorijske oblasti kao što su FLASH (nepromenljiva memorija) i RAM (radna memorija).
   * ***********************************************
*/
MEMORY
{
    /* Definišemo FLASH memoriju:
       - 'rx' označava dozvole: read i execute (čitati i izvršavati).
       - ORIGIN = 0x10000000 je početna adresa FLASH memorije.
       - LENGTH = 4160K je veličina FLASH memorije (4160 kilobajta).
       - Prilagodite ove vrednosti na osnovu vašeg mikrokontrolera.
    */
    FLASH (rx)  : ORIGIN = 0x10000000, LENGTH = 4160K  /* Prilagodite na osnovu vašeg uC */

    /* Definišemo RAM memoriju:
       - 'rwx' označava dozvole: read, write i execute (čitati, pisati i izvršavati).
       - ORIGIN = 0x28000000 je početna adresa RAM memorije.
       - LENGTH = 768K je veličina RAM memorije (768 kilobajta).
       - Prilagodite ove vrednosti na osnovu vašeg mikrokontrolera.
    */
    RAM   (rwx) : ORIGIN = 0x28000000, LENGTH = 768K   /* Prilagodite na osnovu vašeg uC */
}

/* ***********************************************
   * Definisanje sekcija
   * Ovaj deo linker skripte određuje kako će različite sekcije koda i podataka biti smeštene u memoriji.
   * ***********************************************
*/
SECTIONS
{
    /* **************************************
       * Sekcija za kod i podatke samo za čitanje
       * Ova sekcija sadrži izvršni kod (.text) i konstantne podatke (.rodata).
       * **************************************
    */

    /* Definišemo .text sekciju koja počinje od adrese 0x10000000 u FLASH memoriji */
    .text 0x10000000:
    {
        /* Poravnanje na 4 bajta da bi se osiguralo da je početak sekcije poravnat na reč */
        . = ALIGN(4);

        /* Uključujemo sve .text sekcije iz objektnih fajlova
           - *(.text) uključuje sekciju .text iz svih fajlova.
           - *(.text*) uključuje sve sekcije koje počinju sa .text (npr. .text.init).
        */
        *(.text)                  /* Sve .text sekcije */
        *(.text*)                 /* Sve .text* sekcije */

        /* Ponovo poravnavamo na 4 bajta nakon dodavanja sadržaja */
        . = ALIGN(4);
    } > FLASH  /* Ova sekcija se smešta u FLASH memoriju */

    /* Definišemo .rodata sekciju koja počinje od adrese 0x10100000 u FLASH memoriji */
    .rodata 0x10100000:
    {
        . = ALIGN(4);  /* Poravnanje na 4 bajta */

        /* Uključujemo sve .rodata sekcije iz objektnih fajlova
           - *(.rodata) uključuje sekciju .rodata iz svih fajlova.
           - *(.rodata*) uključuje sve sekcije koje počinju sa .rodata.
        */
        *(.rodata)                /* Sve .rodata sekcije */
        *(.rodata*)               /* Sve .rodata* sekcije */

        . = ALIGN(4);  /* Ponovo poravnavamo na 4 bajta */
    } > FLASH  /* Ova sekcija se smešta u FLASH memoriju */

    /* ***********************************************
       * Postavljanje .sw_info sekcije na adresu 0x10200000 u FLASH memoriji
       * Ova sekcija može sadržati informacije o softveru kao što su verzija, datum kompilacije, itd.
       * ***********************************************
    */
    .sw_info 0x10200000:
    {
        . = ALIGN(4);  /* Poravnanje na 4 bajta */

        /* Čuvamo sadržaj .sw_info sekcije
           - KEEP() osigurava da linker ne odbaci ovu sekciju tokom optimizacije.
           - *(.sw_info) uključuje sadržaj iz svih .sw_info sekcija u objektim fajlovima.
        */
        KEEP(*(.sw_info))         /* Čuvamo .sw_info sekciju */

        . = ALIGN(4);  /* Ponovo poravnavamo na 4 bajta */
    } > FLASH  /* Ova sekcija se smešta u FLASH memoriju */

    /* ***********************************************
       * Definišemo .example sekciju na adresi 0x10300000 u FLASH memoriji
       * Ova sekcija može biti korišćena za specifične potrebe, kao što su primeri koda ili posebni podaci.
       * ***********************************************
    */
    .example 0x10300000:
    {
        . = ALIGN(4);  /* Poravnanje na 4 bajta */

        /* Čuvamo sadržaj .example sekcija
           - KEEP() osigurava da linker ne odbaci ovu sekciju tokom optimizacije.
           - *(.example) uključuje sadržaj iz svih .example sekcija u objektim fajlovima.
        */
        KEEP(*(.example))                /* Čuvamo .example sekcije */

        . = ALIGN(4);  /* Ponovo poravnavamo na 4 bajta */
    } > FLASH  /* Ova sekcija se smešta u FLASH memoriju */

    /* ***********************************************
       * Definišemo .debug sekciju na adresi 0x10400000 u FLASH memoriji
       * Ova sekcija sadrži informacije za debagovanje koje koriste alati za debagovanje.
       * ***********************************************
    */
    .debug 0x10400000:
    {
        . = ALIGN(4);  /* Poravnanje na 4 bajta */

        /* Uključujemo različite .debug sekcije
           - *(.debug_line) sadrži informacije o linijama koda za debagovanje.
           - *(.debug_str) sadrži stringove korišćene u debagovanju.
           - *(.debug_aranges) sadrži opsege adresa za debagovanje.
           - *(.debug_abbrev) sadrži skraćenice za debagovanje.
           - *(.debug_info) sadrži glavne informacije za debagovanje.
        */
        *(.debug_line)      /* Sve .debug_line sekcije */
        *(.debug_str)       /* Sve .debug_str sekcije */
        *(.debug_aranges)   /* Sve .debug_aranges sekcije */
        *(.debug_abbrev)    /* Sve .debug_abbrev sekcije */
        *(.debug_info)      /* Sve .debug_info sekcije */

        . = ALIGN(4);  /* Ponovo poravnavamo na 4 bajta */
    } > FLASH  /* Ova sekcija se smešta u FLASH memoriju */

    /* **************************************
       * Sekcija za inicijalizovane podatke
       * .data sekcija sadrži promenljive koje imaju inicijalne vrednosti i koje se tokom izvršavanja nalaze u RAM-u.
       * **************************************
    */
    .data 0x28000000: AT (LOADADDR(.text) + SIZEOF(.text))
    {
        . = ALIGN(4);  /* Poravnanje na 4 bajta */

        _sdata = .;    /* Obeležavamo početak .data sekcije u RAM-u */

        /* Uključujemo sve .data sekcije iz objektnih fajlova
           - *(.data) uključuje .data sekciju iz svih fajlova.
           - *(.data*) uključuje sve sekcije koje počinju sa .data.
        */
        *(.data)                  /* Sve .data sekcije */
        *(.data*)                 /* Sve .data* sekcije */

        . = ALIGN(4);  /* Ponovo poravnavamo na 4 bajta */

        _edata = .;    /* Obeležavamo kraj .data sekcije u RAM-u */
    } > RAM  /* Ova sekcija se smešta u RAM memoriju */

    /* Napomena:
       - 'AT (LOADADDR(.text) + SIZEOF(.text))' označava adresu u FLASH memoriji odakle će se podaci kopirati prilikom inicijalizacije.
       - Ovo znači da će inicijalne vrednosti za .data sekciju biti smeštene odmah nakon .text sekcije u FLASH memoriji.
    */

    /* **************************************
       * Sekcija za neinicijalizovane podatke (nule-inicijalizovane promenljive)
       * .bss sekcija sadrži promenljive koje nisu inicijalizovane i koje se postavljaju na nulu prilikom pokretanja programa.
       * **************************************
    */
    .bss 0x28001000:
    {
        . = ALIGN(4);  /* Poravnanje na 4 bajta */

        _sbss = .;     /* Obeležavamo početak .bss sekcije u RAM-u */

        /* Uključujemo sve .bss sekcije i zajedničke (COMMON) sekcije
           - *(.bss) uključuje .bss sekciju iz svih fajlova.
           - *(.bss*) uključuje sve sekcije koje počinju sa .bss.
           - *(COMMON) uključuje zajedničke neinicijalizovane promenljive.
        */
        *(.bss)
        *(.bss*)
        *(COMMON)

        . = ALIGN(4);  /* Ponovo poravnavamo na 4 bajta */

        _ebss = .;     /* Obeležavamo kraj .bss sekcije u RAM-u */
    } > RAM  /* Ova sekcija se smešta u RAM memoriju */
}

/* ***********************************************
   * Kraj linker skripte
   * Ova linker skripta definiše kako će različite sekcije koda i podataka biti raspoređene u memoriji mikrokontrolera.
   * Omogućava preciznu kontrolu nad lokacijama gde će se određeni delovi programa nalaziti, što je ključno u ugradbenim sistemima.
   * ***********************************************
*/
