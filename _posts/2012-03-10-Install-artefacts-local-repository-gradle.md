---
layout: post
title: 'Install Gradle artefacts in the local Maven repository'
comments: true
tags:
 - gradle
 - maven
 - install
 - local
 - repository
---

For my bachelor thesis project, I gave [Gradle](http://www.gradle.org/) a try.
Gradle is a build automation tool like Ant or Maven, well actually more like
Maven if you ask me. It has Maven's *convention over configuration* approach and
combines it with Ant's flexibility. So far I'm very happy with the configuration
options, but of course it's not used everywhere. Sometimes, libraries that are
developed with Gradle as their build tool, need to be used by other
(dependency management) tools, e.g., Maven or Ivy. This is the case for my
bachelor thesis project.

Luckily, a handy
[Maven plug-in](http://gradle.org/docs/current/userguide/maven_plugin.html)
exists which does exactly this - installing artefacts to the local Maven
repository (actually it's capable of way more, check out the documentation).
To use it, make sure that you are applying the Maven plug-in and define a
group and version. Both are identical to Maven's concepts of
[coordinates](http://maven.apache.org/pom.html#Maven_Coordinates). The following
listing shows a minimal *build.gradle* file.

{% highlight groovy %}
allprojects {
  apply plugin: 'maven'
  group = 'com.example'
  version = '0.1-SNAPSHOT'
}
{% endhighlight %}

What's missing here is the artefact id. The artefact id is actually the
root directory's name. For instance, a project located in
*/home/user/MyFancyProject* will have the artefact id *MyFancyProject*.
Subcomponent artefact ids follow the same rules, i.e., the directory name will
always be used. This is also true for sub-subcomponents, e.g.,
*/home/user/MyFancyProject/BusinessLogicComponent/EntitiesComponent* will
result in artefact ids MyFancyProject, BusinessLogicComponent and
EntitiesComponent.

At last, to actually trigger the local installation, execute the install target.

{% highlight bash %}
gradle install
{% endhighlight %}

To change the output of the Maven plug-in, you can make use of the configure
directive. It's using
[Groovy's XML MarkupBuilder](http://groovy.codehaus.org/Creating+XML+using+Groovy's+MarkupBuilder),
so check out its documentation for more information. Here is a small example
which shows the addition of licensing information, packaging and inception
year.

{% highlight groovy %}
allprojects {
  apply plugin: 'maven'
  group = 'com.example'
  version = '0.1-SNAPSHOT'

  configure(install.repositories.mavenInstaller) {
    pom.project {
      inceptionYear '2012'
      packaging 'jar'
      licenses {
        license {
          name 'The Apache Software License, Version 2.0'
          url 'http://www.apache.org/licenses/LICENSE-2.0.txt'
          distribution 'repo'
        }
      }
    }
  }
}
{% endhighlight %}