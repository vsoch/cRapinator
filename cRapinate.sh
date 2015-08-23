# The cRapinator
# setup an R-server to generate graphics and data structures over the web
# for importing / use in better applications (*cough* python *cough*)

sudo apt-get update > /dev/null
sudo apt-get install -y --force-yes git 
sudo apt-get install -y --force-yes build-essential
sudo apt-get install -y --force-yes apache2
sudo apt-get update

# Set up cgi-bin
# Any files need to have permission sudo chmod 755 file.cgi
sudo a2enmod cgi
sudo service apache2 restart

# Test: http://localhost/cgi-bin/foo.cgi
if ! [ -f /usr/lib/cgi-bin/foo.cgi ]; then
  echo """#!/usr/bin/perl
print "Content-type: text/html\n\n";
print "<html>Hello World</html>";
""" >/tmp/abcde
  sudo cp /tmp/abcde /usr/lib/cgi-bin/foo.cgi
  sudo chmod 755 /usr/lib/cgi-bin/foo.cgi
fi

# Install R
sudo apt-get install -y --force-yes gfortran
sudo apt-get install -y --force-yes xorg
sudo apt-get install -y --force-yes xorg-dev
sudo apt-get install -y --force-yes texlive
sudo apt-get install -y --force-yes texlive-full # probably redundant
sudo apt-get install -y --force-yes libcairo-2
sudo apt-get install -y --force-yes libcairo-2-dev
sudo apt-get install -y --force-yes libtiff5
sudo apt-get install -y --force-yes libtiff5-dev
sudo apt-get install -y --force-yes icu-devtools
sudo apt-get install -y --force-yes libicu-dev
sudo apt-get install -y --force-yes libicu52
sudo apt-get install -y --force-yes libicu52-dbg
sudo apt-get install -y --force-yes libjpeg62
sudo apt-get install -y --force-yes libreadline6
sudo apt-get install -y --force-yes libreadline6-dev
wget https://cran.r-project.org/src/base/R-3/R-3.2.2.tar.gz
tar -xzvf R-3.2.2.tar.gz 
cd R-3.2.2/
./configure --enable-R-shlib
make
sudo make install
cd $HOME
sudo rm -rf $HOME/R-3.2.2

# Install packages for R Rserve, Cairo, FastRWeb
sudo apt-get install -y --force-yes openjdk-7-jdk
sudo apt-get install -y --force-yes autoconf
wget https://cran.r-project.org/src/contrib/Cairo_1.5-8.tar.gz
sudo R CMD INSTALL Cairo_1.5-8.zip
rm Cairo_1.5-8.tar.gz

wget https://cran.r-project.org/src/contrib/base64enc_0.1-3.tar.gz
tar -xzvf base64enc_0.1-3.tar.gz
sudo R CMD INSTALL base64enc
rm -rf base64enc
rm base64enc_0.1-3.tar.gz

wget https://www.rforge.net/Rserve/snapshot/Rserve_1.8-4.tar.gz
sudo apt-get install -y --force-yes libssl-dev
sudo R CMD INSTALL Rserve_1.8-4.tar.gz 

wget https://rforge.net/FastRWeb/snapshot/FastRWeb_1.1-1.tar.gz
sudo R CMD INSTALL FastRWeb_1.1-1.tar.gz
rm FastRWeb_1.1-1.tar.gz

wget https://cran.r-project.org/src/contrib/rjson_0.2.15.tar.gz
sudo R CMD INSTALL rjson_0.2.15.tar.gz
rm rjson_0.2.15.tar.gz

cd /usr/local/lib/R/library/FastRWeb
sudo bash install.sh

# R
# system.file("cgi-bin", package="FastRWeb")
# /usr/local/lib/R/library/FastRWeb/cgi-bin
sudo cp /usr/local/lib/R/library/FastRWeb/cgi-bin/Rcgi /usr/lib/cgi-bin/R
sudo vim /var/FastRWeb/code/rserve.conf
# I added 
# keep-alive enable
# remote enable
sudo /var/FastRWeb/code/start

# Test it out
# Test: http://localhost/cgi-bin/foo.cgi
if ! [ -f  /var/FastRWeb/web.R/foo.png.R ]; then
  echo """run <- function(n=100, ...) {
      n <- as.integer(n)
      p <- WebPlot(800, 600)
      plot(rnorm(n), rnorm(n), pch=19, col=2)
      p
    }""" >/tmp/abc
  sudo cp /tmp/abc  /var/FastRWeb/web.R/foo.png.R
  sudo chmod 755 /var/FastRWeb/web.R/foo.png.R
fi

# http://localhost/cgi-bin/R/foo.png?n=500

# Return json
if ! [ -f  /var/FastRWeb/web.R/json.R ]; then
  echo """library(rjson)
      run <- function(n=100,...) {
      var=c()
      var$hello = 'hello!'
      var$goodbye = 'goodbye'
      data = as.data.frame(var)
      return(toJSON(var))
    }""" >/tmp/abcdef
  sudo cp /tmp/abcdef  /var/FastRWeb/web.R/foo.json.R
  sudo chmod 755 /var/FastRWeb/web.R/json.R
fi

# http://localhost/cgi-bin/R/json
