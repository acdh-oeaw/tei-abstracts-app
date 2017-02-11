xquery version "3.0";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace config="http://www.digital-archiv.at/ns/tei-abstracts/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/tei-abstracts/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare function functx:is-node-in-sequence-deep-equal
  ( $node as node()? ,
    $seq as node()* )  as xs:boolean {

   some $nodeInSeq in $seq satisfies deep-equal($nodeInSeq,$node)
 } ;

declare function functx:distinct-deep
  ( $nodes as node()* )  as node()* {

    for $seq in (1 to count($nodes))
    return $nodes[$seq][not(functx:is-node-in-sequence-deep-equal(
                          .,$nodes[position() < $seq]))]
 } ;

let $tempList := <list>{
for $author in collection(concat($config:app-root, '/data/editions/'))//tei:titleStmt//tei:author/tei:persName
    let $normID := data($author/@ref)
    let $namestring := string-join(($author/tei:forename/text(), $author/tei:surname/text()),'')
    let $id := if (exists($normID)) then $normID else "genID"||util:hash($namestring, 'md5')
    return
        <tei:person>
            <tei:persName key="{$id}">
                <tei:forename>{$author/tei:forename/text()}</tei:forename>
                <tei:surname>{$author/tei:surname/text()}</tei:surname>
            </tei:persName>
        </tei:person>
}
</list>

let $root_doc := doc(concat($config:app-root, '/data/indices/listperson.xml'))

let $personList := <tei:listPerson>{
    for $x in functx:distinct-deep($tempList//tei:person)
        return
            $x
    }</tei:listPerson>

let $updated := update replace $root_doc//tei:listPerson with $personList

return $updated
