#!/usr/bin/env ruby
require 'mongo'
require 'redis'

module Crawl
  class Spider
    def initialize site, opts, links
      @links = links
      @options = opts
      @ua   = "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36"
      @opts = self.settings
      @site = site
      @name = self.name
    end

    def anemone_crawl
      require 'anemone'
      Anemone.crawl(@site, @opts) do |anemone|
        # anemone.storage = Anemone::Storage.Redis
        # anemone.storage = Anemone::Storage.MongoDB
        anemone.on_every_page do |page|
          next if page.body == nil 
          # ap page.links
          ap @links
          page.links.each do |l|
            @links.index{|s| ap s.include?(l.to_s)}
          #   # if @links then puts "Found" end
          end
          # self.scrape page
          page.discard_doc!
          if @depth == 0 then return end
        end
      end
    end

    def mechanize_crawl
      require 'mechanize'
      
    end

    def scrape page
      begin
        data = Crawl.const_get(@name).new(page).save
      rescue
        data = Crawl::Scrape.new(page).save
      end 

      data['site_name'] = @name #if !data['site_name']

      begin
        saving = Crawl.const_get(@name+"Data").new(data, @options).save
      rescue
        saving = Crawl::Data.new(data, @options).save
      end 

      data = nil
      saving = nil
    end

    def name
      uri = URI.parse(@site)
      uri.host.to_s.match(/www.(.+)\.com/)[1].capitalize rescue @site.to_s.match(/(.+)\.com/)[1].capitalize
    end

    def settings
      {discard_page_bodies: true, 
       skip_query_strings: true, 
       # threads: 1, 
       depth_limit: @options[:depth], 
       read_timeout: 10, 
       user_agent: @ua,
       obey_robots_txt: false,
       large_scale_crawl: true,
       max_page_queue_size: 100,}
    end
  end
end
