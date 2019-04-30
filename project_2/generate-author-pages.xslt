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

		<xsl:function name="dblp:getAuthorName">
			<xsl:param name="authorName" />
				<xsl:variable name="badCharName" select="replace($authorName, '[^a-zA-Z. ]', '=')" />
				<xsl:variable name="tokens" select="tokenize($badCharName, ' ')" />
				<xsl:variable name="lastName" select="$tokens[last()]" />
				<xsl:variable name="firstLetter" select="lower-case(substring($lastName, 1, 1))" />

				<xsl:variable name="firstAuthorName" select="replace($badCharName, $lastName, '')" />
				<xsl:variable name="spaceAuthorName" select="replace($firstAuthorName, '[\s]', '')" />
				<xsl:variable name="newAuthorName" select="replace($spaceAuthorName, '[.]', '_')" />
				<xsl:variable name="newtokens" select="tokenize($newAuthorName, ' ')" />
				<xsl:variable name="firstName" select="$newtokens[1]" />

				<xsl:value-of select="concat('a-tree/', $firstLetter, '/', $lastName, '.', $firstName, '.html')" />
		</xsl:function>

		<xsl:template match="/">
			<xsl:variable name="root" select="." />
			<xsl:variable name="authorNames" select="distinct-values(dblp/*/editor | dblp/*/author)" />
			<xsl:for-each select="$authorNames">
				<xsl:sort select="." />
				<xsl:variable name="author" select="." />
					<xsl:result-document href="{dblp:getAuthorName(.)}" method="html" encoding="UTF-8">
						<html>
							<head>
								<title>Publication of <xsl:value-of select="$author" /></title>
							</head>
							<body>
								<xsl:variable name="authorPublications"
									select="$root/dblp/*[editor=$author] | $root/dblp/*[author=$author]" />
								<h1><xsl:value-of select="$author"/></h1>
								<xsl:call-template name="publications">
									<xsl:with-param name="authorPublications" select="$authorPublications" />
									<xsl:with-param name="author" select="$author" />
								</xsl:call-template>
								<h2>Co-author index</h2>
									<table border="1">
                    <xsl:for-each select="$root/dblp/*[(editor | author)=$author]/author[not(.
											= ./following::*[(editor | author)=$author]/(editor | author))]">
                        <tr>
                          <xsl:if test="not(. = $author)">
                            <td>
	                            <a href="../../{dblp:getAuthorName(.)}">
	                                <xsl:value-of select="." />
	                            </a>
                            </td>
                            <td>
	                            <xsl:call-template name="coAuthorIndex">
	                              <xsl:with-param name="thisAuthor" select="$author" />
	                              <xsl:with-param name="coAuthor" select="." />
	                            </xsl:call-template>
                            </td>
                        	</xsl:if>
                    		</tr>
                    </xsl:for-each>
                	</table>
							</body>
						</html>
					</xsl:result-document>
			</xsl:for-each>
		</xsl:template>


		<xsl:template name="publications">
			<xsl:param name="authorPublications" />
			<xsl:param name="author" />
				<table border="1">
					<xsl:for-each select="$authorPublications">
						<xsl:variable name="publication" select="." />
							<xsl:if test="not(preceding-sibling::*/year=year) or position()=1">
								<tr>
									<th colspan="3" bgcolor="#FFFFCC">
										<xsl:value-of select="year" />
									</th>
								</tr>
							</xsl:if>
							<tr>
								<td align="right" valign="top">
									<xsl:value-of select="last() - position() + 1"/>
								</td>
								<td valign="top">
									<a href="{ee}">
											  <img alt="Electronic Edition" title="Electronic Edition"
											  src="http://www.informatik.uni-trier.de/~ley/db/ee.gif"
											  border="0" height="16" width="16"/>
									</a>
								</td>
								<td>
									<xsl:for-each select="author">
										<xsl:call-template name="coAuthors">
                    	<xsl:with-param name="thisAuthor" select="$author" />
                    	<xsl:with-param name="otherAuthor" select="." />
                    </xsl:call-template>
									</xsl:for-each>
									<xsl:value-of select="title" />
									<xsl:text>  </xsl:text>
									<xsl:call-template name="references">
	                	<xsl:with-param name="publication" select="." />
	                </xsl:call-template>
								</td>
							</tr>
					</xsl:for-each>
				</table>
		</xsl:template>

		<xsl:template name="coAuthors">
			<xsl:param name="thisAuthor" />
			<xsl:param name="otherAuthor" />
				<xsl:if test="$thisAuthor = $otherAuthor">
						<xsl:value-of select="$otherAuthor" />
				</xsl:if>
				<xsl:if test="not($thisAuthor = $otherAuthor)">
					<a href="../../{dblp:getAuthorName($otherAuthor)}">
						<xsl:value-of select="$otherAuthor" />
					</a>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="position()=last()">
						<xsl:text>: </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>, </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
		</xsl:template>

		<xsl:template name="coAuthorIndex">
			<xsl:param name="thisAuthor" />
			<xsl:param name="coAuthor" />
				<xsl:for-each select="/dblp/*[author=$thisAuthor]">
          <xsl:sort select="year"/>
          	<xsl:if test="$coAuthor=author">
              	[
              	<a href="#p{last()-position()+1}">
                  <xsl:value-of select="last()-position()+1" />
              	</a>
              	]
          </xsl:if>
      	</xsl:for-each>
		</xsl:template>

		<xsl:template name="references">
			<xsl:param name="publication" />
				<xsl:choose>
					<xsl:when test="name($publication)='book'">
						<xsl:call-template name="linkRef">
							<xsl:with-param name="url" select="url" />
							<xsl:with-param name="reference" select="isbn" />
						</xsl:call-template>
				</xsl:when>

				<xsl:when test="name($publication)='inproceedings' or name($publication)='incollection'">
					<xsl:call-template name="linkRef">
						<xsl:with-param name="url" select="url" />
						<xsl:with-param name="reference" select="booktitle" />
					</xsl:call-template>
				</xsl:when>

				<xsl:when test="name($publication)='article'">
					<xsl:call-template name="linkRef">
						<xsl:with-param name="url" select="url" />
						<xsl:with-param name="reference" select="concat(journal, ' ', volume, ' ', number, ' ')" />
					</xsl:call-template>
				</xsl:when>

				<xsl:when test="name($publication)='mastersthesis' or name($publication)='phdthesis'">
					<xsl:call-template name="linkRef">
						<xsl:with-param name="url" select="url" />
						<xsl:with-param name="reference" select="school" />
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
		</xsl:template>

		<xsl:template name="linkRef">
			<xsl:param name="url" />
			<xsl:param name="reference" />
				<xsl:choose>
					<xsl:when test="matches($url, 'http.*')">
						<a href="{./url}">
							<xsl:value-of select="$reference" />
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="link" select="concat('http://dblp.uni-trier.de/', $url)" />
						<a href="{$link}">
							<xsl:value-of select="$reference" />
						</a>
					</xsl:otherwise>
				</xsl:choose>
		</xsl:template>

</xsl:stylesheet>
