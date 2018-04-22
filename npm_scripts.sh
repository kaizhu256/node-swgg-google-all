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
    rm -f apidocRawFetch.log main.html
    rm -fr cloud.google.com && mkdir -p cloud.google.com
    rm -fr developers.google.com && mkdir -p developers.google.com
    node -e '
// <script>
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
local.fetch = function (options, onError) {
    var ii, file;
    if (options.url.indexOf("https://") !== 0) {
        options.url = options.url[0] === "/"
            ? options.prefix.replace((/\.com.*?$/), ".com") + options.url
            : options.prefix + "/" + options.url;
        options.url = options.prefix.replace((/\.com.*?$/), ".com") + "/" + options.url;
    }
    options.url = options.url
        .replace("https://", "")
        .replace((/\/{2,}/g), "/")
        .replace((/[?#].*?$/), "");
    file = options.url.replace((/\/$/), "") + "/index.html";
    if (!(/^cloud.google.com|^developers.google.com/).test(options.url) || local.dict[file]) {
        onError();
        return;
    }
    local.dict[file] = true;
    ii = local.ii;
    local.ii += 1;
    options.url = "https://" + options.url;
    local.ajax({ prefix: options.prefix, url: options.url }, function (error, xhr) {
        local.fsWriteFileWithMkdirpSync(file, xhr.responseText);
        console.error((ii + 1) + ". fetched " + options.url);
        xhr.prefix = options.url;
        onError(error, xhr);
    });
};
local.ii = 0;
local.onParallelList({
    list: process.argv[1].split("\n").filter(function (element) {
        return element;
    })
}, function (options2, onParallel) {
    onParallel.counter += 1;
    local.fetch({ url: options2.element }, function (error, xhr) {
        //!! ((xhr && xhr.responseText) || "").replace((/href="(.*?)"/g), function (match0, match1) {
            //!! match0 = match1;
            //!! onParallel.counter += 1;
            //!! local.fetch({ prefix: options2.element, url: match0 }, onParallel);
        //!! });
        //!! onParallel(error);
    });
}, local.onErrorDefault);
// </script>
' '
https://cloud.google.com/bigquery/docs/reference/datatransfer/rest/
https://cloud.google.com/bigquery/docs/reference/rest/v2/
https://cloud.google.com/billing/reference/rest/
https://cloud.google.com/compute/docs/oslogin/rest/
https://cloud.google.com/container-builder/docs/api/reference/rest/
https://cloud.google.com/dlp/docs/reference/rest/
https://cloud.google.com/kms/docs/reference/rest/
https://cloud.google.com/ml-engine/reference/rest/
https://cloud.google.com/natural-language/docs/reference/rest/
https://cloud.google.com/resource-manager/reference/rest/
https://cloud.google.com/speech-to-text/docs/reference/rest/
https://cloud.google.com/translate/docs/reference/rest
https://cloud.google.com/vision/docs/reference/rest/
https://developers.google.com/ad-exchange/buyer-rest/reference/rest/
https://developers.google.com/ad-exchange/buyer-rest/v1.4/
https://developers.google.com/ad-exchange/seller-rest/reference/v2.0/
https://developers.google.com/admin-sdk/reports/v1/reference/
https://developers.google.com/adsense/management/v1.4/reference/
https://developers.google.com/amp/cache/reference/acceleratedmobilepageurl/rest/
https://developers.google.com/android/management/reference/rest/
https://developers.google.com/android/over-the-air/reference/rest/
https://developers.google.com/apps-script/api/reference/rest/
https://developers.google.com/blogger/docs/3.0/reference/
https://developers.google.com/civic-information/docs/v2/
https://developers.google.com/fusiontables/docs/v2/reference/
https://developers.google.com/google-apps/activity/v1/reference/
https://developers.google.com/gsuite/marketplace/v2/reference/
https://developers.google.com/maps/documentation/
https://developers.google.com/speed/docs/insights/v4/reference/
https://developers.google.com/youtube/v3/docs/
https://developers.google.com/youtube/v3/live/docs/
https://developers.google.com/zero-touch/reference/reseller/rest/
' 2>&1 | tee -a apidocRawFetch.log
)}

shNpmScriptPostinstall () {
# this function will do nothing
    return
}

# run command
"$@"
