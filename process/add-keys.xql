xquery version "3.0";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace config="http://www.digital-archiv.at/ns/tei-abstracts/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/tei-abstracts/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

for $author in collection(concat($config:app-root, '/data/editions/'))//tei:titleStmt//tei:author/tei:persName
let $normID := data($author/@ref)
let $namestring := string-join(($author/tei:forename/text(), $author/tei:surname/text()),'')
let $id := if (exists($normID)) then $normID else "genID"||util:hash($namestring, 'md5')
let $new:= update insert attribute key {$id} into $author
return 
    <hansi>done</hansi>
