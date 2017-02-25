xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace httpclient="http://exist-db.org/xquery/httpclient";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace config="http://www.digital-archiv.at/ns/tei-abstracts/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/tei-abstracts/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize "method=json media-type=text/javascript";

let $result := <result>{
for $author in collection(concat($config:app-root, '/data/indices'))//tei:person
let $affiliation := $author//tei:affiliation//tei:orgName
group by $affiliation
return
    <payload>
        <name>{normalize-space($affiliation/text())}</name>
        <amount>{count($author)}</amount>
    </payload>
}</result>
return $result