
output/Seasons.csv: input-v1/seasons_1985-2016.csv
	mkdir -p working
	mkdir -p output
	python src/process.py
output/RegularSeasonCompactResults.csv: output/Seasons.csv
output/RegularSeasonDetailedResults.csv: output/Seasons.csv
output/SampleSubmission.csv: output/Seasons.csv
output/Teams.csv: output/Seasons.csv
output/TourneyCompactResults.csv: output/Seasons.csv
output/TourneyDetailedResults.csv: output/Seasons.csv
output/TourneySeeds.csv: output/Seasons.csv
output/TourneySlots.csv: output/Seasons.csv
csv: output/Seasons.csv

working/noHeader/Seasons.csv: output/Seasons.csv
	mkdir -p working/noHeader
	tail +2 $^ > $@
working/noHeader/RegularSeasonCompactResults.csv: output/RegularSeasonCompactResults.csv
	mkdir -p working/noHeader
	tail +2 $^ > $@
working/noHeader/RegularSeasonDetailedResults.csv: output/RegularSeasonDetailedResults.csv
	mkdir -p working/noHeader
	tail +2 $^ > $@
working/noHeader/SampleSubmission.csv: output/SampleSubmission.csv
	mkdir -p working/noHeader
	tail +2 $^ > $@
working/noHeader/Teams.csv: output/Teams.csv
	mkdir -p working/noHeader
	tail +2 $^ > $@
working/noHeader/TourneyCompactResults.csv: output/TourneyCompactResults.csv
	mkdir -p working/noHeader
	tail +2 $^ > $@
working/noHeader/TourneyDetailedResults.csv: output/TourneyDetailedResults.csv
	mkdir -p working/noHeader
	tail +2 $^ > $@
working/noHeader/TourneySeeds.csv: output/TourneySeeds.csv
	mkdir -p working/noHeader
	tail +2 $^ > $@
working/noHeader/TourneySlots.csv: output/TourneySlots.csv
	mkdir -p working/noHeader
	tail +2 $^ > $@

output/database.sqlite: working/noHeader/Seasons.csv working/noHeader/RegularSeasonCompactResults.csv working/noHeader/RegularSeasonDetailedResults.csv working/noHeader/SampleSubmission.csv working/noHeader/Teams.csv working/noHeader/TourneyCompactResults.csv working/noHeader/TourneyDetailedResults.csv working/noHeader/TourneySeeds.csv working/noHeader/TourneySlots.csv
	-rm output/database.sqlite
	sqlite3 -echo $@ < working/import.sql
db: output/database.sqlite

output/hashes.txt: output/database.sqlite
	-rm output/hashes.txt
	echo "Current git commit:" >> output/hashes.txt
	git rev-parse HEAD >> output/hashes.txt
	echo "\nCurrent input/ouput md5 hashes:" >> output/hashes.txt
	md5 output/*.csv >> output/hashes.txt
	md5 output/*.sqlite >> output/hashes.txt
	md5 input-v1/* >> output/hashes.txt
hashes: output/hashes.txt

release: output/hashes.txt
	cp -r output march-machine-learning-mania-2016-v1
	zip -r -X output/march-machine-learning-mania-2016-v1-release-`date -u +'%Y-%m-%d-%H-%M-%S'` world-development-indicators/*
	rm -rf march-machine-learning-mania-2016-v1

all: csv db hashes release

clean:
	rm -rf working
	rm -rf output
