@rem File: setup_environment.bat

@rem Ažuriranje sistema
pacman -Syu --noconfirm

@rem Instalacija Git-a
pacman -S --noconfirm git

@rem Instalacija OpenSSL-a
pacman -S --noconfirm mingw-w64-x86_64-openssl

@rem Instalacija Python-a
pacman -S --noconfirm mingw-w64-x86_64-python

@rem Provera instalacija

git --version
where git

openssl version
where openssl

python --version
where python
