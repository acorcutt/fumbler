require 'fumbler/engine'
require 'fumbler/parser'

describe Fumbler::Engine do
    it "should make a new temple engine" do
      Fumbler::Engine.new
    end
end

describe Fumbler::Parser do
    it "should make a new parser" do
      Fumbler::Parser.new
    end
    
    it "should parse empty string" do
      Fumbler::Parser.new.compile("").should eql([:multi]) 
    end

    it "should parse some static text" do
      Fumbler::Parser.new.compile("some text").should eql([:multi,[:static,"some text"]]) 
    end

    it "should parse escaped tags" do
      Fumbler::Parser.new.compile("hello {{{ <{im}> {escaped} .css{color:red} }}}").should eql([:multi,[:static,"hello "],[:static," <{im}> {escaped} .css{color:red} "]]) 
    end

    it "should parse a text tag" do
      Fumbler::Parser.new.compile("hello {name}-{ age }").should eql([:multi,[:static,"hello "],[:dynamic,"name"],[:static,"-"],[:dynamic,"age"]]) 
    end

    it "should parse a text tag across multi-lines" do
      Fumbler::Parser.new.compile("hello {name\nhere}").should eql([:multi,[:static,"hello "],[:dynamic, "name\nhere"]]) 
    end

    it "should parse a text tag in all tag formats" do
      Fumbler::Parser.new.compile("hello {a}{{b}}<{c}><!--{d}-->").should eql([:multi,[:static,"hello "],[:dynamic,"a"],[:dynamic,"b"],[:dynamic,"c"],[:dynamic,"d"]]) 
    end

    it "should parse a block tag" do
      Fumbler::Parser.new.compile("hello {block:item}{name}{/block:item}").should eql([:multi,[:static,"hello "],[:block,"item",[]],[:dynamic,"name"],[:block,"end"]]) 
    end

    it "should parse a spaced block tag" do
      Fumbler::Parser.new.compile("hello { block : item}{name}{/block : item  }").should eql([:multi,[:static,"hello "],[:block,"item",[]],[:dynamic,"name"],[:block,"end"]]) 
    end

    it "should parse a block tag with attributes" do
      Fumbler::Parser.new.compile("hello {block:item a=\"1\" b='2'}{name}{/block:item}").should eql([:multi,[:static,"hello "],[:block,"item",[["a","1"],["b","2"]]],[:dynamic,"name"],[:block,"end"]]) 
    end
    
end