<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:param name="id"/>
   <xsl:template match="/">
       <div class="panel panel-default">
           <div class="panel-heading">
               <h1 style="text-align:center;">
                   <xsl:value-of select="$id"/>
               </h1>
           </div>
           <div class="panel-body">
               <div class="row">
                   <div class="col-md-6">
                       <div class="panel-group">
                           <div class="panel panel-default">
                               <div class="panel-heading">
                                   <h4 class="panel-title" style="text-align:center;">
                                       <a data-toggle="collapse" href="#collapse2">Affiliated Persons</a>
                                   </h4>
                               </div>
                               <div id="collapse2" class="panel-collapse">
                                   <div class="panel-body" id="chart2">
                                       <xsl:for-each select=".//tei:person[normalize-space(.//tei:orgName[1]//text()[1])=$id]">
                                           <strong>
                                               <xsl:value-of select="./tei:persName"/>
                                           </strong>
                                           <ul class="list-unstyled">
                                               <xsl:for-each select=".//tei:title">
                                                   <li>
                                                       <xsl:apply-templates/>&#160;
                                                       <a target="_blank">
                                                           <xsl:attribute name="href">
                                                               <xsl:value-of select="concat('show.html?document=',./@key)"/>
                                                           </xsl:attribute>
                                                           <span class="glyphicon glyphicon-new-window" aria-hidden="true"/>
                                                       </a>
                                                   </li>
                                               </xsl:for-each>
                                           </ul>
                                       </xsl:for-each>
                                   </div>
                               </div>
                           </div>
                       </div>
                   </div>
                   <div class="col-md-6">
                       <div class="panel-group">
                           <div class="panel panel-default">
                               <div class="panel-heading">
                                   <h4 class="panel-title" style="text-align:center;">
                                       <a data-toggle="collapse" href="#collapse1">located in
                                           <xsl:value-of select="(.//tei:affiliation[normalize-space(./tei:orgName/text())=$id])[1]//tei:country"/>
                                        </a>
                                   </h4>
                               </div>
                               <div id="collapse1" class="panel-collapse">
                                   <div class="panel-body" id="chart1">
                                       here comes the map
                                   </div>
                               </div>
                           </div>
                       </div>
                   </div>
               </div>
           </div>
       </div>
       
       
   </xsl:template>
</xsl:stylesheet>