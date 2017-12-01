require_relative 'note'

class Contact
  def initialize(data)
    @data = data
  end

  def email
    @email ||= (read_email || generate_email)
  end

  # Includes emails
  def notes
    @notes = read_notes.map { |data| Note.new(data) }.sort_by(&:written_at)
  end

  def inspect
    "#<Contact #{email}, notes: #{notes.size}>"
  end

  private

  def read_email
    if contact_ary = @data.find { |obj| obj.has_key?("Contact") }&.[]("Contact")
      contact_ary.find { |ar| ar[0] == "Email_addresses" }&.dig(1, 0)
    end
  end

  def generate_email
    "bounce+#{read_id}@qmintelligence.com"
  end

  def read_id
    @data.dig(0, "ID")
  end

  def read_notes
    @data.select { |obj| obj.keys.first =~ /^(Note|Comment|Email)/ }
  end
end
