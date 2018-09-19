#!/bin/bash

echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo "START PROVISIONING"
sudo apt-get update
sudo apt-get install -y git
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo "STARTING DOCKER INSTALL"
sleep 5
sudo apt-get remove docker docker-engine docker.io
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo docker run hello-world
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

echo "DOCKER INSTALL DONE"
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo "STARTING JAVA 8 INSTALL"
sleep 5

sudo apt-get -y -q install software-properties-common htop
sudo add-apt-repository ppa:webupd8team/java
sudo apt-get -y -q update
sudo echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
sudo apt-get -y -q install oracle-java8-installer
sudo update-java-alternatives -s java-8-oracle
javac -version
sudo sh -c "echo 'JAVA_HOME=\"/usr/lib/jvm/java-8-oracle\"' >> /etc/environment"
source /etc/environment
sudo echo $JAVA_HOME

echo "JAVA 8 INSTALL DONE"
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo "STARTING SCALA INSTALL"
sleep 5

scalaVer="2.12.2"
sudo apt-get remove scala-library scala
sudo wget www.scala-lang.org/files/archive/scala-"$scalaVer".deb
sudo dpkg -i scala-"$scalaVer".deb
sudo apt-get update
sudo apt-get install scala

echo "SCALA INSTALL DONE"
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo "STARTING SPARK INSTALL"
sleep 5

sudo wget https://archive.apache.org/dist/spark/spark-2.3.0/spark-2.3.0-bin-hadoop2.7.tgz
sudo tar -xvf spark-2.3.0-bin-hadoop2.7.tgz
sudo mv spark-2.3.0-bin-hadoop2.7 /usr/local/
sudo ln -s /usr/local/spark-2.3.0-bin-hadoop2.7/ /usr/local/spark
cd /usr/local/spark
sudo sh -c "echo 'SPARK_HOME=\"/usr/local/spark\"' >> /etc/environment"
source /etc/environment

echo "SPARK INSTALL DONE"
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
echo "STARTING VIRTUALENV / AWSCLI INSTALL"
sleep 5

sudo apt-get -y install python-virtualenv
wget https://bootstrap.pypa.io/get-pip.py
python get-pip.py
python -m pip install --upgrade pip setuptools wheel
sudo apt-get -y install python-setuptools
mkdir -p /home/vagrant/awscli
virtualenv /home/vagrant/awscli/
source /home/vagrant/awscli/bin/activate
python -m pip install --upgrade pip setuptools wheel
apt-get -y install python-setuptools
pip install boto
pip install beautifulsoup4 
pip install requests-ntlm
pip install 'requests[security]'
pip install awscli
mkdir -p /home/vagrant/.aws
touch /home/vagrant/.aws/credentials
cat > /home/vagrant/.aws/credentials << EOL
[default]
output = json
region = us-east-1
aws_access_key_id =
aws_secret_access_key =
EOL
deactivate
chown vagrant:vagrant -R /home/vagrant/awscli
chmod ugo+rwx -R /home/vagrant/awscli
chown vagrant:vagrant -R /home/vagrant/.aws
chmod u+rwx -R /home/vagrant/.aws
echo "VIRTUALENV / AWSCLI INSTALL DONE"
#echo "NIELSEN ENVIRONMENT"
#echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
#sudo pip install clouddeploy --extra-index-url http://mediaviewscm.enterprisenet.org/artifactory/api/pypi/local-pypi-repo/simple --trusted-host mediaviewscm.enterprisenet.org
echo "DONE PROVISIONING"
echo "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"