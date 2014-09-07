require 'rubygems'
require 'lastfm-client'
require './api_keys'

module Lastfm

    LastFM.api_key     = LASTFM_KEY
    LastFM.secret      = LASTFM_SECRET
    LastFM.client_name = "band.scor"

    def self.get_tags(artist)
        result = LastFM::Artist.get_top_tags(artist: artist)
        return {} if result["toptags"]["#text"] == "\n"
        return result["toptags"]
    end

    def self.get_comments(artist)
        result = LastFM::Artist.get_shouts(artist: artist)
        return {} if result["shouts"]["#text"] == "\n"
        return result["shouts"] #TODO get in common format, pass to sentiment analysis
    end
end

