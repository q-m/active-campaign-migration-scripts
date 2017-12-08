require 'json'

class AcIdLookup
  def initialize(client)
    @client = client
  end

  def by_highrise_id(id)
    map[id.to_s]
  end

  private

  def map
    @map ||= begin
      page, results = 1, []
      while (response = @client.contact_list(ids: "all", full: "1", page: page)) && response["result_code"] != 0
        response["results"].each do |ac_contact|
          highrise_id, active_campaign_id = read_highrise_id(ac_contact), ac_contact["id"]
          results += [highrise_id, active_campaign_id] if highrise_id
        end
        page += 1
      end

      Hash[*results].freeze
    end
  end

  def read_highrise_id(ac_contact)
    ac_contact["fields"].values.find { |fld| fld["title"] == "Highrise ID" }&.fetch("val")&.to_s
  end
end
