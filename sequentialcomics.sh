#!/bin/bash
# Allows you to download images with a sequential key automatically. 
# Defaults to png, if it doesn't exist the scripts tries gif and then jpg. 
# Intended for webcomics, but can be used for any images. 

url="https://www.example.org/IDX.png"
counter=1
wgetResult=200 

while [[ $wgetResult != 404 ]]
do
    ((counter++))
    baseurl="${url//IDX/$counter}"
    newUrl=$baseurl
    
    echo "Counter ${counter}"
    echo "Trying URL ${newUrl}"
    
    # Try downloading PNG
    wgetResult=$(wget -NS "$newUrl" 2>&1 | grep "HTTP/" | awk '{print $2}')
    
    if [[ $wgetResult == 404 ]]; then
        # If PNG download fails, try GIF
        newUrl="${baseurl%.png}.gif"
        echo "PNG not found, trying URL ${newUrl}"
        wgetResult=$(wget -NS "$newUrl" 2>&1 | grep "HTTP/" | awk '{print $2}')
        
        if [[ $wgetResult == 404 ]]; then
            # If GIF download fails, try JPG
            newUrl="${baseurl%.png}.jpg"
            echo "GIF not found, trying URL ${newUrl}"
            wgetResult=$(wget -NS "$newUrl" 2>&1 | grep "HTTP/" | awk '{print $2}')
        fi
    fi
    
    echo "Result: $wgetResult"
    
    sleep 3
done
