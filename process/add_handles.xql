xquery version "3.1";

declare namespace functx = "http://www.functx.com";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace xhtml = "http://www.w3.org/1999/xhtml";
declare namespace httpclient="http://exist-db.org/xquery/httpclient";

import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace config="http://www.digital-archiv.at/ns/tei-abstracts/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/tei-abstracts/templates" at "../modules/app.xql";

(: a script to create handle pids and write them as <tei:idno> elements into the according TEI-Files, 
 : based upon https://github.com/acdh-oeaw/cr-xq-mets/blob/master/src/modules/resource/handle.xqm
 : call with ?auth=AUTHTOKEN4HANDLESERVICE :)

let $baseID := "https://id.acdh.oeaw.ac.at/"
let $resolver := "http://hdl.handle.net/11022/"
let $auth := request:get-parameter('auth', 'entersomethingvalid')

for $x in xmldb:get-child-collections($config:data-root)
    for $doc in xmldb:get-child-resources($config:data-root||'/'||$x)
        let $filename := string-join(($config:app-name, 'data', $x, $doc), '/')    
        let $url := concat($baseID, $filename)
        let $data := '[{"type":"URL","parsed_data":"' || $url||'"}]'
        let $node := try {
                        doc(string-join(($config:data-root, $x, $doc), '/'))//tei:publicationStmt[not(.//tei:idno)]
                    } catch * {
                        false()
                    }
        return 
            if ($node)
                then
                    let $auth :="Basic "||util:string-to-binary($auth)
                    let $headers := <headers>
                                            <header name="Authorization" value="{$auth}"/>
                                            <header name="Content-Type" value="application/json"/>
                                            <header name="Accept" value="application/xhtml+xml"/>
                                        </headers>
                    let $response := httpclient:post(xs:anyURI("http://pid.gwdg.de/handles/11022/"), $data, true(),$headers)
                    let $handle := if ($response/@statusCode="201") 
                        then
                            $resolver || $response//xhtml:dl[@class='rackful-object'][xhtml:dt='location']/xhtml:dd/xhtml:a/text()
                        else
                            $url
                    let $idno := <tei:idno type="URI">{$handle}</tei:idno>
                    let $updated := update insert $idno into $node
                        return $node
            else 
                $node