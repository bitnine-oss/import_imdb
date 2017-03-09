#!/bin/bash
agens imdb --echo-queries -f "imdb_load.sql" 
printf "Data Preparation Complete"
agens imdb --echo-queries -f "graph_create.sql"
printf "IMDB Graph Database Ready"
