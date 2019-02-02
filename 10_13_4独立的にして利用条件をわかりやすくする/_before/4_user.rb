class User
  include Talkable
  include Addressable
  include Forecastable

  attr_accessor :name, :latitude, :longitude
end
