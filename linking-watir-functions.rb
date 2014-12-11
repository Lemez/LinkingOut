require 'rubygems'
require 'nokogiri'
require 'linkedin'
require 'json'
require 'open-uri'
require 'mechanize'
require 'watir-webdriver'
require "awesome_print"
require_relative './secrets'
# require "authentic_jobs"

@your_consumer_key = LINKEDINAPIKEY
@your_consumer_secret = SECRET_KEY
@access1 = ACCESS_CODE_1
@access2 = ACCESS_CODE_2

@jobs_api_key = AUTHENTIC_API_KEY

CLIENT = LinkedIn::Client.new(@your_consumer_key, @your_consumer_secret)

@api_fields = ["universal-name","email-domains","company-type","ticker","website-url","industries","status","logo-url","square-logo-url","blog-rss-url","twitter-id","employee-count-range","specialties","locations","description","stock-exchange","founded-year","end-year","num-followers"]

@quote_fields = ['age','alone','amazing','anger','anniversary','architecture','art','favorite','attitude','beauty','best','birthday','brainy','business','car','change','communication','computers','cool','courage','dad','dating','death','design','diet','dreams','education','environmental','equality','experience','failure','faith','family','famous','fear','finance','fitness','food','forgiveness','freedom','friendship','funny','future','gardening','god','good','government','graduation','great','happiness','health','history','home','hope','humor','imagination','inspirational','intelligence','jealousy','knowledge','leadership','learning','legal','life','love','marriage','medical','men','mom','money','morning','motivational','movies','music','nature','parenting','patience','patriotism','peace','pet','poetry','politics','positive','power','relationship','religion','respect','romantic','sad','science','smile','society','sports','strength','success','sympathy','teacher','technology','teen','thankful','time','travel','trust','truth','war','wedding','wisdom','women','work']





# @data_keys = ["company_type", "description", "email_domains", "employee_count_range", "address", industries", "locations", "logo_url", "num_followers", "specialties", "square_logo_url", "status", "twitter_id", "universal_name", "website_url"]

def enter_api
    client = CLIENT
    client.authorize_from_access(@access1,@access2)
end


def get_random_index number
    last_i = number-1
    return Random.new.rand(0..last_i)
end


def find_jobs browser,keyword

    # select Jobs from the dropdown
    button = browser.span :class => 'styled-dropdown-select-all' 
    button.click

    browser.ul(:class => 'search-selector').div(:text => 'Jobs').click

    @keyword = keyword
    search = browser.text_field :id => 'main-search-box'
    search.set @keyword

    browser.button(:class => 'search-button').click
    
    topjob = browser.li(:class => 'mod result idx0 job')
    topjob.wait_until_present
    btn = browser.link(:class => 'primary-action-button label')
    btn.click

    btn.wait_while_present

    @job_title = browser.div(:class => 'content').h1.text

    edit_profile browser
    return @job_title
    # p browser.div(:text =>/role/).text
end



def get_list_of_companies string
    enter_api
    client = CLIENT

    unless string 
    @string = ('a'..'z').to_a.shuffle[0,3].join
    else
    @string = string
    end

    response = client.search(options=@string, type='company')

    companies = []
    places = []

    response['companies']['all'].each do |c|
    company_data = client.company(:id => c.id, :fields=>@api_fields).to_hash
    companies << company_data
    end

    return companies 
end

def clean_company_data hash_of_data

    @clean_hash = {}

    hash_of_data.each_pair do |k,v|
        type = v.class.to_s 

        case type
        when "String" 
            @clean_hash[k] = v if v.length > 0

        when "Fixnum"
            @clean_hash[k] = v
            
        when "Hash" 
            
            @clean_hash[k] = v["name"] if v.has_key?("name")

            if v.has_key?("all")
                all = v['all']
                newclass = all.class.to_s
                length = all.length

                case length
                when 1
                    all = all[0]
                    p "#{k}, making a hash from an array: #{v['all']}, #{all}"
                    newclass = all.class.to_s
                end

                case newclass
                when "String"
                    @clean_hash[k] = all

                when "Array"
                    if all.length == 1
                        @clean_hash[k] = v["all"][0] 
                    else
                        @clean_hash[k] = v["all"]
                    end

                when "Hash"

                    if all.has_key?("name")
                       @clean_hash[k] = all["name"]
                    elsif all.has_key?("address")
                        @clean_hash["address"] = all["address"]
                    end
                    
                end
            end
        end
    end
    @clean_hash.each {|k,v| p "#{k}: #{v}"}
    p " Company data cleaned "
    return @clean_hash
end

def download_pic name,url
    agent = Mechanize.new
    agent.get(url).save "images/#{name}.jpg" 
end

def get_quotes string
   
    stem = 'http://www.brainyquote.com/quotes/topics/topic_'
    ending = '.html'
    string = 'yo' unless string

    if @quote_fields.include?(string)
        url = stem + string + ending 
    else 
        url = 'http://www.brainyquote.com/quotes/topics/topic_business.html'
    end

    doc = Nokogiri::HTML(open(url))

    quotes = doc.css(".bqQuoteLink") # get all quotes
    authors = doc.css(".bq-aut") # get their authors quotes

    i = Random.new.rand(quotes.length) # generate a random number

    p random_quote = [quotes[i].content,authors[i].content]

    return random_quote
end


