require 'rubygems'
require 'nokogiri'
require 'open-uri'

module ReverbNationScrape
    USER_AGENT = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2140.0 Safari/537.36"

    def search_by_artist(name, state_code)

        search_url = "http://www.reverbnation.com/main/search" #?filter_type=artist&q=Romeo%20Cologne&country=US&state=GA&sort=relevance"
        search_query = {
            :filter_type => "artist",
            #:q => "",
            :country => "US",
            #:state => "",
            :sort => "relevance"
        }

        

        search_query[:q] = name
        search_query[:state] = state_code

        uri = URI(search_url)
        uri.query = URI.encode_www_form(search_query)

        #puts uri

        search_page = Nokogiri::HTML (open(uri, "User-Agent" => USER_AGENT))

        results = search_page.css('.standard_results_row .homepage_link')

        puts "results: "+results.length.to_s

        return "http://www.reverbnation.com" + results.first.attr('href') if results.length > 0

        # if(results.length > 0)
        #     #$('.standard_results_row .homepage_link').each(function(){ console.log("http://www.reverbnation.com" + $(this).attr('href')) })

        #     band_url = "http://www.reverbnation.com" + results.first.attr('href')

        #     return band_url

        # end
        return nil

    end
    module_function :search_by_artist

    def get_rn_band_info(band_url)
            return {} if band_url.nil?

            band_data = {}
            artist_page = Nokogiri::HTML (open(band_url, "User-Agent" => USER_AGENT))

            #get stats
                #$('#profile_stats_content .stats').children().each(function(a, b, c){
                #    console.log([ $(this).find(".stat_name").text(), $(this).find(".stat_count").text()]);
                # });

            stats = {}
            artist_page.css("#profile_stats_content .stats").children().each do |elem|
                stats[elem.css(".stat_name").text.gsub(/\s/, "")] = elem.css(".stat_count").text.gsub(/\s/, "").to_i
            end
            stats.delete("")
            band_data["stats"] = stats

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
            band_data["profiles"] = profiles
            
            return band_data
    end
    module_function :get_rn_band_info
end

puts ReverbNationScrape.get_rn_band_info(ReverbNationScrape.search_by_artist("Romeo Cologne", "GA"))

