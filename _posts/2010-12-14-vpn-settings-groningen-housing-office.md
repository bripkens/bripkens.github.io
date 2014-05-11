---
layout: post
title: 'VPN settings for the Housing Office in Groningen'
comments: true
tags:
 - vpn
 - groningen
 - housing_office
 - internet
 - settings
 - linux
 - ubuntu
 - wifi
 - encryption
---


I spent my last 3 1/2 months in one of the houses from the <a title="Link to the Housing Office web site" href="http://www.housingoffice.nl/">Housing Office</a> in Groningen. If you are, like me, using Linux as your Operating System you may encounter some difficulties on your day of arrival as they don't supply sufficient information for setting up the VPN connection. After searching on the Internet and with the help of my colleague I got it working using the following settings.

<a href="/img/posts/groningen-vpn/vpn-1.png"><img title="vpn-1" src="/img/posts/groningen-vpn/vpn-1.png" /></a>
<a href="/img/posts/groningen-vpn/vpn-2.png"><img title="vpn-2" src="/img/posts/groningen-vpn/vpn-2.png" /></a>
<a href="/img/posts/groningen-vpn/vpn-3.png"><img title="vpn-3" src="/img/posts/groningen-vpn/vpn-3.png" /></a>
<a href="/img/posts/groningen-vpn/vpn-4.png"><img title="vpn-4" src="/img/posts/groningen-vpn/vpn-3.png" /></a>

Replace <em>some name</em> (see VPN settings 1) with a useful name like <em>housing-YourStreetName. </em>Also in the first step enter your user name and password. You find both on your contract. You should replace the x in the gateway address with the number of your house. You should find these numbers on <a title="The site where you find the ip addresses of the houses." href="http://housing.dmz">housing.dmz</a>. Each number (or complete IP address) is specific to one of the houses.
In the second step (VPN settings 2), copy all the settings. You open this window by clicking on advanced in the first window.
In the third window, enter the DNS server. I added the <a title="Google public DNS server web site" href="http://code.google.com/speed/public-dns/">Google DNS servers</a> but you can leave them out. As in step one, fill in the IP which is specific for your house.
For the last step (VPN settings 4), copy the details and make sure that the house specific IP is entered as the gateway.

This should help you get started with your Internet. Enjoy your time in Groningen!