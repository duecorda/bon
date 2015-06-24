if Rails.env.production?
  Elasticsearch::Model.client = Elasticsearch::Client.new(host: '10.130.142.236:9321')
end
