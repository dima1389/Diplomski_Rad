@rem Fajl: 4_generate_keys_hash_signature.bat

@rem Ova skripta generiše RSA par ključeva (privatni i javni ključ), izračunava SHA256 heš fajla main.bin,
@rem potpisuje heš privatnim ključem, verifikuje potpis i spaja potpis sa originalnim fajlom.

@rem Korak 0: Obriši stari i napravi novi sign folder
rmdir /S /Q sign
mkdir sign

@rem Korak 1: Generiše RSA privatni ključ od 2048 bitova i čuva ga u sign\private_key.pem
openssl genpkey -algorithm RSA -out sign\private_key.pem -pkeyopt rsa_keygen_bits:2048

@rem Korak 2: Izvlači javni ključ iz privatnog ključa i čuva ga u public_key.pem
openssl rsa -pubout -in sign\private_key.pem -out sign\public_key.pem

@rem Korak 3: Izračunava SHA256 heš fajla main.bin i čuva rezultat u main.sha256
openssl dgst -sha256 -binary build\main.bin > sign\main.sha256

@rem Korak 4: Potpisuje heš privatnim ključem i čuva potpis u main-signature.bin
openssl pkeyutl -sign -in sign\main.sha256 -inkey sign\private_key.pem -out sign\main-signature.bin

@rem Korak 5: Verifikuje potpis koristeći javni ključ
openssl pkeyutl -verify -in sign\main.sha256 -sigfile sign\main-signature.bin -pubin -inkey sign\public_key.pem

@rem Korak 6: Spaja main.s19 sa main-signature.bin i kreira main-signed.s19 sa pomakom od 0x10201000
srec_cat build\main.s19 -Motorola sign\main-signature.bin -Binary -offset 0x10201000 -o sign\main-signed.s19 -Motorola -Output_Block_Size=16

pause
