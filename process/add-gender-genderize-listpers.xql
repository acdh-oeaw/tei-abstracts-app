xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace httpclient="http://exist-db.org/xquery/httpclient";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace config="http://www.digital-archiv.at/ns/tei-abstracts/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/tei-abstracts/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare variable $base := "http://127.0.0.1:8000";
declare variable $path := "/api/name/?format=json&amp;name=";
declare variable $genderize := "https://api.genderize.io/?name=";


let $seq := collection(concat($config:app-root, '/data/indices/'))//tei:forename
(:return count($seq):)
(:for $forename in subsequence($seq, 26) :)
for $forename in $seq
    let $name := $forename/text()
(:    let $url := $base||$path||encode-for-uri($name):)
    let $url := $genderize||encode-for-uri($name)
    let $request := httpclient:get(xs:anyURI($url),  true(), <Headers/>)
    let $json : = util:base64-decode($request//httpclient:body/text())
    let $parsed := parse-json($json)
    let $gender := $parsed?gender
    let $result := if($gender eq 'male')
        then "male"
        else if($gender eq 'female')
        then 'female'
        else "no-match"
    let $new:= update insert attribute type {$result} into $forename
    return $result