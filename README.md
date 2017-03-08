# Web App to publish the Abstracts of TEI-2016

The purpose of this application is to publish the in XML/TEI encoded abstracts of the [TEI-Conference 2016](http://tei2016.acdh.oeaw.ac.at/). The abstracts were taken from the GitHub-Repo [TEI2016abstracts](https://github.com/acdh-oeaw/TEI2016abstracts). 
The application is based upon **[generec-de-web-app](https://github.com/acdh-oeaw/generic-de-web-app)**.

## Install

1. This applications is an eXist-db application. Therefore you need to have an eXist-db instance (tested with version 2.2 and RC 3.0) up and running. 
1. Open eXist-db dashboard (if you have eXist running on localhost and with default settings try [http://localhost:8080/exist/apps/dashboard/index.html](http://localhost:8080/exist/apps/dashboard/index.html).
1. There open the package manager
1. Click on 'add a package', the icon in the top left corner
1. Select `tei-abstracts-0.1.xar` located in the `build` directory in this repo
1. After a succesful installation process, you should be all set up and running. Again on localhost try: [http://localhost:8080/exist/apps/tei-abstracts/](http://localhost:8080/exist/apps/tei-abstracts/) 

## Data preprocessing

To enhance functionality of this application, the data had to be slightly processed. Therefore the following steps were conducted:

- derived a person index from the data by collecting all authors and created persName keys, either by taking the already assigned viaf number or created an md5 hash from the concatenated for- and surname plus prefix "genID" (`create-pers-list.xql`)
- added md5 hashes as @key attributes to persName elements in the abstracts (`add.keys.xql`)

## Data enrichment

The scripts ```add-gender-genderize-listpers.xql``` and ```add-gender-genderize-editions.xqll``` map all forenames in the corpus towards their gender. Therefore the names are sent to the service [genderize.io](https://genderize.io/). Since the number of daily requests must not exeed 1000, editions and indices are processed seperatly. 
