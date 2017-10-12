\echo 'Creating and setting graph path...'
CREATE GRAPH imdb_graph;
SET graph_path = imdb_graph;

\echo 'Creating Vertices...'
CREATE VLABEL IF NOT EXISTS Person;
CREATE VLABEL IF NOT EXISTS Production;
CREATE VLABEL IF NOT EXISTS Company;
CREATE VLABEL IF NOT EXISTS Keyword;

\echo 'Populating Nodes...'
LOAD FROM jsonb_person AS persons
CREATE (a:Person =persons.data);

LOAD FROM jsonb_production AS productions
CREATE (a:Production =productions.data);

LOAD FROM jsonb_company AS companies
CREATE (a:Company = companies.data);

LOAD FROM jsonb_keyword AS keywords
CREATE (a:Keyword = keywords.data);


\echo 'Creating Property Indexes'
CREATE PROPERTY INDEX ON PERSON (id);
CREATE PROPERTY INDEX ON PRODUCTION (id);
CREATE PROPERTY INDEX ON COMPANY (id);
CREATE PROPERTY INDEX ON KEYWORD (id);

--KEYWORD LINKS
\echo 'Creating Keyword Links...'
CREATE ELABEL IF NOT EXISTS KEYWORD_OF;

LOAD FROM movie_keyword AS rel_key_movie
MATCH (a:Keyword), (b:Production)
WHERE a.id = to_jsonb(rel_key_movie.keyword_id) AND b.id = to_jsonb(rel_key_movie.movie_id)
CREATE (a)-[:KEYWORD_OF]->(b);

--COMPANY LINKS

\echo 'Creating Company Links...'

CREATE ELABEL IF NOT EXISTS DISTRIBUTED;
CREATE ELABEL IF NOT EXISTS PRODUCED;
CREATE ELABEL IF NOT EXISTS DID_SPECIAL_EFFECTS_FOR;
CREATE ELABEL IF NOT EXISTS MISC_WORK_ON;

LOAD FROM movie_companies AS rel_company_movie
MATCH (a:Company), (b:Production)
WHERE a.id = to_jsonb(rel_company_movie.company_id) AND b.id = to_jsonb(rel_company_movie.movie_id) AND to_jsonb(rel_company_movie.company_type_id) = 1
CREATE (a)-[:DISTRIBUTED]->(b);

LOAD FROM movie_companies AS rel_company_movie
MATCH (a:Company), (b:Production)
WHERE a.id = to_jsonb(rel_company_movie.company_id) AND b.id = to_jsonb(rel_company_movie.movie_id) AND to_jsonb(rel_company_movie.company_type_id) = 2
CREATE (a)-[:PRODUCED]->(b);

--NOT USED
LOAD FROM movie_companies AS rel_company_movie
MATCH (a:Company), (b:Production)
WHERE a.id = to_jsonb(rel_company_movie.company_id) AND b.id = to_jsonb(rel_company_movie.movie_id) AND to_jsonb(rel_company_movie.company_type_id) = 3
CREATE (a)-[:DID_SPECIAL_EFFECTS_FOR]->(b);

--NOT USED
LOAD FROM movie_companies AS rel_company_movie
MATCH (a:Company), (b:Production)
WHERE a.id = to_jsonb(rel_company_movie.company_id) AND b.id = to_jsonb(rel_company_movie.movie_id) AND to_jsonb(rel_company_movie.company_type_id) = 4
CREATE (a)-[:MISC_WORK_ON]->(b);


--PRODUCTION LINKS
\echo 'Creating Production Links...'

