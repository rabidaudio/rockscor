require 'rubygems'
require 'lastfm-client'
require './api_keys'

module Lastfm

    LastFM.api_key     = LASTFM_KEY
    LastFM.secret      = LASTFM_SECRET
    LastFM.client_name = "band.scor"

    def self.get_tags(band_info)
        result = LastFM::Artist.get_top_tags(artist: band_info["name"])
        # return band_info if result["toptags"]["#text"] == "\n"
        band_info["tags"] =  result["toptags"]["#text"] == "\n" ? {} : result["toptags"]
        return band_info
    end

    def self.get_comments(band_info)
        result = LastFM::Artist.get_shouts(artist: band_info["name"])
        # return band_info if result["shouts"]["#text"] == "\n"
        band_info["comments"] = [] if band_info["comments"].nil?
        return band_info if result["shouts"]["#text"] == "\n"
        band_info["comments"].push(result["shouts"]) #TODO get in common format, pass to sentiment analysis
        return band_info
    end

    def self.get_top_tracks(band_info)
        result = LastFM::Artist.get_top_tracks(artist: band_info["name"], limit: 5)
        # return band_info if !result["error"].nil?
        band_info["top_tracks"] = result["error"].nil? ? [] : result["toptracks"]["track"]
        return band_info
    end

    def self.get_info(band_info)
        result = LastFM::Artist.get_info(artist: band_info["name"])
        return band_info if !result["error"].nil?
        artist = result["artist"]
        band_info["mbid"] = artist["mbid"] #= result["error"].nil? ? [] : result["toptracks"]["track"]
        band_info["profiles"] = {} if band_info["profiles"].nil?
        band_info["profiles"]["lastfm"] = [] if band_info["profiles"]["lastfm"].nil?
        band_info["profiles"]["lastfm"].push(artist["url"]) unless band_info["profiles"]["lastfm"].include?(artist["url"])
        #TODO band_info["pictures"] = [] if band_info["pictures"].nil?
        band_info["stats"]["lastfm_listeners"] = artist["stats"]["listeners"].to_i
        band_info["stats"]["lastfm_playcount"] = artist["stats"]["playcount"].to_i
        band_info["similar"] = artist["similar"]

        return band_info
    end

    # def self.get_local_following(artist, area)
    #     LastFM::Artist.get_metro_artist_chart
    # end
end



# metro (Required) : The metro's name
# country (Required) : A country name, as defined by the ISO 3166-1 country names standard
# start (Optional) : Beginning timestamp of the weekly range requested (c.f. geo.getWeeklyChartlist)
# end (Optional) : Ending timestamp of the weekly range requested (c.f. geo.getWeeklyChartlist)
# page (Optional) : The page number to fetch. Defaults to first page.
# limit (Optional) : The number of results to fetch per page. Defaults to 50.
# api_key (Required) : A Last.fm API key.
