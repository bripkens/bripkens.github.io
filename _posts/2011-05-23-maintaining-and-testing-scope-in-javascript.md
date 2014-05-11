---
layout: post
title: 'Maintaining and testing scope in JavaScript'
comments: true
tags:
 - createDelegate
 - delegate
 - function
 - javascript
 - jquery
 - jsdoc
 - jsdoctk
 - qunit
 - scope
 - test
 - this
 - verify
---


One could say that the behaviour of <em>"this"</em> in JavaScript is rather unconventional, at least when you have a strong object-oriented background like I do. For example, libraries like jQuery change the scope of event listeners which does not allow you to refer to a surrounding object (think an object's method is used as an event listener and in this method you try to access the object's properties through <em>"this"</em>).

To maintain the scope we can create closures which make sure that the appropriate scope is set when the function / listener is called.


{% highlight javascript %}
/**
 * @description
 * <p&>We extend the prototype of all functions with the function
 * createDelegate. This method allows us to change the scope of a
 * function.</p>
 *
 * <p>This is useful when attaching listeners to jQuery events like click
 * or mousemove as jQuery normally uses this to reference the source
 * of the event. When using the createDelegate method, this will point to
 * the object that you want to reference with this.</p>
 *
 * <p>Source:
 * <a href="http://stackoverflow.com/questions/520019/controlling-the-value-of-this-in-a-jquery-event">
 *     Stackoverflow
 * </a></p>
 *
 * @param {Object} scope The scope which you want to apply.
 * @return {Function} function with maintained scope
 */
Function.prototype.createDelegate = function(scope) {
    var fn = this;
    return function() {
        // Forward to the original function using 'scope' as 'this'.
        return fn.apply(scope, arguments);
    };
};
{% endhighlight %}


I ran into this issue when I wrote my <a title="Open Decision Repository relationship view preview" href="http://bripkens.de/blog/2010/12/open-decision-repository-relationship-view-preview/">first bigger</a> (> 7000 lines of code) object-oriented JavaScript application. Additionally, you can find a <a title="QUnit documentation" href="http://docs.jquery.com/Qunit">QUnit</a> test in the following listing. It shows how you can tell whether the correct scope was applied.

{% highlight javascript %}
test('function.createDelegate', function() {
    expect(1);

    var scope = { answer : 42 };

    var verify = function() {
        equal(this.answer, 42, 'Wrong scope applied.');
    }

    var delegate = verify.createDelegate(scope);

    delegate.call({ answer : 41})
});
{% endhighlight %}