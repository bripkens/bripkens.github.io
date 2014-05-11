---
layout: post
title: 'Functional JavaScript using Lo-Dash, an underscore.js alternative'
comments: true
description: 'Functional JavaScript DOM manipulation using Lo-Dash.'
formatEmAsCode: true
tags:
 - javascript
 - cross_post
 - functional
 - lo-dash
 - underscore
---

<div class="crossPost">
  This post first appeared in January 2013 on the
  <a title="original blog post" href="http://blog.codecentric.de/en/2013/01/functional-javascript-lo-dash-underscore-js-alternative/">codecentric AG engineering blog</a>.
</div>

Functional programming concepts and functional programming itself are currently all over the news. Languages such as Clojure are leading the way by providing interoperability and state of the art CASE tools. With existing libraries and frameworks, an alternative approach to state management and concurrency as well as growing groups of advocates, you could think that this is yet again the answer to all your problems. Many languages are adopting some functional concepts like functions as first class values, type inference and others to please developers and (hopefully) improve the languages' expressiveness.

In my few adventures with Clojure I was reasonably happy to try something new and to solve problems differently, but I am uncertain whether this programming paradigm really is a good choice for the diverse set of attitudes which you find in the software field.

Maybe one should try a different approach. Instead of going full hog functional, apply it to a few problems in your language of choice first (provided your language has a reasonable support for functional programming, e.g., not Java below version eight). In this blog post I describe a simple experiment in JavaScript using <a href="http://lodash.com/" title="The Lo-Dash website">Lo-Dash</a>.

<h2>The Task</h2>
The task is something relatively simple and commonly done in the web development field: Fill a table with information. For the purpose of this article we are not going to use a templating or data binding facility, but instead we interact with the raw DOM interface directly. As a starting point we assume that we get data in the following form from an unspecified data source.

{% highlight javascript %}
var Person = function Person(name, email, occupation) {
  this.id = _.uniqueId();
  this.name = name;
  this.email = email;
  this.occupation = occupation;
};

var data = [
  new Person("Tom Mason", "tom.mason@example.com", "History professor"),
  new Person("Sheldon Cooper", "sheldon.cooper@example.com", "Theoretical physicist"),
  new Person("Luke Skywalker", "luke.skywalker@example.com", "Saviour of the universe"),
  new Person("Barney Stinson", "barney.stinson@example.com", "?")
];
{% endhighlight %}

As you can see we define a simple class called <em>Person</em> with four properties: an ID, name, email and the person's occupation. Nothing fancy here except for <a href="http://lodash.com/docs#uniqueId" title="API documentation for the uniqueId() function.">Lo-Dash's utility function</a> <em>uniqueId</em> which returns a unique number (sequentially incremented). The <em>data</em> variable is an array of four persons that will be used as input for the generation of the table rows. As a foundation for the generation we assume that the following HTML structure is available in the document's body.

{% highlight xml %}
<table id="people">
  <thead>
    <tr>
      <th>Id</th>
      <th>Name</th>
      <th>Email</th>
      <th>Occupation</th>
    </tr>
  </thead>
  <tbody></tbody>
</table>
{% endhighlight %}



<h2>Imperative Approach</h2>
Let us first start with the imperative solution to see the desired result and to completely understand the task. I am assuming here that you have an ECMAScript 5 compatible browser that at least supports the <em>Array.prototype.forEach</em> function. This function considerably improves readability when it comes to iteration over arrays. If you do not have such a browser or are in a situation in which you need to support older browsers (which is likely since Internet Explorer < v9 has no support), you may want to use the polyfill which is <a href="https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Array/forEach#Compatibility" title="Polyfill for the forEach function.">available through the MDN</a>.

{% highlight javascript %}
// Try this on CodePen: http://codepen.io/joe/pen/JiaEp
var output = document.querySelector("#people tbody");
data.forEach(function(person) {
  var row = document.createElement("tr");

  ["id", "name", "email", "occupation"].forEach(function(prop) {
    var td = document.createElement("td");
    td.appendChild(document.createTextNode(person[prop]));
    row.appendChild(td);
  });

  output.appendChild(row);
});
{% endhighlight %}

