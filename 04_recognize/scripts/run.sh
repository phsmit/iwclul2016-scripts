#!/bin/bash

BASE_DIR=$(readlink -f $(dirname "$0"))/..

if [ -z "$1" ]; then
    echo "Provide a config file"
    exit
fi

. "$1"


echo $TEST_LM
echo $TEST_AM

TEST_LM=(${TEST_LM//:/ })
TEST_AM=(${TEST_AM//:/ })
LM_SCALES=(${TEST_LM_SCALES//:/ })


for AMDIR in ${TEST_AM[@]}; do
    for LMDIR in ${TEST_LM[@]}; do
        for LM_SCALE in ${LM_SCALES[@]}; do
        echo "AM " $AMDIR
        echo "LM " $LMDIR
        export KEY=$(basename $AMDIR)/$(basename $LMDIR)/LM${LM_SCALE}
        export AM=$AMDIR
        export LM=$LMDIR/$(basename $LMDIR)
        export LOOKAHEAD_LM=$LMDIR/model_la
        export DICTIONARY=$LMDIR/vocab
        export FSA=1
        export BEAM=280
        export LM_SCALE
        export TOKEN_LIMIT=100000
        export AUDIO_LIST=$TEST_WAVLIST
        export RESULTS_DIR=$TEST_DIR/recognitions
        export RECOGNITIONS_DIR=$TEST_DIR/results
        export GENERATE_LATTICES=1

        mkdir -p ${RESULTS_DIR}/log/$KEY
        recognize-batch.sh | tee ${RESULTS_DIR}/log/${KEY}/log

        hyp_trn=$(grep "^Wrote" ${RESULTS_DIR}/log/${KEY}/log | sed "s/^Wrote //" | sed "s/\.$//")
#        hyp_trn=${RESULTS_DIR}/$(ls -t ${RESULTS_DIR} | grep -v log | grep -v sclite | head -n1)

        echo $hyp_trn

        td=${RESULTS_DIR}/tmp/$KEY

        mkdir -p $td

        ${BASE_DIR}/scripts/make_tests_trns.py $td $TEST_TRN $hyp_trn $ONE_BYTE_ENCODING

        sclite -i wsj -f 0 -h ${td}/hyp_wer.iso.trn -r ${td}/ref_wer.iso.trn | tee ${hyp_trn}.sclite_wer
        sclite -i wsj -f 0 -h ${td}/hyp_ler.iso.trn -r ${td}/ref_ler.iso.trn | tee ${hyp_trn}.sclite_ler
    done
done
done