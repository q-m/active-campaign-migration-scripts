#!/usr/bin/env ruby -w
require_relative '../environment'
require 'csv'

# Available in source:
#   "Highrise ID",
#   "Company or Person",
#   "Name", "First name",
#   "Last name",
#   "Company",
#   "Title",
#   "Background",
#   "LinkedIn URL",
#   "Tags",
#   "Address - Work Street",
#   "Address - Work City",
#   "Address - Work State",
#   "Address - Work Zip",
#   "Address - Work Country",
#   "Address - Other Street",
#   "Address - Other City",
#   "Address - Other Zip",
#   "Address - Other Country",
#   "Company Address - Work Street",
#   "Company Address - Work City",
#   "Company Address - Work State",
#   "Company Address - Work Zip",
#   "Company Address - Work Country",
#   "Company Address - Other Street",
#   "Company Address - Other City",
#   "Company Address - Other Zip",
#   "Company Address - Other Country",
#   "Phone number - Work",
#   "Phone number - Mobile",
#   "Phone number - Fax",
#   "Phone number - Home",
#   "Phone number - Other",
#   "Email address - Work",
#   "Email address - Home",
#   "Email address - Other",
#   "Web address - Work",
#   "Twitter account - Personal",
#   "Company Phone number - Work",
#   "Company Phone number - Other",
#   "Company Email address - Work",
#   "Company Web address - Work",
#   "Company Twitter account - Personal",
#   "Created at",
#   "Last Updated",
#   "Subscribed",
#   "Added by",
#   "Referred By"

Address = Struct.new(:street, :city, :state, :zip, :country)

def extract_address(row)
  ["Address - Work", "Address - Other", "Company Address - Work", "Company Address - Other"].each do |prefix|
    if row["#{prefix} Street"] && row["#{prefix} Street"].strip != ""
      return Address.new(row["#{prefix} Street"], row["#{prefix} City"], row["#{prefix} State"], row["#{prefix} Zip"], row["#{prefix} Country"])
    end
  end
  Address.new
end

def generate_email(id)
  "bounce+#{id}@qmintelligence.com"
end

def extract_emails(row)
  primary_email, *work_emails = row["Email address - Work"].to_s.split(/\s*[,;]\s*/)
  home_emails = row["Email address - Home"].to_s.split(/\s*[,;]\s*/)
  other_emails = row["Email address - Other"].to_s.split(/\s*[,;]\s*/)

  if primary_email.to_s.strip == ""
    primary_email = home_emails.shift
  end

  if primary_email.to_s.strip == ""
    primary_email = other_emails.shift
  end

  if primary_email.to_s.strip == ""
    primary_email = generate_email(row.first[1])
  end

  [ primary_email, *(work_emails + home_emails + other_emails) ]
end

def prepare_column(s)
  # remove newlines, as ActiveCampaign has issues with it
  s.to_s.gsub(/[\r\n]/, '; ')
end

CSV.open(File.join(__dir__, "..", "data", "csv", "contacts.out.csv"), "w") do |out|
  out << [
    "Company or Person",
    "First name",
    "Last name",
    "Company",
    "Title",
    "Background",
    "LinkedIn URL",
    "Address - Street",
    "Address - City",
    "Address - State",
    "Address - Zip",
    "Address - Country",
    "Phone number - Work",
    "Phone number - Mobile",
    "Phone number - Other",
    "Email address - Primary",
    "Email address - Other(s)",
    "Web address - Work",
    "Twitter account",
    "Tags",
    "Created at",
    "Updated at",
    "Highrise ID"
  ]
  CSV.foreach(File.join(__dir__, "..", "data", "csv", "contacts.csv"), headers: true) do |row|
    address = extract_address(row)
    primary_email, *other_emails = extract_emails(row)

    out << [
      row["Company or Person"],
      row["First name"],
      row["Last name"],
      row["Company"],
      row["Title"],
      row["Background"],
      row["LinkedIn URL"],
      address.street,
      address.city,
      address.state,
      address.zip,
      address.country,
      row["Phone number - Work"],
      row["Phone number - Mobile"],
      row["Phone number - Other"],
      primary_email,
      other_emails.join(", "),
      row["Web address - Work"],
      row["Twitter account"],
      row["Tags"],
      row["Created at"],
      row["Last Updated"],
      row.first[1] # row["Highrise ID"] returns nil, maybe hidden characters in header name?
    ].map {|c| prepare_column(c) }
  end
end
