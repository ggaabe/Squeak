Core functionality of the Connectomix project. All API requests make calls to the connectome functions maintained here.

To compile use:
```
g++ -std=c++11 -Wall -pedantic-errors Network/*.hpp Neurons/*.hpp IO/*.hpp IO/*.cpp main.cpp
```

To run:
```
./a.out
```

To avoid many problems we have created some rules regarding software
development. If any one has any suggestions please propose them by making a pull request.

#Licensing:

#Copyright notice:

All files developed and committed by anyone from our team should have the
following comment on the top:
```
# Copyright 2015 Connectomix
# Authors:
# Your name
```

Where 2015 will change depending on the current year. If file was created in
2015 but modified in 2016 the date should indicate this by writing both years
with dash in between
i.e 2015 - 2016
There is no need to keep all years in, just starting and the year of the last
updated. If file is constantly being modified and it's now 2017 it will be
only 2015 - 2017

If you make even small modification to the file, please add your name.

#Licenses for libraries:

We can't afford to deal with lawyers right now, so to be on a safe side lets
just use libraries with BSD and MIT licenses, or any other permissive licenses like
WTFPL. If in doubt ask, and Mariusz will review them and approve so you can later
blame it on him. :)


#Programming:

##Style:
We will have to decide on programming style, and once we do, we will have to
keep enforcing the rules. For C/C++ I propose "The Elements of C++ Style" as a
starting point.
For Java perhaps some of the rules contained in "Clean Code" should be applied.

##Version Control:
We'll be using GIT hosted on bitbucket for now.

Small commits of code.
Commit often.
Don't mix many changes and features in one commit, unless absolutely necessary.
Work in Development branch.

Each repo will get it's maintainer who will be responsible for keeping it clean.
