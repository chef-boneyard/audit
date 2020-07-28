# Changelog

## [v9.5.0](https://github.com/chef-cookbooks/audit/tree/v9.5.0) (2020-07-28)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v9.4.0...v9.5.0)

**Closed issues:**

- Truncating large InSpec reports [\#422](https://github.com/chef-cookbooks/audit/issues/422)

**Merged pull requests:**

- Report even on inspec runtime exceptions [\#430](https://github.com/chef-cookbooks/audit/pull/430) ([alexpop](https://github.com/alexpop))
- Automated PR: Standardising Files [\#428](https://github.com/chef-cookbooks/audit/pull/428) ([xorimabot](https://github.com/xorimabot))

## [v9.4.0](https://github.com/chef-cookbooks/audit/tree/v9.4.0) (2020-05-20)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v9.3.0...v9.4.0)

**Merged pull requests:**

- Release version 9.4.0 [\#427](https://github.com/chef-cookbooks/audit/pull/427) ([alexpop](https://github.com/alexpop))
- Truncate control results to max 50 by default [\#426](https://github.com/chef-cookbooks/audit/pull/426) ([alexpop](https://github.com/alexpop))

## [v9.3.0](https://github.com/chef-cookbooks/audit/tree/v9.3.0) (2020-05-15)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v9.2.1...v9.3.0)

**Closed issues:**

- Audit cookbook is not upgrading in production mode [\#412](https://github.com/chef-cookbooks/audit/issues/412)
- Request: Update the Changelog [\#377](https://github.com/chef-cookbooks/audit/issues/377)

**Merged pull requests:**

- Release version 9.3.0 [\#425](https://github.com/chef-cookbooks/audit/pull/425) ([alexpop](https://github.com/alexpop))
- Add audit cookbook attributes support for the new InSpec options [\#424](https://github.com/chef-cookbooks/audit/pull/424) ([alexpop](https://github.com/alexpop))

## [v9.2.1](https://github.com/chef-cookbooks/audit/tree/v9.2.1) (2020-04-22)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v9.2.0...v9.2.1)

**Closed issues:**

- missing waiver file fails all reporting [\#413](https://github.com/chef-cookbooks/audit/issues/413)

**Merged pull requests:**

- Release version 7.2.1 [\#421](https://github.com/chef-cookbooks/audit/pull/421) ([alexpop](https://github.com/alexpop))
- Ignore missing waiver files [\#420](https://github.com/chef-cookbooks/audit/pull/420) ([alexpop](https://github.com/alexpop))

## [v9.2.0](https://github.com/chef-cookbooks/audit/tree/v9.2.0) (2020-04-21)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v9.1.0...v9.2.0)

**Closed issues:**

- Add Chef InSpec Waiver integration into Audit Cookbook [\#396](https://github.com/chef-cookbooks/audit/issues/396)

**Merged pull requests:**

- Release version 9.2.0 [\#419](https://github.com/chef-cookbooks/audit/pull/419) ([alexpop](https://github.com/alexpop))
- Support the Automate /compliance/profiles/metasearch endpoint to send reduced reports [\#418](https://github.com/chef-cookbooks/audit/pull/418) ([alexpop](https://github.com/alexpop))
- Update warnings on size limits, error on nil uuid [\#417](https://github.com/chef-cookbooks/audit/pull/417) ([btm](https://github.com/btm))
- Automated PR: Standardising Files [\#416](https://github.com/chef-cookbooks/audit/pull/416) ([xorimabot](https://github.com/xorimabot))
- Automated PR: Cookstyle Changes [\#415](https://github.com/chef-cookbooks/audit/pull/415) ([xorimabot](https://github.com/xorimabot))
- Error: The `Style/BracesAroundHashParameters` cop has been removed. [\#414](https://github.com/chef-cookbooks/audit/pull/414) ([Xorima](https://github.com/Xorima))
- Update changelog after release 9.1.0 [\#411](https://github.com/chef-cookbooks/audit/pull/411) ([alexpop](https://github.com/alexpop))

## [v9.1.0](https://github.com/chef-cookbooks/audit/tree/v9.1.0) (2020-03-03)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v9.0.1...v9.1.0)

**Implemented enhancements:**

- Implement waiver file support [\#397](https://github.com/chef-cookbooks/audit/issues/397)
- Add waiver-file support [\#398](https://github.com/chef-cookbooks/audit/pull/398) ([clintoncwolfe](https://github.com/clintoncwolfe))

**Fixed bugs:**

- Send Report returned: 429 "Too Many Requests" from Automate Server [\#384](https://github.com/chef-cookbooks/audit/issues/384)
- Audit 5.0.0 - NoMethodError: undefined method `path' for nil:NilClass when profile not found [\#301](https://github.com/chef-cookbooks/audit/issues/301)

**Closed issues:**

- Apply current cookstyle [\#407](https://github.com/chef-cookbooks/audit/issues/407)
- Use Net::HTTPClientException instead of Net::HTTPServerException [\#394](https://github.com/chef-cookbooks/audit/issues/394)
- Add Filter Button for Disconnected Services in the Applications View [\#392](https://github.com/chef-cookbooks/audit/issues/392)
- Deprecate current scheduling features [\#333](https://github.com/chef-cookbooks/audit/issues/333)

**Merged pull requests:**

- Bump version and change travis os [\#410](https://github.com/chef-cookbooks/audit/pull/410) ([alexpop](https://github.com/alexpop))
- Get most test kitchen tests passing in Travis [\#405](https://github.com/chef-cookbooks/audit/pull/405) ([clintoncwolfe](https://github.com/clintoncwolfe))
- Update deprecated Net::HTTPServerException with Net::HTTPClientException [\#395](https://github.com/chef-cookbooks/audit/pull/395) ([vsingh-msys](https://github.com/vsingh-msys))
- Detect 429 & 413 and append an additional message [\#393](https://github.com/chef-cookbooks/audit/pull/393) ([vsingh-msys](https://github.com/vsingh-msys))
- Bump cookbook to version 9.0.1 [\#389](https://github.com/chef-cookbooks/audit/pull/389) ([alexpop](https://github.com/alexpop))
- Update test deps and the kitchen dokken config [\#355](https://github.com/chef-cookbooks/audit/pull/355) ([tas50](https://github.com/tas50))

## [v9.0.1](https://github.com/chef-cookbooks/audit/tree/v9.0.1) (2019-09-19)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v9.0.0...v9.0.1)

**Fixed bugs:**

- New Hash of Hashs format for specifying profiles does not work [\#339](https://github.com/chef-cookbooks/audit/issues/339)

**Closed issues:**

- Remove `.push\(\)` examples from documentation [\#359](https://github.com/chef-cookbooks/audit/issues/359)

**Merged pull requests:**

- use Chef Server header auth in Chef Server fetcher [\#388](https://github.com/chef-cookbooks/audit/pull/388) ([stevendanna](https://github.com/stevendanna))
- Update changelog for v9 [\#387](https://github.com/chef-cookbooks/audit/pull/387) ([alexpop](https://github.com/alexpop))

## [v9.0.0](https://github.com/chef-cookbooks/audit/tree/v9.0.0) (2019-09-18)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v8.1.1...v9.0.0)

**Implemented enhancements:**

- Move compliance server handling to inspec core [\#242](https://github.com/chef-cookbooks/audit/issues/242)
- remove deprecations [\#228](https://github.com/chef-cookbooks/audit/issues/228)

**Fixed bugs:**

- Doc is wrong - https://github.com/chef-cookbooks/audit/blob/master/docs/supported\_configuration.md [\#241](https://github.com/chef-cookbooks/audit/issues/241)
- audit profile configuration not working [\#240](https://github.com/chef-cookbooks/audit/issues/240)
- Audit coobook via Chef Automate fails to inherit profiles \(\#\<TypeError: no implicit conversion of URI::HTTPS into String\>\) [\#222](https://github.com/chef-cookbooks/audit/issues/222)

**Closed issues:**

- inspec gem and dependencies [\#231](https://github.com/chef-cookbooks/audit/issues/231)

**Merged pull requests:**

- Remove deprecated examples using Array of Hashes [\#386](https://github.com/chef-cookbooks/audit/pull/386) ([alexpop](https://github.com/alexpop))
- Change profiles default to a Hash [\#385](https://github.com/chef-cookbooks/audit/pull/385) ([lamont-granquist](https://github.com/lamont-granquist))

## [v8.1.1](https://github.com/chef-cookbooks/audit/tree/v8.1.1) (2019-07-25)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v8.0.0...v8.1.1)

**Implemented enhancements:**

- Implement an 'audit' reporter that will terminate Chef Client runs on profile failures [\#380](https://github.com/chef-cookbooks/audit/pull/380) ([sbabcoc](https://github.com/sbabcoc))

**Merged pull requests:**

- Remove compliance and visibility reporters [\#383](https://github.com/chef-cookbooks/audit/pull/383) ([alexpop](https://github.com/alexpop))
- Update changelog after release 8.1.1 [\#382](https://github.com/chef-cookbooks/audit/pull/382) ([alexpop](https://github.com/alexpop))
- Add and check for custom exception to propagate audit failures [\#381](https://github.com/chef-cookbooks/audit/pull/381) ([sbabcoc](https://github.com/sbabcoc))

## [v8.0.0](https://github.com/chef-cookbooks/audit/tree/v8.0.0) (2019-07-03)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v7.8.0...v8.0.0)

**Fixed bugs:**

- Ignore inspec\_version for chef client \>= 15 [\#378](https://github.com/chef-cookbooks/audit/pull/378) ([alexpop](https://github.com/alexpop))

**Closed issues:**

- Readme still indicates chef-client 12.5.1 as lowest client version supported [\#338](https://github.com/chef-cookbooks/audit/issues/338)

**Merged pull requests:**

- Update changelog after 8.0.0 release [\#379](https://github.com/chef-cookbooks/audit/pull/379) ([alexpop](https://github.com/alexpop))

## [v7.8.0](https://github.com/chef-cookbooks/audit/tree/v7.8.0) (2019-06-21)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v7.7.0...v7.8.0)

**Implemented enhancements:**

- way to ensure that the cookbook runs as last cookbook [\#13](https://github.com/chef-cookbooks/audit/issues/13)

**Fixed bugs:**

- AuditReport rasied RunTime Error `supports\_profile` [\#185](https://github.com/chef-cookbooks/audit/issues/185)

**Closed issues:**

- Request: Ability to delete old nodes from Compliance or Automate without having to use API calls [\#306](https://github.com/chef-cookbooks/audit/issues/306)
- Eliminate the need for `.inspec/compliance/config.json` for Chef Compliance reporter [\#125](https://github.com/chef-cookbooks/audit/issues/125)

**Merged pull requests:**

- bump chef infra client requirement to 12.20 to match metadata. Obviou… [\#376](https://github.com/chef-cookbooks/audit/pull/376) ([sarahbakal](https://github.com/sarahbakal))
- Restore style, unit and chefspec testing [\#375](https://github.com/chef-cookbooks/audit/pull/375) ([alexpop](https://github.com/alexpop))
- Provide option to avoid saving the inspec attributes to the node object [\#374](https://github.com/chef-cookbooks/audit/pull/374) ([alexpop](https://github.com/alexpop))
- Add additional audit cookbook matrix conditions around chef-client 15.x [\#373](https://github.com/chef-cookbooks/audit/pull/373) ([sean-horn](https://github.com/sean-horn))

## [v7.7.0](https://github.com/chef-cookbooks/audit/tree/v7.7.0) (2019-05-31)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v7.6.0...v7.7.0)

**Closed issues:**

- Cookbook broken with Chef-15 [\#368](https://github.com/chef-cookbooks/audit/issues/368)

**Merged pull requests:**

- Release cookbook version 7.7.0 [\#372](https://github.com/chef-cookbooks/audit/pull/372) ([alexpop](https://github.com/alexpop))
- Make entity\_uuid work for Chef Infra 15 [\#371](https://github.com/chef-cookbooks/audit/pull/371) ([alexpop](https://github.com/alexpop))
- Update to kitchen-dokken ~\> 2.7.0 [\#370](https://github.com/chef-cookbooks/audit/pull/370) ([teknofire](https://github.com/teknofire))

## [v7.6.0](https://github.com/chef-cookbooks/audit/tree/v7.6.0) (2019-05-17)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v7.5.0...v7.6.0)

**Implemented enhancements:**

- audit cookbook usage in wrapper cookbook [\#82](https://github.com/chef-cookbooks/audit/issues/82)

**Closed issues:**

- This is just a simple PR that came up during a review. [\#365](https://github.com/chef-cookbooks/audit/issues/365)
- Report handler Chef::Handler::AuditReport raised NoMethodError: undefined method 'path' for \<String\> when profile not found [\#348](https://github.com/chef-cookbooks/audit/issues/348)

**Merged pull requests:**

- Release audit version 7.6.0 [\#369](https://github.com/chef-cookbooks/audit/pull/369) ([alexpop](https://github.com/alexpop))
- Prevent downgrading to Chef-InSpec \< 4 when using Chef 15 [\#367](https://github.com/chef-cookbooks/audit/pull/367) ([teknofire](https://github.com/teknofire))

## [v7.5.0](https://github.com/chef-cookbooks/audit/tree/v7.5.0) (2019-04-23)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v7.4.1...v7.5.0)

**Merged pull requests:**

- Export extra fields needed for rbac project tagging [\#363](https://github.com/chef-cookbooks/audit/pull/363) ([alexpop](https://github.com/alexpop))

## [v7.4.1](https://github.com/chef-cookbooks/audit/tree/v7.4.1) (2019-03-20)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v7.4.0...v7.4.1)

**Fixed bugs:**

- chef-client audit-mode exception when the audit cookbook is used [\#34](https://github.com/chef-cookbooks/audit/issues/34)

**Merged pull requests:**

- Prevent failures when running on Chef 15 [\#362](https://github.com/chef-cookbooks/audit/pull/362) ([tas50](https://github.com/tas50))
- Fixing broken link to data collection docs [\#356](https://github.com/chef-cookbooks/audit/pull/356) ([moutons](https://github.com/moutons))

## [v7.4.0](https://github.com/chef-cookbooks/audit/tree/v7.4.0) (2019-02-05)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v7.3.0...v7.4.0)

**Closed issues:**

- Specify compile\_time field on inspec install [\#342](https://github.com/chef-cookbooks/audit/issues/342)

**Merged pull requests:**

- Use standard cookstyle [\#354](https://github.com/chef-cookbooks/audit/pull/354) ([tas50](https://github.com/tas50))
- Minor updates to kitchen, chefignore, and codeowners files [\#353](https://github.com/chef-cookbooks/audit/pull/353) ([tas50](https://github.com/tas50))
- Fixes for undefined method 'path' for \<String\> when profile not found… [\#349](https://github.com/chef-cookbooks/audit/pull/349) ([vsingh-msys](https://github.com/vsingh-msys))
- Update the automate support matrix [\#345](https://github.com/chef-cookbooks/audit/pull/345) ([teknofire](https://github.com/teknofire))
- Add compile\_time flag to inspec install. [\#344](https://github.com/chef-cookbooks/audit/pull/344) ([jquick](https://github.com/jquick))
- Remove Ruby 2.2 support [\#341](https://github.com/chef-cookbooks/audit/pull/341) ([btm](https://github.com/btm))
- Fix errant dash instead of underscore in example of InSpec version  [\#340](https://github.com/chef-cookbooks/audit/pull/340) ([gsreynolds](https://github.com/gsreynolds))

## [v7.3.0](https://github.com/chef-cookbooks/audit/tree/v7.3.0) (2018-09-19)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v7.2.0...v7.3.0)

**Implemented enhancements:**

- Add ability to configure json-file output location [\#286](https://github.com/chef-cookbooks/audit/issues/286)

**Merged pull requests:**

- Bump version to 7.3.0 and update CHANGELOG [\#337](https://github.com/chef-cookbooks/audit/pull/337) ([alexpop](https://github.com/alexpop))
- Allow json-file output location to be configured [\#327](https://github.com/chef-cookbooks/audit/pull/327) ([nvwls](https://github.com/nvwls))

## [v7.2.0](https://github.com/chef-cookbooks/audit/tree/v7.2.0) (2018-09-18)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v7.1.0...v7.2.0)

**Merged pull requests:**

- Switch format to reporter [\#336](https://github.com/chef-cookbooks/audit/pull/336) ([alexpop](https://github.com/alexpop))
- add 7.1.0 release changelog [\#335](https://github.com/chef-cookbooks/audit/pull/335) ([alexpop](https://github.com/alexpop))

## [v7.1.0](https://github.com/chef-cookbooks/audit/tree/v7.1.0) (2018-08-20)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v7.0.1...v7.1.0)

**Closed issues:**

- Audit cookbook removes inspec\_core on new install [\#329](https://github.com/chef-cookbooks/audit/issues/329)

**Merged pull requests:**

- Switch to the new json-automate reporter when inspec version allows it [\#334](https://github.com/chef-cookbooks/audit/pull/334) ([alexpop](https://github.com/alexpop))
- Add support for node\['audit'\]\['profiles'\] as a hash of hashes  [\#328](https://github.com/chef-cookbooks/audit/pull/328) ([mattray](https://github.com/mattray))
- Modify examples to not override hash [\#323](https://github.com/chef-cookbooks/audit/pull/323) ([jerryaldrichiii](https://github.com/jerryaldrichiii))

## [v7.0.1](https://github.com/chef-cookbooks/audit/tree/v7.0.1) (2018-07-17)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v7.0.0...v7.0.1)

**Implemented enhancements:**

- Add support for compliance profiles into chef-zero [\#188](https://github.com/chef-cookbooks/audit/issues/188)

**Closed issues:**

- NoMethodError: undefined method `inspec\_gem' for cookbook: audit, recipe: inspec :Chef::Recipe [\#320](https://github.com/chef-cookbooks/audit/issues/320)

**Merged pull requests:**

- Release audit 7.0.1 [\#324](https://github.com/chef-cookbooks/audit/pull/324) ([jquick](https://github.com/jquick))
- \[MSYS-829\] Fix nil class error when profile not found on automate server [\#321](https://github.com/chef-cookbooks/audit/pull/321) ([NAshwini](https://github.com/NAshwini))

## [v7.0.0](https://github.com/chef-cookbooks/audit/tree/v7.0.0) (2018-05-11)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v6.1.0...v7.0.0)

**Merged pull requests:**

- Bump audit major version [\#319](https://github.com/chef-cookbooks/audit/pull/319) ([jquick](https://github.com/jquick))
- Update audit cookbook to use inspec-core. [\#318](https://github.com/chef-cookbooks/audit/pull/318) ([jquick](https://github.com/jquick))
- compat\_resource is no longer supported [\#316](https://github.com/chef-cookbooks/audit/pull/316) ([lamont-granquist](https://github.com/lamont-granquist))

## [v6.1.0](https://github.com/chef-cookbooks/audit/tree/v6.1.0) (2018-04-19)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v6.0.2...v6.1.0)

**Closed issues:**

- Support ChefClient 14 [\#312](https://github.com/chef-cookbooks/audit/issues/312)

**Merged pull requests:**

- Bump audit to 6.1.0. [\#315](https://github.com/chef-cookbooks/audit/pull/315) ([jquick](https://github.com/jquick))

## [v6.0.2](https://github.com/chef-cookbooks/audit/tree/v6.0.2) (2018-04-18)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v6.0.1...v6.0.2)

**Closed issues:**

- Failing to add nodes: Error:Response from server was : status code 403 [\#307](https://github.com/chef-cookbooks/audit/issues/307)
- Changelog updates [\#302](https://github.com/chef-cookbooks/audit/issues/302)
- Chef inspec giving error during client run [\#300](https://github.com/chef-cookbooks/audit/issues/300)

**Merged pull requests:**

- Bump Audit cookbook to 6.0.2 [\#314](https://github.com/chef-cookbooks/audit/pull/314) ([jquick](https://github.com/jquick))
- Update Audit cookbook to support ChefClient 14 [\#313](https://github.com/chef-cookbooks/audit/pull/313) ([jquick](https://github.com/jquick))
- pin to chef 13 [\#311](https://github.com/chef-cookbooks/audit/pull/311) ([chris-rock](https://github.com/chris-rock))
- AIX support notes [\#309](https://github.com/chef-cookbooks/audit/pull/309) ([jeremymv2](https://github.com/jeremymv2))
- Add optional version parameter when using Compliance store [\#308](https://github.com/chef-cookbooks/audit/pull/308) ([kevinreedy](https://github.com/kevinreedy))
- Fix bundler on Travis [\#305](https://github.com/chef-cookbooks/audit/pull/305) ([adamleff](https://github.com/adamleff))
- Update the readme regarding audit mode [\#304](https://github.com/chef-cookbooks/audit/pull/304) ([btm](https://github.com/btm))
- Update changelog [\#303](https://github.com/chef-cookbooks/audit/pull/303) ([adamleff](https://github.com/adamleff))

## [v6.0.1](https://github.com/chef-cookbooks/audit/tree/v6.0.1) (2017-12-21)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v6.0.0...v6.0.1)

**Closed issues:**

- Activate inspec cache by default to boost Windows execution [\#296](https://github.com/chef-cookbooks/audit/issues/296)

**Merged pull requests:**

- Update reporters to log report size. Update readme [\#299](https://github.com/chef-cookbooks/audit/pull/299) ([alexpop](https://github.com/alexpop))
- README update for inspec\_backend\_cache feature [\#298](https://github.com/chef-cookbooks/audit/pull/298) ([adamleff](https://github.com/adamleff))

## [v6.0.0](https://github.com/chef-cookbooks/audit/tree/v6.0.0) (2017-12-06)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v5.0.4...v6.0.0)

**Closed issues:**

- Audit doesn't run when CCR fails [\#289](https://github.com/chef-cookbooks/audit/issues/289)

**Merged pull requests:**

- Enable Inspec caching [\#297](https://github.com/chef-cookbooks/audit/pull/297) ([jquick](https://github.com/jquick))
- Include handler in exception handlers as well as report handlers [\#290](https://github.com/chef-cookbooks/audit/pull/290) ([drrk](https://github.com/drrk))
- Release v5.0.3 [\#288](https://github.com/chef-cookbooks/audit/pull/288) ([arlimus](https://github.com/arlimus))

## [v5.0.4](https://github.com/chef-cookbooks/audit/tree/v5.0.4) (2017-11-22)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v5.0.3...v5.0.4)

**Closed issues:**

- attributes not being pulled into control [\#293](https://github.com/chef-cookbooks/audit/issues/293)
-  ERROR: Audit report was not generated properly, skipped reporting [\#291](https://github.com/chef-cookbooks/audit/issues/291)

**Merged pull requests:**

- 5.0.4 [\#295](https://github.com/chef-cookbooks/audit/pull/295) ([alexpop](https://github.com/alexpop))
- Add CODEOWNERS for audit cookbook [\#294](https://github.com/chef-cookbooks/audit/pull/294) ([adamleff](https://github.com/adamleff))
- Send end\_time as utc RFC3339 [\#292](https://github.com/chef-cookbooks/audit/pull/292) ([alexpop](https://github.com/alexpop))

## [v5.0.3](https://github.com/chef-cookbooks/audit/tree/v5.0.3) (2017-10-02)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v5.0.2...v5.0.3)

**Merged pull requests:**

- Enrich report with roles and recipes [\#287](https://github.com/chef-cookbooks/audit/pull/287) ([alexpop](https://github.com/alexpop))

## [v5.0.2](https://github.com/chef-cookbooks/audit/tree/v5.0.2) (2017-09-27)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v5.0.1...v5.0.2)

**Fixed bugs:**

- Default chef attributes value may lead to accessing nil. [\#282](https://github.com/chef-cookbooks/audit/issues/282)

**Merged pull requests:**

- Release v5.0.2 [\#285](https://github.com/chef-cookbooks/audit/pull/285) ([adamleff](https://github.com/adamleff))
- simplify profile url code [\#284](https://github.com/chef-cookbooks/audit/pull/284) ([arlimus](https://github.com/arlimus))
- Handle '@' in username when grabbing compliance profiles [\#280](https://github.com/chef-cookbooks/audit/pull/280) ([kevinreedy](https://github.com/kevinreedy))

## [v5.0.1](https://github.com/chef-cookbooks/audit/tree/v5.0.1) (2017-09-20)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v5.0.0...v5.0.1)

**Closed issues:**

- Warning for format [\#277](https://github.com/chef-cookbooks/audit/issues/277)
- UndefinedConversionError: "\xEF" from ASCII-8BIT to UTF-8 [\#276](https://github.com/chef-cookbooks/audit/issues/276)

**Merged pull requests:**

- let inspec set the default attribute for chef node attributes [\#283](https://github.com/chef-cookbooks/audit/pull/283) ([arlimus](https://github.com/arlimus))
- Release v5.0.1 [\#281](https://github.com/chef-cookbooks/audit/pull/281) ([adamleff](https://github.com/adamleff))
- Fix Chef deprecation warnings in inspec\_gem resource [\#279](https://github.com/chef-cookbooks/audit/pull/279) ([adamleff](https://github.com/adamleff))

## [v5.0.0](https://github.com/chef-cookbooks/audit/tree/v5.0.0) (2017-08-30)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v4.3.0...v5.0.0)

**Merged pull requests:**

- Release v5.0.0 [\#275](https://github.com/chef-cookbooks/audit/pull/275) ([adamleff](https://github.com/adamleff))
- Make chef\_node attribute an opt-in feature [\#274](https://github.com/chef-cookbooks/audit/pull/274) ([adamleff](https://github.com/adamleff))
- Add additional words to README re: using Chef node data [\#273](https://github.com/chef-cookbooks/audit/pull/273) ([adamleff](https://github.com/adamleff))

## [v4.3.0](https://github.com/chef-cookbooks/audit/tree/v4.3.0) (2017-08-29)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v4.2.0...v4.3.0)

**Implemented enhancements:**

- Feature enhancement request: Audit cookbook 4.2 to pass node data to Inspec  [\#268](https://github.com/chef-cookbooks/audit/issues/268)

**Closed issues:**

- Document location of json reports when reporter is `json-file` [\#269](https://github.com/chef-cookbooks/audit/issues/269)

**Merged pull requests:**

- The "Format is" log message should debug level [\#278](https://github.com/chef-cookbooks/audit/pull/278) ([xblitz](https://github.com/xblitz))
- Release v4.3.0 [\#272](https://github.com/chef-cookbooks/audit/pull/272) ([adamleff](https://github.com/adamleff))
- Pass Chef node to InSpec as an attribute [\#271](https://github.com/chef-cookbooks/audit/pull/271) ([adamleff](https://github.com/adamleff))
- Add json-file location to README [\#270](https://github.com/chef-cookbooks/audit/pull/270) ([adamleff](https://github.com/adamleff))

## [v4.2.0](https://github.com/chef-cookbooks/audit/tree/v4.2.0) (2017-08-10)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v4.1.1...v4.2.0)

**Closed issues:**

- Support inspec attributes [\#261](https://github.com/chef-cookbooks/audit/issues/261)

**Merged pull requests:**

- Release v4.2.0 [\#267](https://github.com/chef-cookbooks/audit/pull/267) ([adamleff](https://github.com/adamleff))
- Add test for InSpec Attributes functionality [\#266](https://github.com/chef-cookbooks/audit/pull/266) ([adamleff](https://github.com/adamleff))
- Disable default source when using user-supplied gem source [\#265](https://github.com/chef-cookbooks/audit/pull/265) ([adamleff](https://github.com/adamleff))
- Support for attributes within audit cookbook [\#262](https://github.com/chef-cookbooks/audit/pull/262) ([mhedgpeth](https://github.com/mhedgpeth))

## [v4.1.1](https://github.com/chef-cookbooks/audit/tree/v4.1.1) (2017-07-18)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v4.1.0...v4.1.1)

**Closed issues:**

- Unexpected Error when using chef-automate fetcher [\#258](https://github.com/chef-cookbooks/audit/issues/258)
- Declare audit profile in recipes [\#257](https://github.com/chef-cookbooks/audit/issues/257)

**Merged pull requests:**

- Release 4.1.1 [\#263](https://github.com/chef-cookbooks/audit/pull/263) ([alexpop](https://github.com/alexpop))
- Fix inspec hosted profile diagram for Chef Supermarket [\#260](https://github.com/chef-cookbooks/audit/pull/260) ([alexpop](https://github.com/alexpop))
- Non-null header value required for using chef-automate fetcher \(\#258\) [\#259](https://github.com/chef-cookbooks/audit/pull/259) ([ChefRycar](https://github.com/ChefRycar))

## [v4.1.0](https://github.com/chef-cookbooks/audit/tree/v4.1.0) (2017-07-05)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v4.0.0...v4.1.0)

**Implemented enhancements:**

- Raise exception if no token is set when using the chef-automate fetcher [\#249](https://github.com/chef-cookbooks/audit/pull/249) ([adamleff](https://github.com/adamleff))
- Fail Chef run if Audit Mode is enabled [\#238](https://github.com/chef-cookbooks/audit/pull/238) ([adamleff](https://github.com/adamleff))

**Fixed bugs:**

- support profile inheritance for Chef Compliance in audit cookbook 4 [\#256](https://github.com/chef-cookbooks/audit/pull/256) ([chris-rock](https://github.com/chris-rock))
- fix Reporter::ChefServer does not exist [\#253](https://github.com/chef-cookbooks/audit/pull/253) ([chris-rock](https://github.com/chris-rock))
- fix InSpec 1.27.0 Compliance::API use [\#251](https://github.com/chef-cookbooks/audit/pull/251) ([chris-rock](https://github.com/chris-rock))
- Make json-file reporter save JSON content [\#246](https://github.com/chef-cookbooks/audit/pull/246) ([jeremiahsnapp](https://github.com/jeremiahsnapp))
- fix chef compliance profile handling [\#243](https://github.com/chef-cookbooks/audit/pull/243) ([chris-rock](https://github.com/chris-rock))

**Closed issues:**

- Ensure support for InSpec 1.25.1+ [\#252](https://github.com/chef-cookbooks/audit/issues/252)
- json-file reporter saves ruby hash instead of JSON [\#244](https://github.com/chef-cookbooks/audit/issues/244)
- reporter: chef-server-compliance generates error: NameError: uninitialized constant Reporter::ChefServer [\#234](https://github.com/chef-cookbooks/audit/issues/234)
- reporter: chef-compliance fails with error "ArgumentError: wrong number of arguments \(given 2, expected 1\)\>" [\#232](https://github.com/chef-cookbooks/audit/issues/232)

**Merged pull requests:**

- remove unused test [\#255](https://github.com/chef-cookbooks/audit/pull/255) ([chris-rock](https://github.com/chris-rock))
- update travis configuration [\#254](https://github.com/chef-cookbooks/audit/pull/254) ([chris-rock](https://github.com/chris-rock))
- Add link to supported configs in README [\#250](https://github.com/chef-cookbooks/audit/pull/250) ([adamleff](https://github.com/adamleff))
- ensure json file outputs a json file [\#247](https://github.com/chef-cookbooks/audit/pull/247) ([chris-rock](https://github.com/chris-rock))
- Ensure min version of inspec is used [\#237](https://github.com/chef-cookbooks/audit/pull/237) ([alexpop](https://github.com/alexpop))

## [v4.0.0](https://github.com/chef-cookbooks/audit/tree/v4.0.0) (2017-05-22)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v3.1.0...v4.0.0)

**Closed issues:**

- Implement Chef-solo Chef Automate fetcher [\#226](https://github.com/chef-cookbooks/audit/issues/226)

**Merged pull requests:**

- update readme [\#229](https://github.com/chef-cookbooks/audit/pull/229) ([chris-rock](https://github.com/chris-rock))
- add automate fetcher for chef solo [\#227](https://github.com/chef-cookbooks/audit/pull/227) ([chris-rock](https://github.com/chris-rock))
- Remove typed\_attributes and leave the backend handle attributes [\#225](https://github.com/chef-cookbooks/audit/pull/225) ([alexpop](https://github.com/alexpop))
- Reduce report enrichment, bump cookbook to version 4.0.0 [\#224](https://github.com/chef-cookbooks/audit/pull/224) ([alexpop](https://github.com/alexpop))
- readme updates [\#223](https://github.com/chef-cookbooks/audit/pull/223) ([jeremymv2](https://github.com/jeremymv2))

## [v3.1.0](https://github.com/chef-cookbooks/audit/tree/v3.1.0) (2017-05-04)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v3.0.0...v3.1.0)

**Implemented enhancements:**

- JSON output contains "You have X number of issues or packages out of date" [\#207](https://github.com/chef-cookbooks/audit/issues/207)
- ability to install inspec as a package [\#164](https://github.com/chef-cookbooks/audit/issues/164)
- Warning from wrong attribute syntax [\#161](https://github.com/chef-cookbooks/audit/issues/161)
- Cannot report meta-profiles to Chef Compliance [\#155](https://github.com/chef-cookbooks/audit/issues/155)
- Vendor InSpec gem [\#112](https://github.com/chef-cookbooks/audit/issues/112)
- Provide gem\_source attribute for fetching any required gems [\#26](https://github.com/chef-cookbooks/audit/issues/26)

**Fixed bugs:**

- Inspec gem is constantly reinstalled if version is specified [\#215](https://github.com/chef-cookbooks/audit/issues/215)
- Audit coobook via Chef Automate fails to inherit profiles  [\#206](https://github.com/chef-cookbooks/audit/issues/206)
- Compliance Profile inheritence does not work with audit cookbook [\#38](https://github.com/chef-cookbooks/audit/issues/38)

**Closed issues:**

- Rename `collector` to `reporter` [\#205](https://github.com/chef-cookbooks/audit/issues/205)
- Audit cookbook failing to install from internal Ruby gem mirror [\#200](https://github.com/chef-cookbooks/audit/issues/200)
- Document new `chef-server-compliance` collector in Readme [\#190](https://github.com/chef-cookbooks/audit/issues/190)
- Missing default attribute `fail\_if\_any\_audits\_failed` [\#182](https://github.com/chef-cookbooks/audit/issues/182)
- Support certificates \(insecure\) for reporting to chef-visibility [\#150](https://github.com/chef-cookbooks/audit/issues/150)
- Missing profile results in misleading error message in chef\_gate log [\#144](https://github.com/chef-cookbooks/audit/issues/144)

**Merged pull requests:**

- Update comments in attributes file. [\#230](https://github.com/chef-cookbooks/audit/pull/230) ([alexpop](https://github.com/alexpop))
- 3.1.0 [\#221](https://github.com/chef-cookbooks/audit/pull/221) ([chris-rock](https://github.com/chris-rock))
- fix cc token and ensure we create a new string for a url [\#220](https://github.com/chef-cookbooks/audit/pull/220) ([chris-rock](https://github.com/chris-rock))
- stick to plain ruby hash [\#219](https://github.com/chef-cookbooks/audit/pull/219) ([chris-rock](https://github.com/chris-rock))
- fix reinstallation of inspec if version is already installed [\#218](https://github.com/chef-cookbooks/audit/pull/218) ([chris-rock](https://github.com/chris-rock))
- update metadata and gemfile [\#216](https://github.com/chef-cookbooks/audit/pull/216) ([chris-rock](https://github.com/chris-rock))
- refactor reporting [\#214](https://github.com/chef-cookbooks/audit/pull/214) ([chris-rock](https://github.com/chris-rock))
- Use Automate instead of Visibility [\#213](https://github.com/chef-cookbooks/audit/pull/213) ([chris-rock](https://github.com/chris-rock))
- Always use json format for inspec report [\#212](https://github.com/chef-cookbooks/audit/pull/212) ([chris-rock](https://github.com/chris-rock))
- Deprecate `collector` attribute [\#211](https://github.com/chef-cookbooks/audit/pull/211) ([chris-rock](https://github.com/chris-rock))
- Add report summary output to chef logs [\#210](https://github.com/chef-cookbooks/audit/pull/210) ([chris-rock](https://github.com/chris-rock))
- use inspec without nokogiri [\#209](https://github.com/chef-cookbooks/audit/pull/209) ([chris-rock](https://github.com/chris-rock))
- better error output [\#208](https://github.com/chef-cookbooks/audit/pull/208) ([chris-rock](https://github.com/chris-rock))

## [v3.0.0](https://github.com/chef-cookbooks/audit/tree/v3.0.0) (2017-04-03)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v2.4.0...v3.0.0)

**Implemented enhancements:**

- Automate profile fetcher [\#193](https://github.com/chef-cookbooks/audit/issues/193)

**Closed issues:**

- upload failed for cookbooks/audit because missing "compat\_resource" [\#204](https://github.com/chef-cookbooks/audit/issues/204)
- Missing data in Automate UI [\#199](https://github.com/chef-cookbooks/audit/issues/199)

**Merged pull requests:**

- Only install InSpec if not installed or version provided [\#203](https://github.com/chef-cookbooks/audit/pull/203) ([adamleff](https://github.com/adamleff))
- Use `chef-server-compliance` vs `chef-server` [\#202](https://github.com/chef-cookbooks/audit/pull/202) ([jerryaldrichiii](https://github.com/jerryaldrichiii))

## [v2.4.0](https://github.com/chef-cookbooks/audit/tree/v2.4.0) (2017-03-01)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v2.3.5...v2.4.0)

**Merged pull requests:**

- Bump cookbook version with new inspec release [\#198](https://github.com/chef-cookbooks/audit/pull/198) ([alexpop](https://github.com/alexpop))

## [v2.3.5](https://github.com/chef-cookbooks/audit/tree/v2.3.5) (2017-02-16)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v2.3.4...v2.3.5)

**Closed issues:**

- Direct reporting to Chef Visibility doesn't work when proxying node data through Chef Server [\#195](https://github.com/chef-cookbooks/audit/issues/195)
- could not find valid gem 'inspec' [\#194](https://github.com/chef-cookbooks/audit/issues/194)

**Merged pull requests:**

- Type the inspec profile attributes [\#196](https://github.com/chef-cookbooks/audit/pull/196) ([alexpop](https://github.com/alexpop))

## [v2.3.4](https://github.com/chef-cookbooks/audit/tree/v2.3.4) (2017-01-05)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v2.3.3...v2.3.4)

**Closed issues:**

- audit 2.3.2 no longer supports `chef-server` fetcher + `chef-server-visibility` collector [\#184](https://github.com/chef-cookbooks/audit/issues/184)

**Merged pull requests:**

- make automate integration tests optional [\#192](https://github.com/chef-cookbooks/audit/pull/192) ([chris-rock](https://github.com/chris-rock))
- Fix issue with interval being removed because of chef-client cookbook cleanup [\#191](https://github.com/chef-cookbooks/audit/pull/191) ([brentm5](https://github.com/brentm5))

## [v2.3.3](https://github.com/chef-cookbooks/audit/tree/v2.3.3) (2017-01-04)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v2.3.2...v2.3.3)

**Implemented enhancements:**

- Run Chef Automate integration tests in travis [\#178](https://github.com/chef-cookbooks/audit/issues/178)

**Closed issues:**

- Unable to use GIT as a profile source [\#172](https://github.com/chef-cookbooks/audit/issues/172)

**Merged pull requests:**

- Release 2.3.5 [\#197](https://github.com/chef-cookbooks/audit/pull/197) ([alexpop](https://github.com/alexpop))
- Releasing audit 2.3.3 defaulting to inspec 1.8.0 [\#189](https://github.com/chef-cookbooks/audit/pull/189) ([alexpop](https://github.com/alexpop))
- fixing \#184 [\#186](https://github.com/chef-cookbooks/audit/pull/186) ([jeremymv2](https://github.com/jeremymv2))
- Mention uploading profiles to Automate [\#183](https://github.com/chef-cookbooks/audit/pull/183) ([alexpop](https://github.com/alexpop))
- Travis and kitchen-ec2 testing [\#181](https://github.com/chef-cookbooks/audit/pull/181) ([alexpop](https://github.com/alexpop))

## [v2.3.2](https://github.com/chef-cookbooks/audit/tree/v2.3.2) (2016-12-08)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v2.3.1...v2.3.2)

**Fixed bugs:**

- fail\_if\_not\_present doesn't work [\#166](https://github.com/chef-cookbooks/audit/issues/166)

**Merged pull requests:**

- throw chef-client exception if requested by users [\#180](https://github.com/chef-cookbooks/audit/pull/180) ([chris-rock](https://github.com/chris-rock))
- min chef-client version for chef-server-visibility [\#179](https://github.com/chef-cookbooks/audit/pull/179) ([jeremymv2](https://github.com/jeremymv2))

## [v2.3.1](https://github.com/chef-cookbooks/audit/tree/v2.3.1) (2016-12-06)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v2.3.0...v2.3.1)

**Implemented enhancements:**

- Support Visibility in Automate via Chef Server [\#148](https://github.com/chef-cookbooks/audit/issues/148)
- Integration tests via OpsWorks ec2 [\#175](https://github.com/chef-cookbooks/audit/pull/175) ([alexpop](https://github.com/alexpop))

**Closed issues:**

- json-file, unable to save file on a windows system [\#173](https://github.com/chef-cookbooks/audit/issues/173)
- Update Changelog [\#170](https://github.com/chef-cookbooks/audit/issues/170)
- Integration testing with Chef Automate via test-kitchen [\#169](https://github.com/chef-cookbooks/audit/issues/169)

**Merged pull requests:**

- change json-file filename [\#177](https://github.com/chef-cookbooks/audit/pull/177) ([jeremymv2](https://github.com/jeremymv2))
- Attributes file clarifications [\#176](https://github.com/chef-cookbooks/audit/pull/176) ([jeremymv2](https://github.com/jeremymv2))
- Fix \#170, update changelog, add release instructions [\#171](https://github.com/chef-cookbooks/audit/pull/171) ([chris-rock](https://github.com/chris-rock))
- minimum integration tests [\#162](https://github.com/chef-cookbooks/audit/pull/162) ([jeremymv2](https://github.com/jeremymv2))

## [v2.3.0](https://github.com/chef-cookbooks/audit/tree/v2.3.0) (2016-11-23)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v2.2.0...v2.3.0)

**Implemented enhancements:**

- Improve cookbook usability\(fetcher, reporter\) renaming [\#158](https://github.com/chef-cookbooks/audit/issues/158)
- Update fetcher for chef-server-visibility and add chef-server-compliance collector [\#163](https://github.com/chef-cookbooks/audit/pull/163) ([alexpop](https://github.com/alexpop))
- Mention the integration guide between Chef Server and Automate [\#160](https://github.com/chef-cookbooks/audit/pull/160) ([alexpop](https://github.com/alexpop))

**Closed issues:**

- Update chef web docs [\#159](https://github.com/chef-cookbooks/audit/issues/159)

## [v2.2.0](https://github.com/chef-cookbooks/audit/tree/v2.2.0) (2016-11-16)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v2.1.0...v2.2.0)

**Implemented enhancements:**

- Add chef-server-visibility collector and automate fetcher [\#156](https://github.com/chef-cookbooks/audit/issues/156)
- Add chef-server-visibility collector [\#157](https://github.com/chef-cookbooks/audit/pull/157) ([alexpop](https://github.com/alexpop))

## [v2.1.0](https://github.com/chef-cookbooks/audit/tree/v2.1.0) (2016-11-11)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v2.0.0...v2.1.0)

**Closed issues:**

- Modify wording of `ERROR: Please take a look at your interval settings` [\#149](https://github.com/chef-cookbooks/audit/issues/149)

**Merged pull requests:**

- Add fetcher info to readme [\#154](https://github.com/chef-cookbooks/audit/pull/154) ([vjeffrey](https://github.com/vjeffrey))
- Add insecure flag for `Collector::ChefVisibility` [\#153](https://github.com/chef-cookbooks/audit/pull/153) ([jerryaldrichiii](https://github.com/jerryaldrichiii))
- add reference to self-signed certs with visibility [\#152](https://github.com/chef-cookbooks/audit/pull/152) ([chris-rock](https://github.com/chris-rock))
- change interval timing msg to warn [\#151](https://github.com/chef-cookbooks/audit/pull/151) ([vjeffrey](https://github.com/vjeffrey))
- dry up chef\_gem inspec resource declarations [\#147](https://github.com/chef-cookbooks/audit/pull/147) ([jeremymv2](https://github.com/jeremymv2))

## [v2.0.0](https://github.com/chef-cookbooks/audit/tree/v2.0.0) (2016-11-04)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v1.1.0...v2.0.0)

**Implemented enhancements:**

- Implement RFC: Harmonize profile location targets [\#118](https://github.com/chef-cookbooks/audit/issues/118)
- Audit docs improvements [\#115](https://github.com/chef-cookbooks/audit/pull/115) ([alexpop](https://github.com/alexpop))

**Fixed bugs:**

- Timing issues during report aggregation [\#81](https://github.com/chef-cookbooks/audit/issues/81)

**Closed issues:**

- Cannot run profiles from Supermarket [\#139](https://github.com/chef-cookbooks/audit/issues/139)
- version 2.0.0 reporting resources updated [\#138](https://github.com/chef-cookbooks/audit/issues/138)
- inspec\_version attribute specified twice [\#137](https://github.com/chef-cookbooks/audit/issues/137)
- README.md "Upload cookbook to Chef Server" [\#136](https://github.com/chef-cookbooks/audit/issues/136)
- Remove temporary report file [\#132](https://github.com/chef-cookbooks/audit/issues/132)
- Add Chef Server authentication support [\#129](https://github.com/chef-cookbooks/audit/issues/129)
- Add unit tests [\#128](https://github.com/chef-cookbooks/audit/issues/128)
- JSON file reporter [\#126](https://github.com/chef-cookbooks/audit/issues/126)
- Features missing from 2.0.0 [\#116](https://github.com/chef-cookbooks/audit/issues/116)
- Implement reporting as InSpec plugin [\#111](https://github.com/chef-cookbooks/audit/issues/111)
- Harmonize audit cookbook profile fetcher with InSpec fetchers [\#110](https://github.com/chef-cookbooks/audit/issues/110)
- profile scan is reported every chef-client run even if compliance\_profile resource wasn't executed [\#102](https://github.com/chef-cookbooks/audit/issues/102)
- audit cookbook compliance run and report should not report converge [\#70](https://github.com/chef-cookbooks/audit/issues/70)
- quiet should control whether converge is reported by Chef [\#65](https://github.com/chef-cookbooks/audit/issues/65)
- Node information sent to Compliance after first audit run are not accurate [\#40](https://github.com/chef-cookbooks/audit/issues/40)
- 403 Forbidden [\#21](https://github.com/chef-cookbooks/audit/issues/21)

**Merged pull requests:**

- adding support for alternate gem source [\#146](https://github.com/chef-cookbooks/audit/pull/146) ([jeremymv2](https://github.com/jeremymv2))
- enable chef-server fetcher attribute [\#145](https://github.com/chef-cookbooks/audit/pull/145) ([chris-rock](https://github.com/chris-rock))
- Supermarket [\#143](https://github.com/chef-cookbooks/audit/pull/143) ([jeremymv2](https://github.com/jeremymv2))
- fixing resources reporting as updated [\#142](https://github.com/chef-cookbooks/audit/pull/142) ([jeremymv2](https://github.com/jeremymv2))
- fix \#136 thanks @jeremymv2 [\#141](https://github.com/chef-cookbooks/audit/pull/141) ([chris-rock](https://github.com/chris-rock))
- fix \#137 [\#140](https://github.com/chef-cookbooks/audit/pull/140) ([chris-rock](https://github.com/chris-rock))
- implement chef-server fetcher and reporter [\#135](https://github.com/chef-cookbooks/audit/pull/135) ([chris-rock](https://github.com/chris-rock))
- fix reporting files [\#134](https://github.com/chef-cookbooks/audit/pull/134) ([vjeffrey](https://github.com/vjeffrey))
- do not hand over run context into reporter [\#133](https://github.com/chef-cookbooks/audit/pull/133) ([chris-rock](https://github.com/chris-rock))
- Add unit tests [\#131](https://github.com/chef-cookbooks/audit/pull/131) ([vjeffrey](https://github.com/vjeffrey))
- update readme [\#130](https://github.com/chef-cookbooks/audit/pull/130) ([chris-rock](https://github.com/chris-rock))
- bring back intervals [\#127](https://github.com/chef-cookbooks/audit/pull/127) ([vjeffrey](https://github.com/vjeffrey))
- Integrate with Chef Compliance [\#124](https://github.com/chef-cookbooks/audit/pull/124) ([chris-rock](https://github.com/chris-rock))
- move testing deps to integration group in berksfile [\#123](https://github.com/chef-cookbooks/audit/pull/123) ([vjeffrey](https://github.com/vjeffrey))
- Upload profiles to Chef Compliance via Chef resource [\#122](https://github.com/chef-cookbooks/audit/pull/122) ([vjeffrey](https://github.com/vjeffrey))
-  harmonize profile targets [\#121](https://github.com/chef-cookbooks/audit/pull/121) ([vjeffrey](https://github.com/vjeffrey))
- Update Github PR template [\#120](https://github.com/chef-cookbooks/audit/pull/120) ([tas50](https://github.com/tas50))
- recover examples [\#119](https://github.com/chef-cookbooks/audit/pull/119) ([chris-rock](https://github.com/chris-rock))
- add reference to 1.x documentation [\#117](https://github.com/chef-cookbooks/audit/pull/117) ([chris-rock](https://github.com/chris-rock))
- Activate test-kitchen in travis [\#114](https://github.com/chef-cookbooks/audit/pull/114) ([chris-rock](https://github.com/chris-rock))
- use chef handler to run inspec tests [\#113](https://github.com/chef-cookbooks/audit/pull/113) ([vjeffrey](https://github.com/vjeffrey))

## [v1.1.0](https://github.com/chef-cookbooks/audit/tree/v1.1.0) (2016-10-18)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v1.0.2...v1.1.0)

**Implemented enhancements:**

- Docs and examples improvements [\#97](https://github.com/chef-cookbooks/audit/pull/97) ([alexpop](https://github.com/alexpop))

**Fixed bugs:**

- cookbook in master fails to converge [\#108](https://github.com/chef-cookbooks/audit/issues/108)

**Closed issues:**

- Interval setting is not working properly [\#101](https://github.com/chef-cookbooks/audit/issues/101)

**Merged pull requests:**

- Fix resource\_collection profiles selector.  [\#109](https://github.com/chef-cookbooks/audit/pull/109) ([alexpop](https://github.com/alexpop))
- convert library resources to proper custom resources [\#107](https://github.com/chef-cookbooks/audit/pull/107) ([lamont-granquist](https://github.com/lamont-granquist))
- described refresh\_token behavior when logging out of UI [\#105](https://github.com/chef-cookbooks/audit/pull/105) ([jeremymv2](https://github.com/jeremymv2))
- fixing interval issues [\#104](https://github.com/chef-cookbooks/audit/pull/104) ([jeremymv2](https://github.com/jeremymv2))

## [v1.0.2](https://github.com/chef-cookbooks/audit/tree/v1.0.2) (2016-10-12)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v1.0.1...v1.0.2)

**Fixed bugs:**

- Fix bug when counting total failed controls in json format [\#106](https://github.com/chef-cookbooks/audit/pull/106) ([alexpop](https://github.com/alexpop))

## [v1.0.1](https://github.com/chef-cookbooks/audit/tree/v1.0.1) (2016-10-06)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v1.0.0...v1.0.1)

**Merged pull requests:**

- Use the new method to retrieve access tokens and fix total\_failed bug [\#103](https://github.com/chef-cookbooks/audit/pull/103) ([alexpop](https://github.com/alexpop))

## [v1.0.0](https://github.com/chef-cookbooks/audit/tree/v1.0.0) (2016-09-28)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.14.4...v1.0.0)

**Implemented enhancements:**

- Release version 1.0.0 [\#100](https://github.com/chef-cookbooks/audit/pull/100) ([alexpop](https://github.com/alexpop))

**Fixed bugs:**

- Update to InSpec 1.0 [\#98](https://github.com/chef-cookbooks/audit/issues/98)

**Closed issues:**

- Some tests against windows machines will fail with winrm unitialized constant errors [\#94](https://github.com/chef-cookbooks/audit/issues/94)
- Gzip error executing on windows host [\#93](https://github.com/chef-cookbooks/audit/issues/93)

**Merged pull requests:**

- update to work with inspec 1.0 json format [\#99](https://github.com/chef-cookbooks/audit/pull/99) ([vjeffrey](https://github.com/vjeffrey))
- Compliance profile upload [\#96](https://github.com/chef-cookbooks/audit/pull/96) ([jeremymv2](https://github.com/jeremymv2))
- bump inspec version to 0.34.1 to fix issue \#94 [\#95](https://github.com/chef-cookbooks/audit/pull/95) ([thomascate](https://github.com/thomascate))
- Compliance Token resource [\#91](https://github.com/chef-cookbooks/audit/pull/91) ([jeremymv2](https://github.com/jeremymv2))
- Updated examples [\#83](https://github.com/chef-cookbooks/audit/pull/83) ([jwmathe](https://github.com/jwmathe))

## [v0.14.4](https://github.com/chef-cookbooks/audit/tree/v0.14.4) (2016-09-06)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.14.3...v0.14.4)

**Implemented enhancements:**

- Release version 0.14.4 [\#90](https://github.com/chef-cookbooks/audit/pull/90) ([alexpop](https://github.com/alexpop))
- Improve logging and comments for attributes [\#89](https://github.com/chef-cookbooks/audit/pull/89) ([alexpop](https://github.com/alexpop))

**Merged pull requests:**

- making Auth - bad clock errors clearer [\#87](https://github.com/chef-cookbooks/audit/pull/87) ([jeremymv2](https://github.com/jeremymv2))
- adding clarifications [\#86](https://github.com/chef-cookbooks/audit/pull/86) ([jeremymv2](https://github.com/jeremymv2))

## [v0.14.3](https://github.com/chef-cookbooks/audit/tree/v0.14.3) (2016-08-25)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.14.2...v0.14.3)

**Implemented enhancements:**

- improve compliance refresh token handling [\#85](https://github.com/chef-cookbooks/audit/pull/85) ([chris-rock](https://github.com/chris-rock))

**Fixed bugs:**

- Minor fixes and changes [\#84](https://github.com/chef-cookbooks/audit/pull/84) ([tas50](https://github.com/tas50))

## [v0.14.2](https://github.com/chef-cookbooks/audit/tree/v0.14.2) (2016-08-16)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.14.1...v0.14.2)

**Implemented enhancements:**

- restrict travis branch testing to master [\#79](https://github.com/chef-cookbooks/audit/pull/79) ([chris-rock](https://github.com/chris-rock))
- improve info logging to see which reporter is used [\#77](https://github.com/chef-cookbooks/audit/pull/77) ([chris-rock](https://github.com/chris-rock))

**Fixed bugs:**

- Fix compliance direct communitcation [\#80](https://github.com/chef-cookbooks/audit/pull/80) ([chris-rock](https://github.com/chris-rock))
- use new collector attribute in examples [\#78](https://github.com/chef-cookbooks/audit/pull/78) ([chris-rock](https://github.com/chris-rock))

**Closed issues:**

- Changelog documentation Diff Link error [\#66](https://github.com/chef-cookbooks/audit/issues/66)
- we not use inspec progress formatter [\#11](https://github.com/chef-cookbooks/audit/issues/11)

**Merged pull requests:**

- fix Tempfile.new [\#88](https://github.com/chef-cookbooks/audit/pull/88) ([jeremymv2](https://github.com/jeremymv2))
- update metadata.rb [\#76](https://github.com/chef-cookbooks/audit/pull/76) ([chris-rock](https://github.com/chris-rock))

## [v0.14.1](https://github.com/chef-cookbooks/audit/tree/v0.14.1) (2016-08-15)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.14.0...v0.14.1)

**Merged pull requests:**

- ChefCompliance collector fix [\#75](https://github.com/chef-cookbooks/audit/pull/75) ([alexpop](https://github.com/alexpop))
- Update changelog generator task to be native rake task [\#74](https://github.com/chef-cookbooks/audit/pull/74) ([brentm5](https://github.com/brentm5))

## [v0.14.0](https://github.com/chef-cookbooks/audit/tree/v0.14.0) (2016-08-12)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.13.1...v0.14.0)

**Merged pull requests:**

- removing requirement for setting chef server url [\#73](https://github.com/chef-cookbooks/audit/pull/73) ([jeremymv2](https://github.com/jeremymv2))
- Add collector attribute and visibility reporting [\#72](https://github.com/chef-cookbooks/audit/pull/72) ([chris-rock](https://github.com/chris-rock))

## [v0.13.1](https://github.com/chef-cookbooks/audit/tree/v0.13.1) (2016-06-27)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.13.0...v0.13.1)

**Merged pull requests:**

- 0.13.1 [\#69](https://github.com/chef-cookbooks/audit/pull/69) ([chris-rock](https://github.com/chris-rock))
- Standardized node access to classic way [\#68](https://github.com/chef-cookbooks/audit/pull/68) ([mhedgpeth](https://github.com/mhedgpeth))

## [v0.13.0](https://github.com/chef-cookbooks/audit/tree/v0.13.0) (2016-06-22)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.12.0...v0.13.0)

**Closed issues:**

- audit cookbook should not report a converge [\#23](https://github.com/chef-cookbooks/audit/issues/23)

**Merged pull requests:**

- Merged interval functionality into default.rb recipe, updated documentation, gave quiet default [\#64](https://github.com/chef-cookbooks/audit/pull/64) ([mhedgpeth](https://github.com/mhedgpeth))

## [v0.12.0](https://github.com/chef-cookbooks/audit/tree/v0.12.0) (2016-06-09)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.11.0...v0.12.0)

**Merged pull requests:**

- Release 0.12.0 [\#62](https://github.com/chef-cookbooks/audit/pull/62) ([smurawski](https://github.com/smurawski))
- adding with\_http\_rescue method call back in [\#61](https://github.com/chef-cookbooks/audit/pull/61) ([jeremymv2](https://github.com/jeremymv2))

## [v0.11.0](https://github.com/chef-cookbooks/audit/tree/v0.11.0) (2016-06-09)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.10.0...v0.11.0)

**Merged pull requests:**

- Release 0.11.0 [\#60](https://github.com/chef-cookbooks/audit/pull/60) ([smurawski](https://github.com/smurawski))
- http\_rescue not required with tempfile [\#59](https://github.com/chef-cookbooks/audit/pull/59) ([Anirudh-Gupta](https://github.com/Anirudh-Gupta))

## [v0.10.0](https://github.com/chef-cookbooks/audit/tree/v0.10.0) (2016-06-01)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.9.1...v0.10.0)

**Merged pull requests:**

- handle auth error [\#58](https://github.com/chef-cookbooks/audit/pull/58) ([chris-rock](https://github.com/chris-rock))

## [v0.9.1](https://github.com/chef-cookbooks/audit/tree/v0.9.1) (2016-05-26)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.9.0...v0.9.1)

**Closed issues:**

- Reports are not displayed in Chef Compliance [\#52](https://github.com/chef-cookbooks/audit/issues/52)
- Cookbook issue with Windows path [\#48](https://github.com/chef-cookbooks/audit/issues/48)
- Report to Chef Compliance directly [\#45](https://github.com/chef-cookbooks/audit/issues/45)

**Merged pull requests:**

- test-kitchen example for Chef Compliance direct reporting [\#57](https://github.com/chef-cookbooks/audit/pull/57) ([chris-rock](https://github.com/chris-rock))
- changed access token handling [\#56](https://github.com/chef-cookbooks/audit/pull/56) ([cjohannsen81](https://github.com/cjohannsen81))
- add changelog [\#55](https://github.com/chef-cookbooks/audit/pull/55) ([chris-rock](https://github.com/chris-rock))

## [v0.9.0](https://github.com/chef-cookbooks/audit/tree/v0.9.0) (2016-05-25)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.8.0...v0.9.0)

**Closed issues:**

- Provide support for additional profile hosting sources [\#49](https://github.com/chef-cookbooks/audit/issues/49)
- Scan reports showing up as "Skipped" in the Compliance server UI [\#46](https://github.com/chef-cookbooks/audit/issues/46)

**Merged pull requests:**

- Optimize the direct reporting to Chef Compliance [\#54](https://github.com/chef-cookbooks/audit/pull/54) ([chris-rock](https://github.com/chris-rock))
- changed FileUtils, tar\_path and profile\_path behavior [\#51](https://github.com/chef-cookbooks/audit/pull/51) ([cjohannsen81](https://github.com/cjohannsen81))
- Support other sources [\#50](https://github.com/chef-cookbooks/audit/pull/50) ([jeremymv2](https://github.com/jeremymv2))
- quiet mode for inspec scans [\#47](https://github.com/chef-cookbooks/audit/pull/47) ([jeremymv2](https://github.com/jeremymv2))

## [v0.8.0](https://github.com/chef-cookbooks/audit/tree/v0.8.0) (2016-05-18)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.7.0...v0.8.0)

**Closed issues:**

- Compliance results no longer reports back to Chef Compliance with latest version of inspec [\#41](https://github.com/chef-cookbooks/audit/issues/41)

**Merged pull requests:**

- Inspec 0.22.1 for Chef Compliance 1.2.3 [\#44](https://github.com/chef-cookbooks/audit/pull/44) ([chris-rock](https://github.com/chris-rock))
- Update readme and bump patch version [\#43](https://github.com/chef-cookbooks/audit/pull/43) ([alexpop](https://github.com/alexpop))

## [v0.7.0](https://github.com/chef-cookbooks/audit/tree/v0.7.0) (2016-05-13)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.6.0...v0.7.0)

**Closed issues:**

- Undefined method 'path' for nil:NilClass [\#39](https://github.com/chef-cookbooks/audit/issues/39)
- Support chef-client \< 12.5.1 [\#30](https://github.com/chef-cookbooks/audit/issues/30)
- standalone Compliance report [\#12](https://github.com/chef-cookbooks/audit/issues/12)
- we should use the latest inspec version by default [\#8](https://github.com/chef-cookbooks/audit/issues/8)

**Merged pull requests:**

- pin inspec to 0.20.1 [\#42](https://github.com/chef-cookbooks/audit/pull/42) ([chris-rock](https://github.com/chris-rock))

## [v0.6.0](https://github.com/chef-cookbooks/audit/tree/v0.6.0) (2016-05-03)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.5.1...v0.6.0)

**Merged pull requests:**

- fix: use\_ssl value has changed error [\#37](https://github.com/chef-cookbooks/audit/pull/37) ([jeremymv2](https://github.com/jeremymv2))
- Add profile name validation and unit tests [\#36](https://github.com/chef-cookbooks/audit/pull/36) ([alexpop](https://github.com/alexpop))

## [v0.5.1](https://github.com/chef-cookbooks/audit/tree/v0.5.1) (2016-04-27)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.5.0...v0.5.1)

**Merged pull requests:**

- Prevent null pointer when profile cannot be downloaded [\#35](https://github.com/chef-cookbooks/audit/pull/35) ([alexpop](https://github.com/alexpop))

## [v0.5.0](https://github.com/chef-cookbooks/audit/tree/v0.5.0) (2016-04-25)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.4.4...v0.5.0)

**Closed issues:**

- add option to fail chef run, if the audit failed [\#3](https://github.com/chef-cookbooks/audit/issues/3)

**Merged pull requests:**

- Make inspec\_version a cookbook attribute and default it to latest [\#33](https://github.com/chef-cookbooks/audit/pull/33) ([alexpop](https://github.com/alexpop))
- update bundler [\#32](https://github.com/chef-cookbooks/audit/pull/32) ([chris-rock](https://github.com/chris-rock))
- update README.md with client version requirement [\#29](https://github.com/chef-cookbooks/audit/pull/29) ([jeremymv2](https://github.com/jeremymv2))

## [v0.4.4](https://github.com/chef-cookbooks/audit/tree/v0.4.4) (2016-04-22)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.4.3...v0.4.4)

**Merged pull requests:**

- update inspec gem version pin [\#31](https://github.com/chef-cookbooks/audit/pull/31) ([jeremymv2](https://github.com/jeremymv2))

## [v0.4.3](https://github.com/chef-cookbooks/audit/tree/v0.4.3) (2016-04-20)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.3.3...v0.4.3)

**Merged pull requests:**

- chef-compliance profiles changes require a new ver of inspec [\#28](https://github.com/chef-cookbooks/audit/pull/28) ([alexpop](https://github.com/alexpop))
- Add our github templates [\#27](https://github.com/chef-cookbooks/audit/pull/27) ([tas50](https://github.com/tas50))
- failing converge if any audits failed [\#25](https://github.com/chef-cookbooks/audit/pull/25) ([jeremymv2](https://github.com/jeremymv2))
- Misc updates [\#24](https://github.com/chef-cookbooks/audit/pull/24) ([tas50](https://github.com/tas50))
- adding ability to handle offline compliance server [\#22](https://github.com/chef-cookbooks/audit/pull/22) ([jeremymv2](https://github.com/jeremymv2))
- work with token and direct compliance server API [\#20](https://github.com/chef-cookbooks/audit/pull/20) ([srenatus](https://github.com/srenatus))

## [v0.3.3](https://github.com/chef-cookbooks/audit/tree/v0.3.3) (2016-04-05)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.3.2...v0.3.3)

**Merged pull requests:**

- Use move to avoid cross-device error [\#19](https://github.com/chef-cookbooks/audit/pull/19) ([alexpop](https://github.com/alexpop))
- Adding an interval check, if you don't want to run every time [\#17](https://github.com/chef-cookbooks/audit/pull/17) ([spuranam](https://github.com/spuranam))

## [v0.3.2](https://github.com/chef-cookbooks/audit/tree/v0.3.2) (2016-04-04)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.3.1...v0.3.2)

**Merged pull requests:**

- Bump to 0.3.2, testing cookbook release [\#18](https://github.com/chef-cookbooks/audit/pull/18) ([alexpop](https://github.com/alexpop))

## [v0.3.1](https://github.com/chef-cookbooks/audit/tree/v0.3.1) (2016-04-01)

[Full Changelog](https://github.com/chef-cookbooks/audit/compare/5d2dca98d19a1b0516ba3ce5f077a083028ff11d...v0.3.1)

**Closed issues:**

- Do not crash default recipe, if node\['audit'\] is not defined [\#4](https://github.com/chef-cookbooks/audit/issues/4)
- add default recipe that reads profiles from attributes [\#1](https://github.com/chef-cookbooks/audit/issues/1)

**Merged pull requests:**

- Update readme and update version to test stove cookbook update [\#16](https://github.com/chef-cookbooks/audit/pull/16) ([alexpop](https://github.com/alexpop))
- Update github links and change to version 0.3.0 [\#15](https://github.com/chef-cookbooks/audit/pull/15) ([alexpop](https://github.com/alexpop))
- prepare test-kitchen tests [\#10](https://github.com/chef-cookbooks/audit/pull/10) ([chris-rock](https://github.com/chris-rock))
- offer native inspec-style syntax as an alternative [\#9](https://github.com/chef-cookbooks/audit/pull/9) ([arlimus](https://github.com/arlimus))
- lint files and activate travis testing [\#7](https://github.com/chef-cookbooks/audit/pull/7) ([chris-rock](https://github.com/chris-rock))
- Update readme and add license information [\#6](https://github.com/chef-cookbooks/audit/pull/6) ([chris-rock](https://github.com/chris-rock))
- add default attributes file [\#5](https://github.com/chef-cookbooks/audit/pull/5) ([srenatus](https://github.com/srenatus))
- audit::default: read profiles from attributes, push report to chefserver [\#2](https://github.com/chef-cookbooks/audit/pull/2) ([srenatus](https://github.com/srenatus))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
