@rem File: build.bat

@rem *********************************************
@rem * Ova batch skripta kompajlira i linkuje C kod za ARM Cortex-m7 mikrokontroler.
@rem *********************************************

@rem ***** Brisanje postojećih izlaznih fajlova *****
@rem   /Q - Tihi režim; ne traži potvrdu za brisanje fajlova.
@rem   /S - Briše direktorijum i sve njegove poddirektorijume i fajlove.
rmdir /S /Q build

@rem ***** Kompajliranje izvornog koda u izvršni ELF fajl *****
@rem Koristimo 'arm-none-eabi-gcc' kompajler namenjen za ARM Cortex-m7 mikrokontrolere.
@rem Detaljno objašnjenje opcija:
@rem   -mcpu=cortex-m7
@rem     - Specificiramo ciljnu CPU arhitekturu (Cortex-m7).
@rem   -mthumb
@rem     - Koristimo Thumb instrukcijski set za manju veličinu koda i efikasnost.
@rem   -O0
@rem     - Nivo optimizacije postavljen na 0 (bez optimizacije) radi lakšeg debagovanja.
@rem   -g
@rem     - Uključujemo informacije za debagovanje u izlazni fajl.
@rem   -T linker_script.ld
@rem     - Koristimo prilagođenu linker skriptu koja definiše raspored memorije i sekcija.
@rem   -Wl,-Map=output.map
@rem     - Prosleđujemo linkeru opciju da generiše map fajl pod nazivom 'output.map'.
@rem     - '-Wl,' znači da sve nakon zareza ide linkeru ('-Map=output.map').
@rem   -o main.elf
@rem     - Izlazni fajl će biti 'main.elf' (ELF format).
@rem   main.c
@rem     - Izvorni C fajl koji kompajliramo.
@rem   -nostartfiles
@rem     - Ne uključujemo standardne startne fajlove (crt0.o, itd.).
@rem     - Ovo je važno jer možda imamo sopstveni startni kod prilagođen mikrokontroleru.
@rem   --specs=nosys.specs
@rem     - Koristimo specijalne postavke koje isključuju standardne sistemske pozive.
@rem     - Ovo je korisno za ugradbene sisteme koji nemaju operativni sistem.
@rem   -save-temps
@rem     - Čuvamo privremene fajlove generisane tokom kompajliranja (.i, .s, .o fajlovi).
@rem     - Ovo može pomoći pri debagovanju ili analizi procesa kompajliranja.
@rem   -nostdlib
@rem     - Ne povezujemo standardnu biblioteku prilikom linkovanja.
@rem     - Ovo je neophodno ako želimo potpunu kontrolu nad kodom i izbegavamo nepotrebne funkcije.
arm-none-eabi-gcc -mcpu=cortex-m7 -mthumb -O0 -g -T linker_script.ld -Wl,-Map=output.map -o main.elf main.c sw_info.c sections.c -nostartfiles --specs=nosys.specs -save-temps -nostdlib

@rem ***** Konvertovanje ELF fajla u SREC format (main.bin) *****
@rem Koristimo 'arm-none-eabi-objcopy' alat za konverziju binarnih formata.
@rem Opcije:
@rem   -O srec
@rem     - Postavljamo izlazni format na SREC (Motorola S-record format).
@rem   main.elf
@rem     - Ulazni ELF fajl koji želimo da konvertujemo.
@rem   main.bin
@rem     - Izlazni fajl u SREC formatu sa ekstenzijom '.bin'.
@rem Ova komanda generiše 'main.bin' u SREC formatu, koji se može koristiti za programiranje mikrokontrolera.
arm-none-eabi-objcopy -O srec main.elf main.bin

@rem ***** Konvertovanje ELF fajla u S19 format (main.s19) *****
@rem Ponovo koristimo 'arm-none-eabi-objcopy' za generisanje S19 fajla.
@rem S19 je specifična varijanta S-record formata često korišćena za ugradbene sisteme.
@rem Ova komanda generiše 'main.s19' fajl koji može biti korišćen za flešovanje mikrokontrolera.
arm-none-eabi-objcopy -O srec main.elf main.s19

@rem ***** Prikaz informacija o sekcijama u objektnim i izvršnim fajlovima *****
@rem Koristimo 'arm-none-eabi-objdump' alat za ispis informacija o objektnim i izvršnim fajlovima.
@rem Opcija:
@rem   -h
@rem     - Ispisuje zaglavlja sekcija u objektnim ili izvršnim fajlovima.
@rem Ove komande prikazuju informacije o sekcijama u sledećim fajlovima:
@rem   main.elf-main.o      - Objektni fajl generisan iz 'main.c'.
@rem   main.elf-sections.o  - Objektni fajl generisan iz 'sections.c'.
@rem   main.elf-sw_info.o   - Objektni fajl generisan iz 'sw_info.c'.
@rem   main.bin             - Binarni fajl u SREC formatu.
@rem   main.s19             - S19 fajl (Motorola S-record format).
arm-none-eabi-objdump -h main.elf-main.o
arm-none-eabi-objdump -h main.elf-sections.o
arm-none-eabi-objdump -h main.elf-sw_info.o
arm-none-eabi-objdump -h main.bin
arm-none-eabi-objdump -h main.s19

@echo off

@rem ***** Kreiranje build foldera ako ne postoji *****
if not exist build mkdir build

@rem ***** Premještanje fajlova u build folder *****
for %%X in (s exe o bin s19 elf i map) do (
    move /Y *.%%X build >nul 2>&1
)

@rem ***** Kraj batch skripte *****
@rem Ova skripta kompajlira C kod za ARM Cortex-m7 mikrokontroler, generiše potrebne binarne fajlove i briše prethodnе generisane fajlove kako bi osigurala čisto okruženje za svaku kompilaciju.
