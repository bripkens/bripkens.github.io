---
layout: post
title: 'JavaScript Function Contexts and the Meaning of This'
comments: true
description: 'Another take on JavaScript Function Contexts and the meaning of the this identifier'
tags:
 - javascript
 - cross_post
 - this
 - function
 - context
 - scope
 - invocation
 - binding
---

<div class="crossPost">
  This post first appeared in November 2012 on the
  <a title="original blog post" href="http://blog.codecentric.de/en/2012/11/javascript-function-contexts-this-proxy/">codecentric AG engineering blog</a>.
</div>

Many languages have an implicitly declared identifier called <em>this</em>. In languages like Java or C#, <em>this</em> commonly refers to a surrounding object, e.g., to the object on which a method was called. JavaScript also has such an identifier and it is called <em>this</em>. In contrast to the aforementioned languages, JavaScript is not object-oriented, but prototype-based. As such, the identifier is quite different, even though it is also called <em>this</em>. In this blog post, I want to describe what <em>this</em> refers to in JavaScript and thus hopefully shed some light on an otherwise rarely explained concept. First, let us see what <em>this</em> refers to in a simple function call.

{% highlight javascript %}
// JSFiddle: http://jsfiddle.net/exZbG/
var testFunctionContext = function() {
    console.log('Function call context is window?', this === window);
};

console.log('Global context is window?', this === window);
testFunctionContext();
{% endhighlight %}

When executing this code in your browser, you will see that both log statements show that <em>this</em> refers to <em>window</em>. By default, the value of <em>this</em> refers to the global <a title="The W3C's window object specification" href="http://www.w3.org/TR/Window/">DOM <em>window</em> object</a>. Though interesting, you would not want to access the window object through <em>this</em> in such cases, as the global identifier <em>window</em> would convey a much greater meaning and would be less fragile. This is because the identifier <em>this</em> is not stable.

The value of <em>this</em> can change with every function call and can even be influenced and set by the developer. This is the case because it is considered a <a title="ECMAScript Execution Context specification" href="http://www.ecma-international.org/ecma-262/5.1/#sec-10.3">function's context</a>. The simplest way to influence the context is the call of a function on an object, i.e., JavaScript's counterpart to method calls in object-oriented languages. Consider the following example which lists the source code of a class <em>Person</em>, the instantiation of an instance of this class and a function call to the instance's <em>getName()</em> function.

{% highlight javascript %}
// JSFiddle: http://jsfiddle.net/8pXvE/1/
var Person = function(name) {
    this.name = name;
};
Person.prototype.getName = function() {
    return this.name;
}

var tom = new Person('Tom Builder');
console.log(tom.getName());
{% endhighlight %}

With an object-oriented background, you would expect that this code results in the log statement <em>"Tom Builder"</em> and indeed it does. In such cases JavaScript behaves the way you might be used to, but it does so for a different reason. For JavaScript, the <em>Person</em> instance is considered the receiver of a function call and is therefore set as the current context. In the <em>getName()</em> function we can therefore access the property <em>name</em> through the <em>this</em> identifier. Consider the following example in which I misuse the <em>getName()</em> function.

{% highlight javascript %}
// JSFiddle: http://jsfiddle.net/CjhWf/
var Person = function(name) {
    this.name = name;
};
Person.prototype.getName = function() {
    return this.name;
}

var tom = new Person('Tom Builder'),
    getNameFn = tom.getName;

console.log(getNameFn());
{% endhighlight %}

Now we are doing almost the same as before, but instead of calling the <em>getName()</em> function directly, we are storing the value of <em>getName</em> in a variable and call it later on. I cannot even guarantee what this will print, as this depends on the default context and the way your are executing this example. For instance, when executing this code on JSFiddle, it prints the String <em>"result"</em>, whereas it prints an empty String in the Webkit developer tools.
<h2>Explicit Context Definition</h2>
Using objects' functions as, for instance, listeners, is not straightforward with JavaScript and a common source of bugs. Remember: This is because JavaScript follows a different paradigm. The expression <em>tom.getName</em> simply means: give me the value of the property <em>getName</em> on the object which is available through the identifier <em>tom</em>. When calling the function at a later point, the interpreter has no means to determine a proper context and therefore falls back to the global one, i.e., the DOM window object. Before showing you a common JavaScript pattern to alleviate this problem, let me show you two ways with which you can call a function with a user-defined context.

