---
layout: post
title: 'Gravatar for Java applications'
comments: true
tags:
 - avatar
 - gravatar
 - beans
 - dependency
 - gravatar4java
 - java
 - library
 - maven
 - ivy
 - maven_central
 - mvn
 - spring
---


Gravatar for Java (actually Gravatar4Java) is a small library for the generation
of <a title="Gravatar website" href="http://gravatar.com/">Gravatar</a> URLs.
For those readers who don't know Gravatar - Gravatar allows you to have one
avatar everywhere by uploading it to the Gravatar website. Other websites can
then automatically retrieve an avatar for a user by using the email address as
an identifier.

There is already a Java library around Gravatar by Ralf Ebert but it lacks some
of the newer functionality like avatar over HTTPS or custom default avatars.
Additionally it's not a Maven project nor hosted on Maven Central, thus enough
reasons to write my own.

The Gravatar4Java project is hosted on <a title="See the Gravatar4Java project on GitHub" href="https://github.com/bripkens/Gravatar4Java">GitHub</a> and already available in <a title="The Gravatar4Java project in Maven Central" href="http://search.maven.org/#search%7Cga%7C1%7Ca%3A%22gravatar4java%22%20g%3A%22de.bripkens%22">Maven Central</a> (actually my first project in Maven Central)! Following is the typical Maven dependency snippet, a plain Java example and a Spring beans definition for the library.

{% highlight xml %}
<dependency>
  <groupId>de.bripkens</groupId>
  <artifactId>gravatar4java</artifactId>
  <version>1.1</version>
</dependency>
{% endhighlight %}

{% highlight java %}
import de.bripkens.gravatar.DefaultImage;
import de.bripkens.gravatar.Gravatar;
import de.bripkens.gravatar.Rating;

// ...

String gravatarImageURL = new Gravatar()
    .setSize(50)
    .setHttps(true)
    .setRating(Rating.PARENTAL_GUIDANCE_SUGGESTED)
    .setStandardDefaultImage(DefaultImage.MONSTER)
    .getUrl("foobar@example.com");</pre>
{% endhighlight %}

{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:p="http://www.springframework.org/schema/p">

    <!-- Gravatar -->
    <bean id="gravatar"
          class="de.bripkens.gravatar.Gravatar"
          p:size="75"
          p:rating="GENERAL_AUDIENCE"
          p:standardDefaultImage="MONSTER" />

</beans>
{% endhighlight %}