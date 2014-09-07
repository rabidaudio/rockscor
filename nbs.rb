require 'rubygems'
require 'date'
require './api_keys'
require 'next-big-sound-lite'

module Nextbigsound
    
    NextBigSoundLite.api_key = NEXTBIGSOUND_KEY

    def self.get_social(band_info)

        result = NextBigSoundLite::Artist.search(band_info["name"])

        return band_info if !result

        #TODO don't just assume the first is right
        bandinfo["mbid"] = result.first.music_brainz_id if band_info["mbid"].nil? and !result.first.music_brainz_id.nil?
        id = result.first.id.to_i
        band_info["profiles"] = {} if band_info["profiles"].nil?
        band_info["profiles"]["nextbigsound"] = [] if band_info["profiles"]["nextbigsound"].nil?
        band_info["profiles"]["nextbigsound"].push( "band_info https://www.nextbigsound.com/artist/#{id}/overview" )

        result = NextBigSoundLite::Metric.profile(id, :start => Date.today.prev_month(3))
        return band_info if !result

        band_info["social_graph"] = {} if band_info["social_graph"].nil?
        # band_info["social_graph"]["plays"] = result.plays.to_hash
        band_info["social_graph"]["plays"] = {}
        result.plays.to_hash.each do |key,value| # convert to normal unix timestamps
            #in the form of {time => count}
            band_info["social_graph"]["plays"][(key.to_i*1000*60*60*24).to_s] = value
        end

        band_info["social_graph"]["fans"] = {}
        result.fans.to_hash.each do |key,value| # convert to normal unix timestamps
            #in the form of {time => count}
            band_info["social_graph"]["fans"][(key.to_i*1000*60*60*24).to_s] = value
        end

        band_info["social_graph"]["comments"] = {}
        result.comments.to_hash.each do |key,value| # convert to normal unix timestamps
            #in the form of {time => count}
            band_info["social_graph"]["comments"][(key.to_i*1000*60*60*24).to_s] = value
        end

        return band_info

    end

        # NextBigSoundLite::Metric.profile(200, :start => 2.months.ago)

end
