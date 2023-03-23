#!/bin/bash

DEV=devdata
FULL=fulldata
MODE="$1"
DATA_DIR=./data
RESULT_DIR=./results

if [ ! -d $DATA_DIR ]
then
    echo "No Data Folder Found!"
    exit 1
else
    if [ ! -d $RESULT_DIR ]
    then
        mkdir $RESULT_DIR
    fi
    if [ ! -d "$RESULT_DIR/$DEV" ]
    then 
        mkdir $RESULT_DIR/$DEV
    fi
    if [ ! -d "$RESULT_DIR/$FULL" ]
    then
        mkdir $RESULT_DIR/$FULL
    fi
    if [ $MODE = "full" ]
    then
        python unigram.py -r local $DATA_DIR/$FULL/*.txt > $RESULT_DIR/$FULL/unigram_index.txt
        python bigram.py -r local $DATA_DIR/$FULL/*.txt > $RESULT_DIR/$FULL/selected_bigram_index.txt
    elif [ $MODE = "dev" ]
    then
        python unigram.py -r local $DATA_DIR/$DEV/*.txt > $RESULT_DIR/$DEV/unigram_index.txt
        python bigram.py -r local $DATA_DIR/$DEV/*.txt > $RESULT_DIR/$DEV/selected_bigram_index.txt
    else
        echo "Wrong Mode! Please enter either 'full' or 'dev'!"
        exit 1
    fi
fi