def add_position(browser,company_details,position)

    @company = company_details['universal_name'].split("-").join(" ").upcase

    @title = position
    # if !company_details['specialties'].nil?
    #     length = company_details['specialties'].length
    #     case length
    #     when 1
    #         @title = company_details['specialties'].to_s
    #     when 0
    #         @title = position
    #     when 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20
    #         @title = company_details['specialties'][0].to_s
    #     end
    # elsif !company_details['industries'].nil?
    #     @title = position + "," + company_details['industries'].to_s
    # else
    #      @title = position
    # end

    if company_details['address'] 
         @location = company_details['address']["city"] 

    elsif company_details['locations']
        loc = company_details['locations'][0]

        if loc.class.to_s[0] == 'Hash'
          @location = loc[0]["address"]["city"]
        else
            @location = loc["address"]["city"]
        end 
    else
         @location = "New York"
    end


    @image_url = company_details['logo_url']
    @description = company_details['description']

    btn = browser.button :text => 'Add position' # one of two variants
    btn = browser.link :title => 'Click to add a new position' unless btn.exists?
    btn.click

    company = browser.text_field  :id => 'companyName-positionCompany-position-editPositionForm'
    company.wait_until_present
    company.set @company

    title = browser.text_field :id => 'title-position-editPositionForm'
    title.set @title

    location = browser.text_field :id => 'positionLocationName-position-editPositionForm'
    location.set @location

    1.times do
        next unless browser.li(:class => 'top item').exists? 
        browser.li(:class => 'top item').when_present.click 

    end
  

    @month = rand(12).to_s  # "1" or string of number between 1 and 12
    browser.select_list(:id, "month-startDate-position-editPositionForm").select_value(@month)

    @year = rand(2010..2013)
    year = browser.text_field :id => "year-startDate-position-editPositionForm"
    year.click
    year.set @year

    browser.checkbox(:value => 'isCurrent').set

    headline = browser.text_field :id => 'updatedHeadline-updatedHeadline-position-editPositionForm'
    headline.set "#{@title} \n #{@company}, #{@location}"

    description = browser.text_field :id => 'summary-position-editPositionForm'
    description.set @description


    browser.button(:name => 'submit').click
    p "Job saved"
end

def format_quote summary
    return '"' + summary[0] + '"' + "\r\n" + summary[1]
end

def add_summary browser,summary
    sum = browser.span(:text => 'Add a summary')
    sum = browser.button :title => 'Click to add a new summary' unless sum.exists?
    sum.click

    s = browser.textarea(:name => 'expertise_comments')
    
    @summary_formatted = format_quote summary
    s.set @summary_formatted

    browser.button(:name => 'submit').click
    p "Summary saved"
end

def share_wisdom wise_thing
    
    enter_api
    
    client = CLIENT
    client.add_share(:comment => wise_thing)
end

def add_pic_to_history browser,image_url, imagetitle, imagedesc
    @imageurl = image_url
    @title = imagetitle

    button = browser.link :class => 'media-add-promo evt-dispatch'
    button = browser.button :title => "Click to add a video, image, document, presentation..." unless button.exists?
    button.click

    upload = browser.text_field :value => 'http://'
    upload.set @imageurl
    browser.button(:class => 'continue-btn btn-primary').click

    #then it checks with JS
    title = browser.text_field :id => 'customTitle-TreasuryCreateForm'
    title.wait_until_present unless title.exists?
    title.set @title

    browser.button(:text => 'Add to profile').click
    p "History image saved"

end


def get_details
    enter_api
end


def get_a_job keyword
    client = AuthenticJobs.new(@jobs_api_key)
    jobs = client.search(:keywords => keyword).to_hash
    ap jobs
end

def test_browser(browser)
    p browser
end

def login (email, password)

    @email = email
    @password = password
    url = 'https://www.linkedin.com/uas/login'
    browser = Watir::Browser.new 
    browser.goto url
    p "Login URL is #{browser.url}"

    email = browser.text_field :id => 'session_key-login'
    email.set @email
    pass = browser.text_field :id => 'session_password-login'
    pass.set @password

    btn = browser.button :text => 'Sign In'
    btn.click
    btn.wait_while_present # wait until the url changes

    p "Signed-in URL is #{browser.url}"
    edit_profile browser
    return browser
end

def edit_profile browser
    url = 'https://www.linkedin.com/profile/edit?trk=nav_responsive_sub_nav_edit_profile'
    browser.goto url
    link = browser.link(:href, "/people/pymk?trk=nmp-pymk-new_pymk_title")
    link.wait_while_present
    p "Edit profile URL is #{browser.url}"
    return browser
end









def get_company
# string = 'a' + ('a'..'z').to_a.shuffle[0,1].join
# p string
# url = "http://www.linkedin.com/ta/federator?query=" + string + "&types=company"
# url_co = 'https://api.linkedin.com/v1/company-search:(companies:(id,name,universal-name,website-url,industries,status,logo-url,blog-rss-url,twitter-id,employee-count-range,specialties,locations,description,stock-exchange,founded-year,end-year,num-followers))?keywords=' + string + "&access_token=" + 
# profile = Selenium::WebDriver::Firefox::Profile.new
# profile['browser.privatebrowsing.dont_prompt_on_enter'] = true
# profile['browser.privatebrowsing.autostart'] = true
# browser = Watir::Browser.new :firefox, :profile => profile
# browser.goto url_co
# p browser.pre
# p url
# json = JSON.parse(response)
# p json['company']
# p json['company']['resultList'][0]
end

