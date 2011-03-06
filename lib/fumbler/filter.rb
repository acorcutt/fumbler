require 'temple'

module Fumbler
  # 
  # We just take our array and turn it into something Temple understands
  #
  # We prefix any calls with fumble_ which will be defined in our context class, and any children
  #
  #
  class Filter < Temple::Filter
    def on_multi(*exps) 
      exps.each_with_index do |exp,i|
        name = exp[1]
        case exp[0].to_sym
        when :dynamic
          exps[i] = [:dynamic,"fumble_#{name}"]
        when :block
          if exp[1] == "end"
            #just strip any attributes and double up end tags to match block
            exps[i] = [:block,"end;end"]          
          else
            exps[i]=[:static,"block"]

            # TODO - attributes, first we need to fix the parser to grab the whole attribute including quotes, also allow fumble_*params
            atr = exp[2..-1] 

            # TODO - handle Arrays - think we just need to add it and also end;end above? or inject :multi
            exps[i]= [:block,<<-code]
              c = #{name}
              c = [c] unless c.is_a?(Array) 
              c.each do |b|
                b.fumble(self) do
            code
          end
        end
      end
      return [:multi, *exps]
    end
    
    # Create evaluating string
    def ev(s)
      "#\{#{s}}"
    end
  end
end