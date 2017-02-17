xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace httpclient="http://exist-db.org/xquery/httpclient";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace config="http://www.digital-archiv.at/ns/tei-abstracts/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/tei-abstracts/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare variable $base := "http://127.0.0.1:8000";
declare variable $path := "/api/name/?format=json&amp;name=";
declare variable $genderize := "https://api.genderize.io/?name=";

(: 
 : genderize: {"name":"peter","gender":"male","probability":"0.99","count":796}
 : ownService:  {
            "url": "http://127.0.0.1:8000/api/name/6711/",
            "sex": {
                "url": "http://127.0.0.1:8000/api/gender/2/",
                "sex": "male"
            },
            "source": {
                "url": "http://127.0.0.1:8000/api/source/1/",
                "source": "Names Corpus, Version 1.3 (1994-03-29)\nCopyright (C) 1991 Mark Kantrowitz\nAdditions by Bill Ross\n\nThis corpus contains 5001 female names and 2943 male names, sorted\nalphabetically, one per line.\n\nYou may use the lists of names for any purpose, so long as credit is\ngiven in any published work. You may also redistribute the list if you\nprovide the recipients with a copy of this README file. The lists are\nnot in the public domain (I retain the copyright on the lists) but are\nfreely redistributable.  If you have any additions to the lists of\nnames, I would appreciate receiving them.\n\nMark Kantrowitz <mkant+@cs.cmu.edu>\nhttp://www-2.cs.cmu.edu/afs/cs/project/ai-repository/ai/areas/nlp/corpora/names/\n"
            },
            "name": "Peter"
        }
 :)

let $seq := collection(concat($config:app-root, '/data/'))//tei:forename
(:return count($seq):)
for $forename in subsequence($seq, 26) 
    let $name := $forename/text()
(:    let $url := $base||$path||encode-for-uri($name):)
    let $url := $genderize||encode-for-uri($name)
    let $request := httpclient:get(xs:anyURI($url),  true(), <Headers/>)
    let $json : = util:base64-decode($request//httpclient:body/text())
    let $parsed := parse-json($json)
    let $gender := $parsed?gender
    let $result := if($gender eq 'male')
        then "male"
        else if($gender eq 'female')
        then 'female'
        else "no-match"
    let $new:= update insert attribute type {$result} into $forename
    return $result