As of now, you have only seen how to call functions directly, i.e., using the standard notation as we have seen before. JavaScript provides you with two additional means to call functions, set their context and pass arguments either in a var-arg like manner or through an array. You can do so through <em>Function.call(context: Object, args...: Object) : Object</em> and <em>Function.apply(context: Object, args: Array) : Object</em> as the following listing shows.

{% highlight javascript %}
// JSFiddle: http://jsfiddle.net/nxkNP/1/
var linkEntities = function(leftSide, rightSide) {
    console.log(leftSide, this.relationship, rightSide);
};

var context = { relationship: 'likes' },
    leftSide = 'John Mason',
    rightSide = 'Falling Skies';

linkEntities.call(context, leftSide, rightSide);
linkEntities.apply(context, [leftSide, rightSide]);

// not recommended!
context.linkEntities = linkEntities;
context.linkEntities(leftSide, rightSide);
{% endhighlight %}


All three calls to <em>linkEntities()</em> actually result in the same output, i.e, <em>"John Mason likes Falling Skies"</em>. The invocation through the <em>call</em> function is the var-arg variant. You can just pass the arguments directly and it therefore is similar to a normal function call. For additional flexibility, you can use the <em>apply</em> function. This function is commonly used for libraries that implement the Observer pattern as this simplifies calling observers' listener functions with an arbitrary number of arguments. The last way to do it is not recommended as this is semantically not correct. We are changing the context object in order for it to allow standard function invocation with a user-defined context - <strong>never do this</strong>!
<h2>Maintaing Context</h2>
At last, let us see how you can maintain or enforce the invocation of a function with a specific context. Our goal this time: greet the user with his name after one second. JavaScript's way to defer execution is a call to <em>setTimeout(callback: Function, timeout: Number)</em>. There is one problem though: the user's name will be available through <em>this</em>. A quick try might result in the following code, which unfortunately does not work.

{% highlight javascript %}
// JSFiddle: http://jsfiddle.net/8sNq4/
var sayHello = function() {
    alert('Hello ' + this);
};

setTimeout(sayHello, 1000);
{% endhighlight %}


Our <em>sayHello</em> function is called after one second, but unfortunately it does not print our user's name. How could it! We did not define with which context <em>sayHello()</em> should be invoked. As a result, the interpreter, once again, falls back to the default. Enforcing a context is commonly needed in JavaScript and therefore such functionality is also available through <a title="jQuery API documentation for the proxy function" href="http://api.jquery.com/jQuery.proxy/">jQuery</a>, <a title="underscore.js API documentation for the bind function" href="http://underscorejs.org/#bind">underscore.js</a> and other libraries. Because the implementation of such a method is so simple and because we want to grasp the whole concept, we are re-implementing it for educational purposes (just like many of us probably implemented their own object-relational mapper for one or another reason).

Typically, closures are used to memorise the desired, i.e., proxied, context and function. We therefore create a function <em>proxy(context: Object, fn: Function) : Function</em> which creates a new function (a closure) which memorises the context and the target function (<em>sayHello()</em> in this case). Once invoked, this generated function will invoke our target function <em>sayHello()</em> with the memorised context. In terms of JavaScript, we end up with the following code.

{% highlight javascript %}
// JSFiddle: http://jsfiddle.net/y4E97/
var sayHello = function() {
    alert('Hello ' + this);
};

var proxy = function(context, fn) {
    return function() {
        fn.apply(context, arguments);
    };
};

var sayHelloProxy = proxy('Tom Mason', sayHello);

setTimeout(sayHelloProxy, 1000);
{% endhighlight %}

This version alerts us with <em>"Hello Tom Mason"</em> after one second, just as we wanted. Arguments that might have been passed to the proxy are not lost, but retained and available in the target function (albeit not used in this example). This is done with the help of the <a title="Mozilla Developer Network documentation for the arguments object" href="https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Functions_and_function_scope/arguments"><em>arguments</em> object</a>.
<h2>Conclusions</h2>
You have seen why JavaScript's <em>this</em> is different than <em>this</em> in object-oriented languages and why the value is not stable. Also, you have seen three different means to call a function with a context. I hope I was able to convey that a function context is a crucial, yet fragile concept and that you should take extra care when relying upon it. If you have any questions or suggestions, please feel free to drop a comment below.