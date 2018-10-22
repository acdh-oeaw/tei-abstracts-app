<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei" version="2.0">
    <xsl:output media-type="text/html" method="html" encoding="UTF-8"/>
    <!--    https://id.acdh.oeaw.ac.at/glasersqueezes2015/rec1110000005/adlib1110000005.xml -->
    <xsl:variable name="adlibID">
        <xsl:value-of select=".//tei:title[2]/text()"/>
    </xsl:variable>
    <xsl:variable name="archeID">
        <xsl:value-of select="concat('https://id.acdh.oeaw.ac.at/glasersqueezes2015/rec', $adlibID,'/adlib', $adlibID, '.xml')"/>
    </xsl:variable>
    <xsl:variable name="path2source">
        jansi
    </xsl:variable>
    
    <xsl:template match="/">
        <html>
        <head>
            <title data-template="config:app-title">App Title</title>
            <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
            <command data-template="config:app-meta"/>
            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous"/>
            <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"/>
            <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"/>
        </head>
        <style>
            @media screen and (max-width: 810px) {
            #tab-top, #tab-info, #tab-formal, #tab-semantic, #tab-adlib-import  {
            margin-left: 150px;
            }
        </style>
            <body>
                <div class="container">
                <div class="page-header" align="center">
                    <h2>
                        <xsl:for-each select="//tei:fileDesc/tei:titleStmt/tei:title">
                            <xsl:apply-templates/>
                            <br/>
                        </xsl:for-each>
                    </h2>
                    <h4>
                        by<br/>
                        <xsl:for-each select="//tei:titleStmt//tei:author//tei:persName">
                            <xsl:apply-templates select="."/>
                            <br/>
                        </xsl:for-each>
                    </h4>
                </div>
                <div class="regest">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h3 class="panel-title">
                                <h2 align="center">Info</h2>
                            </h3>
                        </div>
                        <div class="panel-body">
                            <table class="table table-striped">
                                <tbody>
                                    <tr>
                                        <th>
                                            <abbr title="tei:titleStmt/tei:title">Title</abbr>
                                        </th>
                                        <td>
                                            <xsl:for-each select="//tei:fileDesc/tei:titleStmt/tei:title">
                                                <xsl:apply-templates/>
                                                <br/>
                                            </xsl:for-each>
                                        </td>
                                    </tr>
                                    <xsl:if test="//tei:msIdentifier">
                                        <tr>
                                            <th>
                                                <abbr title="//tei:msIdentifie">Identifier</abbr>
                                            </th>
                                            <td>
                                                <xsl:for-each select="//tei:msIdentifier/child::*">
                                                    <abbr>
                                                        <xsl:attribute name="title">
                                                            <xsl:value-of select="name()"/>
                                                        </xsl:attribute>
                                                        <xsl:value-of select="."/>
                                                    </abbr>
                                                    <br/>
                                                </xsl:for-each><!--<xsl:apply-templates select="//tei:msIdentifier"/>-->
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="//tei:msContents">
                                        <tr>
                                            <th>
                                                <abbr title="//tei:msContents">Description</abbr>
                                            </th>
                                            <td>
                                                <xsl:apply-templates select="//tei:msContents"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="//tei:supportDesc/tei:extent">
                                        <tr>
                                            <th>
                                                <abbr title="//tei:supportDesc/tei:extent">Extent</abbr>
                                            </th>
                                            <td>
                                                <xsl:apply-templates select="//tei:supportDesc/tei:extent"/>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <xsl:if test="//tei:titleStmt/tei:respStmt">
                                        <tr>
                                            <th>
                                                <abbr title="//tei:titleStmt/tei:respStmt">responsible</abbr>
                                            </th>
                                            <td>
                                                <xsl:for-each select="//tei:titleStmt/tei:respStmt">
                                                    <p>
                                                        <xsl:apply-templates/>
                                                    </p>
                                                </xsl:for-each>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <tr>
                                        <th>
                                            <abbr title="//tei:availability//tei:p[1]">License</abbr>
                                        </th>
                                        <td>
                                            <xsl:element name="a">
                                                <xsl:attribute name="href">
                                                    <xsl:apply-templates select="//tei:licence/@target"/>
                                                </xsl:attribute>
                                                <xsl:apply-templates select="//tei:availability//tei:p[1]"/>
                                            </xsl:element>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <div class="panel-footer">
                                <p style="text-align:center;">
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$path2source"/>
                                        </xsl:attribute>
                                        see the TEI source of this document
                                    </a>
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title">
                            <h2 align="center">
                                Abstract
                            </h2>
                        </h3>
                    </div>
                    <div class="panel-body">
                        <xsl:apply-templates select="//tei:text"/>
                    </div>
                    <div class="panel-footer">
                        <div class="panel-footer">
                            <p style="text-align:center;">
                                <xsl:for-each select="tei:TEI/tei:text/tei:body//tei:note">
                                    <div class="footnotes">
                                        <xsl:element name="a">
                                            <xsl:attribute name="name">
                                                <xsl:text>fn</xsl:text>
                                                <xsl:number level="any" format="1" count="tei:note"/>
                                            </xsl:attribute>
                                            <a>
                                                <xsl:attribute name="href">
                                                    <xsl:text>#fna_</xsl:text>
                                                    <xsl:number level="any" format="1" count="tei:note"/>
                                                </xsl:attribute>
                                                <span style="font-size:7pt;vertical-align:super;">
                                                    <xsl:number level="any" format="1" count="tei:note"/>
                                                </span>
                                            </a>
                                        </xsl:element>
                                        <xsl:choose>
                                            <xsl:when test=".//tei:ptr">
                                                <xsl:for-each select=".//tei:ptr">
                                                    <xsl:variable name="selctedID">
                                                        <xsl:value-of select="substring-after(data(./@target),'#')"/>
                                                    </xsl:variable>
                                                    <xsl:variable name="selectedBook">
                                                        <xsl:value-of select="ancestor::tei:TEI//tei:biblStruct[@xml:id=$selctedID]"/>
                                                    </xsl:variable>
                                                    <xsl:choose>
                                                        <xsl:when test="ancestor::tei:TEI//tei:biblStruct[@xml:id=$selctedID]//tei:persName">
                                                            <xsl:value-of select=" string-join(ancestor::tei:TEI//tei:biblStruct[@xml:id=$selctedID]//tei:surname, '/')"/>,
                                                            <xsl:value-of select="ancestor::tei:TEI//tei:biblStruct[@xml:id=$selctedID]//tei:date[1]"/>
                                                            <xsl:apply-templates/>
                                                            <xsl:if test="position() &lt; last()">; </xsl:if>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select=" string-join(ancestor::tei:TEI//tei:biblStruct[@xml:id=$selctedID]//tei:author, '/')"/>,
                                                            <xsl:value-of select="ancestor::tei:TEI//tei:biblStruct[@xml:id=$selctedID]//tei:date[1]"/>
                                                            <xsl:apply-templates/>
                                                            <xsl:if test="position() &lt; last()">; </xsl:if>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="."/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </div>
                                </xsl:for-each>
                            </p>
                        </div>
                    </div>
                </div>
                </div>
            </body>
        </html>
            </xsl:template>
</xsl:stylesheet>