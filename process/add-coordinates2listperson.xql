xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace httpclient="http://exist-db.org/xquery/httpclient";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace config="http://www.digital-archiv.at/ns/tei-abstracts/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/tei-abstracts/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

for $location in doc(concat($config:app-root, '/data/indices/listperson.xml'))//tei:location
let $key := "country_"||data($location/tei:country/@key)
let $geo := doc(concat($config:app-root, '/data/indices/listplace.xml'))//tei:place[@xml:id=$key]/tei:location/tei:geo
where count($geo/text()) gt 0
return 
    update insert $geo into $location