CREATE ELABEL IF NOT EXISTS FOLLOWS;
CREATE ELABEL IF NOT EXISTS FOLLOWED_BY;
CREATE ELABEL IF NOT EXISTS REMAKE_OF;
CREATE ELABEL IF NOT EXISTS REMADE_AS;
CREATE ELABEL IF NOT EXISTS MAKES_REFERENCES_TO;
CREATE ELABEL IF NOT EXISTS REFERENCED_IN;
CREATE ELABEL IF NOT EXISTS SPOOFS;
CREATE ELABEL IF NOT EXISTS SPOOFED_IN;
CREATE ELABEL IF NOT EXISTS FEATURES;
CREATE ELABEL IF NOT EXISTS FEATURED_IN;
CREATE ELABEL IF NOT EXISTS SPIN_OFF_FROM;
CREATE ELABEL IF NOT EXISTS SPIN_OFF;
CREATE ELABEL IF NOT EXISTS VERSION_OF;
CREATE ELABEL IF NOT EXISTS SIMILAR_TO;
CREATE ELABEL IF NOT EXISTS EDITED_INTO;
CREATE ELABEL IF NOT EXISTS EDITED_FROM;
CREATE ELABEL IF NOT EXISTS ALTERNATE_LANGUAGE_VERSION_OF;
CREATE ELABEL IF NOT EXISTS UNKNOWN_LINK;

LOAD FROM movie_link AS link
MATCH (a:Production), (b:Production)
WHERE a.id = to_jsonb(link.movie_id) AND b.id = to_jsonb(link.linked_movie_id) AND to_jsonb(link.link_type_id) = 1
CREATE (a)-[:FOLLOWS]->(b);

LOAD FROM movie_link AS link
MATCH (a:Production), (b:Production)
WHERE a.id = to_jsonb(link.movie_id) AND b.id = to_jsonb(link.linked_movie_id) AND to_jsonb(link.link_type_id) = 2
CREATE (a)-[:FOLLOWED_BY]->(b);

LOAD FROM movie_link AS link
MATCH (a:Production), (b:Production)
WHERE a.id = to_jsonb(link.movie_id) AND b.id = to_jsonb(link.linked_movie_id) AND to_jsonb(link.link_type_id) = 3
CREATE (a)-[:REMAKE_OF]->(b);

LOAD FROM movie_link AS link
MATCH (a:Production), (b:Production)
WHERE a.id = to_jsonb(link.movie_id) AND b.id = to_jsonb(link.linked_movie_id) AND to_jsonb(link.link_type_id) = 4
CREATE (a)-[:REMADE_AS]->(b);

LOAD FROM movie_link AS link
MATCH (a:Production), (b:Production)
WHERE a.id = to_jsonb(link.movie_id) AND b.id = to_jsonb(link.linked_movie_id) AND to_jsonb(link.link_type_id) = 5
CREATE (a)-[:MAKES_REFERENCES_TO]->(b);

LOAD FROM movie_link AS link
MATCH (a:Production), (b:Production)
WHERE a.id = to_jsonb(link.movie_id) AND b.id = to_jsonb(link.linked_movie_id) AND to_jsonb(link.link_type_id) = 6
CREATE (a)-[:REFERENCED_IN]->(b);

LOAD FROM movie_link AS link
MATCH (a:Production), (b:Production)
WHERE a.id = to_jsonb(link.movie_id) AND b.id = to_jsonb(link.linked_movie_id) AND to_jsonb(link.link_type_id) = 7
CREATE (a)-[:SPOOFS]->(b);

LOAD FROM movie_link AS link
MATCH (a:Production), (b:Production)
WHERE a.id = to_jsonb(link.movie_id) AND b.id = to_jsonb(link.linked_movie_id) AND to_jsonb(link.link_type_id) = 8
CREATE (a)-[:SPOOFED_IN]->(b);

LOAD FROM movie_link AS link
MATCH (a:Production), (b:Production)
WHERE a.id = to_jsonb(link.movie_id) AND b.id = to_jsonb(link.linked_movie_id) AND to_jsonb(link.link_type_id) = 9
CREATE (a)-[:FEATURES]->(b);

LOAD FROM movie_link AS link
MATCH (a:Production), (b:Production)
WHERE a.id = to_jsonb(link.movie_id) AND b.id = to_jsonb(link.linked_movie_id) AND to_jsonb(link.link_type_id) = 10
CREATE (a)-[:FEATURED_IN]->(b);

