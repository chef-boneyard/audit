## Supported Configurations

<table>
<tr>
  <th>Fetch Directly From Compliance</th>
  <td><b>Report Directly to Compliance</b>
<pre lang="ruby"><code>
['audit']['reporter'] = 'chef-compliance'
['audit']['server'] = 'https://compliance-server.test/api'
['audit']['refresh_token' OR 'token'] = '..'
['audit']['owner'] = 'User/Org'
</code></pre>
<p><b>Report Directly to Automate</b>
<pre lang="ruby"><code>
['audit']['reporter'] = 'chef-automate'
['audit']['server'] = 'https://compliance-server.test/api'
['audit']['refresh_token' OR 'token'] = '..'
['audit']['owner'] = 'User/Org'
&#35;
&#35; client.rb:
data_collector['server_url'] = 'https://automate-server.test/data-collector/v0/'
data_collector['token'] = '..'
</code></pre>
<p><b>Report to Compliance via Chef Server</b>
<pre lang="ruby"><code>
['audit']['reporter'] = 'chef-server-compliance'
['audit']['server'] = 'https://compliance-server.test/api'
['audit']['refresh_token' OR 'token'] = '..'
['audit']['owner'] = 'User/Org'
</code></pre>
<p><b>Report to Automate via Chef Server</b>
<pre lang="ruby"><code>
['audit']['reporter'] = 'chef-server-automate'
['audit']['server'] = 'https://compliance-server.test/api'
['audit']['refresh_token' OR 'token'] = '..'
['audit']['owner'] = 'User/Org'
&#35;
&#35; chef-server.rb:
data_collector['root_url'] = 'https://automate-server.test/data-collector/v0/'
</code></pre>
  </td>
</tr>
<tr>
  <th>Fetch From Compliance via Chef Server</th>
  <td><b>Report Directly to Compliance</b>
<pre lang="ruby"><code>
['audit']['reporter'] = 'chef-compliance'
['audit']['fetcher'] = 'chef-server'
['audit']['server'] = 'https://compliance-server.test/api'
['audit']['refresh_token' OR 'token'] = '..'
['audit']['owner'] = 'User/Org'
&#35;
&#35; NOTE: Must have Compliance Integrated w/ Chef Server
</code></pre>
<p><b>Report Directly to Automate</b>
<pre lang="ruby"><code>
['audit']['reporter'] = 'chef-automate'
['audit']['fetcher'] = 'chef-server'
['audit']['server'] = 'https://compliance-server.test/api'
['audit']['refresh_token' OR 'token'] = '..'
['audit']['owner'] = 'User/Org'
&#35;
&#35; client.rb:
data_collector['server_url'] = 'https://automate-server.test/data-collector/v0/'
data_collector['token'] = '..'
&#35;
&#35; NOTE: Must have Compliance Integrated w/ Chef Server
</code></pre>
<p><b>Report to Compliance via Chef Server</b>
<pre lang="ruby"><code>
['audit']['reporter'] = 'chef-server-compliance'
['audit']['fetcher'] = 'chef-server'
&#35;
&#35; NOTE: Must have Compliance Integrated w/ Chef Server
</code></pre>
<p><b>Report to Automate via Chef Server</b>
<pre lang="ruby"><code>
['audit']['reporter'] = 'chef-server-automate'
['audit']['fetcher'] = 'chef-server'
&#35;
&#35; chef-server.rb:
data_collector['root_url'] = 'https://automate-server.test/data-collector/v0/'
&#35;
&#35; NOTE: Must have Compliance Integrated w/ Chef Server
</code></pre>
  </td>
</tr>
<tr>
  <th>Fetch From Automate via Chef Server</th>
  <td><b>Report Directly to Compliance</b>
<pre lang="ruby"><code>
['audit']['reporter'] = 'chef-compliance'
['audit']['fetcher'] = 'chef-server'
['audit']['server'] = 'https://compliance-server.test/api'
['audit']['refresh_token' OR 'token'] = '..'
['audit']['owner'] = 'User/Org'
&#35;
&#35; chef-server.rb:
profiles['root_url'] = 'https://automate-server.test'
&#35;
&#35; delivery.rb:
compliance_profiles["enable"] = true
</code></pre>
<p><b>Report Directly to Automate</b>
<pre lang="ruby"><code>
['audit']['reporter'] = 'chef-automate'
['audit']['fetcher'] = 'chef-server'
&#35;
&#35; chef-server.rb:
profiles['root_url'] = 'https://automate-server.test'
&#35;
&#35; client.rb:
data_collector['server_url'] = 'https://automate-server.test/data-collector/v0/'
data_collector['token'] = '..'
&#35;
&#35; delivery.rb:
compliance_profiles["enable"] = true
</code></pre>
<p><b>Report to Compliance via Chef Server</b>
<pre lang="ruby"><code>
['audit']['reporter'] = 'chef-server-compliance'
['audit']['fetcher'] = 'chef-server'
&#35;
&#35; chef-server.rb:
profiles['root_url'] = 'https://automate-server.test'
&#35;
&#35; delivery.rb:
compliance_profiles["enable"] = true
&#35;
&#35; NOTE: Must have Compliance Integrated w/ Chef Server
</code></pre>
<p><b>Report to Automate via Chef Server</b>
<pre lang="ruby"><code>
['audit']['reporter'] = 'chef-server-automate'
['audit']['fetcher'] = 'chef-server'
&#35;
&#35; chef-server.rb:
data_collector['root_url'] = 'https://automate-server.test/data-collector/v0/'
profiles['root_url'] = 'https://automate-server.test'
&#35;
&#35; delivery.rb:
compliance_profiles["enable"] = true
</code></pre>
  </td>
</tr>
</table>
