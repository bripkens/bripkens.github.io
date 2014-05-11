---
layout: post
title: 'HTML / JavaScript calculate text dimensions'
comments: true
tags:
 - biographer-ui
 - boundaries
 - calculation
 - css
 - dimension
 - font
 - height
 - width
 - javascript
 - jquery
 - jsdoc
 - jsdoctk
 - size
 - svg
 - text
---

As part of my Google Summer of Code 2011 I have to write a client side visualization library in JavaScript and of course textual elements are part of this visualizations. To calculate the dimensions of any text you can make use of an HTML DIV element. With the help of some specific styles it will then auto adapt its size to the text. That's how you do it.

Add the following to your stylesheet (CSS).


{% highlight css %}
.textDimensionCalculation {
    position: absolute;
    visibility: hidden;
    height: auto;
    width: auto;
    white-space: nowrap;
}
{% endhighlight %}

This snippet adds a CSS class named <em>textDimensionCalculation</em> which we will apply to the DIV for the calculation of the text dimensions. The next listing contains the interesting part. I'm using jQuery to simplify things in this example.


{% highlight javascript %}
/**
 * Calculate word dimensions for given text using HTML elements.
 * Optionally classes can be added to calculate with
 * a specific style / layout.
 *
 * @param {String} text The word for which you would like to know the
 *   dimensions.
 * @param {String[]} [classes] An array of strings which represent
 *   css classes which should be applied to the DIV which is used for
 *   the calculation of word dimensions.
 * @param {Boolean} [escape] Whether or not the word should be escaped.
 *   Defaults to true.
 * @return {Object} An object with width and height properties.
 */
var calculateWordDimensions = function(text, classes, escape) {
    classes = classes || [];

    if (escape === undefined) {
        escape = true;
    }

    classes.push('textDimensionCalculation');

    var div = document.createElement('div');
    div.setAttribute('class', classes.join(' '));

    if (escape) {
        $(div).text(text);
    } else {
        div.innerHTML = text;
    }

    document.body.appendChild(div);

    var dimensions = {
        width : jQuery(div).outerWidth(),
        height : jQuery(div).outerHeight()
    };

    div.parentNode.removeChild(div);

    return dimensions;
};
{% endhighlight %}


With the help of this little snippet we can now calculate the text dimensions like this.

{% highlight javascript %}
var dimensions = calculateWordDimensions('42 is the answer!');

console.log(dimensions.width);
console.log(dimensions.height);
{% endhighlight %}