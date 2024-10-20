#!/bin/bash

# Check if three arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Please provide the cooler files folder, view configuration file, and the output folder as arguments"
    exit 1
fi

cooler_folder="$1"
view_config_file="$2"
output_folder="$3"

# Start HiGlass and ingest data
sudo -u "$USER" higlass-manage start --no-public-data --media-dir /tmp/media-dir
sudo -u "$USER" cp -r "$cooler_folder/" /tmp/media-dir
sudo -u "$USER" cp -r "$cooler_folder/" /home/kevinzou53/hg-data

cd "$cooler_folder"
rm -rf temp
mkdir temp
touch temp/temp.txt
touch temp/saved_views.txt

for FILE in *; do
    ingestOutput=$(sudo -u "$USER" higlass-manage ingest --filetype cooler --datatype matrix "/tmp/media-dir/$FILE")
    newTilesetUid=$(echo "$ingestOutput" | grep "command" | awk '{print $NF}')

    echo "$FILE=$newTilesetUid" >> temp/temp.txt

    # Update view configuration with the new tileset UID for the center track
    tmp_file=$(mktemp)
    jq --arg newUid "$newTilesetUid" '.viewconf.views[].tracks.center[0].tilesetUid = $newUid' "$view_config_file" > "$tmp_file"

    if [ -s "$tmp_file" ]; then
        mv "$tmp_file" "$output_folder/$(basename "$view_config_file")"

        # Save view configuration UID to saved_views.txt
        curlOutput=$(curl -X POST -H "Content-Type: application/json" -d "@$output_folder/$(basename "$view_config_file")" http://localhost:8989/api/v1/viewconfs/)
        viewConfUid=$(echo "$curlOutput" | jq -r '.uid')
        echo "$FILE=http://localhost:8989/app/?config=$viewConfUid" >> "$output_folder/saved_views.txt"
    else
        echo "Error: Failed to update the view configuration for file $FILE."
    fi
done

cd ../
cat "$cooler_folder/temp/temp.txt" >> "$output_folder/ingested_data.txt"
cat "$cooler_folder/temp/saved_views.txt" >> "$output_folder/saved_views.txt"