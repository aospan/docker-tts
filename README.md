# Text to speech service (TTS). Neural Network (NN) based Speech Synthesis System

## Description
Based on the Merlin project (https://github.com/CSTR-Edinburgh/merlin/).
NN trained on 'cmu_us_bdl_arctic' dataset (male voice) prepared by Carnegie
Mellon University.

## Usage
In the command line run following commands
```
docker build -t tts .
docker run -it -v `pwd`/out:/opt/out tts
```
Default text ('Hello, my name is Joker') will be used. Resulting audio file location: 'out/tts.wav'.

## Provide your own text
run docker container with your text as argument:
```
docker run -it -v `pwd`/out:/opt/out tts "Hello. This is text to speech service"
```
Resulting audio file location: 'out/tts.wav'.

(c) Abylay Ospan <aospan@jokersys.com>, 2017
https://jokersys.com
