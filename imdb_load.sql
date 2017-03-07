\echo 'CREATING VIEWS...'
CREATE VIEW temp_person_info AS
    SELECT person_info.person_id, person_info.info, info_type.info AS info_type
    FROM person_info LEFT JOIN info_type ON person_info.info_type_id = info_type.id;

CREATE VIEW temp_movie AS
    SELECT a.id, a.episode_nr, a.episode_of_id, a.imdb_id, a.imdb_index, b.kind, a.md5sum, a.phonetic_code, a.production_year, a.season_nr, a.series_years, a.title
    FROM title AS a LEFT JOIN kind_type AS b ON  a.kind_id = b.id;

CREATE VIEW temp_movie_info AS
    SELECT a.movie_id, a.info AS info ,b.info AS info_type, a.note
    FROM movie_info AS a LEFT JOIN info_type AS b ON a.info_type_id = b.id;

CREATE VIEW temp_complete_cast AS
    SELECT complete_cast.movie_id , a.kind AS subject_id, b.kind AS status_id
    FROM complete_cast INNER JOIN comp_cast_type AS a ON complete_cast.subject_id = a.id
    INNER JOIN comp_cast_type AS b ON complete_cast.status_id = b.id;

CREATE VIEW actor_relationships AS
    SELECT a.person_id, a.person_role_id, a.role_id, a.movie_id, b.name, b.name_pcode_nf, b.surname_pcode, b.md5sum, b.imdb_id, b.imdb_index
    FROM cast_info AS a LEFT JOIN char_name AS b ON a.person_role_id = b.id
    WHERE a.role_id <= 2;

\echo 'CREATING TABLES...'
CREATE TABLE jsonb_person (data jsonb);
CREATE TABLE jsonb_production (data jsonb);
CREATE TABLE jsonb_company (data jsonb);
CREATE TABLE jsonb_keyword (data jsonb);




\echo 'PREPARING DATA FOR PERSONS'

INSERT INTO jsonb_person (data)
SELECT json_strip_nulls(row_to_json(fullperson)) as answer
FROM(
    SELECT a.id, a.name, a.gender, a.name_pcode_cf, a.name_pcode_nf, a.surname_pcode, a.md5sum,
        (SELECT jsonb_agg (inf) 
        FROM ( 
            SELECT name AS aka_name ,name_pcode_cf,name_pcode_nf, surname_pcode, md5sum 
            FROM aka_name WHERE person_id = a.id
            ) inf
        ) as alternate_names,
        (SELECT array_agg(jsonb_build_object (info_type, info))
        FROM temp_person_info WHERE person_id = a.id
        ) as full_info
    FROM name AS a
) fullperson;

\echo 'PREPARING DATA FOR PRODUCTIONS'

INSERT INTO jsonb_production (data)
SELECT json_strip_nulls(row_to_json(fullproduction)) as answer
FROM(
    SELECT a.id, a.title, a.phonetic_code, a.production_year, a.imdb_id, a.imdb_index, a.md5sum, a.kind, a.episode_nr, a.season_nr, a.series_years, 
        (SELECT jsonb_agg (ANS) 
        FROM ( 
            SELECT b.title AS aka_title, b.phonetic_code, b.production_year, c.kind, b.note, b.episode_of_id, b.episode_nr, b.md5sum 
            FROM aka_title AS b LEFT JOIN kind_type AS c ON b.kind_id = c.id WHERE b.movie_id = a.id
            ) ANS 
        )AS alternate_titles,
        (SELECT array_agg(jsonb_build_object (info_type, info))
        FROM temp_movie_info WHERE movie_id = a.id
        ) AS full_info,
        (SELECT array_agg(jsonb_build_object (subject_id, status_id))
        FROM temp_complete_cast WHERE movie_id = a.id) AS cast_and_crew_info

    FROM temp_movie as a
) AS fullproduction;

\echo 'PREPARING DATA FOR KEYWORDS'

INSERT INTO jsonb_keyword (data)
SELECT json_strip_nulls(row_to_json(fullkeyword)) AS answer
FROM (
    SELECT *
    FROM keyword
) fullkeyword;

\echo 'PREPARING DATA FOR COMPANIES'
INSERT INTO jsonb_company (data)
SELECT json_strip_nulls(row_to_json(fullcompany)) AS answer
FROM (
    SELECT *
    FROM company_name
) fullcompany;

