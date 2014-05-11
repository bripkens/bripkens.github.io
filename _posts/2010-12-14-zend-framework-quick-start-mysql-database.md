---
layout: post
title: 'Zend framework quick start with MySQL database'
comments: true
tags:
 - database
 - datasource
 - framework
 - guestbook
 - introduction
 - mysql
 - php
 - quick_start
 - tutorial
 - zend
---


The Zend framework quick start guide describes how to use an SQLite database. I wanted to use a MySQL database instead. You should add the following lines to your application.ini if you want it to use a MySQL database.


{% highlight ini %}[production]

; ...

resources.db.adapter = "PDO_MYSQL"

[staging : production]

; ...

[testing : production]

; ...

[development : production]

; ...

resources.db.params.host = "hostName" ; something like localhost or an IP
resources.db.params.username = "username"
resources.db.params.password = "password"
resources.db.params.dbname = "databaseName"
{% endhighlight %}


The create table script for the guestbook table.


{% highlight sql %}
--Uncomment the line below when executing this script in netbeans.
--use databaseName;

CREATE TABLE guestbook (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(32) NOT NULL,
    comment TEXT NULL,
    created TIMESTAMP DEFAULT NOW()
);
{% endhighlight %}