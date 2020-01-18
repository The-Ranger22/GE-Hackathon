#This program pulls the JSON data from the endpoint, saving it as 'all.json', filters and flags for suspicious activity, and stores the new file as 'new.json'.
#Next addition: PostgreSQL database integration to manage JSON data.
#Version 1.0 - Randy "RJ" Clark

######This script requires the following command line programs:
##curl
##postgresql

require 'json'

#Pull JSON data from API.
`curl -o all.json https://s3rdf9bxgg.execute-api.us-east-2.amazonaws.com/deploy/all`

#Filter and flag data.

##Load the just-downloaded JSON file.
json = File.read('all.json')

##Parse the JSON file into a hash.
dataHash = JSON.parse json

##Add primary keys created by hashing subject lines and send dates.
##Scan through the hash for suspicious file extensions and email domains.
dataHash["data"].each do |key, value| 
        key["primKey"] = ((key["subject"]).crypt("$6$" + key["sendDate"]))
        ###Check for suspicious file types and flag accordingly.
        if (key["attachment"] =~ /\.(json|jar|js|jse|css|pptm|xlsm|docm|html|htm|exe|sh|msc|cpl|app|hta|com|msi|msp|bat|vb|vbs|vbe|ps1|ps1xml|ps2|ps2xml|psc1|psc2)$/)
            key["isPhishy"] = "true"
            key["badAttachment"] = "true"
        else
            key["isPhishy"] = "false"
            key["badAttachment"] = "false"
        end
        ###Check for suspicious email domains and flag accordingly.
        if (key["sender"] =~ /\.([0-9]+|info|biz|)$/)
            key["isPhishy"] = "true"
            key["badDomain"] = "true"
        else
            key["badDomain"] = "false"
        end
end  

##Convert Hash back into JSON.
newJson = dataHash.to_json()

##Write the new JSON file to the file system.
File.write("new.json", newJson)


#Pass JSON data to DB.

#Save JSON.