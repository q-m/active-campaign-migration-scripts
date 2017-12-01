#!/usr/bin/env ruby -w
require_relative '../environment'
require 'yaml'
require 'json'
require 'active_campaign'
require_relative '../lib/contact'
require_relative '../lib/ac_id_lookup'

client = ::ActiveCampaign::Client.new(api_endpoint: ENV["AC_API_URL"], api_key: ENV["AC_API_KEY"])
lookup = AcIdLookup.new(client)

# TODO for each txt file in /data folder
test_contact_file = File.join("#{__dir__}", "..", "data", "Test.txt")
test_contact_data = YAML.load_file(test_contact_file)
contact           = Contact.new(test_contact_data)
contact_ac_id     = lookup.by_email(contact.email)

contact.notes.each do |note|
  client.contact_note_add(id: contact_ac_id, note: note.to_s)
  sleep(0.5) # if we're going to0 fast we might loose the order
end
print "Imported #{contact.notes.size} notes and emails for #{contact.email}\n"
