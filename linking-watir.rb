require 'rubygems'
require 'watir-webdriver'
require_relative './linking-watir-functions'
require_relative './secrets'

@email = EMAIL
@password = PASSWORD

@data = {
	"company_type" => {"code" => "C",
						"name" => "Public Company"}, 

	"description" => "PMP Marketing Group is a full service marketing / advertising agency with proven results in all areas of law firm marketing.\r\n\r\nThe offline media marketing experience that we provide, includes:\r\n\r\n- broadcast and cable TV marketing\r\n- national network TV marketing\r\n- radio marketing\r\n- outdoor advertising\r\n- transit marketing\r\n- Yellow Pages / print / direct mail marketing strategy\r\n- targeted Spanish language campaign analysis and marketing\r\n\r\nOur online media marketing experience includes:\r\n\r\n- in-house hosting\r\n- complete onsite optimization\r\n- custom content\r\n- in-house digital design team\r\n- live stream marketing\r\n- proven link building strategies\r\n- social media marketing\r\n- access to established Press Release marketing networks\r\n- local directory marketing\r\n\r\n.... just to name a few.\r\n\r\nOur overall marketing specialties include (but are not limited to):\r\n\r\nLocal & National Media Marketing\r\nVisual Media Marketing\r\nPrint Media Marketing\r\nDigital Marketing\r\nSearch Engine Marketing\r\nMobile Marketing\r\nLead Generation Assistance\r\nBrand Marketing\r\nRadio Marketing Services\r\nTelevision Marketing Strategies\r\nCity Level Marketing Solutions\r\nRegional Marketing\r\nState Level Marketing Campaigns\r\nNational Level Marketing Creative\r\nInternational Marketing Co-Ordination & Implementation\r\n\r\nWith over 75 years of combined, senior-level marketing expertise, PMP Marketing have the knowledge and resources to handle your legal marketing and advertising requirements.\r\n\r\nPMP Marketing - providing comprehensive boutique marketing services.",
	"email_domains" => 
						{"total" => 1,
						"all" => ["pmpmg.com"]},

	"employee_count_range" => 
								{"code" => "C",
								"name" => "11-50"},  

	"industries" => 
					{"total" => 1,  
					"all" => [{"code" => "80","name" => "Marketing & Advertising"}]},

	"locations" => 
					{"total" => 1,  
					"all" => 
						[{ "address" => 
									{   "city" => "West Palm Beach",
										"postal_code" => "33401",
										"street1" => "330 Clematis Street"},
						"contact_info" => 
									{"fax" => "",
									"phone1" => ""}
						}]
					},
	"logo_url" => "https://media.licdn.com/mpr/mpr/p/6/000/21e/016/114a33c.png",
	"num_followers" => 3230,
	 "specialties" => 
	 			{"total" => 8,
				  "all" => [ "Attorney Advertising", 
				  			"Law Firm Marketing Solutions",
				  			"Law Firm Marketing Advice",
				  			"Digital Marketing Services", 
				  			"Broadcast Media Marketing", 
				  			"Offline Marketing and Advertising",
				  			"Online Marketing and Advertising",
				  			"Legal Advertising Guidance"]
				 }, 
	"square_logo_url" => "https://media.licdn.com/mpr/mpr/p/5/000/21e/015/33a2a20.png",
	"status" => 
	  		{"code" => "OPR",
	  		"name" => "Operating"},
	"twitter_id" => "",
	"universal_name" => "pmp-marketing-group",
	"website_url" => "www.pmpmg.com"

	}

options = {  # fake company details while I didn't have a called version from the api
	'company' => "Sapital",
	'description' => "No. 1 for Finance in Latvia",
	'title' => "Broker",
	'location' => "Latvia",
	'imageurl' => 'https://media.licdn.com/mpr/mpr/p/3/000/27b/06f/165d89b.png',
	'imagetitle' => "Financial Services",
	'summary' => "A PROPOS DU GROUPE OPTION FINANCE\r\nAvec ses différentes publications, le Groupe Option Finance est le seul groupe de presse à destination de l’ensemble des professionnels de la finance et du droit des affaires, en entreprises, dans la finance d’entreprise (banques commerciales, banques d’affaires, affacturage, assurance), dans la gestion d’actifs (asset management) et le droit des affaires. \r\n\r\nSon titre amiral, l’hebdomadaire Option Finance, se présente comme un véritable trait d’union entre les entreprises et la communauté financière depuis plus de 20 ans. Dédié à la présentation et l’analyse des grandes évolutions de la finance, aux innovations et montages financiers, aux problématiques de gestion des entreprises ainsi qu’à l’actualité de la communauté financière et de la gestion d’actifs, Option Finance est la référence éditoriale de cet univers professionnel.\r\n\r\nABOUT OPTION FINANCE\r\nOption Finance is the leading business-to-business magazine in France focused on the information needs of senior finance executives. In addition to Option Finance magazine, the business includes a fast-growing portfolio such as the monthly magazine Funds, the professional newsletter \"Option Droit & Affaires\", and the supplement Family Finance as well as the specialized news agency AOF.\r\nIt is expanding online, in research and databases and in events while fully capitalizing on the potential of its print magazine."
}

@position = "HR Assistant"

# pic = 'http://www.smh.com.au/content/dam/images/3/7/9/g/4/image.related.articleLeadNarrow.300x0.378bq.png/1398647520000.jpg'
# download_pic 'gingerman',pic


