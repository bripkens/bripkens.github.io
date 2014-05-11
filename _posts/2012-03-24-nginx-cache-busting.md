---
layout: post
title: 'Cache busting with nginx'
comments: true
description: 'An introduction to cache busting. Comparing query parameter and file path approach. Google page improvements.'
tags:
 - nginx
 - configuration
 - cache
 - busting
 - query_parameter
 - file_path
 - page_speed
---

So, I got myself to write an article about my nginx server configuration. As you
[may have read](/2012/03/Jekyll-up-and-running/), I spent some time optimizing
my site w.r.t. page speed (especially the
[Google Page Speed](http://code.google.com/speed/page-speed/) rating). In this
article, I want to talk about cache busting.

Cache busting is the process of forcing browsers or proxy servers to update
their cache, for instance, JavaScript and CSS files or images.
Since you generally don't have control about the clients' caches, you need to
find a workaround. A common (and the most simple, besides not making use of
caching in the first place...) way to do this is to attach a
query parameter to the resource. Example:

    Requested:  /static/css/main.css?cachebust=1331394748
    Served:     /srv/www/static/css/main.css

The query parameter's name and value actually doesn't matter, you could choose
whatever values you like. It only matters that the resource's URI changes when
the resource is changed so that browsers and proxies can't locate the resources
in their caches. Because if they can't locate them, they will request the files
and thus update the static resources! The simplest solution is to use the
deployment timestamp as the parameter's value.

While very simple to setup (no server configuration changes required), there
is a problem with this approach. Some proxy servers don't cache resources
that contain query parameters (or a *?* as
[Google's](http://code.google.com/speed/page-speed/docs/caching.html#LeverageProxyCaching)
recommendation states it).

This leaves us with the request path for cache busting. Sure, one could extend
the deployment script so that it renames static files. For instance, they could
be changed to something like *main_1331394748.css* (where the number is a
timestamp). This way every cache should be able to cope with this.
Unfortunately, there is a small problem - how do you make sure that the
timestamps in your HTML files are the same as the once used by the
deployment script? Depending on your build and other factors, you might have to
cope with different timestamps and/or a quite complicated build script.
So here comes my approach which removes these problems:

 1. Add a timestamp to the static resources' URIs in your HTML files.
 2. Don't change the static resources' file names.
 3. Add a new rule to your server configuration which *"strips"* the timestamp
    from the requested file.

The objective is the following server behaviour:

    Requested:  /static/css/main_1331394748.css
    Served:     /srv/www/static/css/main.css

Step one should be fairly straightforward. Depending on your application, you
might be able to define a new template tag which renders the deployment
timestamp. In Java EJB world, you could capture the deployment timestamp
using an EJB annotated with {{ "javax.ejb.Singleton" | classname }} and
{{ "javax.ejb.Startup" | classname }} and render it using the unified
expression language.

{% highlight java %}
package de.bripkens.ejb;

import java.util.Date;
import javax.ejb.Lock;
import javax.ejb.LockType;
import javax.ejb.Singleton;
import javax.ejb.Startup;
import javax.annotation.PostConstruct;

@Singleton
@Startup
public class DeploymentBean {

    private Date deploymentTime;

    @PostConstruct
    public void init() {
        deploymentTime = new Date();
    }

    @Lock(LockType.READ)
    public Date getDeploymentTime() {
        return deploymentTime;
    }
}
{% endhighlight %}

As for step two, simply get yourself a coffee and consider it done. With
this coffee, we can tackle the last step. Apache HTTP server, nginx and others
support some kind of URL rewriting. Since my server is running nginx, you can
see its configuration in the following listing.

{% highlight nginx %}
server {
  # ...

  location ~* ^/static/(\w+)/([^/]+)_\d+\.(js|css|png|jpg|jpeg|gif|ico)$ {
    alias /srv/www/static/$1/$2.$3;
    add_header Vary Accept-Encoding;
    expires max;
  }

  # ...
}
{% endhighlight %}

I declare that all static resources have two parent directories. The top-most
one being called *static*. The second directory name must consist of one or more
word characters ({{ "[a-zA-Z_0-9]" | classname }}). I'm so strict because I
don't want to accidentally weaken my server's security. It's just too easy
to get server configurations wrong.
The file name follows a very simple naming convention: Every character (except
the forward slash - to avoid directory changes), followed by an underscore,
a timestamp and one of the defined file name extensions.

When a request matches this regular expression, the underscore and timestamp
are stripped and the file is served. On top of this, I set the expiration
header to the maximum because I'm now taking care of cache busting.
I also add the {{ "Vary: Accept Encoding" | classname }} HTTP header
[for maximum compatibility](http://code.google.com/speed/page-speed/docs/caching.html).

Depending on your project and environment, you may be able to follow this or a
similar approach. No matter what you do, make sure that you don't use query
parameters. Should there be any questions left, feel free to leave a comment :-).