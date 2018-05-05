#!/bin/sh
# jslint-utility2

shNpmScriptApidocRawCreate () {(set -e
# this function will create the raw apidoc
    export npm_config_npm_package_name="${npm_config_npm_package_name:-$npm_package_name}"
    cd tmp/apidoc.raw
    find . -path ./.git -prune -o -type f | \
        xargs -I % -n 1 sh -c "[ ! -s % ] && printf 'empty-file %\\n' 1>&2"
    find . -path ./.git -prune -o -name index.html -type f | \
        sed -e "s/^\.\///" -e "s/\/index.html//" | \
        sort | \
        xargs -I % -n 1 sh -c \
            "printf '\\n\\n# curl -L %\\n' && cat %/index.html | sed -e '/./,\$!d'" | \
        sed -e "s| *\$||" > ".apidoc.raw.$npm_config_npm_package_name.html"
    cp ".apidoc.raw.$npm_config_npm_package_name.html" ../..
)}

shNpmScriptApidocRawFetch () {(set -e
# this function will fetch the raw apidoc
    export npm_config_npm_package_name="${npm_config_npm_package_name:-$npm_package_name}"
    mkdir -p tmp/apidoc.raw && cd tmp/apidoc.raw
    rm -f "apidocRawFetch.$npm_config_npm_package_name.log"
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
var local, options;
local = require("../../assets.utility2.rollup.js");
switch (process.env.npm_config_npm_package_name) {
case "swgg-google-maps":
    options = { urlList: ["https://developers.google.com/maps/documentation/"] };
    break;
default:
    options = { urlList: [] };
}
local.ajaxCrawl(local.objectSetDefault({
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
    }
}, options), local.onErrorDefault);
// </script>
' 2>&1 | tee -a "apidocRawFetch.$npm_config_npm_package_name.log"
    find . -path ./.git -prune -o -type f | \
        xargs -I % -n 1 sh -c "[ ! -s % ] && printf 'empty-file %\\n' 1>&2" | \
        tee -a "apidocRawFetch.$npm_config_npm_package_name.log"

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
'
)}

shNpmScriptPostinstall () {
# this function will do nothing
    return
}

# run command
"$@"
