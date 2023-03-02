set -e
 set -x

# we want to run light house on all the urls in 
# the inpput file
#  and save the output ( ideally as pdf ) 
#  to the dir based on date, and a filename approprotate to the url
#  that could just be show_id

showID_regex='show_id=([0-9]+)'

INPUTFILE='show_urls.txt'

TIMESTAMP=`date  +%F-%H%M%S`    #2023-03-02-091626 format

DATA_DIR=data/$TIMESTAMP

mkdir -p $DATA_DIR



while  IFS= read -r  SHOWURL; do

       # skip blank lines
        [ -z "$SHOWURL" ] && continue

        # skip lines that start with #
        if [[ $SHOWURL =~ '#' ]]; then
            echo "Skipping comment line"
            continue
        fi

        echo "Working on show: $SHOWURL"

        if [[ $SHOWURL =~ $showID_regex ]]; then
            SHOW_ID=${BASH_REMATCH[1]}
            echo $SHOW_ID
        fi

    lighthouse  $SHOWURL \
        --output=json\
        --output=html\
        --output-path=$DATA_DIR/$SHOW_ID \
        --extra-headers   "{\"Cookie\": \"_ga=GA1.2.269269085.1676502087; _gid=GA1.2.332542657.1676502087; _gat=1; __stripe_mid=7436f92e-bcbd-4be8-94eb-0579772e873b486c28; __stripe_sid=6ea407c6-d965-4edf-8d02-ce7d596a2a5d83f20b; _vfa_service_session=Uk4ra01nenpYQXJraDFkUmE0b1FYQnhLMDRKYjdLUytZYW5ZcDgxeFJWT2s3Q3lMb0M2QlpZVUcwMGtNbVFtSk5XcGtCSnM4Ukl4MFB3VVlyZStBR2dLTVR4NWZQWFpTOUdWbVpvMnVLSERta0Y0VkhLb2RFek9HK0hWeUd0My8zL0RNR2ZER1VHbjkzanpSTWRxc24wdFdHYkZNeWRUUUhaRi9VRzRHb2d5WWZUdzFpY2d3M2Q5a1BZNVFUS0VpK2QxV0RUTkNLdmJ5SzlTRWZZcUEvWUg4SndvLzVYbE5IUk5yR05wbUpmUT0tLUpLdnR5Uk5IQ0NqK0JjRE1Ld1piNHc9PQ%3D%3D--dd016c4f09631f9ee8e7775ab34ae3022b76e86a\"}" \


    sleep 10   # make sure the browsers close    

done < $INPUTFILE