###### TO DO ###### 

# Find a smarter way to get company details; better than doing API calls for 20 companies at a time




begin

########### API CALLS ###########

	# ∞∞∞∞∞ MAIN FUNCTION FOR COMPANY DATA - API HEAVY, NO LOGIN REQUIRED ∞∞∞∞∞
		# @company_data = get_list_of_companies ARGV[0] # enter search term eg 'equity' as you run the script
		# random_int = get_random_index(@company_data.length)
		# @company_details = clean_company_data @company_data[random_int] # get clean useable data from a random company in the list

	# ∞∞∞∞∞ END MAIN FUNCTION FOR COMPANY DATA ∞∞∞∞∞

	# ∞∞∞∞∞ TEMP FIX FOR CHECKING ∞∞∞∞∞
		# @company_details = clean_company_data @data 
	

########### END API CALLS ###########	

########### PROFILE LOGIN #############

	# ∞∞∞∞∞ LOGIN FIRST ∞∞∞∞∞	
		@browser = login @email,@password

########### PROFILE HACKING ############

	# ∞∞∞∞∞ GET A JOB TITLE ∞∞∞∞∞
		# @position = find_jobs @browser,ARGV[0]

	# ∞∞∞∞∞ ADD NEW JOB TO PROFILE ∞∞∞∞∞
		# add_position(@browser, @company_details, @position)

	# ∞∞∞∞∞ GET INSPIRATIONAL QUOTES ∞∞∞∞∞
		@random_quote = get_quotes ARGV[0]

	# ∞∞∞∞∞ ADD HEADLINE SUMMARY TEXT ∞∞∞∞∞
		add_summary @browser,@random_quote


	# ∞∞∞∞∞ CHANGE YOUR SUMMARY TEXT ∞∞∞∞∞
		#need to add something here

		# ∞∞∞∞∞ SHARE UPDATE ∞∞∞∞∞
		@random_quote = format_quote @random_quote
		# share_wisdom @random_quote ... check out access levels



	# ∞∞∞∞∞ ADD PICTURE / MEDIA ∞∞∞∞∞
		# add_pic_to_history @browser,options['imageurl'],options['imagetitle'],options['description']

	

########### END PROFILE HACKING #############

rescue 
	raise
	p "Houston, there's a problem"
	@browser.close
else
	p 'All done, closing browser'
		
end




@data_keys = ["company_type", "description", "email_domains", "employee_count_range", "industries", "locations", "logo_url", "num_followers", "specialties", "square_logo_url", "status", "twitter_id", "universal_name", "website_url"]

@data_values = [{"code"=>"C", "name"=>"Public Company"}, "PMP Marketing Group is a full service marketing / advertising agency with proven results in all areas of law firm marketing.\r\n\r\nThe offline media marketing experience that we provide, includes:\r\n\r\n- broadcast and cable TV marketing\r\n- national network TV marketing\r\n- radio marketing\r\n- outdoor advertising\r\n- transit marketing\r\n- Yellow Pages / print / direct mail marketing strategy\r\n- targeted Spanish language campaign analysis and marketing\r\n\r\nOur online media marketing experience includes:\r\n\r\n- in-house hosting\r\n- complete onsite optimization\r\n- custom content\r\n- in-house digital design team\r\n- live stream marketing\r\n- proven link building strategies\r\n- social media marketing\r\n- access to established Press Release marketing networks\r\n- local directory marketing\r\n\r\n.... just to name a few.\r\n\r\nOur overall marketing specialties include (but are not limited to):\r\n\r\nLocal & National Media Marketing\r\nVisual Media Marketing\r\nPrint Media Marketing\r\nDigital Marketing\r\nSearch Engine Marketing\r\nMobile Marketing\r\nLead Generation Assistance\r\nBrand Marketing\r\nRadio Marketing Services\r\nTelevision Marketing Strategies\r\nCity Level Marketing Solutions\r\nRegional Marketing\r\nState Level Marketing Campaigns\r\nNational Level Marketing Creative\r\nInternational Marketing Co-Ordination & Implementation\r\n\r\nWith over 75 years of combined, senior-level marketing expertise, PMP Marketing have the knowledge and resources to handle your legal marketing and advertising requirements.\r\n\r\nPMP Marketing - providing comprehensive boutique marketing services.", {"total"=>1, "all"=>["pmpmg.com"]}, {"code"=>"C", "name"=>"11-50"}, {"total"=>1, "all"=>[{"code"=>"80", "name"=>"Marketing & Advertising"}]}, {"total"=>1, "all"=>[{"address"=>{"city"=>"West Palm Beach", "postal_code"=>"33401", "street1"=>"330 Clematis Street"}, "contact_info"=>{"fax"=>"", "phone1"=>""}}]}, "https://media.licdn.com/mpr/mpr/p/6/000/21e/016/114a33c.png", 3230, {"total"=>8, "all"=>["Attorney Advertising", "Law Firm Marketing Solutions", "Law Firm Marketing Advice", "Digital Marketing Services", "Broadcast Media Marketing", "Offline Marketing and Advertising", "Online Marketing and Advertising", "Legal Advertising Guidance"]}, "https://media.licdn.com/mpr/mpr/p/5/000/21e/015/33a2a20.png", {"code"=>"OPR", "name"=>"Operating"}, "", "pmp-marketing-group", "www.pmpmg.com"]



