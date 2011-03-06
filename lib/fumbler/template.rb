require 'temple'
require 'fumbler'

module Fumbler
  class Template < Temple::Template
    engine Fumbler::Engine
  end
end