This code should hold no big surprises for you. We simply iterate over all persons, create the rows and create columns for every property of the person that should be displayed. The same imperative solution can also be written without the ECMAScript 5 <em>Array.prototype.forEach</em> function, but it certainly <a href="http://codepen.io/joe/pen/ivxHJ" title="Generation of table rows without the ECMAScript 5 forEach function.">does not improve the solution</a>.



<h2>Starting from the Top</h2>
Functional programming is known for its top-down approach, i.e., starting with the end result and only then approaching the details. Let us do this as well. The first step should be the transformation of every <em>Person</em> instance to a table row. In functional jargon this translates to the <em>map</em> function. <em>map</em> is quite simple: It takes a collection and transforms every value in this collection with the help of a callback to a new value. The new values are then stored in a new collection which is returned by the <em>map</em> function.

We could simply write the <em>map</em> function ourselves, but there are many good libraries out there which have a fine set of standard functions that are commonly needed when following a functional paradigm. One of these libraries is <a href="http://lodash.com/" title="The Lo-Dash Website">Lo-Dash</a>, which we are using for this example.

{% highlight javascript %}
_(data).map(function(person) {
  // we take care of this in a few seconds
  return document.createElement("tr");
}).reduce(append, document.querySelector("#people tbody"));
{% endhighlight %}

Step by step: We start a function call chain using Lo-Dash's <em>_</em> (underscore) function. As part of this call chain we call the aforementioned <em>map</em> function which will transform every <em>Person</em> instance to a table row node. Once the <em>map</em> function call returns, we have a collection of table row nodes which can be added to the DOM. We do this using the <em>reduce</em> function. <em>reduce</em> reduces a collection of values to a single value by taking a function as its parameter which describes how two values can be combined. The <em>reduce</em> function continues to reduce values until only one value is left. As parameters to <em>reduce</em> we use <em>append</em>, a function which appends a child node to a parent node, and an initial value. The initial value is the table's tbody node.

{% highlight javascript %}
/**
 * Appends the child node to the parent node (both DOM nodes).
 *
 * @param {Node} parent The parent node
 * @param {Node} child The child node
 * @returns {Node} The given parent node.
 */
var append = function(parent, child) {
  parent.appendChild(child);
  return parent;
};
{% endhighlight %}

As you can see the append function is pretty straightforward. It simply appends the child to the parent and returns the parent node. It is very important that the parent node is returned, as only this enables a usage with the <em>reduce</em> function.

<h2>Generating Columns</h2>
The table is now getting a few additional rows when executing the code that we currently have. Now let us fill these rows with some data! For each column we need to get the value, create a <em>Text</em> node, put it in a <em>td</em> Element and append this element to the row. Even though you might not yet understand how the following code actually generates the columns, you can see how well each step translates to a line in the program.

{% highlight javascript %}
// Try this on CodePen: http://codepen.io/joe/pen/xeLrG
_(data).map(function(person) {
  return _(["id", "name", "email", "occupation"])  // for each column
    .map(prop(person))                             // get the property's value
    .map(textNode)                                 // create a Text node
    .map(wrap("td"))                               // put it in a td Element
    .reduce(append, document.createElement("tr")); // append to row
}).reduce(append, document.querySelector("#people tbody"));
{% endhighlight %}

As you can see <em>map</em> and <em>reduce</em> are really powerful functions that can be combined in various ways. While we previously used <em>map</em> to transform each <em>Person</em> in a single step, we are now using <em>map</em> in a multi-step process! As so often with functional programming, you need to build up a set of utility functions first before you become really productive. Once you have them though, you only need to find ways to combine them in order to achieve what you want.

One such new function is <em>prop</em>. <em>prop</em> generates a function through which an object's properties can be accessed. The interesting and powerful aspect here is that the object is bound to the function and therefore the object does not need to be passed around. Also see the example in the JsDoc if you find yourself having troubles understanding the purpose of this function.

