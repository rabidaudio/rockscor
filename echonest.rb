require 'rubygems'
require 'echowrap'
require './api_keys'

module Echonest

    # #bug in code, missing discovery from artist result
    # Echowrap::Artist.attr_reader :discovery

    Echowrap.configure do |config|
        config.api_key          = ECHONEST_API_KEY
        config.consumer_key     = ECHONEST_CONSUMER_KEY
        config.shared_secret    = ECHONEST_SHARED_SECRET
    end

    # Echowrap.artist_search(:name => params[:artist_name], 
    #                                  :results => 1, 
    #                                  :bucket => ['hotttnesss', 'familiarity', 'artist_location'])

    def self.get_data(band_info)
        options = { :results => 1, :bucket => [
            'hotttnesss', 'discovery', 'familiarity', 'genre', 'artist_location', 'blogs', 'news', 'reviews',
            'songs', 'urls', 'video', 'years_active']}

#        unless band_info["skid"].nil?
#            options[:id] = "songkick:artist:"+band_info["skid"].to_s
#            result = Echowrap.artist_profile(options)
#        else
            options[:name] = band_info["name"]
            #causes error: options[:artist_location] = "region:"+band_info["state"]
            result = Echowrap.artist_search(options)
#        end

        stuff = result.first
        band_info["stats"] = {} if band_info["stats"].nil?

        band_info["stats"]["hotttnesss"]    = stuff.hotttnesss
        band_info["stats"]["discovery"]     = stuff.discovery
        band_info["stats"]["familiarity"]   = stuff.familiarity

        band_info["tags"] = [] if band_info["tags"].nil?
        # stuff.genre.each do |g|
        #     band_info["tags"].push(g.name) unless band_info["tags"].include? g.name
        # end

        band_info["images"] = [] if band_info["images"].nil?
        stuff.images.each do |i|
            band_info["images"].push(i.url)
        end

        band_info["location"]       = stuff.location.to_hash

        band_info["videos"] = [] if band_info["videos"].nil?
        stuff.video.each do |v|
            band_info["videos"].push(v.to_hash)
        end
        band_info["years_active"]   = Date.today.year - stuff.years_active.start if band_info["years_active"].is_a? Integer

        band_info["articles"] = {} if band_info["articles"].nil?
        band_info["articles"]["reviews"] = [] if band_info["articles"]["reviews"].nil?
        stuff.reviews.each do |r| band_info["articles"]["reviews"].push r.to_hash end
        band_info["articles"]["news"] = [] if band_info["articles"]["news"].nil?
        stuff.news.each do |n| band_info["articles"]["news"].push n.to_hash end
        band_info["articles"]["blogs"] = [] if band_info["articles"]["blogs"].nil?
        stuff.blogs.each do |b| band_info["articles"]["blogs"].push b.to_hash end

        return band_info


            #: => "region:"+band_info["state"], name: band_info["name"]
        
    end

end

