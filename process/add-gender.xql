xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace httpclient="http://exist-db.org/xquery/httpclient";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace config="http://www.digital-archiv.at/ns/tei-abstracts/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/tei-abstracts/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
(:declare $base = "http://127.0.0.1:8000";:)
(:declare $path := "/api/name/?format=json&amp;name=";:)

for $forename in collection(concat($config:app-root, '/data/'))//tei:forename
    let $name := $forename/text()
    let $base := "http://127.0.0.1:8000"
    let $path := "/api/name/?format=json&amp;name="
    let $url := $base||$path||encode-for-uri($name)
    let $request := httpclient:get(xs:anyURI($url),  true(), <Headers/>)
    let $json : = util:base64-decode($request//httpclient:body/text())
    let $parsed := parse-json($json)
    let $gender := try{
        $parsed?results(1)?sex?sex} catch * {'no-match'}
    let $new:= update insert attribute type {$gender} into $forename
    return $gender

