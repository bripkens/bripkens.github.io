---
layout: post
title: 'iPad for software engineers'
comments: true
description: 'I was curious whether an iPad is useful for software engineers. I documented my impression in this blog post.'
tags:
 - iPad
 - software_engineers
 - useful
 - experience
 - retina
 - apps
 - virtualbox
 - itunes
 - windows
 - not_recognized
---

Since the first day Apple released the iPad, I was sceptical. In my opinion it
was always a gadget which did not really serve any purpose (besides generating
lots of money for Apple). Over the last weeks, this opinion drastically changed.
Driven by rumours about the "new" iPad I was thinking about use cases for
software engineers or developers. Unlike mobile app developers (which I am
certainly not), I had no problem not having access to a tablet pc.

<img src="/img/posts/ipad/cover.jpg" class="cover">

When the new iPad was introduced in March, I was certain that a tablet pc would
indeed be useful for reading, surfing and watching videos (especially in the
morning when eating my cereals). Sleeping over the decision for three weeks, I
ordered the new iPad (Wi-Fi only, 16gb). In Germany you are allowed to
return any article purchased over the internet within two weeks and get a
full refund, no questions asked. This allowed me to test it thoroughly.

The result? Well, I am very happy with my decision. Reading is so great on
the iPad. In fact it is so good that I am selling my Amazon Kindle just now on
eBay (with the Kindle app you still get access to all your purchased books).
For folks who read a lot, an iPad might just be the right gadget. This is
especially true when you read many blog posts and articles on the internet.
My girlfriend is certainly happier as I can now sit next to her on the couch
and read through my <em>"read it later"</em> list.


# Using iTunes on Linux

Apple does not provide a Linux version of iTunes, but you need it in order to
put ebooks, music and other things on the iPad. There are three ways to solve
this issue.

 1. Install Windows natively
 2. Install iTunes using Wine
 3. Install Windows in a virtual machine

