require 'rubygems'
require 'soundcloud'


# # create a client object with your app credentials
# client = Soundcloud.new(:client_id => 'YOUR_CLIENT_ID')

# # get a tracks oembed data
# track_url = 'http://soundcloud.com/forss/flickermood'
# embed_info = client.get('/oembed', :url => track_url)

# # print the html for the player widget
# puts embed_info['html']


# # create a client object with access token
# client = Soundcloud.new(:access_token => 'YOUR_ACCESS_TOKEN')

# # get the latest track from authenticated user
# track = client.get('/me/tracks', :limit => 1).first

# # create a new timed comment
# comment = client.post("/tracks/#{track.id}/comments", :comment => {
#   :body => 'This is a timed comment',
#   :timestamp => 1500
# })


# # create a client object with access token
# client = Soundcloud.new(:access_token => 'YOUR_ACCESS_TOKEN')

# # Follow user with ID 3207
# client.put('/me/followings/3207')

# # Unfollow the same user
# client.delete('/me/followings/3207')

# # check the status of the relationship
# begin
#   client.get('/me/followings/3207')
# rescue Soundcloud::ResponseError => e
#   if e.response.status == '404'
#     puts 'You are not following user 3207'
#   end
# end


# require 'soundcloud'

# # create a client object with access token
# client = Soundcloud.new(:access_token => 'YOUR_ACCESS_TOKEN')

# # Fetch a track by it's ID
# track = client.get('/tracks/43314655')

# # Like the track
# client.put("/me/favorites/#{track.id}")