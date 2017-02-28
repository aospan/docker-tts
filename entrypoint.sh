#!/bin/bash

set -e

# sanity check
if [ ! -d "/opt/out" ]; then
  echo "Please run docker with \"-v \`pwd\`/out:/opt/out\" option"
  false;
fi

cd /opt/merlin

text="Hello my name is Joker. Today is a great day because it's my birthday"
if [ ! -z "$1" ]; then
    text=$@
fi

echo "Using text: $text"

rm -rf prompt-lab
rm -rf prompt-utt
mkdir prompt-lab
mkdir prompt-utt

echo "(utt.save (utt.synth (Utterance Text \"$text\" )) \"prompt-utt/tts.utt\")" > tts.scm
echo "tts" > file_id_list.scp

# Do text to labels conversion
/opt/merlin/tools/festival/bin/festival -b tts.scm

/opt/merlin/misc/scripts/frontend/festival_utt_to_lab/make_labels \
    prompt-lab \
    prompt-utt \
    /opt/merlin/tools/festival/examples/dumpfeats \
    /opt/merlin/misc/scripts/frontend/festival_utt_to_lab

python /opt/merlin/misc/scripts/frontend/utils/normalize_lab_for_merlin.py \
  prompt-lab/full \
  label_no_align \
  state_align \
  file_id_list.scp \
  0


#Pass labels to NN to synthesize wav
cd /opt/merlin/egs/slt_arctic/s1

cp /opt/merlin/label_no_align/tts.lab experiments/bdl_arctic_full/test_synthesis/prompt-lab/tts.lab 
echo "tts" > experiments/bdl_arctic_full/test_synthesis/test_id_list.scp

. conf/global_settings.cfg
./scripts/submit.sh ${MerlinDir}/src/run_merlin.py \
  conf/test_dur_synth_${Voice}.conf \
  && ./scripts/submit.sh ${MerlinDir}/src/run_merlin.py conf/test_synth_${Voice}.conf

cp ./experiments/bdl_arctic_full/test_synthesis/wav/tts.wav /opt/out/
