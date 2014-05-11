---
layout: post
title: 'Storing Mercurial repository passwords in a secure manner'
comments: true
tags:
 - extension
 - gsoc
 - hg
 - keyring
 - mercurial
 - password
 - passwort
 - permanently
 - save
 - security
 - speichern
 - store
---

To store passwords permanently for Mercurial repositories  you have two options. One possibility is to store it as clear text in your Mercurial configuration file in <em>~/.hgrc</em>. Of course you should never do that and that's why I won't explain how this could be done. Instead you should use a Mercurial extension which allows you to store passwords in a keyring. This blog post summarizes how this can be done.

At first download <a title="Download the Mercurial keyring extension" href="http://bitbucket.org/Mekk/mercurial_keyring/raw/default/mercurial_keyring.py">this file</a> and save it somewhere, e.g. <em>~/.hg/mercurial_keyring.py</em>. As a next step open ~/.hgrc (create the file if it doesn't already exist) and add the following lines.

{% highlight ini %}
[extensions]
hgext.mercurial_keyring = ~/.hg/mercurial_keyring.py
{% endhighlight %}


Make sure to change the path to the actual location of the file which you just downloaded. Now you just have to install the following dependencies and you are done.

{% highlight bash %}
sudo apt-get install python-pip python-dev build-essential
sudo pip install keyring mercurial_keyring
{% endhighlight %}


Next time you push / pull something you should be asked for the last time for your password. If you run into any troubles you should <a title="Keyring wiki page" href="http://mercurial.selenic.com/wiki/KeyringExtension">consult this wiki page</a>.