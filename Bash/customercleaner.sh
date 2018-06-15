#!/bin/bash

home=/home/* # Find home directory for all user accounts

# The following are any folders in the user's home directory
userdocuments=home/Documents
userpictures=home/Pictures
uservideos=home/Videos
usermusic=home/Music
userdownloads=home/Downloads

function cleancontent {
    rm -rf $userdocuments
    rm -rf $userpictures
    rm -rf $uservideos
    rm -rf $usermusic
    rm -rf $userdownloads
    rm -rf $home/*
}

function recreatefolders {
    mkdir $userdocuments
    mkdir $userpictures
    mkdir $uservideos
    mkdir $usermusic
    mkdir $userdownloads
}

function permissions {
    
}
