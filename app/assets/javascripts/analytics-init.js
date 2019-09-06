(function() {
  'use strict';

  // Load Google Analytics libraries
  GOVUK.Analytics.load();

  var cookieDomain = (document.domain === 'www.gov.uk') ? '.www.gov.uk' : document.domain;

  // Configure profiles and make interface public
  // for custom dimensions, virtual pageviews and events
  GOVUK.analytics = new GOVUK.Analytics({
    universalId: 'UA-145652997-1',
    cookieDomain: cookieDomain
  });

  ga('create', 'UA-145652997-1', 'auto', 'govuk_shared', {'allowLinker': true});
  ga('govuk_shared.require', 'linker');
  ga('govuk_shared.linker.set', 'anonymizeIp', true);
  ga('govuk_shared.linker:autoLink', [cookieDomain]);

  // Activate any event plugins eg. print intent, error tracking
  GOVUK.analyticsPlugins.error();
  GOVUK.analyticsPlugins.printIntent();

  // Track initial pageview
  GOVUK.analytics.trackPageview();

  // clicks on data-analytics-event
  $(document).on('click', '[data-analytics-event]', function(e){
    var $target = $(e.target);
    GOVUK.analytics.trackEvent('click', $target.data('analytics-event'), {
      label: e.target.innerText
    });
  });
})();