Option one is actually not an option for me. I do not want to screw my PC over
with a native installation of Windows. These times are over for me. The second
option, i.e., Wine, seems to be working fine for some people, although I read
about people having trouble with the recognition of "iDevices" (iPod, iPad
etc.). Since I did not want to spend a large amount of time solving problems,
I just installed Windows in virtual machine using VirtualBox. This is working
fine for me. Just make sure that you have the
[VirtualBox Extension Pack](https://www.virtualbox.org/wiki/Downloads) installed
and the USB 2.0 EHCI controller option enabled (without this, the iPad was
recognized, but drivers could not be installed).

# 10 useful and great apps

<div class='apps'>
  <div class='clearfix'>
    <img src="/img/posts/ipad/apps/pocket.png">
    <h2>
      <a href="http://itunes.apple.com/us/app/pocket-formerly-read-it-later/id309601447">
        Pocket (Formerly Read It Later)
      </a>
    </h2>
    <p>
      Are you reading many blog posts and articles on the internet? Do you have
      more than one device and would like to keep track of all the things that
      you still want to read? Then install Pocket and save articles for later.
      Once you have time, e.g., when commuting to work, go through the list
      on your smartphone. On the couch you can use your tablet pc. Nice
      side effect: Pocket will preprocess the articles so that you can save
      precious bandwidth and time.
    </p>
  </div>
  <div class='clearfix'>
    <img src="/img/posts/ipad/apps/ibooks.png">
    <h2>
      <a href="http://itunes.apple.com/us/app/ibooks/id364709193">
        iBooks
      </a>
    </h2>
    <p>
      Simply read books and PDFs on your iPad. It supports epub, so you do not
      need to convert your existing library.
    </p>
  </div>
  <div class='clearfix'>
    <img src="/img/posts/ipad/apps/kindle.png">
    <h2>
      <a href="http://itunes.apple.com/us/app/kindle-read-books-magazines/id302584613">
        Kindle
      </a>
    </h2>
    <p>
      Had an Amazon Kindle before your iPad? Maintain access to your Amazon
      bookshelf using the Kindle app.
    </p>
  </div>
  <div class='clearfix'>
    <img src="/img/posts/ipad/apps/itunesu.png">
    <h2>
      <a href="http://itunes.apple.com/us/app/itunes-u/id490217893">
        iTunes U
      </a>
    </h2>
    <p>
      Do you know the free Stanford and MIT lectures? Well, a ton of material
      is available for free on the internet. iTunes U provides a neat interface
      to search and consume it.
    </p>
  </div>
  <div class='clearfix'>
    <img src="/img/posts/ipad/apps/currents.png">
    <h2>
      <a href="http://itunes.apple.com/us/app/google-currents/id459182288">
        Google Currents
      </a>
    </h2>
    <p>
      A very new Google project which is similar to an RSS reader. Instead of
      just showing you the content, it also formats it for improved
      readability.
    </p>
  </div>
  <div class='clearfix'>
    <img src="/img/posts/ipad/apps/keynote.png">
    <h2>
      <a href="http://itunes.apple.com/us/app/keynote/id361285480">
        Keynote
      </a>
    </h2>
    <p>
      An iPad port of Keynote, i.e., the counterpart to (Open|Libre) Office's
      impress and Microsoft PowerPoint. Creativity should not be restricted to
      your desk. Being able to work wherever you want can sometimes be nice. As
      a bonus you can even connect your iPad to a projector and run your
      presentation.
    </p>
  </div>
  <div class='clearfix'>
    <img src="/img/posts/ipad/apps/filebrowser.png">
    <h2>
      <a href="http://itunes.apple.com/us/app/filebrowser-access-files-on/id364738545">
        FileBrowser
      </a>
    </h2>
    <p>
      You have to pay 100 &euro; per 16 Gigabyte. I find this outrageously
      overpriced. I have chosen the 16 Gigabyte version and simply use my
      home server for all things that do not always need to be stored on the
      iPad. With the FileBrowser app you can access Samba shares and thus
      increase your storage for just a few bucks.
    </p>
  </div>
  <div class='clearfix'>
    <img src="/img/posts/ipad/apps/fing.png">
    <h2>
      <a href="http://itunes.apple.com/us/app/fing-network-scanner/id430921107">
        Fing
      </a>
    </h2>
    <p>
      Just your average network scanner. It is free, very well designed
      and working great. It even supports wake on LAN and port scanning.
    </p>
  </div>
  <div class='clearfix'>
    <img src="/img/posts/ipad/apps/snapseed.png">
    <h2>
      <a href="http://itunes.apple.com/us/app/snapseed/id439438619">
        Snapseed
      </a>
    </h2>
    <p>
      You probably heard about Instagram, the company which was just bought by
      Facebook for one billion dollar. Instagram has these cool image filters
      that make almost every image look great (it did not manage to enhance a
      <a href="http://instagr.am/p/JO-wcmSXWX/">TV dinner</a> a few weeks back).
      Snapseed also provides basic image manipulation, for instance, brightness,
      contrast, cropping, texture and "styles". This post's cover photo was
      enhanced using the app.
    </p>
  </div>
  <div class='clearfix'>
    <img src="/img/posts/ipad/apps/crunchyroll.png">
    <h2>
      <a href="http://itunes.apple.com/us/app/crunchyroll-watch-anime-drama/id329913454">
        Crunchyroll
      </a>
    </h2>
    <p>
      Sometimes you need to relax and expose yourself to movies, TV shows and
      similar. Crunchyroll brings some Japanese anime to you for free. My
      girlfriend and I have been enjoying
      <a href="http://www.crunchyroll.com/naruto-shippuden">Naruto</a> for some
      time now.
    </p>
  </div>
</div>


# Summary

The iPad is great for reading, surfing the web and various other tasks. If you
have the chance, pick one up and try it out. Should you be looking forward to
some mobile web app development, you might be interested in
[Firebug lite](http://getfirebug.com/firebuglite).