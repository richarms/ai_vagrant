#!/bin/sh

# make sure we have all ubuntu repositories
sudo cat >/etc/apt/sources.list <<EOL
deb http://za.archive.ubuntu.com/ubuntu/ precise main universe multiverse
deb http://za.archive.ubuntu.com/ubuntu/ precise-updates main universe multiverse
deb http://security.ubuntu.com/ubuntu precise-security main universe multiverse
EOL

sudo apt-get update
sudo apt-get install -y software-properties-common python-software-properties
sudo apt-get update


## --------------------
## Celery Setup
## --------------------
sudo apt-get install celery rabbitmq-server


## set up Rabbit MQ Access control
sudo rabbitmqctl add_user myuser mypassword
sudo rabbitmqctl add_vhost myvhost
sudo rabbitmqctl set_permissions -p myvhost myuser "" ".*" ".*"




## --------------------
## TraP Setup
## --------------------

sudo add-apt-repository -y ppa:gijzelaar/aartfaac
sudo apt-get update

sudo apt-get install -y pyrap python-scipy ipython vim \
    python-pygresql build-essential python-pip python-numpy postgresql cmake \
    libboost-python-dev wcslib-dev gfortran python-psycopg2 python-pyfits git \
	cmake build-essential python-pip python-scipy python-pywcs \
	rabbitmq-server mongodb python-pymongo libfreetype6-dev libpng-dev \
	xvfb

## compile and install trap
mkdir -p /vagrant/tmp
cd /vagrant/tmp
git clone https://richarms:mosfet1@github.com/transientskp/tkp.git || true
mkdir tkp/build && cd tkp/build
cmake ..
make clean
make
sudo make install
cd ..
sudo pip install -U distribute
pip install -r requirements.txt
#rm -rf /vagrant/tmp

## create TraP project
## -------------------

# Setup database
#			-- assumes pg_hba.conf has been copied to /vagrant/postgres by the Vagrant Provisioner
cd /vagrant/postgres
sudo chown postgres:postgres pg_hba.conf
sudo cp pg_hba.conf /etc/postgresql/9.1/main/
sudo service postgresql restart

# init TraP project
cd /vagrant
rm -rf vagrantproject
tkp-manage.py initproject vagrantproject || true
cd vagrantproject
./manage.py initjob vagrantjob || true


# setup & configure banana
cd /opt
git clone https://github.com/transientskp/banana || true
cd banana
cp bananaproject/settings/local_example.py bananaproject/settings/local.py
pip install -r requirements.txt


#----------------------
# Install meqtrees/UberRadioAstronomy software suite 
#----------------------
#----------------------
# install software from ubuntu repositories
#sudo apt-get update
#sudo apt-get install -y software-properties-common python-software-properties \
#    python-pip libzmq-dev python2.7-dev build-essential supervisor xvfb
#
## add the SKA-SA launchpad PPA
#sudo add-apt-repository ppa:ska-sa/main
#sudo apt-get update
#
## install the radio astro software from the SKA repo
#sudo apt-get install -y libcasacore-dev \
#    casacore-data lwimager python-astlib python-kittens \
#    python-purr python-pyxis python-tigger \
#    python-meqtrees-timba python-meqtrees-cattery makems python-owlcat meqtrees
#
## install all python modules
#sudo pip install -r /vagrant/vagrant/requirements.txt
#
## configure a ipython noteboot service
#sudo cp /vagrant/vagrant/supervisor-ipython.conf /etc/supervisor/conf.d/ipython.conf
#sudo service supervisor stop
#sudo service supervisor start



