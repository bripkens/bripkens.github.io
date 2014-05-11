---
layout: post
title: 'Trigger jQuery UI drag start event'
comments: true
tags:
 - drag_and_drop
 - drag_handle
 - dragging
 - dragstart
 - javascript
 - jquery
 - jquery_ui
 - mousedown
 - odr
 - simulate
 - raise
 - event
 - start
 - automatically
 - programmatically
 - visualization
 - trigger
---


In my last few blog posts I repeatedly referenced the visualization that I'm working on. This post is about an obstacle that I encountered while implementing drag and drop functionality.

Most UML <a title="The wikipage page on CASE" href="http://en.wikipedia.org/wiki/Computer-aided_software_engineering">CASE</a> tools allow you to manipulate the shape of a line by adding drag handles to a line. These drag handles can then be used to <em>curve</em> the line. While testing the first visualization with the customer, I repeatedly noticed that he pressed the left mouse button on a line (which adds a drag handle to a line) and moved the mouse around without releasing the left mouse button. Clearly, he was expecting that the drag handle would immediately be dragged when not releasing the mouse button. Unfortunately this wasn't implemented.

I used the <a title="The jQuery UI web site" href="http://jqueryui.com/">jQuery UI</a> JavaScript library to implement drag and drop functionality which is pretty simple but sadly does not provide any built in functionality to trigger the drag event. After some searching, I found the <a title="The plug in hosted on github" href="https://github.com/jquery/jquery-ui/blob/9e8e339648901899827a58e5bf919f7dda03b88e/tests/jquery.simulate.js">jQuery simulate</a> plug in. As you might have guessed from the described issue and name of the plug in, it allows to simulate mouse and keyboard events. With the plug in it is easy to start the jQuery UI drag functionality as the following code listing shows.


{% highlight javascript %}
var someLine = $("#someLine");

someLine.mousedown(function(e) {
    // create a new drag handle
    // the drag handle is jQuery UI draggable
    var dragHandle = $("#someHandle").show();

    var coords = {
        clientX: e.clientX,
        clientY: e.clientY
    };

    // this actually triggers the drag start event
    dragHandle.simulate("mousedown", coords);
});
{% endhighlight %}
