export TEST_NAME="saami-m-3gram-dev"
export TEST_DIR="$GROUP_DIR/p/sami/recog_tests/$TEST_NAME"


export TEST_AM=(
"$GROUP_DIR/p/sami/models/saami_male/hmm/saami_male_11.8.2015_22"
)
export TEST_LM=(
"$GROUP_DIR/p/sami/lmmodels/saamiM_3gram_word"
)

export TEST_TRN="$GROUP_DIR/p/sami/uit-sme-M/devel.trn"
export TEST_WAVLIST="$GROUP_DIR/p/sami/uit-sme-M/devel.scp"
