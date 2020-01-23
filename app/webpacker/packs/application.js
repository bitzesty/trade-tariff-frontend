/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

// import jQuery from 'jquery'
// window.$ = jQuery
// window.jQuery = jQuery
console.log('==jQuery.fn.jquery');
console.log(jQuery.fn.jquery);

require('popup');
require('select2');
require('jquery-migrate');
require('jquery.history');
require('jquery-tabs/jquery.tabs');
require('mark.js/dist/jquery.mark');
require('alphagov-static/app/assets/javascripts/analytics_toolkit/google-analytics-universal-tracker');
require('alphagov-static/app/assets/javascripts/analytics_toolkit/analytics');
require('alphagov-static/app/assets/javascripts/analytics_toolkit/govuk-tracker');
require('alphagov-static/app/assets/javascripts/analytics_toolkit/print-intent');
require('alphagov-static/app/assets/javascripts/analytics_toolkit/error-tracking');

console.log('==$.fn.mark');
console.log($.fn.mark);




// console.log('popup');
// console.log(BetaPopup);
// BetaPopup.popup('title', 'tariff-info');
// console.log(
//   require('jquery-debouncedresize')
// );
// console.log(
//   import('jquery-debouncedresize')
// );
// require('./node_modules/jquery-history/dist/jquery.history');
// require('../../../node_modules/jquery-history/dist/jquery.history');
// require('jquery-history/dist/jquery.history');

// require('../src/analytics-init.js');
require('../src/javascripts/analytics-search-queries.js');
require('../src/javascripts/commodities.js');
// TODO test:
require('../src/javascripts/exchange_rate.js');
require('../src/javascripts/feedback.js');
require('../src/javascripts/quota-search.js');
// CANT IMPORT!
// require('../src/stop-scrolling-at-footer.js');

import { initAll } from 'govuk-frontend';

initAll();

$(function(){
  GOVUK.tariff.onLoad();
});

// console.log(jQuery.History);
// console.log($.History);
console.log($.event.special.debouncedresize);

$(window).on("debouncedresize", function( event ) {
    console.log('onDebounced');
});

$(window).on("resize", function( event ) {
    console.log('NoDebounced');
});

console.log('Hello World from Webpacker')
