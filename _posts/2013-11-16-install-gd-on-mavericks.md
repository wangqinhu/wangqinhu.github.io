---
layout: post
title:	Install zlib/libpng/jpeg/freetype/libgd/GD on Mavericks
tags:	[mac, osx, libgd, zlib, jpeg, freetype, libpng, GD, 10.9, mavericks, install]
date:	2013-11-16 09:20:50
---

>Also works on Yosemite (OS X 10.10).

Various applications depend on library GD, however, you will alway fail on installing GD by CPAN.

I wrapped all the latest of zlib/libpng/jpeg/freetype/libgd/GD moudels and successfully installed GD on Mavericks (Mac OSX 10.9), hope this could help the one who have the similar environments.

Note Xcode should be installed first (if you haven't) and make sure you have a sudo privilege.

Download all the package [here][1].  
Extract the package gd.tar.gz and type `sudo ./install` to install.

This is an alternative approach:

``` bash
curl -O http://wangqinhu.com/data/gd/gd.tar.gz
tar -zxf gd.tar.gz
cd gd
sudo ./install
```
    
Here is the script if you want to modify for your situation (also supplied in the package).

``` bash
#!/bin/sh
#
# Install zlib/libpng/jpeg/freetype/libgd/GD
#
# Wang Qinhu (qinhu.wang # gmail.com)
# Nov 17, 2013
# version 0.2
#

#install zlib
echo "><><><><><><><><><"
echo "Installing zlib"
echo "><><><><><><><><><"
tar -zxf zlib-1.2.8.tar.xz
cd zlib-1.2.8
./configure
make
sudo make install
cd ..

#install libpng
echo "><><><><><><><><><"
echo "Installing libpng"
echo "><><><><><><><><><"
tar -zxf libpng-1.6.6.tar.xz
cd libpng-1.6.6
./configure
make
sudo make install
cd ..

#install jpegb
echo "><><><><><><><><><"
echo "Installing libjpeg"
echo "><><><><><><><><><"
tar -zxf jpegsrc.v9.tar.gz
cd jpeg-9
./configure
make
sudo make install
cd ..

#install freetype
echo "><><><><><><><><><"
echo "Installing freetype"
echo "><><><><><><><><><"
tar -zxf freetype-2.5.0.1.tar.bz2
cd freetype-2.5.0.1
./configure
make
sudo make install
cd ..

#install libgd
echo "><><><><><><><><><"
echo "Installing libgd"
echo "><><><><><><><><><"
tar -zxf libgd-2.1.0.tar.xz
cd libgd-2.1.0
./configure --with-zlib=/usr/local --with-jpeg=/usr/local --with-png=/usr/local --with-freetype=/usr/local
make
sudo make install
cd ..

#install GD
echo "><><><><><><><><><"
echo "Installing GD"
echo "><><><><><><><><><"
tar -zxf GD-2.50.tar.gz
cd GD-2.50
perl Makefile.PL
make
sudo make install
cd ..

#clean
rm -rf zlib-1.2.8 libpng-1.6.6 jpeg-9 freetype-2.5.0.1 libgd-2.1.0 GD-2.50

#test
echo "GD" | xargs -I MODULE perl -e  'print eval "use MODULE;1"?"\n\n\nOK\n\n\n":"\n\n\nFail\n\n\n"'
```

 [1]: /data/gd/gd.tar.gz
