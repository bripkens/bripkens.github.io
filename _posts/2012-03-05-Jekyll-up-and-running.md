---
layout: post
title: This blog is now powered by Jekyll
comments: true
tags:
 - 'blog'
 - 'jekyll'
 - wordpress
 - update_issues
 - rant
---

Lately, I felt constrained and, at the same time, annoyed by my old system. I
had been hosting Wordpress using a very cheap web hoster for more than a year
now - the experience was not always pleasant. Due broken updates, I had to
reinstall both, Wordpress and Piwik, at least once. Since then, I was
reluctant to update either system as I feared broken updates or other problems.
Of course, you can't just not update Wordpress nor Piwik as many updates
are necessary security updates.

In addition to the update issues, I felt the urge to customize my Wordpress
installation with a custom, minimalistic theme. I started to do this, but
stopped shortly after because of the complexity of Wordpress themes.
Seriously, the 2011 Wordpress default theme comes with **30** .php files! Each
one of those littered with PHP statements. Logic-less templates? Forget about
it. To give you one example (believe me or not, I really only clicked on a
single file and was presented with a prime example), the following code is
included in the 2011 Wordpress default theme's image.php file.


{% highlight php %}
<?php
  $attachments = array_values( get_children( array( 'post_parent' => $post->post_parent, 'post_status' => 'inherit', 'post_type' => 'attachment', 'post_mime_type' => 'image', 'order' => 'ASC', 'orderby' => 'menu_order ID' ) ) );
  foreach ( $attachments as $k => $attachment ) {
    if ( $attachment->ID == $post->ID )
      break;
  }
  $k++;
  // If there is more than 1 attachment in a gallery
  if ( count( $attachments ) > 1 ) {
    if ( isset( $attachments[ $k ] ) )
      // get the URL of the next image attachment
      $next_attachment_url = get_attachment_link( $attachments[ $k ]->ID );
    else
      // or get the URL of the first image attachment
      $next_attachment_url = get_attachment_link( $attachments[ 0 ]->ID );
  } else {
    // or, if there's only 1 image, get the URL of the image
    $next_attachment_url = wp_get_attachment_url();
  }
?>
{% endhighlight %}


Please to get me wrong, I think that Wordpress is an awesome piece of open
source software, but it's just not for everyone. Anyway, that's my two cents,
I'll stop ranting about it from now on. So, I looked for alternatives and
stumbled upon a new hype: **static site generators**. After giving it some
thought, I tried it out and soon after, was convinced that this is something
for me.

Why are static websites something for me? Well, first of all, it's nerdy
(or geeky, whatever you want to call it nowadays). Despite belonging to a
nerdy group of people, you also don't need to run PHP or Wordpress on the
server. That's certainly one of the main arguments for static websites. So
maintenance wise, this drastically reduces the workload.

Long story short, I went with Jekyll as my static site generator and I'm happy
with it. In combination with nginx (which I desperately wanted to try) and 
website updates through a Git commit hook, performance is now fantastic and
maintenance a boon. Although these numbers may not be representative for every
geographical location, I can record page load times of less than 300 ms and
a Google Page Speed rating of 100.

With this I want to conclude this post, maybe I'll post some parts of my
server configuration in the following week(s). If you didn't like the rant
about Wordpress, please leave me a comment. I would love to hear your opinion
about it (of course you may just as well leave a comment when you share my
opinion).

*I also need to mention that the social media icons are kindly provided by
[komodomedia](http://www.komodomedia.com/).*