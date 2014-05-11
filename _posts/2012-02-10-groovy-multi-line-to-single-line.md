---
layout: post
title: 'Quick post: How to use Groovy multi-line GStrings for single-line messages'
comments: true
tags:
 - character_limit
 - exception_message
 - groovy
 - gstring
 - indention
 - multi_line
 - new_lines
 - single_line
 - strip_indent
---

Need to put a long string into your source code but don't want to violate the
80 character line limit (yes, I prefer it)? You can do it by adding a new
method to java.lang.String as the following listing shows.

{% highlight groovy %}
def toSingleLinePattern = ~/\s{2,}/
String.metaClass.toSingleLine = {
    (delegate =~ toSingleLinePattern).replaceAll(' ')
}

println """This could be an error message which is very long
    and which would need to span several lines if you have a line
    length limitation of 80 characters or similar.""".toSingleLine()
{% endhighlight %}