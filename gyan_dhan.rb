require 'json'

MAX_DISTANCE_AWAY_IN_KM = 100.0
RAD_PER_DEG             = 0.017453293
Rkm                     = 6371

def haversine_distance( lat1, lon1, lat2, lon2 )
  dlon = lon2 - lon1
  dlat = lat2 - lat1

  dlon_rad = dlon * RAD_PER_DEG
  dlat_rad = dlat * RAD_PER_DEG

  lat1_rad = lat1 * RAD_PER_DEG
  lon1_rad = lon1 * RAD_PER_DEG

  lat2_rad = lat2 * RAD_PER_DEG
  lon2_rad = lon2 * RAD_PER_DEG

  a = (Math.sin(dlat_rad/2))**2 + Math.cos(lat1_rad) *
       Math.cos(lat2_rad) * (Math.sin(dlon_rad/2))**2
  c = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a))

  dKm = Rkm * c        
  { :km => dKm }
end

file = File.read('test.json')
data_hash = JSON.parse(file)
destination_latitude = 28.521134
destination_longitude = 77.206567
matched = []

data_hash.each do |data|
  friends_longitude = data['longitude'].to_f
  friends_latitude = data['latitude'].to_f
  distance = haversine_distance(friends_latitude, friends_longitude, destination_latitude, destination_longitude)
  if distance[:km] < MAX_DISTANCE_AWAY_IN_KM
    matched << data
  end
end

sort_by_id = matched.sort_by { |k| k[:id] }

sort_by_id.each do |match|
  puts match['id'] + ' ' + match['name'] 
end