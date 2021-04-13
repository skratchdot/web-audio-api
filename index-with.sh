#!/bin/bash

interfaces="AnalyserNode AudioBuffer AudioBufferSourceNode AudioContext AudioDestinationNode AudioListener AudioNode AudioParam AudioParamMap AudioProcessingEvent AudioScheduledSourceNode AudioWorklet AudioWorkletGlobalScope AudioWorkletNode AudioWorkletProcessor BaseAudioContext BiquadFilterNode ChannelMergerNode ChannelSplitterNode ConstantSourceNode ConvolverNode DelayNode DynamicsCompressorNode GainNode IIRFilterNode MediaElementAudioSourceNode MediaStreamAudioDestinationNode MediaStreamAudioSourceNode MediaStreamTrackAudioSourceNode OfflineAudioCompletionEvent OfflineAudioContext OscillatorNode PannerNode PeriodicWave ScriptProcessorNode StereoPannerNode WaveShaperNode"
dictionaries="AnalyserOptions AudioBufferOptions AudioBufferSourceOptions AudioContextOptions AudioNodeOptions AudioParamDescriptor AudioProcessingEventInit AudioTimestamp AudioWorkletNodeOptions BiquadFilterOptions ChannelMergerOptions ChannelSplitterOptions ConstantSourceOptions ConvolverOptions DelayOptions DynamicsCompressorOptions GainOptions IIRFilterOptions MediaElementAudioSourceOptions MediaStreamAudioSourceOptions MediaStreamTrackAudioSourceOptions OfflineAudioCompletionEventInit OfflineAudioContextOptions OscillatorOptions PannerOptions PeriodicWaveConstraints PeriodicWaveOptions StereoPannerOptions WaveShaperOptions"

for i in $interfaces; do
  lcase="$(tr [A-Z] [a-z] <<< "$i")"
  gsed -i -E "s/^<h3 .*[=\"]$i[\" \>].*$/<h3 interface lt=\"$lcase\" id=\"$i\">/" index.bs
  gsed -i -E "s/^<h4 .*[=\"]$i[\" \>].*$/<h4 interface lt=\"$lcase\" id=\"$i\">/" index.bs
done

for i in $dictionaries; do
  lcase="$(tr [A-Z] [a-z] <<< "$i")"
  gsed -i -E "s/^<h4 .*[=\"]$i[\" \>].*$/<h4 dictionary lt=\"$lcase\" id=\"$i\">/" index.bs
  gsed -i -E "s/^<h5 .*[=\"]$i[\" \>].*$/<h5 dictionary lt=\"$lcase\" id=\"$i\">/" index.bs
done

./compile.sh;
cp index.html index-with-both-lcase.html

# print links for pr
echo ""
echo "### Interfaces"
num=0
for i in $interfaces; do
  lcase="$(tr [A-Z] [a-z] <<< "$i")"
  num=$((num+1))
  echo ""
  echo "#### $num. $i:"
  echo "- https://projects.skratchdot.com/web-audio-api/index-with-both-lcase.html#$i"
  echo "- https://projects.skratchdot.com/web-audio-api/index-with-both-lcase.html#$lcase"
done

echo ""
echo "### Dictionaries"
num=0
for i in $dictionaries; do
  lcase="$(tr [A-Z] [a-z] <<< "$i")"
  num=$((num+1))
  echo ""
  echo "#### $num. $i:"
  echo "- https://projects.skratchdot.com/web-audio-api/index-with-both-lcase.html#$i"
  echo "- https://projects.skratchdot.com/web-audio-api/index-with-both-lcase.html#dictdef-$lcase"
done

