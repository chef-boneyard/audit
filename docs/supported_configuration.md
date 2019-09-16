## Supported Configurations

<table>

<tr>
  <th>Report to Chef Automate via Chef Server</th>
  <td>

<b>when fetching profiles from Chef Automate via Chef Server</b>
<pre lang="ruby">
&#35; audit cookbook attributes:
['audit']['reporter'] = 'chef-server-automate'
['audit']['fetcher'] = 'chef-server'
['audit']['profiles']['linux-baseline'] = { 'compliance': 'linux-baseline', 'version': '2.2.2' }
&nbsp;
&#35; chef-server.rb (Chef Server configuration):
data_collector['root_url'] = 'https://automate-server.test/data-collector/v0/'
profiles['root_url'] = 'https://automate-server.test'
&nbsp;
&#35; delivery.rb (configuration only for Automate v1):
compliance_profiles["enable"] = true
</pre>

<b>when fetching URL and GIT profiles</b>
<pre lang="ruby">
&#35; audit cookbook attributes:
['audit']['reporter'] = 'chef-server-automate'
['audit']['fetcher'] = 'chef-automate'
['audit']['profiles']['linux-baseline'] = { 'url': 'https://github.com/dev-sec/linux-baseline/archive/2.0.1.tar.gz' }
['audit']['profiles']['ssl-benchmark'] = { 'git': 'https://github.com/dev-sec/ssl-benchmark.git' }
&nbsp;
&#35; chef-server.rb (Chef Server configuration):
data_collector['root_url'] = 'https://automate-server.test/data-collector/v0/'
profiles['root_url'] = 'https://automate-server.test'
&nbsp;
&#35; delivery.rb (configuration only for Automate v1):
compliance_profiles["enable"] = true
</pre>

  </td>
</tr>


<tr>
  <th>Report directly to Chef Automate</th>
  <td>

<b>when fetching profiles from Chef Automate</b>
<pre lang="ruby">
&#35; audit cookbook attributes:
['audit']['reporter'] = 'chef-automate'
['audit']['fetcher'] = 'chef-automate'
['audit']['profiles']['linux-baseline'] = { 'compliance': 'linux-baseline' }
&nbsp;
&#35; client.rb (Chef Client configuration):
data_collector['server_url'] = 'https://automate-server.test/data-collector/v0/'
data_collector['token'] = '...'
</pre>


<b>when fetching URL and GIT profiles</b>
<pre lang="ruby">
&#35; audit cookbook attributes:
['audit']['reporter'] = 'chef-automate'
['audit']['fetcher'] = 'chef-automate'
['audit']['profiles']['linux-baseline'] = { 'url': 'https://github.com/dev-sec/linux-baseline/archive/2.0.1.tar.gz' }
['audit']['profiles']['ssl-benchmark'] = { 'git': 'https://github.com/dev-sec/ssl-benchmark.git' }
&nbsp;
&#35; client.rb (Chef Client configuration):
data_collector['server_url'] = 'https://automate-server.test/data-collector/v0/'
data_collector['token'] = '...'
</pre>


<b>when fetching local path and Chef Supermarket profiles</b>
<pre lang="ruby">
&#35; audit cookbook attributes:
['audit']['reporter'] = 'chef-automate'
['audit']['fetcher'] = 'chef-automate'
['audit']['profiles']['web-iis'] = { 'path': 'E:/profiles/web-iis' }
['audit']['profiles']['ssh-baseline'] = { 'supermarket': 'dev-sec/ssh-baseline' }
&nbsp;
&#35; client.rb (Chef Client configuration):
data_collector['server_url'] = 'https://automate-server.test/data-collector/v0/'
data_collector['token'] = '...'
</pre>

  </td>
</tr>

</table>
