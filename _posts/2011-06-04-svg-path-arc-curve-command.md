---
layout: post
title: 'SVG path arc curve command'
comments: true
tags:
 - arc
 - svg
 - biographer-ui
 - corners_radii
 - how_to
 - javascript
 - path
 - radius
 - rect
 - rectangle
 - regex
 - round
---

The basic <a title="Rect shape documentation" href="http://www.w3.org/TR/SVG/shapes.html#RectElement">SVG rect shape</a> provides functionality for rounded corners. Unfortunately, you can only change it for all four corners. I needed a rectangle which supports something like the CSS3 top- and bottom-border-radius instructions.

{% highlight css %}
#foo {
  border-top-left-radius: 10px;
  border-top-right-radius: 10px;
  border-bottom-right-radius: 20px;
  border-bottom-left-radius: 20px;
}
{% endhighlight %}

I needed this because of my GSoC project. In this project, there are different node types which have to be visualized. You can see the two node types (which are the reason for this blog post) in the following figure.

<img src="/img/posts/svg-path-arc/sbgn-nodes.png" alt="Two nodes, one of them only with two rounded corners.">

Sticking to the Don't-Repeat-Yourself paradigm, I abstracted the drawing of rectangular shapes into a base class <em>RectangularNode</em> from which the classes <em>Macromolecule</em> and <em>NucleicAcidFeature</em> inherit. Since the two node types are the same (with regard to implementation), except for the border radius, I put all the funtionality into the base class <em>RectangularNode</em>. Now the <em>Macromolecule and <em>NucleicAcidFeature </em></em>classes are merely subclasses which set the border radius on the <em>RectangularNode </em>class.

Now to the drawing of rectangles with different border-radii, there is no basic SVG shape which supports such behavior. As a result, you need the <a title="Documentation of the path element" href="http://www.w3.org/TR/SVG/paths.html#PathElement">SVG path element</a>. The path element enables you to draw such things as curves and arcs and can be used to draw every possible shape. For this specific issue, the <a title="Documentation for the arc command" href="http://www.w3.org/TR/SVG/paths.html#PathDataEllipticalArcCommands">arc</a> is needed. Please refer to the <a title="Path specification, documentation and examples" href="http://www.w3.org/TR/SVG/paths.html">specification</a> for an explanation of the various commands and the path element in general. In this post I'll only cover the generation of rectangles with different border radii and the arc command. The arc command is defined the following way (expressed as a regular expression in JavaScript with an example parsing).<!--more-->

{% highlight javascript %}
// please note that this regex doesn't take optional whitespace
// and commas into account.
var regex = /^(a|A)([+\-]?\d+),([+\-]?\d+) ([+\-]?\d+) (0|1),(0|1) ([+\-]?\d+),([+\-]?\d+)$/;

var command = "a10,10 0 0,1 150,100";

var match = command.match(regex);

var evaluatedCommand = {
    relative : match[1] === 'a',
    radiusX : parseInt(match[2]),
    radiusY : parseInt(match[3]),
    xAxisRotation : parseInt(match[4]),
    largeArc : match[5] === '1',
    sweep : match[6] === '1',
    targetX : parseInt(match[7]),
    targetY : parseInt(match[8])
};
{% endhighlight %}

console.log(evaluatedCommand);</pre>
A very good description of the parameters can be found in the <a title="Arc specification" href="http://www.w3.org/TR/SVG/paths.html#PathDataEllipticalArcCommands">specification</a>. Now to the actual generation, I'm uing the following two helper functions for this. Please refer to the comments in the source code for a description of the functionality.

{% highlight javascript %}
// generate a path's arc data parameter
// http://www.w3.org/TR/SVG/paths.html#PathDataEllipticalArcCommands
var arcParameter = function(rx, ry, xAxisRotation, largeArcFlag, sweepFlag,
                          x, y) {
    return [rx,
            ',',
            ry,
            ' ',
            xAxisRotation,
            ' ',
            largeArcFlag,
            ',',
            sweepFlag,
            ' ',
            x,
            ',',
            y].join('');
};

/*
 * Generate a path's data attribute
 *
 * @param {Number} width Width of the rectangular shape
 * @param {Number} height Height of the rectangular shape
 * @param {Number} tr Top border radius of the rectangular shape
 * @param {Number} br Bottom border radius of the rectangular shape
 * @return {String} a path's data attribute value
 */
var generatePathData = function(width, height, tr, br) {
    var data = [];

    // start point in top-middle of the rectangle
    data.push('M' + width / 2 + ',' + 0);

    // next we go to the right
    data.push('H' + (width - tr));

    if (tr &gt; 0) {
        // now we draw the arc in the top-right corner
        data.push('A' + arcParameter(tr, tr, 0, 0, 1, width, tr));
    }

    // next we go down
    data.push('V' + (height - br));

    if (br &gt; 0) {
        // now we draw the arc in the lower-right corner
        data.push('A' + arcParameter(br, br, 0, 0, 1, width - br,
                height));
    }

    // now we go to the left
    data.push('H' + br);

    if (br &gt; 0) {
        // now we draw the arc in the lower-left corner
        data.push('A' + arcParameter(br, br, 0, 0, 1, 0, height - br));
    }

    // next we go up
    data.push('V' + tr);

    if (tr &gt; 0) {
        // now we draw the arc in the top-left corner
        data.push('A' + arcParameter(tr, tr, 0, 0, 1, tr, 0));
    }

    // and we close the path
    data.push('Z');

    return data.join(' ');
};
{% endhighlight %}

With this utility function we can now generate rectangles in the following way (<a title="jsfiddle which you can use to try it" href="http://jsfiddle.net/uj3U5/">use this jsfiddle</a> to try it right away) .

{% highlight javascript %}
var svgns = 'http://www.w3.org/2000/svg';

var svg = document.getElementsByTagName('svg')[0];

var rect = document.createElementNS(svgns, 'path');
var pathDataValue = generatePathData(300, 200, 0, 20);
rect.setAttributeNS(null, 'd', pathDataValue);

svg.appendChild(rect);
{% endhighlight %}