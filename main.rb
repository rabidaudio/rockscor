require 'rubygems'
require './rn_scrape'
require './lastfm'
require './songkick'



def get_all_info(artist, state)
    band_info = {}

    # band_info = Reverbnation::get_data(artist, state)

    # band_info["tags"] = Lastfm::get_tags(artist)

    # band_info["comments"] = Lastfm::get_comments(artist)



    band_info["events"] = Songkick::get_events(artist)



    # band_info["comments"].push()

    band_info
end

puts get_all_info("Romeo Cologne", "GA")



# dont trust accuracy
# LOCAL!!!!!!
# gig history is big