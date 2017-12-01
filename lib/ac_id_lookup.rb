class AcIdLookup
  def initialize(client)
    @client = client
  end

  def by_email(email)
    map[email]
  end

  private

  def map
    @map ||= begin
      # TODO deal with pages (per page = 20)
      response = @client.contact_list(ids: "all", full: "0", page: 1)
      Hash[*response["results"].flat_map do |ac_contact|
        [ac_contact["email"], ac_contact["id"]]
      end].freeze
    end
  end
end
