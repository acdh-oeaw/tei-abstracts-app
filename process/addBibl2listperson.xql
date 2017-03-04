xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace httpclient="http://exist-db.org/xquery/httpclient";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace config="http://www.digital-archiv.at/ns/tei-abstracts/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/tei-abstracts/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

for $person in doc(concat($config:app-root, '/data/indices/listperson.xml'))//tei:person
let $key := data($person/tei:persName/@key)
let $posts := collection(concat($config:app-root, '/data/editions'))//tei:titleStmt[.//tei:author/tei:persName/@*=$key]
let $listBibl := <listBibl xmlns="http://www.tei-c.org/ns/1.0">{for $x in $posts return 
                    <bibl xmlns="http://www.tei-c.org/ns/1.0">
                        <title xmlns="http://www.tei-c.org/ns/1.0" key="{app:getDocName($x)}">{($x//tei:title)[1]/text()}</title>
                    </bibl>}
                </listBibl>
where count($posts) gt 0
return 
    update insert $listBibl into $person