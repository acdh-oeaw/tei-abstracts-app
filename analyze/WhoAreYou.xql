xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/tei-abstracts/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/tei-abstracts/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare namespace util = "http://exist-db.org/xquery/util";
declare option exist:serialize "method=xml media-type=text/xml omit-xml-declaration=no indent=yes";

let $baseID := 'https://id.acdh.oeaw.ac.at/'
let $RDF := 
<rdf:RDF
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:dct="http://purl.org/dc/terms/"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:acdh="https://vocabs.acdh.oeaw.ac.at/#"
    xmlns:acdhi="https://id.acdh.oeaw.ac.at/"
    xmlns:foaf="http://xmlns.com/foaf/spec/#"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:ebucore="http://www.ebu.ch/metadata/ontologies/ebucore/ebucore#"
    xml:base="https://id.acdh.oeaw.ac.at/">
    
        <acdh:Project rdf:about="{concat($baseID, $config:app-name)}">
            <dc:title>{$config:app-title}</dc:title>
            <dc:description>{$config:repo-description/text()}</dc:description>
            <dct:contributor>
            <foaf:Agent rdf:about="{concat($baseID, 'pandorfer')}">
                <dc:title>Peter Andorfer</dc:title>
                <foaf:name>Peter Andorfer</foaf:name>
            </foaf:Agent>
            </dct:contributor>
        </acdh:Project>
        <acdh:Collection rdf:about="{concat($baseID, string-join(($config:app-name, 'data'), '/'))}">
            <dc:title>{string-join(($config:app-name, 'data'), '/')}</dc:title>
            <dct:isPartOf rdf:resource="{concat($baseID,$config:app-name)}"/>
        </acdh:Collection>

        {
            for $x in xmldb:get-child-collections($config:data-root) 
                return
                    <acdh:Collection rdf:about="{concat($baseID,string-join(($config:app-name, 'data', $x), '/'))}">
                        <dc:title>{string-join(($config:app-name, 'data', $x), '/')}</dc:title>
                        <dct:isPartOf rdf:resource="{concat($baseID, string-join(($config:app-name, 'data'), '/'))}"/>
                    </acdh:Collection>
        }
        {
            for $x in xmldb:get-child-collections($config:data-root)
                for $doc in xmldb:get-child-resources($config:data-root||'/'||$x)
                let $node := try {
                        doc(string-join(($config:data-root, $x, $doc), '/'))
                    } catch * {
                        false()
                    }
                let $filename := string-join(($config:app-name, 'data', $x, $doc), '/')
                let $title := try {
                        <dc:title>{normalize-space(string-join($node//tei:titleStmt/tei:title//text(), ' '))}</dc:title>
                    } catch * {
                        <dc:title>{tokenize($filename, '/')[last()]}</dc:title>
                    }
                let $filename := string-join(($config:app-name, 'data', $x, $doc), '/')
                return
                    <acdh:Resource rdf:about="{concat($baseID, $filename)}">
                        {$title}
                        <dct:isPartOf rdf:resource="{concat($baseID, (string-join(($config:app-name, 'data', $x), '/')))}"/>
                    </acdh:Resource>
        }

        
    </rdf:RDF>
    
return
    $RDF