#!/bin/bash 

BASE_DIR=$(readlink -f $(dirname "$0"))/..

if [ -z "$1" ]; then
    echo "Provide a config file"
    exit
fi

source "$1"

if [  -z ${VARIKN_OPTIONS+x} ]; then

ngram -order $NGRAM_ORDER -unk -lm $TRAIN_DIR/model.gz -prune $PRUNE_THRESHOLD -write-lm $TRAIN_DIR/${TRAIN_NAME}
ngram -order $LA_NGRAM_ORDER -unk -lm $TRAIN_DIR/model.gz -prune $LA_PRUNE_THRESHOLD -write-lm $TRAIN_DIR/model_la

else
ngram -order $LA_NGRAM_ORDER -unk -lm $TRAIN_DIR/${TRAIN_NAME} -prune $LA_PRUNE_THRESHOLD -write-lm $TRAIN_DIR/model_la
fi


lm --arpa="$TRAIN_DIR/${TRAIN_NAME}" --out-bin="$TRAIN_DIR/${TRAIN_NAME}.fsabin"
arpa2bin < "$TRAIN_DIR/model_la" > "$TRAIN_DIR/model_la.bin"

if [ ! -z ${MORPH_TRAIN_OPTIONS+x} ]; then
extra_option="-morph"
fi

$BASE_DIR/../02_amtraining/base_scripts/vocab2lex.pl $extra_option -read="$TRAIN_DIR/vocab" >"$TRAIN_DIR/vocab.lex"

