xquery version "3.0";

module namespace api="http://www.digital-archiv.at/ns/tei-abstracts/api";
declare namespace rest = "http://exquery.org/ns/restxq";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
import module namespace functx = "http://www.functx.com";
import module namespace app="http://www.digital-archiv.at/ns/tei-abstracts/templates" at "app.xql";
import module namespace config="http://www.digital-archiv.at/ns/tei-abstracts/config" at "config.xqm";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace http = "http://expath.org/ns/http-client";

declare variable $api:JSON := 
<rest:response>
    <http:response>
      <http:header name="Content-Language" value="en"/>
      <http:header name="Content-Type" value="application/json; charset=utf-8"/>
    </http:response>
    <output:serialization-parameters>
    <output:method value='json'/>
      <output:media-type value='application/json'/>
    </output:serialization-parameters>
 </rest:response>;

declare variable $api:XML := 
<rest:response>
    <http:response>
      <http:header name="Content-Language" value="en"/>
      <http:header name="Content-Type" value="application/xml; charset=utf-8"/>
    </http:response>
    <output:serialization-parameters>
    <output:method value='xml'/>
      <output:media-type value='application/xml'/>
    </output:serialization-parameters>
 </rest:response>;

(:~ lists content of collection ~:)
declare 
    %rest:GET
    %rest:path("/tei-abstracts/{$collection}/{$format}")
function api:list-documents($collection, $format) {
let $result:= api:list-collection-content($collection)

let $serialization := switch($format)
    case('xml') return $api:XML
    default return $api:JSON
        return 
            ($serialization, $result)
};

declare %private function api:list-collection-content($collection as xs:string){
    let $result:= 
        <result>
            {for $doc in collection($config:app-root||'/data/'||$collection)//tei:TEI
            let $path := functx:substring-before-last(document-uri(root($doc)),'/')
            let $ID := app:getDocName($doc)
                return
                <entry>
                    <ID>{$ID}</ID>
                    <path>{$path}</path>
                    <created>{xmldb:created($path, $ID)}</created>
                    <modified>{xmldb:last-modified($path, $ID)}</modified>
                </entry>
             }
        </result>
        return 
            $result
};

declare %private function api:show-document($ID as xs:string, $collection as xs:string){
    let $doc := doc($config:app-root||'/data/'||$collection||'/'||$ID)
    return 
        <result>
            <somethingFound>
                {$doc}
            </somethingFound>
        </result>
};