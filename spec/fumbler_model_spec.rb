require 'fumbler/model'

describe Fumbler::Model do
    before(:all) do
            
      class Context < Fumbler::Model
        
        fumbleable :you, :cage
        
        def you
          "dave"
        end
                
        class Cage < Fumbler::Model
          fumbleable :inside
          
          def inside
            "im trapped"
          end
        end
        
        def cage
          Cage.new
        end
      end


    end

    it "should find all attributes" do
      @context = Context.new
      
      @context.fumble(self){        
        you.inspect    
        outside = "outside"        
        cage.fumble(self){
          outside.inspect    
          inside.inspect             
          you.inspect    
        }   
      }   
    end

end