## A mirror API for Ruby

In [various][p1] [reasearchers][p2] the advantages of having a [mirror
API][p3] to separate reflection from a language implementation have
been discussed, and "industry grade" implementations exist for
[Java][p4] and [C#][p5]. This project aims at providing a number of
specs and classes that document a mirror API for Ruby. The mirror
implementation that is part of this project will use only those
language facilities that are available across Ruby implementations,
the specs, however, will also test behavior that cannot be provided in
such a manner. The idea here is that in time, all implementations
provide their own implementation of the mirror API, and all
implementations collaborate on this one spec.

Why do this, you ask? Because Ruby needs tools, and those tools need
to be written in Ruby. If they are not, that excludes many people from
tinkering with their tools, thus impeding innovation. You only have to
look at Emacs or Smalltalk to see what's possible when Programmers can
extend their tools, all tools, in a language they feel comfortable
in. If we have a standard mirror API, all tools that are written **for**
Ruby, **in** Ruby, can be shared across implementations, while at the same time
allowing language implementers to use the facilities of their platform
to provide optimal reflective capabilities without tying them to
internals.

[p1]: http://www.cs.virginia.edu/~lorenz/papers/icse03/icse2003.pdf "Pluggable Reflection: Decoupling Meta-Interface and Implementation"
[p2]: http://bracha.org/newspeak-spec.pdf "Newspeak Programming Language Draft Specification, Version 0.06, pages 40 onward"
[p3]: http://www.hpi.uni-potsdam.de/hirschfeld/events/past/media/100105_Bracha_2010_LinguisticReflectionViaMirrors_HPI.mp4 "Linguistic Reflection Via Mirrors"
[p4]: http://bracha.org/mirrors.pdf "Mirrors: Design Principles for Meta-level Facilities of Object-Oriented Programming Languages"
[p5]: http://oreilly.com/catalog/progcsharp/chapter/ch18.html "See esp. 18-3, highlighting how C# reflection works on assembly rather than VM objects"
