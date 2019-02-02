class Forecaster
  def initialize(latitude, longitude)
    @latitude = latitude
    @longitude = longitude
  end

  def city
    @city ||= Geo.search(@latitude, @longitude).city
  end

  def city_name
    city.name
  end

  def weather
    city_name == '長岡' ? '雪' : '晴れ'
  end
end
