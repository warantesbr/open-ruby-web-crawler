#!/usr/bin/env ruby
require 'json'

module Crawl
  class Data
    def initialize data
      ap data
      @data = data
      @time = Time.now.getutc
    	@organization = data['site_name']
      @id = data['id']
      @type = data['type'] if !@type rescue nil
      @type = data['type'] if @type.nil?
      @path = "data/#{@organization}"
      @alternate_id = data['name'].tr("/", "-").tr(" ", "_") if @type
    end

    def file_handling path
      FileUtils.mkdir_p @path
      FileUtils.mkdir_p @path + "/Miscellaneous"
      FileUtils.mkdir_p @path + "/#{@type}" rescue nil
      @hash = JSON.parse(File.open(path, "rb").read) rescue {}
      @hash["#{Time.now.getutc}"] = @data
      File.open(path,"w").puts(@hash.to_json)
    end

    def save
      if !@type.nil?
        file_handling(@path + "/#{@type}/#{@id}.json")
        File.open(@path + "/#{@type}/.#{@alternate_id}.json","w").puts(@hash.to_json) 
      else
        file_handling(@path + "/Miscellaneous/#{@id}.json")
      end
    end
  end
end