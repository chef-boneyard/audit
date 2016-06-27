# Change Log

## [v0.13.1](https://github.com/chef-cookbooks/audit/tree/v0.13.1) (2016-06-27)
[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.13.0...v0.13.1)

**Merged pull requests:**

- Standardized node access to classic way [\#68](https://github.com/chef-cookbooks/audit/pull/68) ([mhedgpeth](https://github.com/mhedgpeth))

## [v0.13.0](https://github.com/chef-cookbooks/audit/tree/v0.13.0) (2016-06-22)
[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.12.0...v0.13.0)

**Implemented enhancements:**

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

**Implemented enhancements:**

- handle auth error [\#58](https://github.com/chef-cookbooks/audit/pull/58) ([chris-rock](https://github.com/chris-rock))

## [v0.9.1](https://github.com/chef-cookbooks/audit/tree/v0.9.1) (2016-05-26)
[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.9.0...v0.9.1)

**Implemented enhancements:**

- Report to Chef Compliance directly [\#45](https://github.com/chef-cookbooks/audit/issues/45)
- test-kitchen example for Chef Compliance direct reporting [\#57](https://github.com/chef-cookbooks/audit/pull/57) ([chris-rock](https://github.com/chris-rock))

**Fixed bugs:**

- changed access token handling [\#56](https://github.com/chef-cookbooks/audit/pull/56) ([cjohannsen81](https://github.com/cjohannsen81))

**Closed issues:**

- Reports are not displayed in Chef Compliance [\#52](https://github.com/chef-cookbooks/audit/issues/52)
- Cookbook issue with Windows path [\#48](https://github.com/chef-cookbooks/audit/issues/48)

**Merged pull requests:**

- add changelog [\#55](https://github.com/chef-cookbooks/audit/pull/55) ([chris-rock](https://github.com/chris-rock))

## [v0.9.0](https://github.com/chef-cookbooks/audit/tree/v0.9.0) (2016-05-25)
[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.8.0...v0.9.0)

**Fixed bugs:**

- Scan reports showing up as "Skipped" in the Compliance server UI [\#46](https://github.com/chef-cookbooks/audit/issues/46)

**Closed issues:**

- Provide support for additional profile hosting sources [\#49](https://github.com/chef-cookbooks/audit/issues/49)

**Merged pull requests:**

- Optimize the direct reporting to Chef Compliance [\#54](https://github.com/chef-cookbooks/audit/pull/54) ([chris-rock](https://github.com/chris-rock))
- changed FileUtils, tar\_path and profile\_path behavior [\#51](https://github.com/chef-cookbooks/audit/pull/51) ([cjohannsen81](https://github.com/cjohannsen81))
- Support other sources [\#50](https://github.com/chef-cookbooks/audit/pull/50) ([jeremymv2](https://github.com/jeremymv2))
- quiet mode for inspec scans [\#47](https://github.com/chef-cookbooks/audit/pull/47) ([jeremymv2](https://github.com/jeremymv2))

## [v0.8.0](https://github.com/chef-cookbooks/audit/tree/v0.8.0) (2016-05-18)
[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.7.0...v0.8.0)

**Fixed bugs:**

- Compliance results no longer reports back to Chef Compliance with latest version of inspec [\#41](https://github.com/chef-cookbooks/audit/issues/41)
- Inspec 0.22.1 for Chef Compliance 1.2.3 [\#44](https://github.com/chef-cookbooks/audit/pull/44) ([chris-rock](https://github.com/chris-rock))

**Merged pull requests:**

- Update readme and bump patch version [\#43](https://github.com/chef-cookbooks/audit/pull/43) ([alexpop](https://github.com/alexpop))

## [v0.7.0](https://github.com/chef-cookbooks/audit/tree/v0.7.0) (2016-05-13)
[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.6.0...v0.7.0)

**Fixed bugs:**

- Support chef-client \< 12.5.1 [\#30](https://github.com/chef-cookbooks/audit/issues/30)

**Closed issues:**

- Undefined method 'path' for nil:NilClass [\#39](https://github.com/chef-cookbooks/audit/issues/39)
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

**Fixed bugs:**

- Prevent null pointer when profile cannot be downloaded [\#35](https://github.com/chef-cookbooks/audit/pull/35) ([alexpop](https://github.com/alexpop))

## [v0.5.0](https://github.com/chef-cookbooks/audit/tree/v0.5.0) (2016-04-25)
[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.4.4...v0.5.0)

**Implemented enhancements:**

- add option to fail chef run, if the audit failed [\#3](https://github.com/chef-cookbooks/audit/issues/3)

**Merged pull requests:**

- Make inspec\_version a cookbook attribute and default it to latest [\#33](https://github.com/chef-cookbooks/audit/pull/33) ([alexpop](https://github.com/alexpop))
- update bundler [\#32](https://github.com/chef-cookbooks/audit/pull/32) ([chris-rock](https://github.com/chris-rock))
- update README.md with client version requirement [\#29](https://github.com/chef-cookbooks/audit/pull/29) ([jeremymv2](https://github.com/jeremymv2))

## [v0.4.4](https://github.com/chef-cookbooks/audit/tree/v0.4.4) (2016-04-22)
[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.4.3...v0.4.4)

**Implemented enhancements:**

- work with token and direct compliance server API [\#20](https://github.com/chef-cookbooks/audit/pull/20) ([srenatus](https://github.com/srenatus))

**Merged pull requests:**

- update inspec gem version pin [\#31](https://github.com/chef-cookbooks/audit/pull/31) ([jeremymv2](https://github.com/jeremymv2))

## [v0.4.3](https://github.com/chef-cookbooks/audit/tree/v0.4.3) (2016-04-20)
[Full Changelog](https://github.com/chef-cookbooks/audit/compare/v0.3.3...v0.4.3)

**Fixed bugs:**

- chef-compliance profiles changes require a new ver of inspec [\#28](https://github.com/chef-cookbooks/audit/pull/28) ([alexpop](https://github.com/alexpop))

**Merged pull requests:**

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
**Implemented enhancements:**

- add default recipe that reads profiles from attributes [\#1](https://github.com/chef-cookbooks/audit/issues/1)
- prepare test-kitchen tests [\#10](https://github.com/chef-cookbooks/audit/pull/10) ([chris-rock](https://github.com/chris-rock))
- Update readme and add license information [\#6](https://github.com/chef-cookbooks/audit/pull/6) ([chris-rock](https://github.com/chris-rock))

**Closed issues:**

- Do not crash default recipe, if node\['audit'\] is not defined [\#4](https://github.com/chef-cookbooks/audit/issues/4)

**Merged pull requests:**

- Update readme and update version to test stove cookbook update [\#16](https://github.com/chef-cookbooks/audit/pull/16) ([alexpop](https://github.com/alexpop))
- Update github links and change to version 0.3.0 [\#15](https://github.com/chef-cookbooks/audit/pull/15) ([alexpop](https://github.com/alexpop))
- offer native inspec-style syntax as an alternative [\#9](https://github.com/chef-cookbooks/audit/pull/9) ([arlimus](https://github.com/arlimus))
- lint files and activate travis testing [\#7](https://github.com/chef-cookbooks/audit/pull/7) ([chris-rock](https://github.com/chris-rock))
- add default attributes file [\#5](https://github.com/chef-cookbooks/audit/pull/5) ([srenatus](https://github.com/srenatus))
- audit::default: read profiles from attributes, push report to chefserver [\#2](https://github.com/chef-cookbooks/audit/pull/2) ([srenatus](https://github.com/srenatus))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*