require 'temple'
require 'fumbler'

module Fumbler
  class Engine < Temple::Engine
    use Fumbler::Parser
    use Fumbler::Filter

    #filter :EscapeHTML, :use_html_safe  
    filter :MultiFlattener
    filter :StaticMerger
    filter :DynamicInliner
    
    generator :ArrayBuffer
  end
end