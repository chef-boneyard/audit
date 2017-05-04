# Change Log

## [v3.1.0](https://github.com/chef-cookbooks/audit/tree/v3.1.0) (2017-05-04)
[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v3.0.0...v3.1.0)

**Closed issues:**

- Inspec gem is constantly reinstalled if version is specified [\#215](https://github.com/chef-cookbooks/audit/issues/215)
- JSON output contains "You have X number of issues or packages out of date" [\#207](https://github.com/chef-cookbooks/audit/issues/207)
- Audit coobook via Chef Automate fails to inherit profiles  [\#206](https://github.com/chef-cookbooks/audit/issues/206)
- Rename `collector` to `reporter` [\#205](https://github.com/chef-cookbooks/audit/issues/205)
- Audit cookbook failing to install from internal Ruby gem mirror [\#200](https://github.com/chef-cookbooks/audit/issues/200)
- Document new `chef-server-compliance` collector in Readme [\#190](https://github.com/chef-cookbooks/audit/issues/190)
- Missing default attribute `fail\_if\_any\_audits\_failed` [\#182](https://github.com/chef-cookbooks/audit/issues/182)
- ability to install inspec as a package [\#164](https://github.com/chef-cookbooks/audit/issues/164)
- Warning from wrong attribute syntax [\#161](https://github.com/chef-cookbooks/audit/issues/161)
- Cannot report meta-profiles to Chef Compliance [\#155](https://github.com/chef-cookbooks/audit/issues/155)
- Support certificates \(insecure\) for reporting to chef-visibility [\#150](https://github.com/chef-cookbooks/audit/issues/150)
- Missing profile results in misleading error message in chef\_gate log [\#144](https://github.com/chef-cookbooks/audit/issues/144)
- Vendor InSpec gem [\#112](https://github.com/chef-cookbooks/audit/issues/112)
- Compliance Profile inheritence does not work with audit cookbook [\#38](https://github.com/chef-cookbooks/audit/issues/38)
- Provide gem\_source attribute for fetching any required gems [\#26](https://github.com/chef-cookbooks/audit/issues/26)

**Merged pull requests:**

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

- Release 2.3.5 [\#197](https://github.com/chef-cookbooks/audit/pull/197) ([alexpop](https://github.com/alexpop))
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

**Closed issues:**

- Run Chef Automate integration tests in travis [\#178](https://github.com/chef-cookbooks/audit/issues/178)
- Unable to use GIT as a profile source [\#172](https://github.com/chef-cookbooks/audit/issues/172)

**Merged pull requests:**

- Releasing audit 2.3.3 defaulting to inspec 1.8.0 [\#189](https://github.com/chef-cookbooks/audit/pull/189) ([alexpop](https://github.com/alexpop))
- fixing \#184 [\#186](https://github.com/chef-cookbooks/audit/pull/186) ([jeremymv2](https://github.com/jeremymv2))
- Mention uploading profiles to Automate [\#183](https://github.com/chef-cookbooks/audit/pull/183) ([alexpop](https://github.com/alexpop))
- Travis and kitchen-ec2 testing [\#181](https://github.com/chef-cookbooks/audit/pull/181) ([alexpop](https://github.com/alexpop))

## [v2.3.2](https://github.com/chef-cookbooks/audit/tree/v2.3.2) (2016-12-08)
[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v2.3.1...v2.3.2)

**Closed issues:**

- fail\_if\_not\_present doesn't work [\#166](https://github.com/chef-cookbooks/audit/issues/166)

**Merged pull requests:**

- throw chef-client exception if requested by users [\#180](https://github.com/chef-cookbooks/audit/pull/180) ([chris-rock](https://github.com/chris-rock))
- min chef-client version for chef-server-visibility [\#179](https://github.com/chef-cookbooks/audit/pull/179) ([jeremymv2](https://github.com/jeremymv2))

## [v2.3.1](https://github.com/chef-cookbooks/audit/tree/v2.3.1) (2016-12-06)
[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v2.3.0...v2.3.1)

**Closed issues:**

- json-file, unable to save file on a windows system [\#173](https://github.com/chef-cookbooks/audit/issues/173)
- Update Changelog [\#170](https://github.com/chef-cookbooks/audit/issues/170)
- Integration testing with Chef Automate via test-kitchen [\#169](https://github.com/chef-cookbooks/audit/issues/169)
- Support Visibility in Automate via Chef Server [\#148](https://github.com/chef-cookbooks/audit/issues/148)

**Merged pull requests:**

- change json-file filename [\#177](https://github.com/chef-cookbooks/audit/pull/177) ([jeremymv2](https://github.com/jeremymv2))
- Attributes file clarifications [\#176](https://github.com/chef-cookbooks/audit/pull/176) ([jeremymv2](https://github.com/jeremymv2))
- Integration tests via OpsWorks ec2 [\#175](https://github.com/chef-cookbooks/audit/pull/175) ([alexpop](https://github.com/alexpop))
- Fix \#170, update changelog, add release instructions [\#171](https://github.com/chef-cookbooks/audit/pull/171) ([chris-rock](https://github.com/chris-rock))
- minimum integration tests [\#162](https://github.com/chef-cookbooks/audit/pull/162) ([jeremymv2](https://github.com/jeremymv2))

## [v2.3.0](https://github.com/chef-cookbooks/audit/tree/v2.3.0) (2016-11-23)
[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v2.2.0...v2.3.0)

**Closed issues:**

- Update chef web docs [\#159](https://github.com/chef-cookbooks/audit/issues/159)
- Improve cookbook usability\(fetcher, reporter\) renaming [\#158](https://github.com/chef-cookbooks/audit/issues/158)

**Merged pull requests:**

- Install inspec from source [\#168](https://github.com/chef-cookbooks/audit/pull/168) ([stephenlauck](https://github.com/stephenlauck))
- Update fetcher for chef-server-visibility and add chef-server-compliance collector [\#163](https://github.com/chef-cookbooks/audit/pull/163) ([alexpop](https://github.com/alexpop))
- Mention the integration guide between Chef Server and Automate [\#160](https://github.com/chef-cookbooks/audit/pull/160) ([alexpop](https://github.com/alexpop))

## [v2.2.0](https://github.com/chef-cookbooks/audit/tree/v2.2.0) (2016-11-16)
[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v2.1.0...v2.2.0)

**Closed issues:**

- Add chef-server-visibility collector and automate fetcher [\#156](https://github.com/chef-cookbooks/audit/issues/156)

**Merged pull requests:**

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

**Closed issues:**

- Cannot run profiles from Supermarket [\#139](https://github.com/chef-cookbooks/audit/issues/139)
- version 2.0.0 reporting resources updated [\#138](https://github.com/chef-cookbooks/audit/issues/138)
- inspec\_version attribute specified twice [\#137](https://github.com/chef-cookbooks/audit/issues/137)
- README.md "Upload cookbook to Chef Server" [\#136](https://github.com/chef-cookbooks/audit/issues/136)
- Remove temporary report file [\#132](https://github.com/chef-cookbooks/audit/issues/132)
- Add Chef Server authentication support [\#129](https://github.com/chef-cookbooks/audit/issues/129)
- Add unit tests [\#128](https://github.com/chef-cookbooks/audit/issues/128)
- JSON file reporter [\#126](https://github.com/chef-cookbooks/audit/issues/126)
- Implement RFC: Harmonize profile location targets [\#118](https://github.com/chef-cookbooks/audit/issues/118)
- Features missing from 2.0.0 [\#116](https://github.com/chef-cookbooks/audit/issues/116)
- Implement reporting as InSpec plugin [\#111](https://github.com/chef-cookbooks/audit/issues/111)
- Harmonize audit cookbook profile fetcher with InSpec fetchers [\#110](https://github.com/chef-cookbooks/audit/issues/110)
- profile scan is reported every chef-client run even if compliance\_profile resource wasn't executed [\#102](https://github.com/chef-cookbooks/audit/issues/102)
- Timing issues during report aggregation [\#81](https://github.com/chef-cookbooks/audit/issues/81)
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
- Audit docs improvements [\#115](https://github.com/chef-cookbooks/audit/pull/115) ([alexpop](https://github.com/alexpop))
- Activate test-kitchen in travis [\#114](https://github.com/chef-cookbooks/audit/pull/114) ([chris-rock](https://github.com/chris-rock))
- use chef handler to run inspec tests [\#113](https://github.com/chef-cookbooks/audit/pull/113) ([vjeffrey](https://github.com/vjeffrey))

## [v1.1.0](https://github.com/chef-cookbooks/audit/tree/v1.1.0) (2016-10-18)
[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v1.0.2...v1.1.0)

**Closed issues:**

- cookbook in master fails to converge [\#108](https://github.com/chef-cookbooks/audit/issues/108)
- Interval setting is not working properly [\#101](https://github.com/chef-cookbooks/audit/issues/101)

**Merged pull requests:**

- Fix resource\_collection profiles selector.  [\#109](https://github.com/chef-cookbooks/audit/pull/109) ([alexpop](https://github.com/alexpop))
- convert library resources to proper custom resources [\#107](https://github.com/chef-cookbooks/audit/pull/107) ([lamont-granquist](https://github.com/lamont-granquist))
- described refresh\_token behavior when logging out of UI [\#105](https://github.com/chef-cookbooks/audit/pull/105) ([jeremymv2](https://github.com/jeremymv2))
- fixing interval issues [\#104](https://github.com/chef-cookbooks/audit/pull/104) ([jeremymv2](https://github.com/jeremymv2))

## [v1.0.2](https://github.com/chef-cookbooks/audit/tree/v1.0.2) (2016-10-12)
[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v1.0.1...v1.0.2)

**Merged pull requests:**

- Fix bug when counting total failed controls in json format [\#106](https://github.com/chef-cookbooks/audit/pull/106) ([alexpop](https://github.com/alexpop))

## [v1.0.1](https://github.com/chef-cookbooks/audit/tree/v1.0.1) (2016-10-06)
[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v1.0.0...v1.0.1)

**Merged pull requests:**

- Use the new method to retrieve access tokens and fix total\_failed bug [\#103](https://github.com/chef-cookbooks/audit/pull/103) ([alexpop](https://github.com/alexpop))

## [v1.0.0](https://github.com/chef-cookbooks/audit/tree/v1.0.0) (2016-09-28)
[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.14.4...v1.0.0)

**Closed issues:**

- Update to InSpec 1.0 [\#98](https://github.com/chef-cookbooks/audit/issues/98)
- Some tests against windows machines will fail with winrm unitialized constant errors [\#94](https://github.com/chef-cookbooks/audit/issues/94)
- Gzip error executing on windows host [\#93](https://github.com/chef-cookbooks/audit/issues/93)

**Merged pull requests:**

- Release version 1.0.0 [\#100](https://github.com/chef-cookbooks/audit/pull/100) ([alexpop](https://github.com/alexpop))
- update to work with inspec 1.0 json format [\#99](https://github.com/chef-cookbooks/audit/pull/99) ([vjeffrey](https://github.com/vjeffrey))
- Docs and examples improvements [\#97](https://github.com/chef-cookbooks/audit/pull/97) ([alexpop](https://github.com/alexpop))
- Compliance profile upload [\#96](https://github.com/chef-cookbooks/audit/pull/96) ([jeremymv2](https://github.com/jeremymv2))
- bump inspec version to 0.34.1 to fix issue \#94 [\#95](https://github.com/chef-cookbooks/audit/pull/95) ([thomascate](https://github.com/thomascate))
- Compliance Token resource [\#91](https://github.com/chef-cookbooks/audit/pull/91) ([jeremymv2](https://github.com/jeremymv2))
- Updated examples [\#83](https://github.com/chef-cookbooks/audit/pull/83) ([jwmathe](https://github.com/jwmathe))

## [v0.14.4](https://github.com/chef-cookbooks/audit/tree/v0.14.4) (2016-09-06)
[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.14.3...v0.14.4)

**Merged pull requests:**

- Release version 0.14.4 [\#90](https://github.com/chef-cookbooks/audit/pull/90) ([alexpop](https://github.com/alexpop))
- Improve logging and comments for attributes [\#89](https://github.com/chef-cookbooks/audit/pull/89) ([alexpop](https://github.com/alexpop))
- fix Tempfile.new [\#88](https://github.com/chef-cookbooks/audit/pull/88) ([jeremymv2](https://github.com/jeremymv2))
- making Auth - bad clock errors clearer [\#87](https://github.com/chef-cookbooks/audit/pull/87) ([jeremymv2](https://github.com/jeremymv2))
- adding clarifications [\#86](https://github.com/chef-cookbooks/audit/pull/86) ([jeremymv2](https://github.com/jeremymv2))

## [v0.14.3](https://github.com/chef-cookbooks/audit/tree/v0.14.3) (2016-08-25)
[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.14.2...v0.14.3)

**Merged pull requests:**

- improve compliance refresh token handling [\#85](https://github.com/chef-cookbooks/audit/pull/85) ([chris-rock](https://github.com/chris-rock))
- Minor fixes and changes [\#84](https://github.com/chef-cookbooks/audit/pull/84) ([tas50](https://github.com/tas50))

## [v0.14.2](https://github.com/chef-cookbooks/audit/tree/v0.14.2) (2016-08-16)
[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.14.1...v0.14.2)

**Closed issues:**

- Changelog documentation Diff Link error [\#66](https://github.com/chef-cookbooks/audit/issues/66)
- we not use inspec progress formatter [\#11](https://github.com/chef-cookbooks/audit/issues/11)

**Merged pull requests:**

- Fix compliance direct communitcation [\#80](https://github.com/chef-cookbooks/audit/pull/80) ([chris-rock](https://github.com/chris-rock))
- restrict travis branch testing to master [\#79](https://github.com/chef-cookbooks/audit/pull/79) ([chris-rock](https://github.com/chris-rock))
- use new collector attribute in examples [\#78](https://github.com/chef-cookbooks/audit/pull/78) ([chris-rock](https://github.com/chris-rock))
- improve info logging to see which reporter is used [\#77](https://github.com/chef-cookbooks/audit/pull/77) ([chris-rock](https://github.com/chris-rock))
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
- Adding an interval check, if you don't want to run every time [\#17](https://github.com/chef-cookbooks/audit/pull/17) ([spuranam](https://github.com/spuranam))

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
- work with token and direct compliance server API [\#20](https://github.com/chef-cookbooks/audit/pull/20) ([srenatus](https://github.com/srenatus))

## [v0.4.3](https://github.com/chef-cookbooks/audit/tree/v0.4.3) (2016-04-20)
[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.3.3...v0.4.3)

**Merged pull requests:**

- chef-compliance profiles changes require a new ver of inspec [\#28](https://github.com/chef-cookbooks/audit/pull/28) ([alexpop](https://github.com/alexpop))
- Add our github templates [\#27](https://github.com/chef-cookbooks/audit/pull/27) ([tas50](https://github.com/tas50))
- failing converge if any audits failed [\#25](https://github.com/chef-cookbooks/audit/pull/25) ([jeremymv2](https://github.com/jeremymv2))
- Misc updates [\#24](https://github.com/chef-cookbooks/audit/pull/24) ([tas50](https://github.com/tas50))
- adding ability to handle offline compliance server [\#22](https://github.com/chef-cookbooks/audit/pull/22) ([jeremymv2](https://github.com/jeremymv2))

## [v0.3.3](https://github.com/chef-cookbooks/audit/tree/v0.3.3) (2016-04-05)
[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.3.2...v0.3.3)

**Merged pull requests:**

- Use move to avoid cross-device error [\#19](https://github.com/chef-cookbooks/audit/pull/19) ([alexpop](https://github.com/alexpop))

## [v0.3.2](https://github.com/chef-cookbooks/audit/tree/v0.3.2) (2016-04-04)
[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.3.1...v0.3.2)

**Merged pull requests:**

- Bump to 0.3.2, testing cookbook release [\#18](https://github.com/chef-cookbooks/audit/pull/18) ([alexpop](https://github.com/alexpop))

## [v0.3.1](https://github.com/chef-cookbooks/audit/tree/v0.3.1) (2016-04-01)
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



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*