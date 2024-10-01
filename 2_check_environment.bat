@rem File: 2_check_environment.bat

@rem Provera instalacija

@rem Prikazuje verziju Git-a kako bi potvrdio uspešnu instalaciju
git --version
@rem Prikazuje putanju do Git izvršne datoteke
where git

@rem Prikazuje verziju OpenSSL-a kako bi potvrdio uspešnu instalaciju
openssl version
@rem Prikazuje putanju do OpenSSL izvršne datoteke
where openssl

@rem Prikazuje verziju Python-a kako bi potvrdio uspešnu instalaciju
python --version
@rem Prikazuje putanju do Python izvršne datoteke
where python

@rem Prikazuje verziju VSCode-a kako bi potvrdio uspešnu instalaciju
code --version
@rem Prikazuje putanju do VSCode izvršne datoteke
where code

pause

@rem Git komanda koja preuzima projekat sa GitHub-a i smešta ga u folder diplomski_projekat
git clone https://github.com/dima1389/Diplomski_Rad.git diplomski_projekat_ee3_2016

echo Okruzenje je uspesno postavljeno.
pause