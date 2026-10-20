# Torii Pixel for Google Tag Manager

This web-container template loads Torii's existing pixel. Page views run on
load; optional automatic capture and cross-domain linking are off by default.
The template is available for manual import.

## Install

1. Download [`template.tpl`](template.tpl), or use Torii's pixel Install page.
2. In a **test** GTM web container, open Templates → New → menu → Import.
   Import the file, review permissions, and run its Tests tab before saving.
3. Create a Torii Pixel tag. Paste the connection's Pixel ID from Torii.
4. Select only the capture features you want. Page views need no option;
   SPA routes need the SPA option. Remove manual router page-view calls.
5. Optional linker domains are comma-separated hostnames, such as
   `shop.example.com, *.myshopify.com`. Install the same pixel on destinations.
6. Set the tag's firing option to **Once per page**. Choose the page trigger
   and configure Consent Settings/additional checks for your site's policy.
   The consent-first option is off by default. To hold collection, enable it here and on the Torii pixel, then forward CMP choices with `Torii.consent(state)` or Consent Mode commands in `dataLayer`. All four permissions are required. Test both grant and withdrawal before publishing.
7. Preview in Tag Assistant on a test site. Confirm one pixel loads, events arrive
   in Torii, and opted-in capture works. Then publish your GTM container.

Use either this GTM tag or a direct script installation on each page. Different
configurations for the same pixel on one page are unsupported. GTM's success
callback means the script loaded; it does not prove Torii accepted events.

## Consent-first collection

Enable **Require consent before collection** in the tag and on the Torii pixel.
The SDK then waits for all four Consent Mode grants before accessing browser
storage or collecting events. Unknown/denied consent blocks collection, and
early events are dropped. Forward every CMP preference change, including
withdrawal, through `Torii.consent(state)` or Consent Mode `dataLayer` commands.
GTM's internal consent state alone is not read by the SDK. A TCF bridge is
available with an explicitly configured vendor and purpose mapping.

See the [Torii consent integration guide](https://github.com/EdgeDigital/ToriiData/blob/main/docs/CONSENT_FIRST_COLLECTION.md).

## Optional custom tracking domain

Leave Tracking origin blank to use `https://app.toriidata.com`. No client DNS
is needed for the default. For first-party serving, register a tracking hostname
with Torii hosting, configure DNS, and wait for HTTPS before entering its origin.
In the template's **Permissions**, add your exact
`https://your-tracking-host/torii.js*` to `inject_script` allowed URLs. The shipped
permission allows only `https://app.toriidata.com/torii.js*`.

Enable server cookies only for a custom origin on the same site as the page.
They are not enabled by default. A configured but unreachable custom origin
does not automatically fall back to the app. Fix DNS/TLS or clear the setting.

## Check an installation

In Torii's Installation Check, enter the measured site's URL. Static script
tags are matched by their actual `src` and Pixel ID. Dynamically injected tags
are confirmed by an SDK event from that exact site origin within 24 hours.
GTM template events are labelled as GTM. A GTM container alone, events from
another site, and old events do not confirm the requested site's install.
Visit the site after consent allows the tag, then re-run the check. An event
confirms recent SDK execution on the site, not execution on every page.

Custom HTML also works: paste the direct script from Torii's Install page into
a GTM Custom HTML tag, using the same once-per-page trigger and consent setup.
It is recognised from SDK activity even without the GTM template marker.

Maintained by Edge Digital. Template files in this directory are Apache-2.0;
see LICENSE. This licence does not apply to other Torii application source.

References: [GTM custom templates](https://developers.google.com/tag-platform/tag-manager/templates),
[sandbox APIs](https://developers.google.com/tag-platform/tag-manager/templates/api),
[tests](https://developers.google.com/tag-platform/tag-manager/templates/tests).
