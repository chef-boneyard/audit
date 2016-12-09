
describe file '/etc/chef/client.rb' do
  it { should exist }
end

curl_elasticsearch = 'curl -X POST http://127.0.0.1:9200/insights-*/_search -d \'
{
  "query": {
    "filtered": {
      "filter": {
        "bool": {
          "must": [
            {
              "term": {
                "event_type": "inspec"
              }
            },
            {
              "term": {
                "event_action": "exec"
              }
            }
          ]
        }
      }
    }
  },
  "sort": {
    "@timestamp": {
      "order": "asc"
    }
  }
}\''

elastic_response = json({ command: curl_elasticsearch })

describe elastic_response do
  it { should_not be nil }
end

elastic_hits = elastic_response['hits','hits']

# one for the chef-server-visibility collector
# one for the chef-visibility collector
describe elastic_hits.length do
  it { should eq 2 }
end

# guard the elastic_hits array from index out of bounds exception
if elastic_hits.length == 2
  describe elastic_hits[0]['_source']['compliance_summary'] do
    its(['status']) { should eq 'failed' }
    its(['total']) { should be > 60 }
  end

  describe elastic_hits[0]['_source']['profiles'][0]['name'] do
    it { should eq 'ssh-hardening' }
  end

  describe elastic_hits[1]['_source']['profiles'][0]['name'] do
    it { should eq 'linux-patch-benchmark' }
  end
end
