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
        <div class="container">
            <div class="row">
            <nav class="col-sm-2" id="myScrollspy">
                <ul class="nav nav-pills nav-stacked" data-spy="affix" data-offset-top="">
                    <li>
                        <a href="#tab-top">top</a>
                    </li>
                    <li>
                        <a href="#tab-info">metadata</a>
                    </li>
                    <li>
                        <a href="#tab-formal">formal markup</a>
                    </li>
                    <li>
                        <a href="#tab-semantic">semantic markup</a>
                    </li>
                    <li>
                        <a href="#tab-syntactic">syntactic markup</a>
                    </li>
                    
                </ul>
            </nav>
            <div class="col-sm-10">
                <div class="page-header" id="tab-top">
                    <h2 align="center">
                        <xsl:for-each select="//tei:fileDesc/tei:titleStmt/tei:title">
                            <xsl:value-of select="."/>
                            <br/>
                        </xsl:for-each>
                    </h2>
                </div>
                <div class="regest" id="tab-info">
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
                            <div class="panel-footer" style="text-align:center;">
                                    <p>
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="concat($archeID, '?format=raw')"/>
                                            </xsl:attribute>
                                            source-file
                                        </a>
                                    </p>
                                <p>
                                    <xsl:element name="a">
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="$archeID"/>
                                        </xsl:attribute>
                                        <xsl:attribute name="target">_blank</xsl:attribute>
                                        Arche-Entry
                                    </xsl:element>
                                </p>
                                    <p>
                                        <xsl:element name="a">
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="concat('http://glaser.acdh.oeaw.ac.at/#/gl/rec/', $adlibID)"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="target">_blank</xsl:attribute>
                                            <xsl:value-of select="concat('http://glaser.acdh.oeaw.ac.at/#/gl/rec/', $adlibID)"/>
                                        </xsl:element>
                                    </p>
                                
                                
                            </div>
                        </div>
                    </div>
                </div>
                <div class="panel panel-default" id="tab-formal">
                    <div class="panel-heading">
                        <h3 class="panel-title">
                            <h2 align="center">
                                    formal markup
                                </h2>
                        </h3>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div id="annotated_text">
                                    <h3 align="center">transliteration</h3>
                                    <xsl:apply-templates select="//tei:div[@type='edition']/tei:ab[@type='formal-markup']"/>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div id="annotated_text">
                                    <h3 align="center">translation</h3>
                                    <xsl:apply-templates select="//tei:div[@type='translation']/tei:ab[@type='formal-markup']"/>
                                </div>
                            </div>
                        </div>
                        <hr/>
                    </div>
                </div>
                <div class="panel panel-default" id="tab-semantic">
                    <div class="panel-heading">
                        <h3 class="panel-title">
                            <h2 align="center">
                                    semantic markup
                                </h2>
                        </h3>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div id="annotated_text">
                                    <h3 align="center">transliteration</h3>
                                    <xsl:apply-templates select="//tei:div[@type='edition']/tei:ab[@type='semantic-markup']"/>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div id="annotated_text">
                                    <h3 align="center">translation</h3>
                                    <xsl:apply-templates select="//tei:div[@type='translation']/tei:ab[@type='semantic-markup']"/>
                                </div>
                            </div>
                        </div>
                        <hr/>
                    </div>
                </div>
                <div class="panel panel-default" id="tab-syntactic">
                    <div class="panel-heading">
                        <h3 class="panel-title">
                            <h2 align="center">
                                syntactic markup
                            </h2>
                        </h3>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div id="annotated_text">
                                    <h3 align="center">transliteration</h3>
                                    <xsl:apply-templates select="//tei:div[@type='edition']/tei:ab[@type='syntactic-markup']"/>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div id="annotated_text">
                                    <h3 align="center">translation</h3>
                                    <xsl:apply-templates select="//tei:div[@type='translation']/tei:ab[@type='syntactic-markup']"/>
                                </div>
                            </div>
                        </div>
                        <hr/>
                    </div>
                </div>
                <div class="panel panel-default" id="tab-adlib-import">
                    <div class="panel-heading">
                        <h3 class="panel-title">
                            <h2 align="center">
                            original (imported) markup
                        </h2>
                        </h3>
                    </div>
                    <div class="panel-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div id="annotated_text">
                                    <h3 align="center">transliteration</h3>
                                    <xsl:apply-templates select="//tei:div[@type='edition']/tei:ab[@type='adlib-orig']"/>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div id="annotated_text">
                                    <h3 align="center">translation</h3>
                                    <xsl:apply-templates select="//tei:div[@type='translation']/tei:ab[@type='adlib-orig']"/>
                                </div>
                            </div>
                        </div>
                        <hr/>
                    </div>
                </div>
            </div>
        </div>
            </div>
        </html>
    </xsl:template>
    <xsl:template match="tei:w">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="concat('http://www.ruzicka.net:8180/kalam/servlet/kalam?op=showhtml&amp;dictionary=yes&amp;word=', .)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </a>
    </xsl:template><!--
    #####################
    ###  Formatierung ###
    #####################
