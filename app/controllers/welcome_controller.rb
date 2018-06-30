require 'open-uri'
require 'nokogiri'
require 'rubygems'
class WelcomeController < ApplicationController
  def index
    @news = News.all
    parse_posts
  end
  def contact_us
  end
  def parse_posts
    url = 'http://hot-rock.ru'
    html = open(url)
    doc = Nokogiri::HTML(html)
    @posts = []
    doc.css('.binner').each do |post|
      ttl = post.css('h2')
      ttl.children.each { |c| c.remove if c.name == 'span' }
      title = ttl.text.strip.to_s
      description = post.css('.smaincont').text
      img = post.css('.smaincont > div > a')
      img.children.each { |c| c.remove if c.name == 'img' }
      image = ""
      u = ""
      img.each do |n|
        image = n["href"]
      end
      url = post.css('.mlink > span.argmore > a')
      url.each do |el|
        u = el['href']
        puts u
      end
      if title.length > 0
      @posts.push(
        title: title,
        description: description,
        image: image,
        url: u)
      end
    end
    @posts.each do |post|
      if post[:title] != nil
        if @news.length == 0
          News.create({:title => post[:title],:description => post[:description],:image => post[:image], :url =>  post[:url]})
        end
        elsif 
          @news.each do |n|
            n.title != post[:title]
          end
        News.create({:title => post[:title],:description => post[:description],:image => post[:image], :url =>  post[:url]})
        end
      end
    end
end
