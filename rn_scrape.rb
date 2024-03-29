require 'rubygems'
require 'nokogiri'
require 'open-uri'

#module ReverbNationScrape
module Reverbnation
    USER_AGENT = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2140.0 Safari/537.36"

    def self.rn_search_by_artist(band_info)

        search_url = "http://www.reverbnation.com/main/search" #?filter_type=artist&q=Romeo%20Cologne&country=US&state=GA&sort=relevance"
        search_query = {
            :filter_type => "artist",
            #:q => "",
            :country => "US",
            #:state => "",
            :sort => "relevance"
        }

        

        search_query["q"] = band_info["name"]
        search_query["state"] = band_info["state"]

        uri = URI(search_url)
        uri.query = URI.encode_www_form(search_query)

        # puts uri

        search_page = Nokogiri::HTML (open(uri, "User-Agent" => USER_AGENT))

        results = search_page.css('.standard_results_row .homepage_link')

        # puts "results: "+results.length.to_s

        band_info["profiles"] = {} if band_info["profiles"].nil?

        band_info["profiles"]["reverbnation"] = ["http://www.reverbnation.com" + results.first.attr('href')] if results.length > 0

        # if(results.length > 0)
        #     #$('.standard_results_row .homepage_link').each(function(){ console.log("http://www.reverbnation.com" + $(this).attr('href')) })

        #     band_url = "http://www.reverbnation.com" + results.first.attr('href')

        #     return band_url

        # end
        return band_info

    end
    #module_function :search_by_artist

    def self.get_rn_band_info(band_info)
        # puts band_info["profiles"]["reverbnation"]
        return band_info if band_info["profiles"]["reverbnation"].nil?

        artist_page = Nokogiri::HTML (open(band_info["profiles"]["reverbnation"].first, "User-Agent" => USER_AGENT))

        #get stats
            #$('#profile_stats_content .stats').children().each(function(a, b, c){
            #    console.log([ $(this).find(".stat_name").text(), $(this).find(".stat_count").text()]);
            # });

        stats = {}
        artist_page.css("#profile_stats_content .stats").children().each do |elem|
            stats[elem.css(".stat_name").text.gsub(/\s/, "")] = elem.css(".stat_count").text.gsub(/\s/, "").to_i
        end
        stats.delete("")
        band_info["stats"] = stats

        #get profiles
        profiles = {}
        artist_page.css("#profile_website_items").children().each do |elem|
            if !elem.attr("class").nil?
                platform = elem.attr("class").split.last
                url = elem.css("a").first.attr("href")
                if profiles[platform].nil?
                    profiles[platform] = [url]
                else
                    profiles[platform].push(url)
                end
            end
        end
        band_info["profiles"] = profiles
        
        return band_info
    end
    #module_function :get_rn_band_info

    def self.get_data(band_info)
        get_rn_band_info(rn_search_by_artist(band_info))
    end
end


#puts Scrape.get_rn_band_info(Scrape.search_by_artist("Romeo Cologne", "GA"))