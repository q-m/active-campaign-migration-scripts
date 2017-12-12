#!/usr/bin/env ruby -w
require_relative '../environment'
require 'yaml'
require 'active_campaign'
require_relative '../lib/contact'
require_relative '../lib/ac_id_lookup'

client = ::ActiveCampaign::Client.new(api_endpoint: ENV["AC_API_URL"], api_key: ENV["AC_API_KEY"])
lookup = AcIdLookup.new(client)

# TODO for each txt file in /data folder
Dir["./data/yaml/*.txt"].each do |file|
  begin
    s = File.read(file)
    s.gsub!(/(Body: \|)6(\+\r\n      )\s*/, '\\1\\2\\3')
    test_contact_data = YAML.load(s)
    contact           = Contact.new(test_contact_data)

    if contact_ac_id = lookup.by_highrise_id(contact.id)
      if contact.notes.size > 0 # avoid doing this twice
        contact.notes.each do |note|
          client.contact_note_add(id: contact_ac_id, note: note.to_s)
          sleep(0.5) # if we're going too fast we might loose the order
        end
        print "[ok]   Imported #{contact.notes.size} notes and emails for contact with ActiveCampaign ID #{contact_ac_id}\n"
      else
        print "[ok]   Skipped ActiveCampaign ID #{contact_ac_id} because contact already has notes\n"
      end
    else
      print "[fail] Unable to find Active Campaign contact for Highrise ID #{contact.id}. Did you populate the Highrise ID field in ActiveCampaign?\n"
    end
  rescue Psych::SyntaxError => e
    print "[fail] Parse error in '#{file}': #{e}\n"
  end
end
