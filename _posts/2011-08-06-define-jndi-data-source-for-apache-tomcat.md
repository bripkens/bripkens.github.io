---
layout: post
title: 'Define JNDI data source for Apache Tomcat'
comments: true
tags:
 - apache
 - context.xml
 - data_source
 - how_to
 - guide
 - jndi
 - spring
 - java_ee
 - jpa
 - tomcat
 - tutorial
---


Defining data sources via JNDI has various benefits, e.g. pooling and
completely external configuration. The latter is especially important as this
avoids putting database credentials into your application. Since I'm currently
studying the Spring framework, I also wanted to use another application server.
In fact, I wanted to try Apache Tomcat 7, a servlet container.

I have to say that I found the <a title="The JNDI how-to for Apache Tomcat"
href="http://tomcat.apache.org/tomcat-7.0-doc/jndi-datasource-examples-howto.html">
JNDI how-to</a> for Apache Tomcat insufficient and therefore want to share some
information that I collected in addition to the how-to.

At first, they show what a context.xml file should look like but they don't
tell you where to put it (ok they lead you to another documentation page). I
found the simplest place to be the <em>$CATALINA_BASE/conf/context.xml</em> as
this is probably sufficient for most use cases. Please note though that all
deployed applications will have access to this data source. The next thing you
shouldn't forget is to put the driver into <em>$CATALINA_BASE/lib/</em>. In
combination with the aforementioned how-to this should be all you need to use
JNDI data sources with Apache Tomcat.