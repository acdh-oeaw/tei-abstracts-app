xquery version "3.1";
import module namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace httpclient="http://exist-db.org/xquery/httpclient";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace config="http://www.digital-archiv.at/ns/tei-abstracts/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/tei-abstracts/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

let $ID := 'Armaselu.xml'
let $collection := 'editions'

let $doc := doc($config:app-root||'/data/'||$collection||'/'||$ID)
return 
    <result>
        <somethingFound>
            {$doc}
        </somethingFound>
    </result>
