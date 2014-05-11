---
layout: post
title: 'Installing Rails 3 on a fresh Ubuntu machine'
comments: true
tags:
 - no_javascript_runtime
 - installation
 - how_to
 - rails
 - ruby
 - ubuntu
 - linux
---

Since I find myself researching the same information a second time, I put it on
my blog for further reference. The following steps were everything that is
needed to get started with Rails 3 on a fresh Ubuntu 10.10 installation.

{% highlight bash %}
# Installing rails, rubygems and its dependencies
sudo apt-get install build-essential ruby1.8-dev libsqlite3-dev
wget http://rubyforge.org/frs/download.php/75574/rubygems-1.8.12.zip
unzip rubygems-1.8.12.zip
cd rubygems-1.8.12.zip
sudo ruby setup.rb
sudo gem install rdoc-data; rdoc-data --install
sudo gem install rails

# create project
rails new .

# only necessary when no JavaScript runtime environment exists
echo "gem 'therubyracer'" >> Gemfile
sudo bundle

# starting the server
rails s
{% endhighlight %}