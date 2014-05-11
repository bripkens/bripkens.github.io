---
layout: post
title: 'Using Sass with Django'
comments: true
tags:
 - command
 - convert
 - css
 - custom
 - django-admin
 - django
 - python
 - sass
 - scss
 - stylesheet
---

<a title="Project home page" href="http://sass-lang.com/">Sass</a> is great as it adds some neat functionality to your stylesheets, e.g. nesting, mixins, variables and math. Since it is a command line tool you can execute it like

{% highlight bash %}
sass --watch input.scss:output.css
{% endhighlight %}

Having to type this command is tedious and creating a .sh or .bat script for this requires you to maintain two files.  My approach is to create a custom django-admin command <em>watchsass</em> for this. How this is generally done can be read on <a title="Django documentation on custom django-admin commands" href="http://docs.djangoproject.com/en/dev/howto/custom-management-commands/">this page</a>. The following listing shows the command which I'm using in a small project right now.


{% highlight python %}
#/usr/bin/env python2.6
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

from django.core.management.base import NoArgsCommand
import os
import time
import datetime

class Command(NoArgsCommand):
    """
    Watch for changes in the common.scss file and convert it to common.css
    using sass. Sass needs to be on the path.

    http://sass-lang.com/

    """
    help = 'Convert scss to css'

    def handle_noargs(self, **options):
        scss = os.path.abspath("media/css/common.scss")
        css = os.path.abspath("media/css/common.css")

        command = "sass \"" + scss + "\":\"" + css + "\" --style compressed"

        print "Executing command '%s'" % command
        print "Sass watch parameter is not used due to some bug."

        last_update = os.stat(scss).st_mtime
        os.system(command)

        while True:
            if not last_update == os.stat(scss).st_mtime:
                os.system(command)
                last_update = os.stat(scss).st_mtime
                print "Updated stylesheet at %s" % datetime.datetime.now()
            time.sleep(0.5)
{% endhighlight %}


As you can see I'm not using the --watch flag. This is because it's not working on my system.