LOAD FROM movie_link AS link
MATCH (a:Production), (b:Production)
WHERE a.id = to_jsonb(link.movie_id) AND b.id = to_jsonb(link.linked_movie_id) AND to_jsonb(link.link_type_id) = 11
CREATE (a)-[:SPIN_OFF_FROM]->(b);

LOAD FROM movie_link AS link
MATCH (a:Production), (b:Production)
WHERE a.id = to_jsonb(link.movie_id) AND b.id = to_jsonb(link.linked_movie_id) AND to_jsonb(link.link_type_id) = 12
CREATE (a)-[:SPIN_OFF]->(b);

LOAD FROM movie_link AS link
MATCH (a:Production), (b:Production)
WHERE a.id = to_jsonb(link.movie_id) AND b.id = to_jsonb(link.linked_movie_id) AND to_jsonb(link.link_type_id) = 13
CREATE (a)-[:VERSION_OF]->(b);

LOAD FROM movie_link AS link
MATCH (a:Production), (b:Production)
WHERE a.id = to_jsonb(link.movie_id) AND b.id = to_jsonb(link.linked_movie_id) AND to_jsonb(link.link_type_id) = 14
CREATE (a)-[:SIMILAR_TO]->(b);

LOAD FROM movie_link AS link
MATCH (a:Production), (b:Production)
WHERE a.id = to_jsonb(link.movie_id) AND b.id = to_jsonb(link.linked_movie_id) AND to_jsonb(link.link_type_id) = 15
CREATE (a)-[:EDITED_INTO]->(b);

LOAD FROM movie_link AS link
MATCH (a:Production), (b:Production)
WHERE a.id = to_jsonb(link.movie_id) AND b.id = to_jsonb(link.linked_movie_id) AND to_jsonb(link.link_type_id) = 16
CREATE (a)-[:EDITED_FROM]->(b);

LOAD FROM movie_link AS link
MATCH (a:Production), (b:Production)
WHERE a.id = to_jsonb(link.movie_id) AND b.id = to_jsonb(link.linked_movie_id) AND to_jsonb(link.link_type_id) = 17
CREATE (a)-[:ALTERNATE_LANGUAGE_VERSION_OF]->(b);

LOAD FROM movie_link AS link
MATCH (a:Production), (b:Production)
WHERE a.id = to_jsonb(link.movie_id) AND b.id = to_jsonb(link.linked_movie_id) AND to_jsonb(link.link_type_id) = 18
CREATE (a)-[:UNKNOWN_LINK]->(b);

--ACTING LINKS
\echo 'Creating Acting Links...'
CREATE ELABEL IF NOT EXISTS ACTOR_IN;
CREATE ELABEL IF NOT EXISTS ACTRESS_IN;
CREATE ELABEL IF NOT EXISTS PRODUCER_OF;
CREATE ELABEL IF NOT EXISTS WRITER_OF;
CREATE ELABEL IF NOT EXISTS CINEMATOGRAPHER_OF;
CREATE ELABEL IF NOT EXISTS COMPOSER_FOR;
CREATE ELABEL IF NOT EXISTS COSTUME_DESIGNER_FOR;
CREATE ELABEL IF NOT EXISTS DIRECTOR_OF;
CREATE ELABEL IF NOT EXISTS EDITOR_OF;
CREATE ELABEL IF NOT EXISTS MISC_CREW_OF;
CREATE ELABEL IF NOT EXISTS PRODUCTION_DESIGNER_FOR;
CREATE ELABEL IF NOT EXISTS GUEST_IN;
LOAD FROM actor_relationships AS crew_relations
MATCH (a:Person), (b:Production)
WHERE a.id = to_jsonb(crew_relations.person_id) AND b.id = to_jsonb(crew_relations.movie_id) AND to_jsonb(crew_relations.role_id) = 1
CREATE (a)-[:ACTOR_IN {role_name: crew_relations.name, name_pcode_nf: crew_relations.name_pcode_nf, surname_pcode: crew_relations.surname_pcode, md5sum: crew_relations.md5sum} ]->(b);
LOAD FROM actor_relationships AS crew_relations
MATCH (a:Person), (b:Production)
WHERE a.id = to_jsonb(crew_relations.person_id) AND b.id = to_jsonb(crew_relations.movie_id) AND to_jsonb(crew_relations.role_id) = 2
CREATE (a)-[:ACTRESS_IN { role_name: crew_relations.name, name_pcode_nf: crew_relations.name_pcode_nf, surname_pcode: crew_relations.surname_pcode, md5sum: crew_relations.md5sum } ]->(b);

