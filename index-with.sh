#!/bin/bash

interfaces="AnalyserNode AudioBuffer AudioBufferSourceNode AudioContext AudioDestinationNode AudioListener AudioNode AudioParam AudioParamMap AudioProcessingEvent AudioScheduledSourceNode AudioWorklet AudioWorkletGlobalScope AudioWorkletNode AudioWorkletProcessor BaseAudioContext BiquadFilterNode ChannelMergerNode ChannelSplitterNode ConstantSourceNode ConvolverNode DelayNode DynamicsCompressorNode GainNode IIRFilterNode MediaElementAudioSourceNode MediaStreamAudioDestinationNode MediaStreamAudioSourceNode MediaStreamTrackAudioSourceNode OfflineAudioCompletionEvent OfflineAudioContext OscillatorNode PannerNode PeriodicWave ScriptProcessorNode StereoPannerNode WaveShaperNode"

for i in $interfaces; do
  gsed -i -E "s/^<h3 .*[=\"]$i[\" \>].*$/<h3 interface lt=\"$i\">/" index.bs
done

./compile.sh;
cp index.html index-with-lt.html

for i in $interfaces; do
  gsed -i -E "s/^<h3 .*[=\"]$i[\" \>].*$/<h3 id=\"$i\">/" index.bs
done

./compile.sh;
cp index.html index-with-id.html

for i in $interfaces; do
  gsed -i -E "s/^<h3 .*[=\"]$i[\" \>].*$/<h3 interface lt=\"$i\" id=\"$i\">/" index.bs
done

./compile.sh;
cp index.html index-with-both.html

for i in $interfaces; do
  lcase="$(tr [A-Z] [a-z] <<< "$i")"
  gsed -i -E "s/^<h3 .*[=\"]$i[\" \>].*$/<h3 interface lt=\"$lcase\" id=\"$i\">/" index.bs
done

./compile.sh;
cp index.html index-with-both-lcase.html

# print links for pr
num=0
for i in $interfaces; do
  lcase="$(tr [A-Z] [a-z] <<< "$i")"
  num=$((num+1))
  echo ""
  echo "#### $num. $i:"
  echo "- https://projects.skratchdot.com/web-audio-api/index-with-both-lcase.html#$i"
  echo "- https://projects.skratchdot.com/web-audio-api/index-with-both-lcase.html#$lcase"
done
