---
layout: post
title: 'Exclude files from automatic JavaScript documentation generation'
comments: true
tags:
 - api
 - automatic
 - documentation
 - exclude_files
 - generation
 - javascript
 - jsdoc
 - jsdoctk
 - maven
 - odr
 - toolkit
---

In December I <a title="Link to the article" href="http://bripkens.de/blog/2010/12/document-javascript-code-using-the-jsdoc-toolkit/">wrote an article</a> about the JsDoc toolkit and especially about a <a title="The Maven plugin website" href="http://code.google.com/p/jsdoctk-plugin/">Maven plug-in</a> that simplifies the build process. A few days ago the author of this plug-in, i.e. Martin Reurings, contacted me and asked for some feedback.
We discussed the issues that I mentioned in my previous article and that the plug-in is missing some exclude / include functionality. Recently he implemented this functionality and released version <a title="Download for version 2.3.2 of the plug-in." href="http://code.google.com/p/jsdoctk-plugin/downloads/detail?name=jsdoctk-plugin-2.3.2.zip&amp;can=2&amp;q=">2.3.2</a>.

Now to use this plug-in add the plug-in repository


{% highlight xml %}
<pluginRepositories>
    <pluginRepository>
        <id>jsdoctk2</id>
        <url>http://jsdoctk-plugin.googlecode.com/svn/repo</url>
    </pluginRepository>
</pluginRepositories>
{% endhighlight %}


and add the following to the report plug-in section to your pom.


{% highlight xml %}
<plugin>
    <groupId>nl.windgazer</groupId>
    <artifactId>jsdoctk-plugin</artifactId>
    <version>2.3.2</version>
    <configuration>
        <recurse>3</recurse>
        <exclude>
            <param>/^(?!diagram-).+/</param>
            <param>common.js</param>
            <param>jquery-1.4.4.min.js</param>
            <param>jquery-ui-1.8.6.custom.min.js</param>
            <param>vtip-min.js</param>
        </exclude>
    </configuration>
</plugin>
{% endhighlight %}


Now I tried to exclude all files using a negative look ahead <em>{{ '/^(?!diagram-).+/' }}</em>. This regex means "Ignore everything that does not start with <em>diagram-</em>" (all the JavaScript files for the visualization in my last project have the common prefix <em>diagram-</em>) but unfortunately it's not working. Maybe I used a wrong syntax for the exclusion but I can't seem to find more documentation about it. If you know what went wrong or how to realize it without mentioning every JavaScript file that should be excluded please let me know.
Anyway this feature may allow more projects to use the plug-in and is generally a great addition to the plug-in.