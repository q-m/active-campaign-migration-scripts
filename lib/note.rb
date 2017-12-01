class Note
  def initialize(data)
    raise ArgumentError, "Not a valid note" unless data.size == 1
    @key, @data = data.keys.first, data.values.first
  end

  def type
    @key[/^(.*?)\s/, 1]
  end

  def email?
    type == "Email"
  end

  def author
    @author ||= find_obj("Author")
  end

  def written_at
    @written_at ||= Time.parse(find_obj("Written"))
  end

  def subject
    @subject ||= find_obj("Subject")
  end

  def body
    @body ||= find_obj("Body")
  end

  def inspect
    %(#<Note #{type}, author: "#{author}", written_at: #{written_at}>)
  end

  def to_s
    email? ? to_s_email : to_s_default
  end

  private

  def to_s_email
    <<~TXT
      Email by #{author} on #{written_at.strftime("%e %b %Y, %H:%M")}

      Subject: #{subject}

      #{body}
    TXT
  end

  def to_s_default
    <<~TXT
      #{type.to_s} by #{author} on #{written_at.strftime("%e %b %Y, %H:%M")}

      #{body}
    TXT
  end

  def find_obj(name)
    @data.find { |obj| obj.has_key?(name) }&.[](name)
  end
end
