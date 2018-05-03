#!/bin/sh
# jslint-utility2

shNpmScriptApidocRawCreate () {(set -e
# this function will create the raw apidoc
    cd tmp/apidoc.raw
    find developer.github.com/v3 -name index.html -type f | \
        sed -e "s/\/index.html//" | \
        sort | \
        sed -e "s/\(developer.github.com\/.*\)/\1\/index.html/" | \
        xargs -I @ -n 1 sh -c "printf '\\n@\\n' && cat @" | \
        sed -e "s| *\$||" > .apidoc.raw.html
    cp .apidoc.raw.html ../..
)}

shNpmScriptApidocRawFetch () {(set -e
# this function will fetch the raw apidoc
    mkdir -p tmp/apidoc.raw && cd tmp/apidoc.raw
    rm -fr cloud.google.com developers.google.com
    node -e '
// <script>
/* jslint-utility2 */
/*jslint
    bitwise: true,
    browser: true,
    maxerr: 4,
    maxlen: 100,
    node: true,
    nomen: true,
    regexp: true,
    stupid: true
*/
"use strict";
var local;
local = require("../../assets.utility2.rollup.js");
local.dict = {};
switch (process.argv[1]) {
case "swgg-google-maps":
    local.list = ["https://developers.google.com/maps/documentation/"];
    break;
default:
    local.list = [];
}
local.onParallelList({
    list: process.argv[1].split("\n"),
    rateLimit: 1
}, function (options2, onParallel) {
    var url;
    url = options2.element;
    onParallel.counter += 1;
    if (!url || url[0] === "#") {
        onParallel();
        return;
    }
    console.error("\n\n" + options2.ii + ". " + url + "\n");
    local.ajaxCrawl({
        depth: 2,
        dict: local.dict,
        dir: ".",
        filter: function (options) {
            return (/\b(?:rest)\b/).test(options.url) || !new RegExp("\\b(?:" +
/* jslint-ignore-begin */
"\
android|\
apps-script|\
dotnet|\
go|\
ios|\
java|\
javascript|\
js|\
nodejs|\
php|\
python|\
ruby|\
sdk" +
/* jslint-ignore-end */
                ")\\b|\\bc\\+\\+").test(options.url);
        },
        postProcess: function (data) {
            return data
                .replace((/<[^>]*? name="xsrf_token"[^>]*?>/g), "")
                .replace((/ data-request-elapsed="[^"]*?"/g), "");
        },
        urlList: [url]
    }, onParallel);
}, local.onErrorDefault);
// </script>
' 2>&1 | tee apidocRawFetch.log

: '
# https://console.cloud.google.com/apis/library
#!! https://cloud.google.com/compute/docs/oslogin/rest/
#!! https://cloud.google.com/container-builder/docs/api/reference/rest/
#!! https://cloud.google.com/dlp/docs/reference/rest/
#!! https://cloud.google.com/resource-manager/reference/rest/
#!! https://cloud.google.com/speech-to-text/docs/reference/rest/
#!! https://cloud.google.com/vision/docs/reference/rest/
#!! https://developers.google.com/ad-exchange/buyer-rest/v1.4/
#!! https://developers.google.com/ad-exchange/seller-rest/reference/v2.0/
#!! https://developers.google.com/admin-sdk/reports/v1/reference/
#!! https://developers.google.com/adsense/management/v1.4/reference/
#!! https://developers.google.com/amp/cache/reference/acceleratedmobilepageurl/rest/
#!! https://developers.google.com/apps-script/api/reference/rest/
#!! https://developers.google.com/blogger/docs/3.0/reference/
#!! https://developers.google.com/civic-information/docs/v2/
#!! https://developers.google.com/doubleclick-publishers/docs/reference/v201802/ActivityGroupService.ActivityGroup
#!! https://developers.google.com/fusiontables/docs/v2/reference/
#!! https://developers.google.com/gsuite/marketplace/v2/reference/
#!! https://developers.google.com/speed/docs/insights/v4/reference/



#!! https://developers.google.com/zero-touch/reference/customer/rest/
#!! https://developers.google.com/google-apps/activity/v1/reference/
#!! https://cloud.google.com/ml-engine/reference/rest/
#!! https://cloud.google.com/translate/docs/reference/rest
#!! https://developers.google.com/ad-exchange/buyer-rest/reference/rest/
#!! https://developers.google.com/android/management/reference/rest/
#!! https://developers.google.com/android/over-the-air/reference/rest/

https://developers.google.com/maps/documentation/

#!! https://developers.google.com/youtube/v3/docs/
#!! https://developers.google.com/youtube/v3/live/docs/
#!! https://cloud.google.com/bigquery/docs/reference/
#!! https://cloud.google.com/billing/reference/rest/
#!! https://cloud.google.com/kms/docs/reference/rest/
#!! https://cloud.google.com/natural-language/docs/reference/rest/
' 2>&1 | tee apidocRawFetch.log
)}

shNpmScriptPostinstall () {
# this function will do nothing
    return
}

# run command
"$@"
