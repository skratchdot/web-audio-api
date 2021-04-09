#!/bin/bash

interfaces="AnalyserNode AudioBuffer AudioBufferSourceNode AudioContext AudioDestinationNode AudioListener AudioNode AudioParam AudioParamMap AudioProcessingEvent AudioScheduledSourceNode AudioWorklet AudioWorkletGlobalScope AudioWorkletNode AudioWorkletProcessor BaseAudioContext BiquadFilterNode ChannelMergerNode ChannelSplitterNode ConstantSourceNode ConvolverNode DelayNode DynamicsCompressorNode GainNode IIRFilterNode MediaElementAudioSourceNode MediaStreamAudioDestinationNode MediaStreamAudioSourceNode MediaStreamTrackAudioSourceNode OfflineAudioCompletionEvent OfflineAudioContext OscillatorNode PannerNode PeriodicWave ScriptProcessorNode StereoPannerNode WaveShaperNode"

for i in $interfaces; do
  gsed -i -E "s/^<h3 .*[=\"]$i.*$/<h3 interface lt=\"$i\" \/>/" index.bs
done

./compile.sh;
cp index.html index-with-lt.html

for i in $interfaces; do
  gsed -i -E "s/^<h3 .*[=\"]$i.*$/<h3 id=\"$i\" \/>/" index.bs
done

./compile.sh;
cp index.html index-with-id.html
