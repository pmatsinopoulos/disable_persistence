Disable Persistence
===================

This project has been developed after reading this question on SOW:

http://stackoverflow.com/questions/17889777/rails-how-to-disable-persistence-of-object-temporarily

Let me repeat here the text of the question:

> As in, freeze disables ability to update object values (to a degree). How might I build a method User.disable_persistence
> that would disable ability to create/save/update on that object and associated objects, both called directly (User.save)
> and indirectly (User.children << child).

The problem seems simple. The tricky part though is the `and indirectly (User.children << child)` part of it.
This can be dealt with easily when the parent object (`User`) is new record. But not that easily if it is not.
This is because a statement like `user#children << child` saves the parent record and the children when record of `user` is new
but does not do the same when it is not. On latter case it saves only the `child`. This problem is not solved on
this project, automatically, at least for now. Developer has to disable the persistency on the `child` object first
in order to achieve this on this latter case.

See the `author_spec.rb` file. It is very helpful to tell you the whole story.

Anyone that wants to contribute on that, feel free.




