#! /bin/bash

clear
sleep 2
sudo apt update && sudo apt upgrade
#Instalando o docker
sudo apt install docker.io
echo "instalado"x
java -version
if [ $? = 0 ];

        then echo "Java instalado"

        else

        echo "Java não instalado"

        echo "Deseja instalar o Java? (s/n)"

        read get

        if [ \"$get\" == \"s\" ];

                then

                sudo apt install openjdk-17-jre -y

        fi

fi


which java | grep bin/java

if [ $? = 0 ]

        then

        which java-repository | grep java-repository

        if [ $? = 0 ]

                then

                git clone https://github.com/inc-view/java-repository.git

                else

		echo "Este repositório já existe"

        fi

fi


which python | grep /usr/bin/python

if [ $? = 0 ]

        then echo "Python instalado"

#cria o diretório e navega até ele

        mkdir diretorio_viss

        cd diretorio_viss

#clona o repositorio na branch qa

        git clone -b qa -n https://github.com/inc-view/java-repository.git

        cd viss-repository

# pega apenas a pasta python-semBD

        git checkout HEAD python-semBD

# Acessa a pasta

        cd python-semBD

#executa a api

        python3 api_dados.py

        else

#instala e depois executa a api

        sudo apt-get install python3.9

         mkdir diretorio_viss

        cd diretorio_viss

        git clone -b qa -n https://github.com/inc-view/viss-repository.git

        cd viss-repository

        git checkout HEAD python-semBD

        cd python-semBD


 sudo apt install python3-pip

        pip3 install psutil

        pip3 install matplotlib

        python3 api_dados.py


fi
