# Check for docker image provided
TRIVY="docker run --rm --name trivy -v $(pwd):/tmp/ -w /tmp/ -v $HOME/.docker/config.json:/root/.docker/config.json aquasec/trivy"

# Expect the user to input -i <image_name> or -f <file_name>
if [ "$1" = "-i" ]; then
    IMAGE_NAME="$2"
elif [ "$1" = "-f" ]; then
    FILE_NAME="$2"
else
    echo "Please provide -i <image_name> or -f <file_name>"
    exit 1
fi

if ! [ -z "$FILE_NAME" ]
then
    echo "Multiple images were provided in $FILE_NAME"
    cat $FILE_NAME
    echo
    echo

    # If a file with multiple images are provided we'll loop through it and scan all of them
    while read -r image
    do
        echo "-----------------------------------"
        echo "Scanning $image for vulnerabilities"
        echo "-----------------------------------"
        echo "Pull image"
        docker pull $image
        echo "Scan image"
        $TRIVY -- image --format template --template "@html.tpl" -o /tmp/report-$(echo $image | tr "[/:]" _).html $image
    done < $FILE_NAME
else
    # Else just scan the image provided
    echo "----------------------------------------"
    echo "Scanning $IMAGE_NAME for vulnerabilities"
    echo "----------------------------------------"
    echo "Pull image"
    docker pull $IMAGE_NAME
    echo "Scan image"
    $TRIVY -- image --format template --template "@html.tpl" -o /tmp/report-$(echo $IMAGE_NAME | tr "[/:]" _).html $IMAGE_NAME
fi
