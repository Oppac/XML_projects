declare function local:distance($author_one, $author_two, $authors, $visited, $counter, $dblp){
    let $co_authors := $dblp/*[author = $authors]/author[not(. = $authors) and not(. = $visited)]
    let $dist := (
        if (count($authors) = 0) then
            <distance author1="{$author_one}" author2="{$author_two}" distance="0"/>
        else if ($co_authors = $author_two) then
            <distance author1="{$author_one}" author2="{$author_two}" distance="{$counter}"/>
        else
            local:distance($author_one, $author_two, $co_authors, ($visited, $co_authors), $counter + 1, $dblp)
    )

    return $dist
};

<distances> {
    let $authors := doc("dblp-excerpt.xml")/dblp/*/author[not(. = ./following::author)]
    for $author_one in $authors
        let $sub_authors := $author_one/following::author[not(. = ./following::author)]
        for $author_two in $sub_authors
            return
                local:distance($author_one, $author_two, $author_one, <author></author>, 1, doc("dblp-excerpt.xml")/dblp)
}
</distances>
