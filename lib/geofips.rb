require "geofips/version"
require "csv"

module Geofips
  require 'singleton'
  
  class Coder
    
    def initialize(code = "")
      @data = CSV.read(File.expand_path('../data/locations.csv', __FILE__), { headers: true, header_converters: :symbol })
    end
    
    @@instance = Coder.new
    
    def self.instance
      return @@instance
    end
    
    def data
      return @data
    end
    
    private_class_method :new
    
  end

  class Location
    attr_reader :lat, :lng, :ne_lat, :ne_lng, :sw_lat, :sw_lng, :county, :state
    
    def initialize(code = "")
      @lat = 0.0
      @lng = 0.0
      @ne_lat = 0.0
      @ne_lng = 0.0
      @sw_lat = 0.0
      @sw_lng = 0.0
      @county = ""
      @state = ""
      return find_by_code(code) if !code.empty?
      return self
    end

    def find_by_code(code)
      Geofips::Coder.instance.data.each do |loc|
        if loc[:fips] == code
          @lat = loc[:lat]
          @lng = loc[:lng]
          @ne_lat = loc[:ne_lat]
          @ne_lng = loc[:ne_lng]
          @sw_lat= loc[:sw_lat]
          @sw_lng= loc[:sw_lng]
          @county = loc[:county]
          @state = loc[:state]
        end
      end

      return self
    end
    
    def find_by_county(county)
      Geofips::Coder.instance.data.each do |loc|
        if loc[:county].downcase.strip == county.downcase.strip
          @lat = loc[:lat]
          @lng = loc[:lng]
          @ne_lat = loc[:ne_lat]
          @ne_lng = loc[:ne_lng]
          @sw_lat= loc[:sw_lat]
          @sw_lng= loc[:sw_lng]
          @fips = loc[:county]
          @state = loc[:state]
        end
      end
      #binding.pry
      return self
    end
    
  end
end
