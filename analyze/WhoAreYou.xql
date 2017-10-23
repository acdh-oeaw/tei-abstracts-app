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
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:acdh="https://vocabs.acdh.oeaw.ac.at/schema#"
    xmlns:acdhi="https://id.acdh.oeaw.ac.at/"
    xmlns:foaf="http://xmlns.com/foaf/spec/#"
    xml:base="https://id.acdh.oeaw.ac.at/">

<!-- define involved Organisations -->
        
        <acdh:Organisation rdf:about="http://www.stiftung-fte.at/">
            <acdh:hasTitle>Nationalstiftung</acdh:hasTitle>
        </acdh:Organisation>

<!-- define involved Persons -->
    
        <acdh:Person rdf:about="http://viaf.org/viaf/31146030596135862230">
            <acdh:hasLastName>Hannesschläger</acdh:hasLastName>
            <acdh:hasFirstName>Vanessa</acdh:hasFirstName>
        </acdh:Person>
        <acdh:Person rdf:about="http://d-nb.info/gnd/1043833846">
            <acdh:hasLastName>Andorfer</acdh:hasLastName>
            <acdh:hasFirstName>Peter</acdh:hasFirstName>
        </acdh:Person>
    
<!-- define involved Project(s) -->        

        <acdh:Project rdf:about="{concat($baseID,'project/', $config:app-name)}">
            <acdh:hasTitle>TEI 2016 Abstracts</acdh:hasTitle>
            <acdh:language>eng</acdh:language>
            <acdh:hasContact>
                <acdh:Person rdf:about="http://viaf.org/viaf/31146030596135862230"/>
            </acdh:hasContact>
            <acdh:hasDescription>
                A collection of abstracts of contributions to the TEI conference 2016.
            </acdh:hasDescription>
            <acdh:hasUrl>https://tei2016app.acdh.oeaw.ac.at/</acdh:hasUrl>
            <acdh:hasStartDate>2017-01-23</acdh:hasStartDate>
            <acdh:hasEndDate>2017-06-23</acdh:hasEndDate>
            <acdh:hasPrincipalInvestigator>
                <acdh:Person rdf:about="http://viaf.org/viaf/31146030596135862230"/>
            </acdh:hasPrincipalInvestigator>
            <acdh:hasContributor>
                <acdh:Person rdf:about="http://d-nb.info/gnd/1043833846"/>
            </acdh:hasContributor>
            <acdh:hasFunder>
                <acdh:Organisation rdf:about="http://www.stiftung-fte.at/"/>
            </acdh:hasFunder>
            <acdh:hasRelatedCollection rdf:about="{concat($baseID, $config:app-name)}"/>
        </acdh:Project>

        <acdh:Collection rdf:about="{concat($baseID, $config:app-name)}">
            <acdh:hasRelatedProject>
                <acdh:Project rdf:about="{concat($baseID,'project/', $config:app-name)}"/>
            </acdh:hasRelatedProject>
            <acdh:hasTitle>{$config:app-title}</acdh:hasTitle>
            <acdh:hasDescription>{$config:repo-description/text()}</acdh:hasDescription>
            <acdh:hasContributor>
                <acdh:Person rdf:about="http://viaf.org/viaf/31146030596135862230"/>
            </acdh:hasContributor>
            <acdh:hasContributor>
                <acdh:Person rdf:about="http://d-nb.info/gnd/1043833846"/>
            </acdh:hasContributor>
            <acdh:hasLicense rdf:resource="https://creativecommons.org/licenses/by-sa/4.0/"/>
        </acdh:Collection>
        
        <acdh:Collection rdf:about="{concat($baseID, string-join(($config:app-name, 'data'), '/'))}">
            <acdh:hasContributor>
                <acdh:Person rdf:about="http://viaf.org/viaf/31146030596135862230"/>
            </acdh:hasContributor>
            <acdh:hasContributor>
                <acdh:Person rdf:about="http://d-nb.info/gnd/1043833846"/>
            </acdh:hasContributor>
            <acdh:hasLicense rdf:resource="https://creativecommons.org/licenses/by-sa/4.0/"/>
            <acdh:hasTitle>{string-join(($config:app-name, 'data'), '/')}</acdh:hasTitle>
            <acdh:isPartOf rdf:resource="{concat($baseID,$config:app-name)}"/>
        </acdh:Collection>

        {
            for $x in xmldb:get-child-collections($config:data-root) 
                return
                    <acdh:Collection rdf:about="{concat($baseID,string-join(($config:app-name, 'data', $x), '/'))}">
                        <acdh:hasTitle>{string-join(($config:app-name, 'data', $x), '/')}</acdh:hasTitle>
                        <acdh:isPartOf rdf:resource="{concat($baseID, string-join(($config:app-name, 'data'), '/'))}"/>
                        <acdh:hasContributor>
                            <acdh:Person rdf:about="http://viaf.org/viaf/31146030596135862230"/>
                        </acdh:hasContributor>
                        <acdh:hasContributor>
                            <acdh:Person rdf:about="http://d-nb.info/gnd/1043833846"/>
                        </acdh:hasContributor>
                        <acdh:hasLicense rdf:resource="https://creativecommons.org/licenses/by-sa/4.0/"/>
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
                        <acdh:hasTitle>{normalize-space(string-join($node//tei:titleStmt/tei:title//text(), ' '))}</acdh:hasTitle>
                    } catch * {
                        <acdh:hasTitle>{tokenize($filename, '/')[last()]}</acdh:hasTitle>
                    }
                let $authors := try {
                        
                            for $y in $node//tei:titleStmt//tei:author//tei:persName
                                let $uri := if(starts-with(data($y/@key), 'http')) 
                                    then $y/@key
                                    else "https://id.acdh.oeaw.ac.at/tei-abstracts/"||data($y/@key)
                            
                                return
                                    <acdh:hasAuthor>
                                <acdh:Person rdf:about="{$uri}">
                                    <acdh:hasLastName>
                                        {$y/tei:surname/text()}
                                    </acdh:hasLastName>
                                    <acdh:hasFirstName>
                                        {$y/tei:forename/text()}
                                    </acdh:hasFirstName>
                                </acdh:Person>
                                </acdh:hasAuthor>
                            
                        
                } catch * {()}
                let $idno := try {
                    $node//tei:publicationStmt/tei:idno/text()
                } catch * {()}
                let $pid := if ($idno) then $idno else 'create some'
                
                let $filename := string-join(($config:app-name, 'data', $x, $doc), '/')
                return
                    <acdh:Resource rdf:about="{concat($baseID, $filename)}">
                        {$title}
                        {$authors}
                        <acdh:isPartOf rdf:resource="{concat($baseID, (string-join(($config:app-name, 'data', $x), '/')))}"/>
                        <acdh:hasLicense rdf:resource="https://creativecommons.org/licenses/by-sa/4.0/"/>
                        <acdh:hasPid>{$pid}</acdh:hasPid>
                    </acdh:Resource>
        }

        
    </rdf:RDF>
    
return
    $RDF