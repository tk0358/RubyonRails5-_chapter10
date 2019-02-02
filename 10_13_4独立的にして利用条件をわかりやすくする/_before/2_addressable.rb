module Addressable
  def city
    Geo.search(latitude, longitude).city
  end
end
