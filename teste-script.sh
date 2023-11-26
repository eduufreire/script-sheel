#! /bin/bash

clear

sleep 2

sudo apt install docker.io

sudo systemctl start docker
sudo systemctl enable docker

# Verificando se a imagem do MYSQL existe
sudo docker images | grep mysql
if [ $? = 0 ];
	then
	  echo "Imagem já existe"
	else
	  sudo docker pull mysql:5.7
fi

# Veriricando se o container existe
sudo docker ps -a | grep databaseink
if [ $? = 0 ];
	then
	  echo "Iniciando imagem"
	  sudo docker start databaseink
	else
	  sudo docker run -d -p 3306:3306 --name databaseink -e "MYSQL_ROOT_PASSWORD=urubu100" mysql:5.7

fi


sleep 2
clear

# Verificando o status do container e executando o Mysql, já com o script do banco
CONTAINER_STATUS=$(sudo docker inspect -f '{{.State.Status}}' databaseink)
if [ "$CONTAINER_STATUS" == "running" ];
	then
	  sudo docker exec -i databaseink mysql -u root -purubu100 < script_tabelas.sql
fi


java -version
if [ $? = 0 ];
	then
	  echo "Java instalado"
	else
	  echo "Instalando java"
	  sudo apt install openjdk-17-jre -y
fi


PYTHON_INSTALLED=0
which python | grep /usr/bin/python
if [ $? = 0 ];
	then
	  echo "Python instalado"
	  PYTHON_INSTALLED=1
	else
	  sudo apt-get install python3.9
	  sudo apt install python3-pip
	  pip3 install psutil
	  pip3 install matplotlib
	  PYTHON_INSTALLED=1
fi


clear
echo $PYTHON_INSTALLED

if [ "$PYTHON_INSTALLED" -eq 1 ];
	then

		ls | grep diretorio_viss
		if [ $? = 0 ];
		  then echo "Diretório existe" 
		  else mkdir diretorio_viss
		fi

	  	cd diretorio_viss
		ls | grep viss-repository
		if [ $? = 0 ];
		  then
		   echo "Repositório existe"
		  else
		   git clone https://github.com/inc-view/viss-repository.git
		fi


		cd viss-repository
		git checkout qa
		git pull origin qa
	  	cd python-semBD
	  	python3 api_dados.py

	else
	  echo "Houve algum problema com a instalação do Python"
fi

