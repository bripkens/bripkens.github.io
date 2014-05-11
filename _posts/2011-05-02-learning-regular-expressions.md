---
layout: post
title: 'Learning regular expressions'
comments: true
tags:
 - links
 - django
 - odr
 - python
 - regex
 - regular_expression
 - robodoc
 - spring
 - twitter
 - links
 - url
---

There are times in which I hear about or start investigating something and suddenly I notice that I could use this knowledge, technology, pattern or term in various situations. Just recently I started diving into regular expressions. Even though I'm developing software for several years now I never took the time to <em>really</em> learn them.

Everything started with a small module that I developed for a project that I'm contributing to - the so called Open Decision Repository which I have been referring to in a few blog posts. I wanted to apply some of the neat URL rewriting techniques that Django or Spring use. Especially nice are Django's capabilities with regard to reverting a regular expression, i.e. it can build a URL from a regular expression. For example you might define a RESTful URL for an entity Customer. From a view you could now say give me the URL to the Customer with id ten. Django now uses the regular expressions from your URL configuration to build the URL.

Besides the URL rewriting module I'm working for company which requested a better output format for <a title="Learn more about ROBOdoc" href="http://www.xs4all.nl/~rfsber/Robo/robodoc.html">ROBOdoc</a>. This also required a fair amount of regular expressions and XML parsing using xmllib2 for Python but that's a whole other story and subject to non-disclosure.

To document a small example I created the following Python program which replaces Twitter like links to users, e.g. @BenRipkens, with a link to the user's profile.

{% highlight python %}
#/usr/bin/env python2.6
#
# Copyright 2011 Ben Ripkens
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

__authors__ = [
    '"Ben Ripkens" <bripkens.dev@gmail.com>',
]

import re

user_name_pattern = re.compile(r"""
    @                 # the 'at sign' must be used to reference a user
    (?P<user_name>    # the user name is contained within the 'user_name' group
      [a-z]           # at least one character (a-z) is required
      \w{0,19}        # the shortest user name may be one character, max 20
    )
    \b                # it must end through a word boundary character
    """, re.IGNORECASE | re.VERBOSE)

def generate_link_to_user_page(match):
    """Callable for every user name match

    Keyword arguments:
    match -- A regex match object which contains a user_name group

    Returns:
    Link to the user detail page.
    """
    user_name = match.group('user_name')

    # verify that the user exists and create a user slug / id
    user_link = user_name

    return """<a href="/user/details/%s"
        title="Retrieve more information about this user'>
            %s
        </a>
        """ % (user_link, user_name)

if __name__ == '__main__':
    tweet = """Example regex use case. We are going to capture the link to
        @BenRipkens and transform it into a HTML 'a' element.
        """

    print re.sub(user_name_pattern, generate_link_to_user_page, tweet)</pre>
{% endhighlight %}
