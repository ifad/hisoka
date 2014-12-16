# Hisoka

"Hisoka ni" means in secret. It is a simple spy library that can be used
in a Rails* app.

```
ひそかに【密かに】
【人に知られないように隠れて】secretly, in secret;
```

#What is it for?
Think of this as a debug or analysis tool for recording messages sent to

The design principle is that you should be able to drop instances into a Rails app
and find you are quite likely to record everything that happens to them, and still
render a page without a 500. They can be placed in views, forms, hashes, arrays
iterated over, and pass through the app invisibly and unscathed.

E.g. they secretly pretend to be ActiveRecord objects, iterable collections,
objects you can put into and retrieve from hashes/arrays or hashes of arrays of
hashes and still undetectably to the application like the real thing.

This will help get a rough overview of how an object is used, but isn't guaranteed
to cover every code path or use case.

Easily seeing what methods are called on an object
during normal usage means you can swap it out for an equivalent.

This project was created because of the need to replace some
calls to a database with an external service and not port across
unnecessary methods.

#Usage

##Iterable spies
```ruby
#old code
@projects = Project.all

#replaced with
@projects = Hisoka::Iterable.new("all-projects")
```

#Log output example

```log
Hisoka: all-projects  (app/controllers/projects_controller.rb:19:in `index' ) .select
Hisoka: all-projects  (app/controllers/projects_controller.rb:22:in `index' ) select.each
Hisoka: all-projects  (app/controllers/projects_controller.rb:22:in `index' ) select.block-inside-each
Hisoka: all-projects  (app/controllers/projects_controller.rb:23:in `index' ) select.block-inside-each.country
Hisoka: all-projects  (app/controllers/projects_controller.rb:23:in `index' ) select.block-inside-each.country.region
Hisoka: all-projects  (app/controllers/projects_controller.rb:24:in `index' ) select.block-inside-each.country
Hisoka: all-projects  (app/controllers/projects_controller.rb:24:in `index' ) select.block-inside-each.country.region
Hisoka: all-projects  (app/controllers/projects_controller.rb:24:in `index' ) select.block-inside-each.country`)
```

#API
The classes are defined in a hierarchy with each one adding more functionality (and cluttering with more methods)

* `Hisoka::Basic` extends BasicObject and is hence as light weight as possible
* `Hisoka::Tryable` extends Object so works with `:try`
* `Hisoka::Iterable` can be iterated over
* `Hisoka::Routable` can be used in forms and link_to helpers


#Note
It doesn't need to be Rails specific, but has been abstracted out of
being used in 2 Rails apps. Pull requests welcome to make it work
in a more generic way

## Installation, contributions etc
All the usual bundler gem/github PR guidelines.

