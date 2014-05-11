---
layout: post
title: 'Evaluate JSF expression in backing bean'
comments: true
tags:
 - jsf
 - backing_bean
 - evaluate_expression
 - java
 - java_server_faces
 - localization
 - properties
 - resource_bundle
---


When developing a JSF application you may find yourself in situations where it is easier to supply localized text from the backing bean then to use complex JSF expressions in a Facelet. This may also reduce code duplication when conditional behaviour can be reused.

The easiest way to retrieve localized text from one of the resource bundles is to use the <a title="Documentation of the method" href="http://download.oracle.com/docs/cd/E17802_01/j2ee/javaee/javaserverfaces/2.0/docs/api/javax/faces/application/Application.html#evaluateExpressionGet(javax.faces.context.FacesContext, java.lang.String, java.lang.Class)">javax.faces.application.Application#evaluateExpressionGet</a> method. You can use it in the following way.


{% highlight java %}
package nl.rug.search.odr.util;

import javax.faces.context.FacesContext;

/**
 *
 * @author Ben Ripkens <bripkens.dev@gmail.com>
 */
public class JsfUtil {

    public static <T> T evaluateExpressionGet(String expression, Class<? extends T> expected) {
        return JsfUtil.evaluateExpressionGet(FacesContext.getCurrentInstance(), expression, expected);
    }

    public static <T> T evaluateExpressionGet(FacesContext context, String expression, Class<? extends T> expected) {
        return context.getApplication().evaluateExpressionGet(context, expression, expected);
    }
}
{% endhighlight %}


{% highlight java %}
package nl.rug.search.odr.util;

import nl.rug.search.odr.Filename;
import nl.rug.search.odr.SessionAttribute;

/**
 *
 * @author Ben Ripkens <bripkens.dev@gmail.com>
 */
public abstract class ErrorUtil {

    public static void showErrorMessageUsingExpression(String headline, String content) {
        headline = JsfUtil.evaluateExpressionGet(headline, String.class);
        content = JsfUtil.evaluateExpressionGet(content, String.class);

        showErrorMessage(headline, content);
    }

    public static void showErrorMessage(String headline, String content) {
        SessionUtil.addValues(
                new String[]{SessionAttribute.ERROR_TITLE, SessionAttribute.ERROR_CONTENT},
                new String[]{headline, content});

        JsfUtil.redirect(Filename.ERROR_WITH_LEADING_SLASH);
    }

    public static void showUknownError() {
        ErrorUtil.showErrorMessageUsingExpression("#{error['unknown.heading']}",
                "#{error['unknown.message']}");
    }

    // ...
}
{% endhighlight %}

These code samples are part of the <a title="The Open Decision Repository" href="http://code.google.com/p/opendecisionrepository/">Open Decision Repository</a> project.