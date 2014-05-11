---
layout: post
title: 'Learning Python'
comments: true
tags:
 - language
 - learning
 - studying
 - lines_of_code
 - new_language
 - pragmatic_programmers
 - programming
 - python
---


<em>Learn at least one new language every year.</em> Andrew Hunt and David Thomas wrote down this recommendation in their book <a title="The book on Amazon Germany" href="http://www.amazon.de/gp/product/020161622X?ie=UTF8&amp;tag=finalfanta079-21&amp;linkCode=as2&amp;camp=1638&amp;creative=19454&amp;creativeASIN=020161622X">The Pragmatic Programmer</a>. Last year I have been learning C, C++ and C# as it was part of my <a title="Fontys University of Applied Sciences Software Engineering curriculum." href="http://fontysictvenlo.nl/study-directions/software-engineering/">curriculum</a> but this year I can choose a language on my own.

In 2009 I have already been experimenting with Python. I implemented the typical <a title="Wikipedia about the Game of Life" href="http://en.wikipedia.org/wiki/Conway's_Game_of_Life">Game of Life</a> using Qt but after that I kinda lost focus due to my studies. Recently I wanted to learn a new language and as in 2009 I ended up with Python.

This time I started by implementing a small command line tool that counts the number of lines of code. I know that the amount of code lines tells one nothing important about a code base or project but I still like to see how many lines have been written in the course of a project, i.e. projects that I participated in.
The following listing shows the code of the application.


{% highlight python %}
#!usr/bin/env python3
#
# Copyright 2011 Ben Ripkens.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Count the number of lines for a given directory or file
"""

__author__ = '"Ben Ripkens" <bripkens.dev@gmail.com>'

import logging
import os
import glob
import sys

# Just the logger configuration which needs to be set up before the rest
# of the application
logger = logging.getLogger("linesofcode")

class LineCounter:
    """Class that counts lines for a given path"""

    def __init__(self):
        self.__paths = set()
        self.__lines_by_type = {}

    def countpath(self, path):
        """
        Analyse path an act differently based on the type of content.

        Keyword arguments:
        path -- The path which should be scanned.

        Returns: LineCounter, The object on which you called the method

        """

        path = os.path.normpath(os.path.abspath(path))

        if path in self.__paths:
            logger.info("""Path "%s" was already scanned""", path)
            return self

        if not os.path.exists(path):
            logger.info("""Path "%s" does not seem to exist.""", path)
            return self

        self.__paths.add(path)

        if os.path.isdir(path):
            self.__countdir(path)
        elif os.path.isfile(path):
            self.__addfile(path)

        return self

    def print_statistics(self):
        """
        A simple way of printing statistics to the console

        Returns: LineCounter, The object on which you called the method

        """

        longest_type_name = max(len(s) for s in self.__lines_by_type.keys())

        for type in self.__lines_by_type.keys():
            print("{type:{padding}} {lines}".format(type=type,
                                                    lines=
                                                    self.__lines_by_type[
                                                    type],
                                                    padding=longest_type_name))

        total = sum(i for i in self.__lines_by_type.values())
        print("Total: {}".format(total))

        return self

    def __countdir(self, dir):
        """
        Count the lines of a given directory

        Keyword arguments:
        directory -- The directory which should be scanned.

        Returns: int, The number of lines of code of the directory

        """

        directory_contents = glob.glob(os.path.join(dir, "*"))

        for path in directory_contents:
            self.countpath(path)

    def __addfile(self, file):
        """
        Add information about a file to the statistics

        Keyword arguments:
        file -- The file which should be scanned

        Returns: LineCounter, The object on which you called the method

        """

        lines = LineCounter.countfile(file)

        if lines == 0:
            return self

        type = os.path.splitext(file)[1]

        if type not in self.__lines_by_type:
            self.__lines_by_type[type] = lines
        else:
            self.__lines_by_type[type] = self.__lines_by_type[type] + lines

        return self

    @staticmethod
    def countfile(file):
        """
        Count the lines of a file

        Keyword arguments:
        file -- The file which should be scanned

        Returns: int, The number of lines of code for the file

        """

        if not LineCounter.is_text_file(file):
            logger.debug("""File "%s" is not a text file""", file)
            return 0

        with open(file) as f:
            return len(f.readlines())

        return 0

    @staticmethod
    def is_text_file(file):
        """
        Checks whether the given file is a text file.

        Keyword arguments:
        file -- File to be checked

        Returns: boolean, true when the file is a text file, false otherwise

        """

        with open(file) as f:
            try:
                return "\0" not in f.read()
            except UnicodeDecodeError:
                return False

        return False

if __name__ == "__main__":
    folder = None

    if len(sys.argv) < 2:
        LineCounter().countpath(os.getcwd()).print_statistics()
    else:
        if os.path.exists(sys.argv[1]):
            LineCounter().countpath(
                    os.path.abspath(sys.argv[1])).print_statistics()
            folder = os.path.abspath(sys.argv[1])
        else:
            print("The path is invalid.")
{% endhighlight %}


Example usage and output.


{% highlight bash %}
python3 /home/ben/LinesOfCode/linesofcode.py .
.sh         11
.NavData    53
.java       35222
.default    32
.htm        567
.css        9457
.js         26010
.htc        3
.log        2526
.txt        160
.properties 2635
.xml        5806
.bat        6
.MF         8
.xhtml      10941
Total: 93437
{% endhighlight %}


Some websites that I used:

<ul>
  <li><a title="A great online book about Python 3" href="http://diveintopython3.org/">Dive into Python 3</a></li>
  <li><a title="Coding recommendations" href="http://www.python.org/dev/peps/pep-0008/">PEP 8 - Style Guide for Python Code</a></li>
  <li><a title="Good Python IDE" href="http://www.jetbrains.com/pycharm/">JetBrains PyCharm</a></li>
  <li><a title="Library documentation..." href="http://docs.python.org/py3k/">Python 3 documentation</a></li>
</ul>