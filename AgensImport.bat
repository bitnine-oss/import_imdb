@echo off
rem This batch file will port imdb data into AgensGraph in the relational format.
agens -e -f "imdb_load.sql" imdb
echo Data Preparation Complete
agens -e -f "graph_create.sql" imdb
echo IMDB Graph Database Ready
