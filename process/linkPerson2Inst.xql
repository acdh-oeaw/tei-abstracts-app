xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace httpclient="http://exist-db.org/xquery/httpclient";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace config="http://www.digital-archiv.at/ns/tei-abstracts/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/tei-abstracts/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";


let $instPerson := doc(concat($config:app-root, '/process/linkPerson2Inst.xml'))
for $person in doc(concat($config:app-root, '/data/indices/listperson.xml'))//tei:person
let $match := $instPerson//tei:item[./tei:surname/text()=$person//tei:surname/text()]/tei:org
let $org := 
    <tei:affiliation>
        {doc(concat($config:app-root, '/data/indices/listorg.xml'))//tei:org[starts-with(./tei:orgName/text(), $match/text())]/*} 
    </tei:affiliation>
return 
    update insert $org into $person
(:    $org:)