--CAST LINKS
LOAD FROM cast_info AS crew_relations
MATCH (a:Person), (b:Production)
WHERE a.id = to_jsonb(crew_relations.person_id) AND b.id = to_jsonb(crew_relations.movie_id) AND to_jsonb(crew_relations.role_id) = 3
CREATE (a)-[:PRODUCER_OF ]->(b);

LOAD FROM cast_info AS crew_relations
MATCH (a:Person), (b:Production)
WHERE a.id = to_jsonb(crew_relations.person_id) AND b.id = to_jsonb(crew_relations.movie_id) AND to_jsonb(crew_relations.role_id) = 4
CREATE (a)-[:WRITER_OF ]->(b);

LOAD FROM cast_info AS crew_relations
MATCH (a:Person), (b:Production)
WHERE a.id = to_jsonb(crew_relations.person_id) AND b.id = to_jsonb(crew_relations.movie_id) AND to_jsonb(crew_relations.role_id) = 5
CREATE (a)-[:CINEMATOGRAPHER_OF]->(b);

LOAD FROM cast_info AS crew_relations
MATCH (a:Person), (b:Production)
WHERE a.id = to_jsonb(crew_relations.person_id) AND b.id = to_jsonb(crew_relations.movie_id) AND to_jsonb(crew_relations.role_id) = 6
CREATE (a)-[:COMPOSER_FOR]->(b);

LOAD FROM cast_info AS crew_relations
MATCH (a:Person), (b:Production)
WHERE a.id = to_jsonb(crew_relations.person_id) AND b.id = to_jsonb(crew_relations.movie_id) AND to_jsonb(crew_relations.role_id) = 7
CREATE (a)-[:COSTUME_DESIGNER_FOR]->(b);

LOAD FROM cast_info AS crew_relations
MATCH (a:Person), (b:Production)
WHERE a.id = to_jsonb(crew_relations.person_id) AND b.id = to_jsonb(crew_relations.movie_id) AND to_jsonb(crew_relations.role_id) = 8
CREATE (a)-[:DIRECTOR_OF]->(b);

LOAD FROM cast_info AS crew_relations
MATCH (a:Person), (b:Production)
WHERE a.id = to_jsonb(crew_relations.person_id) AND b.id = to_jsonb(crew_relations.movie_id) AND to_jsonb(crew_relations.role_id) = 9
CREATE (a)-[:EDITOR_OF]->(b);

LOAD FROM cast_info AS crew_relations
MATCH (a:Person), (b:Production)
WHERE a.id = to_jsonb(crew_relations.person_id) AND b.id = to_jsonb(crew_relations.movie_id) AND to_jsonb(crew_relations.role_id) = 10
CREATE (a)-[:MISC_CREW_OF]->(b);

LOAD FROM cast_info AS crew_relations
MATCH (a:Person), (b:Production)
WHERE a.id = to_jsonb(crew_relations.person_id) AND b.id = to_jsonb(crew_relations.movie_id) AND to_jsonb(crew_relations.role_id) = 11
CREATE (a)-[:PRODUCTION_DESIGNER_FOR]->(b);

LOAD FROM cast_info AS crew_relations
MATCH (a:Person), (b:Production)
WHERE a.id = to_jsonb(crew_relations.person_id) AND b.id = to_jsonb(crew_relations.movie_id) AND to_jsonb(crew_relations.role_id) = 12
CREATE (a)-[:GUEST_IN]->(b);
