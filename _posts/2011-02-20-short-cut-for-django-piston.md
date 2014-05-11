---
layout: post
title: 'Shortcut for django-piston'
comments: true
tags:
 - django
 - dry
 - get_object_or_404
 - get_object_or_none
 - handler
 - piston
 - python
 - rest
 - shortcut
---

Django ships with a few shortcuts like <em>django.shortcuts.get_object_or_404</em> which come handy as they are frequently needed. I wrote a similar shortcut for the Django framework <a title="Django-Piston hosted on bitbucket" href="https://bitbucket.org/jespern/django-piston/wiki/Home">piston</a>. This framework is used for the creation of RESTful APIs and is great as it makes it really easy to provide a RESTful API.

When using this framework you have something similar to views, called <strong>handlers</strong>. In this handlers you have methods like read which are implemented in a way quite similar to Django views. Unfortunately you can't use <em>get_object_or_404</em> as the Exception will be caught by piston and shown to the user. To overcome this issue I wrote the following function which tries to retrieve an entity and if it fails it will just return <em>None</em> (which will be rendered to <em>null</em> by piston).

{% highlight python %}
from piston.handler import BaseHandler
from patterns.models import Template
from django.shortcuts import _get_queryset

def get_object_or_none(klass, *args, **kwargs):
    """Utility function just list django.shortcuts.get_object_or_404

    Instead of raising a 404 error this function returns None.

    See: django.shortcuts.get_object_or_404

    """

    queryset = _get_queryset(klass)

    try:
        return queryset.get(*args, **kwargs)
    except queryset.model.DoesNotExist:
        return None

class TemplateHandler(BaseHandler):
    """Retrieve the templates that are available.

    """

    allowed_methods = ('GET',)
    model = Template
    fields = ('id', 'name', 'description', 'author',
              ('components', ('id', 'name', 'description', 'mandatory',
                              'sort_order')))

    def read(self, request, id=None):
        """Retrieve one or more template

        If you call this method with the 'id' parameter then one entity will
        be returned or null if there is no entity for the given id.

        Calling this method without the id parameter will result in
        all templates.

        """

        if id:
            return get_object_or_none(Template, pk=id)
        else:
            return Template.objects.all()</pre>
{% endhighlight %}