
Cellulate: a dangerous module for a thread-safer world.

Celluloid is designed to be mixed into a class at definition, and instantiate
actor obscured objects from the moment they are created. This is a sane
and rational approach to building a concurrent and thread safe application.
Unfortunately, sanity is not always present in software development and
situations come up where actions must be performed on an object before
its abstraction behind an actor can occur. Due to the operating mechanism
of the Celluloid mixin, extending the object with a module is one of those
actions.

Enter Cellulate, a late initialization module for creating Celluloid objects.
It is intended for instantiated objects which are conditionally extended during
construction, and not as a late backgrounding method for existing objects which
may be referenced elsewhere.

THIS IS DANGEROUS!

Ruby 1.9 does not allow reassignment of self, or rather the value at the address
of the object contextually defined as self. SmallTalk calls such a method "become."
This means that if an object is instantiated, and is referenced by some other
context, then using this method will not replace the object in that context
with the proxy created here. The result can lead to calls on the raw object...

Example of how things go wrong:
```ruby
obj = Object.new
ar = []
ar << obj
obj.extend(Celluloid::Cellulate)
obj = obj.send(:cellulate)
ar[0] != obj
```

This implementation has the potential to ruin your day, so much so that
it was placed in a separate gem with this WARNING.

When should I use Cellulate?
--------------------------------

Cellulate is for edge cases like the one shown in examples/fibber_cell. It should
to be used before the newly initialized object is referenced by another context.
This is not guaranteed as some initialization calls can associate the
embryonic object with another, and before you know it, you're back to reading
stack traces.

Objects which need to be extended before getting their actor assigned can use
this, presuming they meet the "no external reference" criteria. Dynamically
generated classes may also be converted to Celluloid objects this way, as an
object which has been extended with other modules, then Cellulate has its own
class which can be used to create pools and supervisors of that class.

Supported Platforms
-------------------

Known to work in MRI 1.9.3 and rbx-head --19 @ 6f3a7abfa88925f907352974dbeff07e5bd34730

Usage
-----

Extend the instantiated object with Celluloid::Cellulate, and force a private
method call to :cellulate. If pools and supervisors are needed, a call to the
object's class with the appropriate method (:pool, :supervise, etc) will return
the desired result. When possible, cellulate an object's duplicate as an
additional safeguard in the workflow to reduce potential calls on the raw object.

Status
------

Cellulate is currently implemented for Celluloid only.

Celluloid::IO and DCell versions/modules to follow.


License
-------

Copyright (c) 2012 Boris Lukashev. Distributed under the MIT License. See
LICENSE.txt for further details.
