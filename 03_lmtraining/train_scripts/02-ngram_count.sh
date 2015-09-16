#!/bin/bash 

BASE_DIR=$(readlink -f $(dirname "$0"))/..

if [ -z "$1" ]; then
    echo "Provide a config file"
    exit
fi

source "$1"


INTERPOLATE=$(seq 1 $NGRAM_ORDER | sed "s/^/-interpolate/" | tr "\n" " ")
KNDISCOUNT=$(seq 1 $NGRAM_ORDER | sed "s/^/-kndiscount/" | tr "\n" " ")


cat $TRAIN_DIR/lm_source_txt | \
ngram-count \
  -order $NGRAM_ORDER \
  $INTERPOLATE \
  -text - \
  -lm $TRAIN_DIR/model.gz \
  $KNDISCOUNT \
  -write-vocab $TRAIN_DIR/vocab
  
   