require 'rubygems'
#require 'songkickr'
require 'songkick'
require './api_keys'
#require 'active_support/all'
#require './to_hash_monkeypatch'


module SongkickScrape

    #REMOTE = Songkickr::Remote.new SONGKICK_KEY
    REMOTE = Songkick::Client.new(SONGKICK_KEY, :json)

    def self.get_events(band_info) #, state)
        # results = REMOTE.artist_search(:artist_name => artist, :per_page => '10').results
        # 
        # puts results
        # return {} if results.empty?
        # REMOTE.artists_gigography(results.first.id, per_page: '100', page: '1').results #.to_hash #TODO parse in reasonable system

        #TODO Songkick sucks at resolving colisions. need to verify correct artist
        events = {}
        id = REMOTE.search_artist(band_info["name"])["resultsPage"]["results"]["artist"].first["id"]
        band_info["skid"] = id

        page = 1
        result = REMOTE.artist_gigography(id)["resultsPage"]
        events["past"] = result["results"]["event"]
        # puts result["totalEntries"]
        # puts events
        while (page*50 < result["totalEntries"].to_i)
            page=page+1
            new_result = REMOTE.artist_gigography(id, page: page)
            #puts new_result["resultsPage"]["results"]
            events["past"].concat(new_result["resultsPage"]["results"]["event"]) #if !new_result["resultsPage"]["results"]["events"].nil?
        end


        page = 1
        result = REMOTE.artist_calendar(id)["resultsPage"]
        events["future"] = result["results"]["event"]
        # puts result["totalEntries"]
        # puts events
        while (page*50 < result["totalEntries"].to_i)
            page=page+1
            new_result = REMOTE.artist_calendar(id, page: page)
            #puts new_result["resultsPage"]["results"]
            events["future"].concat(new_result["resultsPage"]["results"]["event"]) #if !new_result["resultsPage"]["results"]["events"].nil?
        end

        band_info["events"] = events

        return band_info
    end

end

#http://www.songkick.com/artists/253846-radiohead