-->
    <xsl:template match="tei:supplied">
        <span style="color:red;" data-toggle="tooltip" title="supplied">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:unclear">
        <span style="color:#F7C331;" data-toggle="tooltip" title="unclear">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:del">
        <del style="color:#FA07EA;" data-toggle="tooltip" title="deleted">
            <xsl:apply-templates/>
        </del>
    </xsl:template>
    <xsl:template match="tei:gap">
        <span style="color:#FFFFFF;" data-toggle="tooltip">
            <xsl:attribute name="title">
                <xsl:value-of select="@quantity"/> <xsl:value-of select="@unit"/> missing</xsl:attribute>
            []
        </span>
    </xsl:template><!-- resp -->
    <xsl:template match="tei:respStmt/tei:resp">
        <xsl:apply-templates/> 
    </xsl:template>
    <xsl:template match="tei:respStmt/tei:name">
        <xsl:for-each select=".">
            <li>
                <xsl:apply-templates/>
            </li>
        </xsl:for-each>
    </xsl:template><!--
    #####################
    ###  semantic markup         ###
    #####################
-->
    <xsl:template match="tei:persName">
        <strong style="color:green" data-toggle="tooltip">
            <xsl:attribute name="title">
                <xsl:value-of select="@type"/>
                <xsl:value-of select="@subtype"/>
                <xsl:value-of select="@role"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </strong>
    </xsl:template>
    <xsl:template match="tei:placeName">
        <strong style="color:blue" data-toggle="tooltip">
            <xsl:attribute name="title">
                <xsl:value-of select="@type"/>
                <xsl:value-of select="@subtype"/>
                <xsl:value-of select="@role"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </strong>
    </xsl:template>
    <xsl:template match="tei:orgName">
        <strong style="color:purple" data-toggle="tooltip">
            <xsl:attribute name="title">
                <xsl:value-of select="@type"/>
                <text/>
                <xsl:value-of select="@subtype"/>
                <xsl:value-of select="@role"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </strong>
    </xsl:template><!-- reference strings   -->
    <xsl:template match="tei:rs[@ref or @key]">
        <strong>
            <xsl:element name="a">
                <xsl:attribute name="class">reference</xsl:attribute>
                <xsl:attribute name="data-type">
                    <xsl:value-of select="concat('list', data(@type), '.xml')"/>
                </xsl:attribute>
                <xsl:attribute name="data-key">
                    <xsl:value-of select="substring-after(data(@ref), '#')"/>
                    <xsl:value-of select="@key"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
            </xsl:element>
        </strong>
    </xsl:template><!-- additions -->
    <xsl:template match="tei:add">
        <xsl:element name="span">
            <xsl:attribute name="style">
                <xsl:text>color:blue;</xsl:text>
            </xsl:attribute>
            <xsl:attribute name="title">
                <xsl:choose>
                    <xsl:when test="@place='margin'">
                        <xsl:text>zeitgenössische Ergänzung am Rand </xsl:text>(<xsl:value-of select="./@place"/>).
                    </xsl:when>
                    <xsl:when test="@place='above'">
                        <xsl:text>zeitgenössische Ergänzung oberhalb </xsl:text>(<xsl:value-of select="./@place"/>)
                    </xsl:when>
                    <xsl:when test="@place='below'">
                        <xsl:text>zeitgenössische Ergänzung unterhalb </xsl:text>(<xsl:value-of select="./@place"/>)
                    </xsl:when>
                    <xsl:when test="@place='inline'">
                        <xsl:text>zeitgenössische Ergänzung in der gleichen Zeile </xsl:text>(<xsl:value-of select="./@place"/>)
                    </xsl:when>
                    <xsl:when test="@place='top'">
                        <xsl:text>zeitgenössische Ergänzung am oberen Blattrand </xsl:text>(<xsl:value-of select="./@place"/>)
                    </xsl:when>
                    <xsl:when test="@place='bottom'">
                        <xsl:text>zeitgenössische Ergänzung am unteren Blattrand </xsl:text>(<xsl:value-of select="./@place"/>)
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>zeitgenössische Ergänzung am unteren Blattrand </xsl:text>(<xsl:value-of select="./@place"/>)
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:text/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template><!-- Bücher -->
    <xsl:template match="tei:bibl">
        <xsl:element name="strong">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template><!-- Seitenzahlen -->
    <xsl:template match="tei:pb">
        <xsl:element name="div">
            <xsl:attribute name="style">
                <xsl:text>text-align:right;</xsl:text>
            </xsl:attribute>
            <xsl:text>[Bl.</xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text>]</xsl:text>
        </xsl:element>
        <xsl:element name="hr"/>
    </xsl:template><!-- Tabellen -->
    <xsl:template match="tei:table">
        <xsl:element name="table">
            <xsl:attribute name="class">
                <xsl:text>table table-bordered table-striped table-condensed table-hover</xsl:text>
            </xsl:attribute>
            <xsl:element name="tbody">
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:row">
        <xsl:element name="tr">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:cell">
        <xsl:element name="td">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template><!-- Überschriften -->
    <xsl:template match="tei:head">
        <xsl:element name="h3">
            <xsl:element name="a">
                <xsl:attribute name="id">
                    <xsl:text>text_</xsl:text>
                    <xsl:value-of select="."/>
                </xsl:attribute>
                <xsl:attribute name="href">
                    <xsl:text>#nav_</xsl:text>
                    <xsl:value-of select="."/>
                </xsl:attribute>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:element>
    </xsl:template><!--  Quotes / Zitate -->
    <xsl:template match="tei:q">
        <xsl:element name="i">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template><!-- Zeilenumbürche   -->
    <xsl:template match="tei:lb">
        <hr/>
        <small>
            <xsl:value-of select="@n"/>: </small>
    </xsl:template><!-- Absätze    -->
    <xsl:template match="tei:p">
        <xsl:element name="p">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template><!-- Durchstreichungen -->
    <xsl:template match="tei:del">
        <xsl:element name="strike">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>