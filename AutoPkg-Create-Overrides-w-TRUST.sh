#!/bin/bash

#Taken from https://github.com/lindegroup/autopkgr/issues/571
#Creates override list for recipes to allow them to be trusted

A="$HOME/Library/Application Support/AutoPkgr"
for R in $(cat "$A/recipe_list.txt"); do
    if  [[ $R == local.* ]] ; then
        echo Skipping: $R
        echo $R >> "$A/recipe_list.new"
    else
        OV=$(autopkg make-override $R | awk '{print substr($0,24)}')
        echo Created: $OV
        /usr/libexec/PlistBuddy -c "print Identifier" "$OV" >> "$A/recipe_list.new"
    fi
done
mv "$A/recipe_list.txt" "$A/recipe_list.bak"
mv "$A/recipe_list.new" "$A/recipe_list.txt"