---
layout: post
title: 'Parameterized JUnit tests in Groovy'
comments: true
tags:
 - groovy
 - java
 - junit
 - parameterized
 - test
---

Need to test a class or method with various values? You can make use of
parameterized JUnit tests to accomplish this. And since I'm currently learning
Groovy, I'm taking this chance to do it in this neat language (and to keep it
as a reminder for some language constructs).

You can make use of parameterized tests using the appropriate JUnit test runner.
In case of the following code listing, I'm verifying that my regular expression
for Java package names is correct (or at least that it detects a certain amount
of invalid ones...). Test input data is obtained from the *data()* method
and passed to the test's constructor. In the *testInvalidPackages()*
method I'm simply making use of the instance variable *pckg*, i.e.,
changing the value.

{% highlight java %}
package de.codecentric.janus.scaffold

import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.junit.runners.Parameterized.Parameters;

/**
 * @author Ben Ripkens <bripkens.dev@gmail.com>
 */
@RunWith(Parameterized.class)
class ScaffoldExecutorValidationTest {
    String pckg
    Scaffold scaffold

    ScaffoldExecutorValidationTest(String pckg) {
        this.pckg = pckg
        scaffold = new Scaffold([filename: 'quickstart.zip'])
    }

    @Parameters static Collection<Object[]> data() {
        def data = ['.', 'com.', '.com', 'com.example.', 'com..example']
        return data.collect { [it] as Object[] }
    }

    @Test(expected=ScaffoldingException.class) void testInvalidPackages() {
        new ScaffoldExecutor(scaffold, pckg)
    }
}
{% endhighlight %}