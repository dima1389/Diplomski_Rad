@rem File: 1_setup_environment.bat

@rem *******************************************
@rem * Batch Skripta za Postavljanje Okruženja *
@rem *******************************************

@rem Ova komanda preuzima i izvršava instalacionu skriptu za Chocolatey
@rem sa zvaničnog Chocolatey sajta.
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

@rem Instalacija Git, OpenSSL, Python, i VSCode alata koristeći Chocolatey paket menadžer.
@rem Opcija -y automatski potvrđuje instalaciju bez potrebe za korisničkim unosom.
choco install git openssl python vscode -y

@rem Pauza pre osvežavanja okruženja kako bi korisnik mogao da vidi instal log
pause

@rem Osvežavanje okruženja kako bi se nove promene u PATH varijabli odmah primenile
@rem u trenutnoj sesiji komandnog prompta.
refreshenv
