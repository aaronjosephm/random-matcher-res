require "nokogiri"
require "open-uri"

class ProfilesController < ApplicationController
  def index
    @profiles = Profile.all
  end

  def show
    @profile = Profile.find(params[:id])
  end

  def new
    @profile = Profile.new
  end

  def create
    @result = []
    @result_details = []
    @prep_times = []
    @difficulties = []
    @profiles = []

    age = params[:profile][:age]
    ethnicity = params[:profile][:ethnicity]
    height = params[:profile][:height]
    body_type = params[:profile][:body_type]
    interests = params[:profile][:interests]

    random_select()
    attributes = filter({age: age, ethnicity: ethnicity, height: height, body_type: body_type})

    puts

    @profile = Profile.new(attributes)
    if @profile.save
      redirect_to @profile
    else
      render :new
    end
    # profiles = random_select()
  end

  def delete
    Profile.destroy(params[:id])
    redirect_to profiles_path
  end

  def random_select(attributes = {})
    url = "https://www.pof.com"
    html_file = open(url).read
    doc = Nokogiri::HTML(html_file)
    # contains 4 profile links.
    build_links = []
    links = []
    doc.css('div.profile-card-right a').each { |link| links << link['href'] if link['href'][0] == "v" }
    build_links = links
    build_links.each do |link|
      url = "https://www.pof.com/" + link
      html_file = open(url).read
      doc = Nokogiri::HTML(html_file)
      puts "hey"
      doc.css('div.imagebarsingle a').each { |link| links << link['href'].strip if link['href'][0] == "v" }
      if links.length > 100
        break
      end
    end
    links.each do |link|
      url = "https://www.pof.com/" + link
      tmp_html_file = open(url).read
      tmp_doc = Nokogiri::HTML(tmp_html_file)
      attributes = {}
      attributes[:age] = tmp_doc.search('#age').text
      attributes[:ethnicity] = tmp_doc.search('#ethnicity').text
      attributes[:height] = tmp_doc.search('#height').text.split('"')[0]
      attributes[:body_type] = tmp_doc.search('#body').text
      attributes[:url] = url
      attributes[:picture] = tmp_doc.search('#mp').attr('src').value
      attributes[:name] = tmp_doc.search('#username').text
      attributes[:interests] = tmp_doc.search('#profile-interests-wrapper').text.split(" ")
      puts tmp_doc.search('#age').text
      @profiles << attributes
    end
    @profiles
  end

  def filter(attributes)
    @profiles.each do |profile|
      points = 0
      age_points = (attributes[:age].to_i - profile[:age].to_i).abs
      height_inches = (attributes[:height].split("' ")[0].to_i*12) + attributes[:height].split("' ")[1].to_i
      profile_height = (profile[:height].split("'")[0].to_i*12) + profile[:height].split("'")[1].to_i
      height_points = (height_inches - profile_height).abs
      points += age_points if attributes[:age] != profile[:age]
      points += 10 if attributes[:ethnicity] != profile[:ethnicity]
      points += 10 if attributes[:body_type] != profile[:body_type]
      points += height_points if attributes[:height] != profile[:height]
      profile[:points] = points
    end
    @profiles.sort_by! { |profile| profile[:points] }
    @profiles[0]
  end

  # private

  # def profile_params
  #   params.require(:profile).permit(:age, :body_type, :height, :ethnicity, :picture, :name, :interests, :url)
  # end
end
