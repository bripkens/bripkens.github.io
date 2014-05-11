---
layout: post
title: 'Adding custom profiles to the Django User model'
comments: true
tags:
 - account
 - additional_attributes
 - additional_properties
 - authentication
 - authorization
 - AUTH_PROFILE_MODULE
 - custom
 - django
 - model
 - post_save
 - profile
 - python
 - signal
 - user
---

One of the great things of Django is that it ships with a variety of useful apps (and that there is a notion of apps in the first place). One of them is <em>django.contrib.auth</em>, an user authentication system. In Django views you can make use of <em>request.user</em> to retrieve a User instance which represents the currently logged-in user. Django even allows you to attach application specific profiles to these user models. That's how you do it:

Start by creating a new Django model which will represent a user profile.

{% highlight python %}
from django.db import models
from django.contrib.auth.models import User

class Pirate(models.Model):
    """User profile model. This profile can be retrieved by calling
    get_profile() on the User model

    """
    
    account = models.OneToOneField(User)

    description = models.TextField(blank=True)

    @models.permalink
    def get_absolute_url(self):
        return ('view_pirate', None, {'username': self.account.username})

    def __unicode__(self):
        return self.account.username
{% endhighlight %}


This profile will just add a description text field to the user profile. Make sure to create a one-to-one relationships to Django's User model. Next you have to tell Django that it should use this model as a user profile. You do this by adding the following line to your settings.py.

{% highlight python %}
#The value of this variable is the application name plus
#the model name separated by a dot
AUTH_PROFILE_MODULE = 'pirates.Pirate'
{% endhighlight %}

That's all you need to add a profile to the Django User model. You can now retrieve the profile by calling <em>get_profile()</em> on a User instance. But wait - there is one thing left.

When a new User is registered we need to create a user profile. You can do this using signals in the following way (add this after you profile model in models.py).

{% highlight python %}
from django.db.models.signals import post_save
from django.contrib.auth.models import User

# here is the profile model

def user_post_save(sender, instance, created, **kwargs):
    """Create a user profile when a new user account is created"""
    if created == True:
        p = Pirate()
        p.account = instance
        p.save()

post_save.connect(user_post_save, sender=User)
{% endhighlight %}