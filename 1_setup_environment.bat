@rem File: setup_environment.bat

@rem *******************************************
@rem * Batch Skripta za Postavljanje Okruženja *
@rem *******************************************

@rem Ova komanda preuzima i izvršava instalacionu skriptu za Chocolatey
@rem sa zvaničnog Chocolatey sajta.
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

@rem Instalacija Git, OpenSSL i Python alata koristeći Chocolatey paket menadžer.
@rem Opcija -y automatski potvrđuje instalaciju bez potrebe za korisničkim unosom.
choco install git openssl python -y

@rem Osvežavanje okruženja kako bi se nove promene u PATH varijabli odmah primenile
@rem u trenutnoj sesiji komandnog prompta.
refreshenv

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

@rem Kraj skripte
echo Okruženje je uspešno postavljeno.
pause
