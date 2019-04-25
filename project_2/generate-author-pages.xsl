<?xml version="1.0" encoding="utf-8"?>


<xsl:stylesheet version="2.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:dblp="http://www.project2.be"
				xmlns="http://www.w3.org/1999/xhtml">

    <xsl:output method="html" indent="yes"
			use-character-maps="html-illegal-chars" encoding="UTF-8"/>
		<xsl:character-map name="html-illegal-chars">
			<xsl:output-character character="&#150;" string=""/>
		</xsl:character-map>

		<xsl:template match="/">
			<!-- TODO: add editiors -->
			<xsl:variable name="allPublications" select="dblp/*" />
			<xsl:variable name="authorNames" select="dblp/*/author" />
			<xsl:for-each select="$authorNames">
				<xsl:sort select="." />
				<xsl:variable name="author" select="." />

				<!-- TODO: compute the file name in the a-tree -->
				<xsl:variable name="lastName" select="." />
				<xsl:variable name="firstLetterLastName" select="." />
				<xsl:variable name="firstName" select="." />
				<xsl:variable  name="fileName" select="concat('$firstLetterLastName',
					'/', '$lastName', '.', 'firstName', '.html')" />

					<!-- TODO: give each author its own html document and put it in the a-tree -->
					<!--xsl:result-document href="a-tree/{$fileName}" method="html" encoding="UTF-8"-->
						<html>
							<head>
								<title>Publication of <xsl:value-of select="$author" /></title>
							</head>
							<body>
								<h1><xsl:value-of select="$author"/></h1>
								<xsl:call-template name="publications">
									<xsl:with-param name="allPublications" select="$allPublications" />
									<xsl:with-param name="author" select="$author" />
								</xsl:call-template>
								<h2>Co-author index</h2>
								<xsl:call-template name="coAuthorIndex">
								</xsl:call-template>
							</body>
						</html>
					<!---/xsl:result-document-->
			</xsl:for-each>
		</xsl:template>


		<!-- TODO: Publication table for each author ordered by year -->
		<xsl:template name="publications">
			<xsl:param name="allPublications" />
			<xsl:param name="author" />
				<table border="1">
					<xsl:for-each select="$allPublications">
						<xsl:if test="author=$author">
							<tr>
								<td><xsl:value-of select="title" /></td>
							</tr>
						</xsl:if>
					</xsl:for-each>
				</table>
		</xsl:template>

		<!-- TODO: Co-author index -->
		<xsl:template name="coAuthorIndex">
			<table border="1">
			</table>
		</xsl:template>

</xsl:stylesheet>
