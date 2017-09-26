classdef CustomTrack
    properties 
        name = 'untitledTrack'
        instrument = 1; 
        volume = 0.9;
        octave = 0.0;
        pitch = 0.0;
        highestPitch = 0;
        restRecognitionValue = .25;
        
        originalSignal = 2*cos(2*pi*300*[0:1/8192:2]);
        samplingRate = 8192;
        samplingPointIndexes = []
        %samplingPointFrequencies = []
        sinSignal = []
        finalSignal = []
        player = audioplayer([0], 8192);
    end
end