#!/bin/bash
 
storage_account="$1"
local_file="$2"
container_name="$3"
access_key="$4"
file_length=$(stat -c%s $local_file)
 
blob_store_url="blob.core.windows.net"
 
request_method="PUT"
request_date=$(TZ=GMT LC_ALL=en_US.utf8 date "+%a, %d %h %Y %H:%M:%S %Z")
#request_date="Mon, 18 Apr 2016 05:16:09 GMT"
storage_service_version="2015-04-05"
 
x_ms_date_h="x-ms-date:$request_date"
x_ms_version_h="x-ms-version:$storage_service_version"
x_ms_blob_h="x-ms-blob-type:BlockBlob"
 
canonicalized_headers="${x_ms_blob_h}\n${x_ms_date_h}\n${x_ms_version_h}"
canonicalized_resource="/${storage_account}/${container_name}"
 
string_to_sign="${request_method}\n\n\n$file_length\n\n\n\n\n\n\n\n\n${canonicalized_headers}\n${canonicalized_resource}"
 
decoded_hex_key="$(echo -n $access_key | base64 -d -w0 | xxd -p -c256)"
 
signature=$(printf "$string_to_sign" | openssl dgst -sha256 -mac HMAC -macopt "hexkey:$decoded_hex_key" -binary |  base64 -w0)
 
authorization_header="Authorization: SharedKey $storage_account:$signature"
 
curl \
  -X PUT \
  -T "$local_file" \
  -H "$x_ms_date_h" \
  -H "$x_ms_version_h" \
  -H "$authorization_header" \
  -H "$x_ms_blob_h" \
  -H "Content-Length: $file_length" \
  "https://${storage_account}.${blob_store_url}/${container_name}"
 
