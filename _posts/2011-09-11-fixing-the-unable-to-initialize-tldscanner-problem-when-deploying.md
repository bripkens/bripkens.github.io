---
layout: post
title: 'Fixing the unable to initialize TldScanner problem when deploying'
comments: true
tags:
 - deploy
 - ear
 - Error_in_linking_security_policy
 - glassfish
 - java
 - java_ee
 - netbeans
 - tldscanner
---

With the change to Glassfish 3.3 I encountered the TldScanner problem when
deploying a simple EAR file. Since the problem did not occur with Glassfish
3.0.1 and because some of my colleagues were also having problems I
investigated the problem today.

The problem is reported by many people in various mailing lists and issue
trackers but in all cases the solution wasn't fixing the problem. After
replacing several dependencies (the server log stated sometimes that the
problem occurred in a third party library..) and trying various solutions which
I had found on the internet, I changed the directory structure and removed
all whitespace from the directory and file names. Even though you might
figure that an application server, as mature as Glassfish, might be able to
cope with whitespace in directory names, it is not.

Long story short, I created a symlink in my home directory (/home/ben/odr)
which points to the existing checkout at */home/ben/fontys/some semester
identifier with whitespace/odr*. This solved the TldScanner problem and
everything was running fine again. Sometimes the simple solutions are the right
ones, even in the Java EE world :-).