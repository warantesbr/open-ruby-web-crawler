#!/usr/bin/env ruby
require 'ap'

module Crawl
  class Controller
    def initialize opts
      if opts[:urls] == nil then @urls = self.get_follow_urls; opts[:sniper]=true
      else @urls = opts[:urls] end
      if opts[:file] == true
        # ap File.open('url.txt', "rb").read
        # File.foreach('url.txt').map { |line| @urls << l.to_s }
      end
      while url = @urls.pop do
        crawl = Crawl::Spider.new(url)
        if opts[:sniper] == true then crawl.sniper
        else crawl.shotgun end
        crawl = nil
      end
    end

    def get_follow_urls
    	get_json("#{@host}/api/get_follow_urls.json")
    end

    private

    def get_json path
        begin
          response = Net::HTTP.get(URI(path))
          job = JSON.parse(response)
        rescue => e
          ap e
        end
    end
  end
end