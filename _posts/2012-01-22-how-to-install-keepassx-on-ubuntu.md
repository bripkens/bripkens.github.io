---
layout: post
title: 'How-to install KeePassX on Ubuntu'
comments: true
tags:
 - cross_plattform
 - how_to
 - installation
 - keepass
 - linux
 - ubuntu
 - password_manager
---

Do you have to remember an ever increasing amount of passwords? If you do, then
[KeePassX](http://www.keepassx.org/) might be of interest to you. It's a
password manager which has high security standards and which is additionally
available on Microsoft Windows and Mac OS X (besides Linux of course). If you
are running Ubuntu (this probably also applies to recent Debian versions), the
following snippet might be of interest to you as it shows how to install
version 0.4.3 of this program. After installation, you can find it in your
desktop manager's application menu (under GNOME 2 it's located in
Applications -> Accessories -> KeePassX).

{% highlight bash %}
NAME='keepassx-0.4.3'
FILENAME=$NAME'.tar.gz'

echo ':: Installing prerequisites...'
sudo apt-get install libxtst-dev libqt4-dev qt4-qmake

echo ':: Downloading and extracting file...'
wget 'http://downloads.sourceforge.net/keepassx/'$FILENAME
tar xvf $FILENAME

echo ':: Installing...'
cd $NAME
qmake
make
sudo make install

echo ':: Cleaning up...'
cd ..
rm -rf $NAME $FILENAME
{% endhighlight %}