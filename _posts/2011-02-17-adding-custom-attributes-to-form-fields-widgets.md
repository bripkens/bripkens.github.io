---
layout: post
title: 'Adding custom attributes to Form fields / widgets'
comments: true
tags:
 - add
 - additional
 - form_fields
 - widget
 - attr
 - attributes
 - autofocus
 - custom
 - django
 - dry
 - dont_repeat_yourself
 - fields_for_model
 - model_field
 - python
 - reusing
---

Currently I'm learning Python and Django by creating a web application. My goal is to learn as much as possible and to create a web application that adheres to as many code guidelines as possible.

Today I wanted to create a form from a model. With Django you would normally use a <a title="Django ModelForm documentation" href="http://docs.djangoproject.com/en/dev/topics/forms/modelforms/">ModelForm</a>. Unfortunately this approach is to generic for my desired form. That's why I'm creating a subclass of <em>django.forms.Form</em>. Applying the DRY principle I still don't want to rewrite all the validation logic / constraints which are already part of the model. You can use the <em>fields_from_model</em> function from <em>django.forms.models</em> which does exactly that. It creates form fields for each model field. Thus you don't need to place the validation logic in two places.


{% highlight python %}
from django import forms
from django.forms.models import fields_for_model
from models import Pattern

class ManagePattern(forms.Form):
    _pattern_fields = fields_for_model(Pattern)
    name = _pattern_fields['name']
{% endhighlight %}


Django automatically creates the input fields based on the form fields. In this case <em>name</em> will be an instance of <em>django.forms.CharField</em>. Later on this would be rendered as an HTML input element with <em>type="text"</em>.

To add attributes to this element you need to add the attributes to the widget of the form field. In this case I wanted to add the new HTML 5 autofocus attribute.


{% highlight python %}
from django import forms
from django.forms.models import fields_for_model
from models import Pattern

class ManagePattern(forms.Form):
    _pattern_fields = fields_for_model(Pattern)
    name = _pattern_fields['name']
    name.widget.attrs.update({'autofocus' : 'autofocus'})
{% endhighlight %}