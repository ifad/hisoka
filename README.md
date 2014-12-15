# Hisoka

"Hisoka ni" means in secret. It is a simple spy library that can be used
in a Rails* app.

```
ひそかに【密かに】
【人に知られないように隠れて】secretly, in secret;
```

Easily seeing what methods are called on an object
during normal usage means you can swap it out for an equivalent.

This project was created because of the need to replace some
calls to a database with an external service and not port across
unnecessary methods.

#Usage

##Iterable spies
```ruby
#old code
@users = User.all

#replaced with
@users = Hisoka::Iterable.new("all-users")
```

#log output example

```log
```

#Note
It doesn't need to be Rails specific, but has been abstracted out of
being used in 2 Rails apps. Pull requests welcome to make it work
in a more generic way

## Installation, contributions etc
All the usual bundler gem/github PR guidelines.

