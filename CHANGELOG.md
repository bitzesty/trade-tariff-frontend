# Change Log

## [December 20, 2019](https://github.com/bitzesty/trade-tariff-frontend/compare/b93b87ddf6df3bc00daed4d52dd122433a1cd00d...0ac45a6dce27477da8add5671d3a84a49e032517)

### Added
- Minor optimisations for JSONAPI parses
- Improve search results for exact and fuzzy search
- Add footnotes search
- Add cross domain event tracking
- Improve errors handling
- Add search results pagination
- Minor CSS tweaks

### Changed
- Move API documentation link to "Related information" section in page footer
- Use bootsnap instead of bootscale
- Update additional codes search
- Update google analytics token
- Fix query string forwarding
- Expose search api (forwarded to backend)
- Update puma to 3.12.2
- Redirect to v2 bu default

### Removed
- Remove simplecov-rcov
- Hide search bar for a-z index and exchange rates


## [June 14, 2019](https://github.com/bitzesty/trade-tariff-frontend/compare/8769ff1635cdc769445b78a434eb1e3b9d601e68...c870a6da3ef9c4724f7d62fca752801313c086c2)

### Added
- Add env variable to hide legal base column
- Add IP and Auth locking
- Add API v1 routes
- Add link to API documentation to footer
- Use new API v2
- Add `Cache-Control` header to all forwarded API calls
- Add scout_apm
- Track custom events with google analytics
- Add faraday
- Add quota search
- Use `api` prefix to V1 and V2 routes

### Changed
- Upgrade ruby to 2.6.2
- Replace route `v1/commodities/codes` with `v1/(commodities)/goods_nomenclature`
- Replace route `v1/(commodities)/goods_nomenclature` with `v1/goods_nomenclature`
- Increasing HTTParty timeout
- Switch to blue-green-deploy from autopilot
- Switch to new JSONAPI parser
- Redirect v1 quota/search to v2

### Removed
- Remove currency param that no longer applies
- Hide BTI link if regs are not enabled
- Remove "update" endpoints from proxy-able API methods
- Remove rack-timeout gem
- Remove newrelic
- Remove HTTParty
- Remove heading code from commodity tree
- Remove requirement for `.json` extension on API calls


## [February 1, 2019](https://github.com/bitzesty/trade-tariff-frontend/compare/7ffe0c3afb012fa98fc25d257901c35f1746b16a...c5115a46acd5662224e16bf18deae4b170660ddc)


### Added
- Use redis store for caching
- Use paas redis service
- GitlabCI integration
- Add env variable to disable/enable currency picker
- Displaying links for chapter guidance and discussion forum
- Display duty_expression for measure condition
- Add govuk link and run autocorrect

### Changed
- Make footnote code as a link for popup for single footnote
- Extra information on commodity page
- Minor CSS tweaks
- Select unique duty expressions
- Display 10 or 8 numbers for commodity codes
- Fix geographical areas ordering
- Making all pages wider
- Upgrade rails to 5.1.6.1
- Upgrade ruby to 2.5.3
- Fix CORS

### Removed
- Remove “dalli” gem
- Remove CircleCI integration


## [November 6, 2018](https://github.com/bitzesty/trade-tariff-frontend/compare/7ffe0c3afb012fa98fc25d257901c35f1746b16a...c5115a46acd5662224e16bf18deae4b170660ddc)

### Added
- Add chapter and section notes for non-declarable headings
- Render footnotes from API payload
- Add exchange rates page
- Add a link to the forum
- New 500 error page
- Add browserconfig.xml
- Add manifest file for DIT jenkins integration

### Changed
- Upgrade ruby to 2.5.0
- Change chapter notes position
- Moving additional code info from modal to inline in Measure column
- Minor CSS tweaks
- Displaying all footnotes, even the ones not direclty associated with declarables
- Upgrade rails to 5.1.5
- Update copy on ECO footnote notice

### Removed
- Hide duty expression ID = '37' (NIHIL)


## [January 18, 2018]

### Changed
- Update `ruby` version to `2.4.3`.

## [August 28, 2017]

### Added
- Set `default_url_options`
- Search suggestions
- Tweaking print styles
- Feedback form
- `aws-sdk` and `aws-sdk-rails`

### Changed
- Search term from `params[:search][:q]` to `params[:q]`
- Not include day, month and year params if they are today
- Stop using select2 for date select
- Used form_tag instead of form_for for searching
- Downcase search term
- Enabled search green button
- `Rails` upgraded to 5.1.3, `coffee-rails` to 4.2.2, `jquery-rails` to 4.2.2
- Update `ruby` version to `2.4.1`.

### Removed
- `commodity_codes` endpoint
- `quiet_assets` gem
- ActionDispatch::ParamsParser::DEFAULT_PARSERS was deprecated and `remove_parsers.rb` initializer was removed

[August 28, 2017]: https://github.com/bitzesty/trade-tariff-frontend/compare/a72e3a4...9c2d125


## [May 27, 2017]

Maintained at now at the Bit Zesty repo - not the alphagov one.

### Added
- Commodity code search complete
- Snyk
- Sentry (Error tracking)
- New Relic
- Select2 for geographical area search
- Custom footer
- maintance page
- Robots.txt

### Changed
- Travis to CircleCI
- Google analytics account change
- Updated designs
- Moved some configuration into environment variables

### Removed
- GDS report a problem, will replace with another form

[May 27, 2017]: https://github.com/bitzesty/trade-tariff-frontend/compare/ac8b487...b120373

## [August 05, 2016]

