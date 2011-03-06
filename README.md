Fumbler
=======

This is the start of a ruby template engine based on the Tumblr syntax.

It's not production ready, and this is my first gem so please try it out and let me know if I'm doing anything wrong.

Some better examples are coming, checkout the specs for basic usage.


Overview
--------

The aim is to create a safe-evaluating template engine based on the designer friendly Tumblr syntax. It will be a lot more restrictive than ERB and even Liquid, but slightly more evaluating than Mustache. 

It will enable you to give the designer limited control flow, safely evaluating contexts, nest-able blocks, and a few extensions to make things easier.


Whats Implemented
-----------------


###Model

Inherit from the Model class to create your context which the template can access, it includes a little attr_reader style helper called 'fumbleable' to make stuff available to the template so you can apply it to existing classes and not worry about giving access to db saves etc. 



    class Cage < Fumbler::Model
      fumbleable :inside,:current
      
      def initialize(c)
        @current = c
      end
      
      def inside
        "im trapped"
      end
      
      def current
        @current
      end
    end
      
    class Context < Fumbler::Model
      
      fumbleable :you, :cage, :cages
      
      def you
        "dave"
      end
      
      def hidden
        "you cant access me"
      end
          
      def cage
        Cage.new(0)
      end
      
      def cages
        [Cage.new(1),Cage.new(2)]
      end
    end
    @context = Context.new



###Template

This is based on [Tilt](https://github.com/rtomayko/tilt) but not everything is implemented yet.

The current syntax supports basic {tags} and {block:items}{tagsinparent}or{tagsinhere}{/block:items}, blocks can be nested and will always look to the parent for missing tags.

    t = Fumbler::Template.new {"hello {you}, {block:cage}{current}{/block:cage}  {block:cages}{you}{current},{/block:cages}]"}
    t.render(@context)



TODO
----

* Attributes
* Meta-settings
* Partials
* Layout Inheritance
* File handling
* Rails Integration via Tilt
* Re-write the regex as a token scanner
* Lots More!



Acknowledgements
----------------

This is based on the [Temple](https://github.com/judofyr/temple) framework, taking a few tips from [Mustache](https://github.com/defunkt/mustache). The syntax aims to resemble that of [Tumblr](http://www.tumblr.com) and (Posterous)[http://www.posterous.com].

