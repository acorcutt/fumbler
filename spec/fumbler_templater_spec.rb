require 'fumbler/template'
require 'fumbler/model'

describe Fumbler::Template do
    before(:all) do
      class Context < Fumbler::Model
        
        fumbleable :you, :cage, :cages
        
        def you
          "dave"
        end
        
        def hidden
          "you cant access me"
        end
        
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
        
        def cage
          Cage.new(0)
        end
        
        def cages
          [Cage.new(1),Cage.new(2)]
        end
      end
      @context = Context.new

    end

    it "should make a new temple" do
      Fumbler::Template.new {}
    end

    it "should render some static text" do
      Fumbler::Template.new{"hello from template"}.render.should eql("hello from template")
    end

    it "should render a tag" do
      t = Fumbler::Template.new {"hello {you}"}
      t.render(@context).should eql("hello dave")
    end    

    it "should render a block" do
      t = Fumbler::Template.new {"hello {you}, {block:cage}{you} {inside}{/block:cage}"}
      t.render(@context).should eql("hello dave, dave im trapped")
    end    

    it "should render a block a few times" do
      t = Fumbler::Template.new {"hello {you}, [{block:cages}{you}{current},{/block:cages}]"}
      t.render(@context).should eql("hello dave, [dave1,dave2,]")
    end    

end