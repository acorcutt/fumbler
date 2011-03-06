module Fumbler

  class Model
   
    def self.fumbleable(*accessors)
      accessors.each do |m|
        class_eval <<-EOS
          def fumble_#{m}
            self.#{m}
          end
        EOS
      end
    end

    # What I'm trying todo is make blocks work inside blocks, and still be able to access
    # the parents attributes, instance_eval lets us do something similar to javascripts with(o){}
    # In this example we cant access 'you' inside the cage context how we would like to
    # as its not a local, but see how 'outside' works. So we need to catch the missing_method
    # and push send up to the parent, which might be a bit slow but it simplifies the block filter.
    #
    #      @context.fumble(self){        
    #        puts you   #defined in root context class 
    #        outside = "outside"        
    #        cage.fumble(self){
    #          puts outside
    #          puts inside #defined in cage class        
    #          puts you #this errors unless we catch method_missing
    #        }   
    #      }       
    def fumble(parent,&block)
      @parent = parent
      instance_eval &block
    end
    
    def method_missing(sym, *args,&block)
      if @parent
        @parent.send(sym, *args,&block) 
      end
    end
  end
end