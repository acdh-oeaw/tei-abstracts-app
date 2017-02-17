xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace httpclient="http://exist-db.org/xquery/httpclient";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace config="http://www.digital-archiv.at/ns/tei-abstracts/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/tei-abstracts/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize "method=json media-type=text/javascript";

let $temp := <temp>{
for $titleStmt in collection(concat($config:app-root, '/data/editions'))//tei:titleStmt
let $title := $titleStmt/tei:title
let $male := count($titleStmt//tei:author//tei:forename[@type='male'])
let $female := count($titleStmt//tei:author//tei:forename[@type='female'])
let $nomatch := count($titleStmt//tei:author//tei:forename[@type='no-match'])
let $gender := if ($male gt $female and $male gt $nomatch) 
    then 'male' 
    else if ($female eq $male and $female+$male gt $nomatch)
    then 'balanced'
    else if ($female gt $nomatch)
    then 'female'
    else if ($male eq $female and $male+$female gt $nomatch)
    then 'balanced'
    else 'unclear'

return
    <result>
        <gender>{$gender}</gender>
        <title>{$title/text()}</title>
        <doc>{app:getDocName($title)}</doc>
        <male>{$male}</male>
        <female>{$female}</female>
        <nomatch>{$nomatch}</nomatch>
    </result>
}</temp>

let $maletexts := count($temp//result/gender[text()='male'])
let $femaletexts := count($temp//result/gender[text()='female'])
let $balanced := count($temp//result/gender[text()='balanced'])
let $unclear := count($temp//result/gender[text()='unclear'])
return
    <hansi>
        <header>Texts by Gender</header>
        <male>{$maletexts}</male>
        <female>{$femaletexts}</female>
        <balanced>{$balanced}</balanced>
        <unclear>{$unclear}</unclear>
        <details>{$temp}</details>
    </hansi>