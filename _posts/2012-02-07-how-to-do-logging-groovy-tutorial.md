---
layout: post
title: 'How to do logging in Groovy'
comments: true
tags:
 - best_practice
 - gradle
 - groovy
 - how_to
 - logback
 - logging
 - slf4j
 - tutorial
---

For some reason I couldn't find any information about how to do logging in the
two Groovy books that are available at work. I have been using Groovy for a few
days now and I'm surprised about all the little tweaks and improvements the
developers made to reduce code duplication and boilerplate code. For this
reason, I figured that there *must* be a rather straightforward way to
do logging in Groovy. And of course, there is one!

*Please note that the following was introduced with Groovy version 1.8 and
therefore won't work in earlier versions. I don't know about any best practices
for earlier Groovy versions, but I fear that you may need to do it the way that
you are used to, i.e., the Java way.*

I'm going to show this using SLF4J as I always try to decouple my program from
specific logging frameworks. First of, let's start with our *build.gradle*
file (gradle project descriptor).

{% highlight groovy %}
apply plugin: 'groovy'

repositories {
    mavenCentral()
}

dependencies {
    groovy group: 'org.codehaus.groovy', name: 'groovy', version: '1.8.5'
    compile group: 'org.slf4j', name:'slf4j-api', version: '1.6.4'

    logbackVersion = '1.0.0'
    testRuntime group: 'ch.qos.logback', name:'logback-classic', version: logbackVersion
    testRuntime group: 'ch.qos.logback', name:'logback-core', version: logbackVersion
    testCompile group: 'junit', name: 'junit', version: '4.10'
}
{% endhighlight %}

First of all, we declare that we are using Groovy and that we are retrieving
dependencies from Maven Central. As for the dependencies, we need to have
Groovy and the SLF4J API available at compile have. For testing purposes, we
additionally declare a dependency on JUnit and logback.

In contrast to the way you do logging in Java, logging in Groovy is really
clean as the following code listing shows.

{% highlight groovy %}
import groovy.util.logging.Slf4j

@Slf4j
class HelloWorld {

    HelloWorld() {
        log.info 'Hello World'
    }

    static main(args) {
        new HelloWorld()
    }
}
{% endhighlight %}

What happens behind the curtain is that the abstract syntax tree (AST) is
analysed and transformed at compile time. With the
[groovy.util.logging.Slf4j](http://groovy.codehaus.org/gapi/groovy/util/logging/Slf4j.html)
annotation we declare a dependency on a SLF4J logger instance which is then
available through the *log* variable. If you are familiar with dependency
injection, think of it as field injection where the field is of type
[org.slf4j.Logger](http://www.slf4j.org/api/org/slf4j/Logger.html).

But this is not all, in Java you need to make use of format strings in your log
statements to avoid unnecessary overhead, e.g., because the log might be thrown
away because of the log level. In Groovy, this is not necessary as the log
statement will be transformed as the following listing shows.

{% highlight groovy %}
// This is the Java way
log.debug("Temperature set to {}. Old temperature was {}.", t, oldT);

// In Groovy you would write
log.debug("Temperature set to ${t}. Old temperature was ${oldT}.")

// But this will actually be generated for you
if (log.isDebugEnabled()) {
    log.debug("Temperature set to ${t}. Old temperature was ${oldT}.")
}
{% endhighlight %}

As you can see, the Groovy way of logging provides a few benefits that you can
make use of. I hope this was helpful :-).