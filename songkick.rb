require 'rubygems'
#require 'songkickr'
require 'songkick'
require './api_keys'
require 'active_support/all'
require './to_hash_monkeypatch'


module SongkickScrape

    #REMOTE = Songkickr::Remote.new SONGKICK_KEY
    REMOTE = Songkick::Client.new(SONGKICK_KEY, :json)

    def self.get_events(artist) #, state)
        # results = REMOTE.artist_search(:artist_name => artist, :per_page => '10').results
        # 
        # puts results
        # return {} if results.empty?
        # REMOTE.artists_gigography(results.first.id, per_page: '100', page: '1').results #.to_hash #TODO parse in reasonable system

        #TODO Songkick sucks at resolving colisions. need to verify correct artist
        id = REMOTE.search_artist(artist)["resultsPage"]["results"]["artist"].first["id"]
        page = 1
        result = REMOTE.artist_gigography(id)["resultsPage"]
        events = result["results"]["events"]
        #puts result["totalEntries"]
        #puts events
        while page*50 < result["totalEntries"].to_i
            page+=1
            new_result = REMOTE.artist_gigography(id, page: page)
            # puts new_result["resultsPage"]["results"]
            events.concat(new_result["resultsPage"]["results"]) #if !new_result["resultsPage"]["results"]["events"].nil?
            
        end

        events
    end

end

#http://www.songkick.com/artists/253846-radiohead