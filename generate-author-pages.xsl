<?xml version="1.0"?>

	
<xsl:stylesheet version="2.0" exclude-result-prefixes="xs xdt err fn" 
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
				xmlns:xs="http://www.w3.org/2001/XMLSchema"
				xmlns:fn="http://www.w3.org/2005/xpath-functions" 
				xmlns:xdt="http://www.w3.org/2005/xpath-datatypes"
				xmlns:err="http://www.w3.org/2005/xqt-errors">
				<xsl:output method="html" indent="yes"  use-character-maps="html-illegal-chars"/>
				<xsl:character-map name="html-illegal-chars">
					<xsl:output-character character="&#150;" string=""/>
				</xsl:character-map>
				<xsl:strip-space elements="*"/>
				
		
		
		<xsl:variable name="NameAuteur">
			<xsl:for-each select="dblp/*/author">
				<xsl:element name="Author">
					<xsl:value-of select ="."/>
				</xsl:element>
			</xsl:for-each>
		</xsl:variable>
		
		
		<xsl:template match="dblp">	
				<xsl:for-each select="$NameAuteur/Author">
					<br>
						<xsl:variable name="currentAuthor">
							<xsl:value-of select ="."/>
						</xsl:variable>
						
						<h1><xsl:value-of select ="$currentAuthor"/></h1>
						
						<h2>
							<!--xsl:for-each select="/dblp/*[author='$currentAuthor']" >
								<xsl:value-of select="title"/>
							</xsl:for-each-->
							<xsl:apply-templates select="/dblp/*[author='$currentAuthor']"/>
						</h2>
					</br>
				</xsl:for-each>
		</xsl:template>
		
		<xsl:template match="/dblp/*">
			<title>
				<xsl:value-of select="title" /> 
			</title>
		</xsl:template>
	
</xsl:stylesheet>