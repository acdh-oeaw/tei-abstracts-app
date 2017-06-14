xquery version "3.0";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace config="http://www.digital-archiv.at/ns/tei-abstracts/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/tei-abstracts/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

for $person in collection(concat($config:app-root, '/data/editions/'))//tei:titleStmt//tei:author//tei:persName
let $key := data($person/@key)
let $sex := doc(concat($config:app-root, '/data/indices/listperson.xml'))//tei:persName[@key=$key]/tei:forename/@type
let $forename := $person/tei:forename
let $new:= update insert attribute type {$sex} into $forename

return 
    $forename
