(:Thomas Bardisbanian, Borel Thomas Kamdem Tagne:)

for $proceeding in doc("dblp-excerpt.xml")/dblp/proceedings
	
	return <proceedings>
	
				<proc_title>{data($proceeding/title)}</proc_title>
				
				{
                    for $inproceeding in doc("dblp-excerpt.xml")/dblp/inproceedings[crossref=data($proceeding/@key)]
                    return <title>{data($inproceeding/title)}</title>
                }
				
			</proceedings>