### Added
- Add connection pool for memcached.
- Add Slack notifications from the deploy script.
- Add the `rack-timeout` gem.
- Set the server name for `Raven`.
- Add custom errors pages instead of default pages from rails.
- Add noindex metatag on atom feeds.
- Add attribute rel="nofollow" to changes links.

### Changed
- Update `SearchReferencePresenter` to not expect the `referenced` association.
- Update deploy script.
- Update logs format.
- Update `dalli` gem.
- Update `puma` gem.
- Implement low level caching to backend requests.
- Simplify Search#countries method.
- Add maintance mode page, redirect if `MAINTENANCE` env var is present.
- MultiJson.engine now uses `yajl`.
- Now the links persist the query-string of the date and country.

### Fixed
- Fix issue with n+1 requests to the backend API.

### Removed
- Remove the `therubyracer` gem.
- Remove ci reporter rake tasks.

[August 05, 2016]: https://github.com/bitzesty/trade-tariff-frontend/compare/bcb1ea1...58633f0

## [July 25, 2016]

### Added
- Add `newrelic`.
- Ensure `puma` establishes the connection on boot.
- Add `dalli` gem.
- Add `lograge` gem and configuration.
- Ignore from git all CloudFoundry manifest files.
- Add deploy script.

### Changed
- Update `ruby` version to `2.3.1`.
- Update `sentry-raven`.
- Switch to use memcached, use `dalli` as cache_store.
- Enable threadsafe mode in production.
- Update README.
- Update puma configuration to have 1 worker by default.


### Fixed
- Fix issue with the proxy to backend.
- Fix issue with duplicated titles.

### Removed
- Remove hard-coded text about changes in procedures.
- Remove `jenkins.sh` file.

[July 25, 2016]: https://github.com/bitzesty/trade-tariff-frontend/compare/69114b5...1c74294


## [June 16, 2016]

### Added
- Add `rspec_junit_formatter` gem.
- Add `secrets.yml` file.
- Add `.cfignore` file as a symlink of the `.gitignore` file.
- Add `rails_12factor` gem.


### Changed
- Switch from Travis to CircleCI.
- Update `ruby` version to `2.2.3`.
- Prepare the application to work in CloudFoundry.
- Switch from `Unicorn` to `Puma`.
- Update `govuk_template` gem.
- Update `govuk_frontend_toolkit` gem.
- Update headings partial to use `formatted_description`.
- Update `README`.
- Replace Airbrake with Sentry.

### Fixed
- Unescape content in additional code description.
- Fix issues with Dates and timezones
- Fix vcr cassette with missing `formatted_description`
 key.

### Removed
- Remove travis configuration file.
- Remove logstasher.
- Remove capistrano.
- Remove `govuk_artefact` dependency.

[June 16, 2016]: https://github.com/bitzesty/trade-tariff-frontend/compare/eb1f40b...69114b5


## [March 01, 2016]

### Added
- Display the country code in the measures collection.
- Add a link to GOV.UK's Terms and Conditions to the footer.
- Add codeclimate configuration file.
- Paragraph added so the users will know about the import, export and storage procedures are changing.

### Changed
- `nokogiri` gem updated.
- Upgrade `rails` to `4.2.5.2`
- `govuk_template` gem updated.
- Use bearer token for publishing API authentication.

### Removed
- Remove the `bundler-audit` gem and rake task.
- Remove redundant precompiled assets

[March 01, 2016]: https://github.com/bitzesty/trade-tariff-frontend/compare/58633f0...eb1f40b

## [September 23, 2015]

### Added
- Rake task to register special routes.
- Meta description to trade tariff

### Changed
- `gds-api-adapters` gem updated.
- `uglifier` gem updated.
- Update README

### Fixed
- Fix broken background image in the tariff styles.

### Removed
- Remove panopticon registration

[September 23, 2015]: https://github.com/bitzesty/trade-tariff-frontend/compare/bcb1ea1...58633f0

## [release_754...release_776](https://github.com/alphagov/trade-tariff-frontend/compare/release_754...release_776)
### Changed
- Upgraded Ruby version to 2.2.2
- Upgraded Rails version to 4.2.3
- GOVUK Classic removed
- API request_forwarder now passes on query strings so we can do pagenatination
- Fix licences typo

### Added
- Links to Volume 1 and 3

### Removed
- Need IDs custom dimension not used anymore

## [release_742...release_754](https://github.com/alphagov/trade-tariff-frontend/compare/release_742...release_754)
### Changed
- Modified padding between letters in az-index
- Modified padding for .related-module
- Fixed bundler audit in production
- Corrected copyright notice
- Anonymized the IP addresses in UA
- Upgraded Ruby version to 2.2.1
- Upgraded Rails version to 4.2
- Upgraded gds-api-adapters, govspeak, rspec, capistrano among others

### Added
- Used frontend_toolkit analytics

## [release_727...release_742](https://github.com/alphagov/trade-tariff-frontend/compare/release_727...release_742)
### Changed
- Removed slimmer, now just using govuk_template
- upgrades to breakman and sprockets

### Added
- default rake task which runs the specs
- specs for the A-Z
- bundler-audit added to check for security vulnerabilities

## [release_707...release_727](https://github.com/alphagov/trade-tariff-frontend/compare/release_707...release_727)
### Changed
- Upgrade Rails to 4.1.8 from 3.2.18
- Upgrade Ruby to 2.1.4 from 1.9.3
- Update slimmer from 3.25.0 to 5.0.1. Fixing the MetaViewportRemover and adds
  "Is there anything wrong with this page?"

### Added
- Show the last successful sync date using "Last updated:"
