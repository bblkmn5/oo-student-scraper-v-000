require 'open-uri'
require 'pry'

#roster of all student instances: div.student-card
#each student card: div.card-text-container
#student profile_link: a.href
#student location:
#student name:

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    index_page = Nokogiri::HTML(open(index_url))

    index_page.css("div.student-card").each do |student|
      scraped_students = {
        :name => student.css("div.card-text-container h4.student-name").text,
        :location => student.css("div.card-text-container p.student-location").text,
        :profile_url => student.css("a").attribute("href").value}
        students << scraped_students
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    scraped_students = {}
    html = Nokogiri::HTML(open(profile_url))

    socials = html.css("div.social-icon-container").children.css("a").collect {|a| a.attribute("href").value}

      socials.each do |link|
        if link.include?("twitter")
          profile[:twitter] = link
        elsif link.include?("linkedin")
          profile[:linkedin] = link
        elsif link.include?("github")
          profile[:github] = link
        else
          profile[:blog] = link
        end
      end

      profile[:profile_quote] = html.css("div.profile-quote").text if html.css("div.profile-quote").text

      profile[:bio] = html.css("div.bio-content.content-holder div.description-holder p").text if html.css("div.bio-content.content-holder div.description-holder p").text
       profile
  end

end
