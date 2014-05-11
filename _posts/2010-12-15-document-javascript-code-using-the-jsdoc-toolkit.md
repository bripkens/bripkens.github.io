---
layout: post
title: 'Document JavaScript code using the JsDoc toolkit'
comments: true
tags:
 - api
 - automatic
 - docu
 - documentation
 - generated
 - javadoc
 - javascript
 - jsdoc
 - jsdoctk
 - maven
 - odr
 - toolkit
 - visualization
---


The documentation of JavaScript becomes increasingly important as the amount of JavaScript lines of code per project increases. In my current project, the <a title="Link to the google code web site" href="http://code.google.com/p/opendecisionrepository/">Open Decision Repository</a>, I am solely responsible for the development of several visualizations which are mostly written in JavaScript. It is likely that new developers will continue developing the system and / or visualization as part of an internship and therefore it needs to be documented.

Apart from the architectural documentation, the code should of course also be documented. The most obvious approach to me is something like JavaDoc as I consider a good API documentation as valuable. Also UML class- and activity diagrams should be available, but that's a whole other story.

Quickly, I stumbled upon JsDoc and it's successor, the <a title="The project web site" href="http://code.google.com/p/jsdoc-toolkit/">JsDoc toolkit</a>. It is similar to JavaDoc, Netbeans (and all other major IDEs) support the syntax, a <a title="The project web site of the maven plugin" href="http://code.google.com/p/jsdoctk-plugin/">maven plugin</a> to generate the documentation is available and it creates a nice and readable API documentation. More than enough reasons for me to give it a try and now, to use it. You can visit the <a title="JavaScript documentation of the Open Decision Repository" href="http://opendecisionrepository.googlecode.com/svn/javascript-doc/index.html">following</a> page to get a first idea about how the JsDoc toolkit documents your code.

The syntax is well documented on their <a title="The documentation of the JsDoc toolkit syntax" href="http://code.google.com/p/jsdoc-toolkit/w/list">project page</a>. In case you need examples, consider viewing the <a title="The source code from which the documentation was generated" href="http://code.google.com/p/opendecisionrepository/source/browse/trunk/sources/web-interface/src/main/webapp/resources/js/diagram-entities.js?r=762">source code</a> from which the documentation was generated. You can either use the tool from the project website or the Maven plug-in to generated the documentation. An example for the generation using the tool can be seen in the following listing.


{% highlight bash %}
#!/bin/bash
java -jar ./jsrun.jar ./app/run.js \
    -a \
    -t=./templates/jsdoc \
    -d=./doc/ \
    drawing.core.js drawing.menu.js drawing.entities.js drawing.js
gnome-open ./doc/index.html
{% endhighlight %}


The following listing shows the Maven configuration for the jsdoctk plug-in. Additional configuration instructions are explained on the <a title="Configuration parameters" href="http://code.google.com/p/jsdoctk-plugin/wiki/ConfigurationInstructions">project site</a>. Even though this is simpler, especially for teams, I strongly encourage you to use the command line approach as it allows you to exclude files from the documentation.


{% highlight xml %}
<!-- ... -->

<pluginRepositories>
    <pluginRepository>
        <id>jsdoctk2</id>
        <url>http://jsdoctk-plugin.googlecode.com/svn/repo</url>
    </pluginRepository>
</pluginRepositories>

<!-- ... -->

<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-site-plugin</artifactId>
    <version>3.0-beta-3</version>
    <configuration>
        <reportPlugins>
            <plugin>
                <groupId>nl.windgazer</groupId>
                <artifactId>jsdoctk-plugin</artifactId>
                <version>2.0.1-RC1</version>
                <configuration>
                    <recurse>3</recurse>
                </configuration>
            </plugin>
        </reportPlugins>
    </configuration>
</plugin>
{% endhighlight %}