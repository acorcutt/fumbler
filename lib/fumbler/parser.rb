require 'temple'

module Fumbler
  #
  # Handles parsing of our template string
  #
  # The Basics:
  # 
  #
  # Display something:
  #
  #   {title}
  #
  # Blocks:
  #
  # {block:item limit="10"}
  #   {title}      
  # {/block:item}
  #
  #
  # We allow a few tag formats and special html style wrapper to hide from rich html editors
  # {block:items} {{block:items}} <{block:items}> <!--{block:items}--> are all equivelant, 
  # The surrounding tag will always be stripped from the output.
  #
  # Escape things with 
  # {{{ <{im}> {escaped} .css{color:red} }}}
  #
  # TODO - make tag patterns customizable so we can do ${tag} etc.
  # TODO - combine the block and tag pattern, then allow tag & block delimiters to be differerent e.g. erb style
  # TODO - or switch to scanning for opening and closing tags so we can do things like {block:tag a="{" b="}"} and ignore {tag}} 
    
  class Parser
    include Temple::Mixins::Options
    
    TAG_PATTERN = /{{{(.*?)}}}|({|{{|<{|<!--{)\s*?(\/?\b.+?)\s*?(}-->|}>|}}|})/m #order of the { {{ <{ <!--{ tag groups is important
    
    BLOCK_PATTERN = /(\/?\b\w+\b)\s*?:\s*?(\b\w+\b)\s*?(.*)/m
    
    ATTRIBUTE_PATTERN = /\s+(\b\w+\b)\s*=\s*(?:(['"])(.*?)\2)/m #a='1' b="2"
    
    def compile(input)
      result = [:multi]
      return result unless input

      pos = 0
      blocks = 0
      input.scan(TAG_PATTERN) do |escaped,s, tag, e|
        m = Regexp.last_match
        text = input[pos...m.begin(0)]
        pos  = m.end(0)
        result << [:static, text] if !text.empty?
        if escaped
          result << [:static, escaped]  
        else      
          m = tag.match(BLOCK_PATTERN)
          if m
            t = m[2]
            a = []
            m[3].scan(ATTRIBUTE_PATTERN) do |key,q,value|
              a << [key,value]
            end
            case m[1]
            when "block"
              result << [:block,t,a]
              blocks+=1
            when "/block"
              result << [:block,"end"]
              blocks-=1
            end
          else
            result << [:dynamic,tag]
          end
        end
      end
      text = input[pos..-1]
      result << [:static, text] if !text.empty?      
  
      #close any blocks left over
      blocks.times do
        result << [:block,"end"]
      end

      result
    end
  end
end