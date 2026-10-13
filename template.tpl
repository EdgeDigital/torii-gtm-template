___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "categories": [
    "ANALYTICS",
    "ATTRIBUTION",
    "CONVERSIONS"
  ],
  "displayName": "Torii Pixel",
  "description": "Install the Torii pixel with optional automatic capture, SPA page views and cross-domain linking.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "pixelId",
    "displayName": "Pixel ID",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "help": "Copy the pixel connection ID from Torii\u0027s Install page."
  },
  {
    "type": "TEXT",
    "name": "trackingOrigin",
    "displayName": "Tracking origin (optional)",
    "simpleValueType": true,
    "help": "Leave blank for https://app.toriidata.com. For a custom HTTPS origin, complete DNS/TLS setup and add https://your-tracking-host/torii.js* to this template\u0027s inject_script permission."
  },
  {
    "type": "CHECKBOX",
    "name": "serverCookies",
    "checkboxText": "Use server-set identity cookies",
    "simpleValueType": true,
    "defaultValue": false,
    "help": "Requires a working custom tracking origin on the same site as the measured page."
  },
  {
    "type": "CHECKBOX",
    "name": "outbound",
    "checkboxText": "Track outbound link clicks",
    "simpleValueType": true,
    "defaultValue": false
  },
  {
    "type": "CHECKBOX",
    "name": "spa",
    "checkboxText": "Track single-page app routes",
    "simpleValueType": true,
    "defaultValue": false,
    "help": "Remove manual router page-view calls to avoid duplicates."
  },
  {
    "type": "CHECKBOX",
    "name": "forms",
    "checkboxText": "Track form submissions",
    "simpleValueType": true,
    "defaultValue": false,
    "help": "Field values are excluded. Use data-torii-event\u003dlead on lead forms. Identity capture requires a separate data-torii-identify attribute."
  },
  {
    "type": "CHECKBOX",
    "name": "buttons",
    "checkboxText": "Track button clicks",
    "simpleValueType": true,
    "defaultValue": false
  },
  {
    "type": "CHECKBOX",
    "name": "scroll",
    "checkboxText": "Track scroll depth",
    "simpleValueType": true,
    "defaultValue": false
  },
  {
    "type": "CHECKBOX",
    "name": "video",
    "checkboxText": "Track native HTML video plays",
    "simpleValueType": true,
    "defaultValue": false
  },
  {
    "type": "CHECKBOX",
    "name": "shopify",
    "checkboxText": "Stamp Shopify cart attribution",
    "simpleValueType": true,
    "defaultValue": false,
    "help": "For Shopify storefronts only. Checkout tracking still needs its separate installation."
  },
  {
    "type": "TEXT",
    "name": "linkerDomains",
    "displayName": "Linker domains (optional)",
    "simpleValueType": true,
    "help": "Comma-separated hostnames, e.g. shop.example.com, *.myshopify.com. Install this same pixel on each destination."
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const injectScript = require('injectScript');
const queryPermission = require('queryPermission');
const encodeUriComponent = require('encodeUriComponent');
const makeString = require('makeString');
const parseUrl = require('parseUrl');

const id = makeString(data.pixelId || '').trim().toLowerCase();
let validId = id.length === 36;
for (let i = 0; i < id.length; i++) {
  const hyphen = i === 8 || i === 13 || i === 18 || i === 23;
  if (hyphen ? id.charAt(i) !== '-' : '0123456789abcdef'.indexOf(id.charAt(i)) === -1) validId = false;
}
if (!validId) { data.gtmOnFailure(); return; }

const configured = makeString(data.trackingOrigin || '').trim();
const parsed = parseUrl(configured || 'https://app.toriidata.com');
if (!parsed || parsed.origin.indexOf('https://') !== 0 || !parsed.hostname
  || parsed.username || parsed.password || parsed.search || parsed.hash
  || (parsed.pathname && parsed.pathname !== '/')) {
  data.gtmOnFailure(); return;
}
if (data.serverCookies === true && (!configured || parsed.origin === 'https://app.toriidata.com')) {
  data.gtmOnFailure(); return;
}

const features = [];
const featureNames = ['outbound', 'spa', 'forms', 'buttons', 'scroll', 'video', 'shopify'];
for (let i = 0; i < featureNames.length; i++) {
  if (data[featureNames[i]] === true) features.push(featureNames[i]);
}
const domains = [];
const rawDomains = makeString(data.linkerDomains || '').split(',');
for (let i = 0; i < rawDomains.length; i++) {
  const domain = rawDomains[i].trim().toLowerCase();
  if (!domain) continue;
  const host = domain.indexOf('*.') === 0 ? domain.slice(2) : domain;
  let valid = host.length > 0 && host.length <= 253;
  const labels = host.split('.');
  for (let j = 0; j < labels.length; j++) {
    const label = labels[j];
    if (!label || label.length > 63 || label.charAt(0) === '-' || label.charAt(label.length - 1) === '-') valid = false;
  }
  for (let j = 0; j < host.length; j++) {
    if ('abcdefghijklmnopqrstuvwxyz0123456789.-'.indexOf(host.charAt(j)) === -1) valid = false;
  }
  if (!valid) { data.gtmOnFailure(); return; }
  if (domains.indexOf(domain) === -1) domains.push(domain);
}

let url = parsed.origin + '/torii.js?id=' + encodeUriComponent(id) + '&installed_via=gtm';
if (features.length) url += '&autotrack=' + encodeUriComponent(features.join(','));
if (domains.length) url += '&linker=' + encodeUriComponent(domains.join(','));
if (data.serverCookies === true) url += '&server_cookies=1';
if (!queryPermission('inject_script', url)) { data.gtmOnFailure(); return; }
injectScript(url, data.gtmOnSuccess, data.gtmOnFailure, 'torii-pixel-' + id);


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://app.toriidata.com/torii.js*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Default origin and no optional capture
  code: |-
    runCode({pixelId: '6f1c1c6e-2b7a-4a43-9a1e-5d0f3b8f2a11'});
    assertThat(injectedUrl).isEqualTo('https://app.toriidata.com/torii.js?id=6f1c1c6e-2b7a-4a43-9a1e-5d0f3b8f2a11&installed_via=gtm');
    assertApi('gtmOnSuccess').wasCalled();
    assertApi('gtmOnFailure').wasNotCalled();
- name: Invalid pixel does not inject
  code: |-
    runCode({pixelId: 'not-a-pixel'});
    assertApi('injectScript').wasNotCalled();
    assertApi('gtmOnFailure').wasCalled();
- name: Capture and linker options are encoded
  code: |-
    runCode({pixelId: '6f1c1c6e-2b7a-4a43-9a1e-5d0f3b8f2a11', forms: true, spa: true, linkerDomains: 'shop.example.com, *.myshopify.com'});
    assertThat(injectedUrl).isEqualTo('https://app.toriidata.com/torii.js?id=6f1c1c6e-2b7a-4a43-9a1e-5d0f3b8f2a11&installed_via=gtm&autotrack=spa%2Cforms&linker=shop.example.com%2C*.myshopify.com');
- name: Permission denial prevents injection
  code: |-
    mock('queryPermission', function() { return false; });
    runCode({pixelId: '6f1c1c6e-2b7a-4a43-9a1e-5d0f3b8f2a11', trackingOrigin: 'https://t.client.example'});
    assertApi('injectScript').wasNotCalled();
    assertApi('gtmOnFailure').wasCalled();
setup: |-
  let injectedUrl = '';
  mock('queryPermission', function() { return true; });
  mock('injectScript', function(url, success, failure, cacheToken) {
    injectedUrl = url;
    success();
  });


___NOTES___

Copyright 2026 Edge Digital. Apache-2.0; see LICENSE.
Gallery submission requires an authenticated maintainer to agree to Google's Gallery terms in the Template Editor and export the final template.