{% highlight javascript %}
/**
 * Create a new property accessor function.
 *
 * @param {Object} obj The object from which properties should be accessed.
 * @returns {Function} The accessor function. Basically a single-argument
 *   function which returns the value of the property. The property name is
 *   denoted by the generated function's first argument.
 *
 * @example
 * var tom = { name: "Tom Mason" };
 * var tomAccessor = prop(tom);
 * tomAccessor("name") // results in "Tom Mason"
 */
var prop = function(obj) {
  return function(name) {
    return obj[name];
  };
};
{% endhighlight %}

After this mapping we will therefore have a collection of property values, i.e., the actual data which should be displayed. Text cannot be directly added to a DOM node through a function like <em>setValue(myText)</em>, but instead needs to be added through a specific node type - the <em>Text</em> node. The next transformation step therefore transforms the collection of <em>Strings</em> into a collection of <em>Text</em> nodes with the help of the <em>textNode</em> function.

{% highlight javascript %}
/**
 * @function
 * Create a new DOM Text node.
 *
 * @param {String} content Textual content.
 * @returns {Text} A DOM Text node with the content set.
 */
var textNode = document.createTextNode.bind(document);
{% endhighlight %}

<em>Text</em> nodes are commonly generated through <em>document.createTextNode</em> and we could directly pass the <em>createTextNode</em> function to <em>map</em>, but this would not work as the identifier <em>this</em> would not point to the <em>document</em> inside the <em>createTextNode</em> function as I explained earlier in my blog post on <a href="http://blog.codecentric.de/en/2012/11/javascript-function-contexts-this-proxy/" title="An article which explains the meaning of this and how to maintain a function context.">JavaScript function contexts</a>. As a result, we need to create a new function which enforces a specific function context. Luckily, ECMAScript 5 introduced a new function called <em>Function.prototype.bind</em> which does exactly this: enforce a context. You may want to check out the <a href="https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/Function/bind" title="bind API documentation, compatibility and a Polyfill">documentation on the MDN</a> for more information and a polyfill.

The last utility function is <em>wrap</em>. We use it to wrap a node in a given node type. Specifically, we wrap the <em>Text</em> nodes in columns, i.e., <em>td</em> nodes.

{% highlight javascript %}
/**
 * Create a new function which wraps the child node in a new node of the
 * given type.
 *
 * @param {String} elementType Type type of the wrapping node, e.g., "div".
 * @returns {Function} A function with a single argument. Pass a DOM Node to
 * wrapped and it will be wrapped in a new DOM node of the given elementType.
 *
 * @example
 * var divWrapper = wrap("div");
 * var p = document.createElement("p");
 * divWrapper(p); // results in "<div><p></p></div>"
 */
var wrap = function(elementType) {
  return function(child) {
    var parent = document.createElement(elementType);
    parent.appendChild(child);
    return parent;
  };
};
{% endhighlight %}

The <em>wrap</em> function is pretty straightforward: Whenever the generated function is called, it will wrap its first argument in a new node of the given type. Where in our case the given type is <em>"td"</em> and the given node is a <em>Text</em> node. When the <em>map</em> call finishes we will thus have a collection of <em>td</em> nodes which are then added to a <em>tr</em> node just like we added <em>tr</em> nodes to the <em>tbody</em> node, i.e., using the <em>reduce</em> function.


<h2>Conclusions</h2>
Finished the article? Good work! The mentioned principles and techniques are certainly no basics and require a different mindset. Functional programming is different and not quite intuitive when you have a strong object-oriented background.

As for the example, of course this is not a good use for functional programming as you can do this in fewer lines of code and a more maintainable way with data binding or a templating engine, but I hope to have shown you how versatile functional programming can be. Especially once you have built up a nice tool belt with functions like <em>append</em>, <em>wrap</em> and many more, you can combine those in interesting ways.

If you made some experiences with functional programming with or without JavaScript, please let me know through the comments. I would be very happy to hear about the good and bad parts.