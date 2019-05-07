(:Thomas Bardisbanian, Borel Thomas Kamdem Tagne:)

<authors_coauthors>
{
    
	for $author in distinct-values(doc("dblp-excerpt.xml")/dblp/*/author)
	
		let $nb := if (count(distinct-values(doc("dblp-excerpt.xml")/dblp/*[author=$author]/author))> 1)
				   then count(distinct-values(doc("dblp-excerpt.xml")/dblp/*[author=$author]/author))-1 
				   else 0 
     
	return <author>
					
                <name>{data($author)}</name>
				<coauthors number="{$nb}">
					{
						for $coauthor in distinct-values(doc("dblp-excerpt.xml")/dblp/*[author=$author]/author[not(.=$author)])
						order by $coauthor
						return <coauthor>
								<name>{data($coauthor)}</name>
								<nb_joint_pubs>{count(distinct-values(doc("dblp-excerpt.xml")/dblp/*[author=$author]/author[.=$coauthor]))}</nb_joint_pubs>
							</coauthor>
					}
				</coauthors>
            </author>
}
</authors_coauthors>
