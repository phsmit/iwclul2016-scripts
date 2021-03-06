#!/usr/bin/env python3

for lang in ("sme", "est", "fin"):
    g = ("M", "F")
    if lang == "est":
        g = ("M", "F", "M2")
    for gender in g:
        for tool in ("s", "v"):
            for order in range(5,10):
                for type in ("m", "w"):
                    with open("{}{}_s1w_{}_{}g_{}.sh".format(lang,gender,tool,order,type), 'w') as f:
                        print("export TRAIN_NAME='{}{}_s1w_{}_{}g_{}'".format(lang,gender,tool,order,type), file=f)
                        print("export TRAIN_DIR=$GROUP_DIR/p/sami/lmmodels/small1_wikipedia/$TRAIN_NAME", file=f)
                        print(file=f)
                        print("export SOURCE_FILES=$GROUP_DIR/p/sami/audio_data/{}_{}/train_9000.trn:$GROUP_DIR/p/sami/lmdata/{}/wikipedia_small.txt".format(lang, gender, lang), file=f)
                        print(file=f)
                        print("export NGRAM_ORDER={}".format(order), file=f)
                        print("export PRUNE_THRESHOLD=5e-9", file=f)
                        print(file=f)
                        print("export LA_NGRAM_ORDER={}".format(order//3), file=f)
                        print("export LA_PRUNE_THRESHOLD=5e-8", file=f)

                        if type == "m":
                            print("export MORPH_TRAIN_OPTIONS=\"\"", file=f)
                        if tool == "v":
                            print("export VARIKN_OPTIONS=\"\"", file=f)
                            print("export VARIKN_DEVSIZE=100", file=f)
