---
layout: post
title: Visualizing source code repository activity
comments: true
tags:
 - visualizing
 - visualization
 - svn
 - git
 - mercurial
 - activity
 - gource
 - commit
 - repository
 - video
 - odr
---

I just found a really nice application for visualization of source code repository
activity. The application is called [Gource](http://code.google.com/p/gource/)
and can create a video which illustrates how (colour of
the beam), when (date) and what (the beam) files the committers are touching.
It's kinda hard to explain, so just check out the following video which visualizes
my last project's repository activity.

<iframe width="640" height="360" src="http://www.youtube.com/embed/_4HZUAKt-kc?rel=0" frameborder="0" allowfullscreen></iframe>

Pretty neat, isn't it? To do this yourself, install Gource and create a log which contains
all necessary information (not necessary for every VCS, refer to the
[wiki](http://code.google.com/p/gource/w/list) for additional information).


{% highlight bash %}
svn log -r 1:HEAD https://svn.example.com/my-project \
    trunk branches \
    --xml \
    --verbose \
    --quiet > my-project-log.xml
{% endhighlight%}


Now, to test this and simply show the video, execute the following command
and tinker with it.


{% highlight bash %}
gource my-project-log.xml \
    --highlight-all-users \            # always show user names
    --colour-images \                  # colourize users
    --seconds-per-day 2 \              # seconds spent for each day
    --hide filenames,progress,mouse \  # hide certain elements
    --key \                            # show a list with all file types
    --title "Some title" \             # title which is shown in the bottom
    --multi-sampling \                 # anti aliasing
    -1920x1080 \                       # output resolution
    --date-format "%Y-%m-%d" \         # date format
    --file-idle-time 0                 # how long files should be shown.
                                       # 0 means "show always"
{% endhighlight %}


At last, create a video! [The project's wiki](http://code.google.com/p/gource/wiki/Videos)
contains some useful guidelines. I used the following command to create the
video that you (hopefully) just saw (I removed any
unnecessary Gource command line options for clarity).


{% highlight bash %}
gource my-project-log.xml -o - | ffmpeg \
    -y \
    -r 60 \
    -f image2pipe \
    -vcodec ppm \
    -i - \
    -vcodec libvpx \
    -b 10000K \
    gource.webm
{% endhighlight %}


I hope this worked out for you. Please leave a comment with a link to your
video should you stumble upon this.
