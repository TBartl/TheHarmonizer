function main = p3_HITME(varargin)
    %Remove any workspace variables
    clear all;
    %Make sure the class to store tracks is recognized.
    CustomTrack;
    %Set up the main window figure
    fig = figure;
    set(fig, 'Position', [50 50 775 775])
    set(fig, 'Resize', 'off')
    set(fig, 'Color', [125 125 125]./256)
    set(fig, 'Name', 'The Harmonizer by Team HITME')

    %Make all of the top row buttons
    playButton  = setupButton('play',[25 775-125-25 125 125]);
    set(playButton, 'Callback', @playAllTracks);
    set(playButton, 'Tooltip', 'Play all tracks.')
    
    pauseButton  = setupButton('pause',[175 (775-125)-25 125 125]);
    set(pauseButton, 'Callback', @stopAllAudio);
    set(pauseButton, 'Tooltip', 'Stop the sound from all tracks.')
    
    newTrackButton  = setupButton('newtrack',[325 (775-125)-25 125 125]);
    set(newTrackButton, 'Callback', @addNewTrack);
    set(newTrackButton, 'Tooltip', 'Add a new track.')
    
    %Create UI controls for everything
    trackSelectionMenu = uicontrol('Style', 'popupmenu', 'String', ['untitledTrack1'; 'untitledTrack2'; 'untitledTrack3'], 'Position', [475 (775-175)-25 125 125]);
    set(trackSelectionMenu, 'Callback', @changeToTrack);
    set(trackSelectionMenu, 'Tooltip', 'Select the track you want to edit.');
    
    exportButton  = setupButton('export',[625 (775-125)-25 125 125]);
    set(exportButton, 'Callback', @saveAllTracksWav);
    set(exportButton, 'Tooltip', 'Save all of the tracks to a single .wav file.')
    
    borderImage = imread('border.png');
    border = uicontrol('cdata', borderImage, 'Position', [25 (775-125)-50 725 10]);
    set(border, 'Tooltip', 'Why are you hovering over this border? Dont you have better things to be doing with your free time?.')
    
    
    trackRecorder = audiorecorder(44100, 16, 2);
    trackRecord = setupButton('recordInactive',[25 (610-125)-25 125 125]);
    set(trackRecord, 'Callback', @recordTrack);
    set(trackRecord, 'Tooltip', 'Use a microphone to record a new signal in real-time');
    
    trackRecordStop = setupButton('recordActive',[25 (610-125)-25 125 125]);
    set(trackRecordStop, 'Callback', @stopRecording);
    set(trackRecordStop, 'Tooltip', 'Stop the recording and save the track.');
    set(trackRecordStop, 'Visible', 'off');
    set(trackRecordStop, 'Enable', 'off');
    
    trackImport = setupButton('import',[175 (610-125)-25 125 125]);
    set(trackImport, 'Callback', @importTrack);
    set(trackImport, 'Tooltip', 'Import a signal saved in the .wav format.');
    
    trackPlay = setupButton('play',[25 (610-125)-175 125 125]);
    set(trackPlay, 'Callback', @playTrack);
    set(trackPlay, 'Tooltip', 'Play only this track');
    
    trackExport = setupButton('export',[175 (610-125)-175 125 125]);
    set(trackExport, 'Callback', @saveTrackWav);
    set(trackExport, 'Tooltip', 'Export only this track as a .wav file.');
    
    instrumentSelectionMenu = uicontrol('Style', 'popupmenu', 'String', ['Instrument 1: Sinusoidal               '; 'Instrument 2: Tenor Saxophone          ';'Instrument 3: Alto Saxophone           '; 'Instrument 4: Clarinet                 '; 'Instrument 5: French Horn              ';  'Instrument 6: Electric Guitar          ';  'Instrument 7: Distorted Electric Guitar'; 'Instrument 8: Mayonnaise               '], 'Position', [25 (610-125)-225 275 25]);
    set(instrumentSelectionMenu, 'Callback', @changeInstrument);
    set(instrumentSelectionMenu, 'Tooltip', 'Select an instrument that the track will sound like.');
   
    trackVolumeString = uicontrol('Style', 'pushbutton', 'String', 'Volume:', 'Position', [25 (610-125)-275 125 25], 'cdata', borderImage);
    trackVolume = uicontrol('Style', 'slider', 'Position', [175 (610-125)-275 125 25], 'Min', 0, 'Max', 1, 'Value', 0.9);
    set(trackVolume, 'Callback', @changeVolume);
    set(trackVolume, 'Tooltip', 'Move to adjust from 0 to 1.');
    
    trackOctaveString = uicontrol('Style', 'pushbutton', 'String', 'Octave:', 'Position', [25 (610-125)-325 125 25], 'cdata', borderImage);
    trackOctave = uicontrol('Style', 'slider', 'Position', [175 (610-125)-325 125 25], 'Min', -3, 'Max', 3, 'Value', 0);
    set(trackOctave, 'Callback', @changeOctave);
    set(trackOctave, 'Tooltip', 'Move to adjust from -3 to 3.');
    
    trackPitchString = uicontrol('Style', 'pushbutton', 'String', 'Pitch:', 'Position', [25 (610-125)-375 125 25], 'cdata', borderImage);
    trackPitch = uicontrol('Style', 'slider', 'Position', [175 (610-125)-375 125 25], 'Min', -12, 'Max', 12, 'Value', 0);
    set(trackPitch, 'Callback', @changePitch);
    set(trackPitch, 'Tooltip', 'Move to adjust from -12 to 12.');  
    
    highestPitchString = uicontrol('Style', 'pushbutton', 'String', 'Highest Note:', 'Position', [25 (610-125)-425 125 25], 'cdata', borderImage);
    highestPitch = uicontrol('Style', 'slider', 'Position', [175 (610-125)-425 125 25], 'Min', 0, 'Max', 25, 'Value', 10);
    set(highestPitch, 'Callback', @changeHighestPitch);
    set(highestPitch, 'Tooltip', 'Adjust to make the range the sample is proccessed at fit better.');  
    
    restRecognitionString = uicontrol('Style', 'pushbutton', 'String', 'Rest Recognition:', 'Position', [25 (610-125)-475 125 25], 'cdata', borderImage);
    restRecognition = uicontrol('Style', 'slider', 'Position', [175 (610-125)-475 125 25], 'Min', .025, 'Max', .5, 'Value', .25);
    set(restRecognition, 'Callback', @changeRestRecognition);
    set(restRecognition, 'Tooltip', 'Adjust to change how harsh the program recognizes rests.');  
    
    trackTitleString = uicontrol('Style', 'pushbutton', 'String', 'untitledTrack', 'Position', [475 610-75 125 25], 'cdata', borderImage);
    
    deleteTrack = setupButton('close',[625 (610-50)-35 50 50]);
    set(deleteTrack, 'Callback', @deleteCurrentTrack);
    set(deleteTrack, 'Tooltip', 'Remove this track.');
    
    
    logo = imread('logo_grey.png');
    border = uicontrol('cdata', logo, 'Position', [375 (775-125)-580 353 113]);
    set(border, 'Tooltip', 'Established 2014.')
    
    subplot(3, 2, 4);
    musicPlot = plot(round([1:100]/10));
    title('Relative Frequencies vs Time');
    
    instrumentNames = ['Sinusoidal               '; 'Tenor Saxophone          ';'Alto Saxophone           '; 'Clarinet                 '; 'French Horn              '; 'Electric Guitar          '; 'Distorted Electric Guitar'; 'Mayonnaise               '];
        
    % This is the time in seconds that the original signal will be sampled at.
    samplingPointTimes = .05;
    
    %Harmonics for different instruments
    sawtoothModifiedHarmonics = [1, 7/5, 2/3, 1/4, 1/8, 0, 1/16];
    sawtoothHarmonics = [1, 1/2, 1/3, 1/4, 1/5, 1/6, 1/7, 1/8, 1/9, 1/10, 1/11, 1/12, 1/13, 1/14, 1/15];
    squareHarmonics = [1, 15/7, 7/5, -1/9, -3/14, -1/30, 1/81];
    triangleHarmonics = [1, 1/2, 2/7, 2/9, 1/10, 1/15, 1/21, 1/30];
    
    currentTrackIndex = 1;
    tracks = [CustomTrack, CustomTrack];
    updateUI
    
    function xButton = setupButton(buttonName, position)
        [imgNormal] = imread([buttonName  'Normal.png']);
        imgNormal = imresize(imgNormal, [position(3), position(4)]);
        xButton = uicontrol('Style', 'pushbutton', 'Position', position, 'cdata', imgNormal);
    end

    function updateUI()
        trackSelections = java_array('java.lang.String', numel(tracks));
        for index  = 1:numel(tracks);
           trackSelections(index) = java.lang.String(tracks(index).name);
        end
        trackSelections = cell(trackSelections);
        set(trackSelectionMenu, 'String', trackSelections)
        set(trackSelectionMenu, 'Value', currentTrackIndex);
        set(instrumentSelectionMenu, 'Value', tracks(currentTrackIndex).instrument);
        set(trackVolume, 'Value', tracks(currentTrackIndex).volume);
        set(trackOctave, 'Value', tracks(currentTrackIndex).octave);
        set(trackPitch, 'Value', tracks(currentTrackIndex).pitch);
        
        set(trackTitleString, 'String', tracks(currentTrackIndex).name);
        
        subplot(3, 2, 4);
        musicPlot = plot( round([1:100]/10), 'LineWidth',2, 'Color', 'Black' );
        musicPlot = plot(tracks(currentTrackIndex).samplingPointIndexes, 'LineWidth',2, 'Color', 'Black');
        title('Relative Frequencies vs Time');
        
    end

    function importTrack(source, callbackdata)
        trackName = uigetfile('*.wav','Select the .wav file you want to assign to the track.');
        [originalSignal, samplingRate] = wavread(trackName);
        tracks(currentTrackIndex).originalSignal = originalSignal;
        tracks(currentTrackIndex).samplingRate = samplingRate;
        tracks(currentTrackIndex).name = trackName;
        correlateTrack;
        updateRelativeFrequencies;
        updateUI;
    end

    function recordTrack(source, callbackData)
        set(trackRecord, 'Visible', 'off');
        set(trackRecord, 'Enable', 'off');
        set(trackRecordStop, 'Visible', 'on');
        set(trackRecordStop, 'Enable', 'on');
        trackRecorder.record();
        for index = 1:numel(tracks)
            if (index ~= currentTrackIndex)
                play(tracks(index).player);
            end
        end
        
    end

    function stopRecording(source, callbackData)
        set(trackRecord, 'Visible', 'on');
        set(trackRecord, 'Enable', 'on');
        set(trackRecordStop, 'Visible', 'off');
        set(trackRecordStop, 'Enable', 'off');
        stop(trackRecorder);        
        tracks(currentTrackIndex).originalSignal = getaudiodata(trackRecorder);
        tracks(currentTrackIndex).samplingRate = 44100;
        tracks(currentTrackIndex).name = 'recordedTrack';
        correlateTrack;
        updateRelativeFrequencies;
        updateUI;
    end

    function changeInstrument(source, callbackdata)
        tracks(currentTrackIndex).instrument = get(instrumentSelectionMenu, 'Value');
        updateRelativeFrequencies;
        updateUI
    end

    function changeVolume(source, callbackData)
        tracks(currentTrackIndex).volume = get(trackVolume, 'Value');
        updateRelativeFrequencies
        updateUI
    end

    function changeOctave(source, callbackData)
        tracks(currentTrackIndex).octave = round(get(trackOctave, 'Value'));
        display(tracks(currentTrackIndex).octave)
        updateRelativeFrequencies
        updateUI
    end

    function changePitch(source, callbackData)
        tracks(currentTrackIndex).pitch = round(get(trackPitch, 'Value'));
        updateRelativeFrequencies
        updateUI
    end

    function changeHighestPitch(source, callbackData)
        tracks(currentTrackIndex).highestPitch = round(get(highestPitch, 'Value'));
        correlateTrack
        updateRelativeFrequencies
        updateUI
    end
    function changeRestRecognition(source, callbackData)
        tracks(currentTrackIndex).restRecognitionValue = get(restRecognition, 'Value');
        correlateTrack
        updateRelativeFrequencies
        updateUI
        end

    function playTrack(source, callbackdata)
        play(tracks(currentTrackIndex).player);
    end

    function playAllTracks(source, callbackdata)
        for index = 1:numel(tracks)
            play(tracks(index).player);
        end
    end

    function correlateTrack()
        % Limit X to only the first channel of audio incase it was recorded with
        % two.
        tracks(currentTrackIndex).originalSignal = tracks(currentTrackIndex).originalSignal(:,1);
        % The bounds is the diameter of each sampling point. The first number
        % determines how far they strech past other sampling points.
        samplingPointBounds = 4*floor(samplingPointTimes/2*tracks(currentTrackIndex).samplingRate);
        % These are the indexes that the original signal will be sampled at,
        % rounded to the nearest integer.
        
        samplingPointIndexes = [1:tracks(currentTrackIndex).samplingRate*samplingPointTimes:numel(tracks(currentTrackIndex).originalSignal)];
        samplingPointIndexes = floor(samplingPointIndexes);
        
        % Create a new array that will hold the frequencies at each sampling point.
        %tracks(currentTrackIndex).samplingPointFrequencies = [];
        tracks(currentTrackIndex).samplingPointIndexes = [];
        % Read value across the entire piece. This is used to scale the original
        % signal up to a standardized volume and add rests.
        maximum = max(.0005, max(abs(tracks(currentTrackIndex).originalSignal)));
        
        % Use a formula obtained from wikepida to get the frequencies each key
        % corresponds with.
        pianoKeyFrequencies = power(2, ([16:1:(30+tracks(currentTrackIndex).highestPitch)]-49)/12)*440;
        for index=1:numel(samplingPointIndexes)
            % Isolate adjust range of values sampled around the sampling point.
            segmentBounds = [max(1,samplingPointIndexes(index) - samplingPointBounds) : min(numel(tracks(currentTrackIndex).originalSignal),samplingPointIndexes(index) + samplingPointBounds)];
            segment = tracks(currentTrackIndex).originalSignal(segmentBounds);
            segment = segment/ maximum;
            segment = transpose(segment);

            % If the segment never reaches a significant volume, count it as a rest
            % and keep the frequency at 0.
            % Otherwise use correlation to estimate the frequency by comparing it
            % to the piano key frequencies.
            frequencyIndex = 0;
            if (max(abs(segment)) > tracks(currentTrackIndex).restRecognitionValue)
                phaseShift = acos(segment(1));
                noteLength = [1:numel(segment)];
                cosPart = cos(2*pi*noteLength'*pianoKeyFrequencies/tracks(currentTrackIndex).samplingRate + phaseShift);
                sinPart = sin(2*pi*noteLength'*pianoKeyFrequencies/tracks(currentTrackIndex).samplingRate + phaseShift);
                corr1 = (segment*cosPart).^2 + (segment*sinPart).^2;
                [~, frequencyIndex] = max(corr1);
            end
            tracks(currentTrackIndex).samplingPointIndexes = [tracks(currentTrackIndex).samplingPointIndexes, frequencyIndex];
        end
    end

    function saveAllTracksWav(source,callBackData)
        totalSize = 0;
        for index = 1:numel(tracks)
            totalSize = max(totalSize, numel(tracks(index).finalSignal));
        end
        arrayToSave = zeros(1,totalSize);
        for index = 1:numel(tracks)
            for index2 = 1:numel(tracks(index).finalSignal)
                arrayToSave(index2) = arrayToSave(index2) +  tracks(index).finalSignal(index2);
            end
        end
        arrayToSave = arrayToSave ./ numel(tracks);
        wavwrite(arrayToSave, tracks(1).samplingRate, 'Full Track');
        
        
    end

    function saveTrackWav(source, callbackdata)
        wavwrite(tracks(currentTrackIndex).finalSignal, tracks(currentTrackIndex).samplingRate, [tracks(currentTrackIndex).name 'Sinusoidal'])
    end

    function addNewTrack(source, callbackdata)
        tracks = [tracks, CustomTrack];
        updateUI
    end

    function changeToTrack(source, callbackdata)
        currentTrackIndex = get(trackSelectionMenu, 'Value');
        updateUI
    end

    function stopAllAudio(source, callbackdata)
        for index = 1:numel(tracks)
            stop(tracks(index).player)
        end
    end

    function deleteCurrentTrack(source, callbackdata)
        if (currentTrackIndex ~= 1)
            tracks(currentTrackIndex) = [];
            currentTrackIndex = 1;
        end
        updateUI;
    end

    function updateRelativeFrequencies()
        tracks(currentTrackIndex).sinSignal = [tracks(currentTrackIndex).volume - .001,tracks(currentTrackIndex). volume];
        tracks(currentTrackIndex).finalSignal = [tracks(currentTrackIndex).volume - .001,tracks(currentTrackIndex). volume];
        % Create a digital signal for for each sampling point.
        for index = 1:numel(tracks(currentTrackIndex).samplingPointIndexes)
            addedSinSignal = [];
            addedFinalSignal = [];
            phaseShift = acos(tracks(currentTrackIndex).sinSignal(numel(tracks(currentTrackIndex).sinSignal))/tracks(currentTrackIndex).volume);
            if (tracks(currentTrackIndex).sinSignal(numel(tracks(currentTrackIndex).sinSignal)) > tracks(currentTrackIndex).sinSignal(numel(tracks(currentTrackIndex).sinSignal)-1) )
                phaseShift = - phaseShift;
            end
            addedSinSignal = tracks(currentTrackIndex).volume*cos(2*pi*getFrequency(index)*[1/tracks(currentTrackIndex).samplingRate:1/tracks(currentTrackIndex).samplingRate:samplingPointTimes] + phaseShift);
            
            if (tracks(currentTrackIndex).instrument == 1)
                addedFinalSignal = addedSinSignal;
            elseif (tracks(currentTrackIndex).instrument == 2)
                addedFinalSignal = addedSinSignal;
                for harmonicIndex = 2: numel(sawtoothModifiedHarmonics)
                    harmonicSignal = sawtoothModifiedHarmonics(harmonicIndex)*tracks(currentTrackIndex).volume*cos(2*pi*harmonicIndex*getFrequency(index)*[1/tracks(currentTrackIndex).samplingRate:1/tracks(currentTrackIndex).samplingRate:samplingPointTimes] + harmonicIndex*phaseShift);
                    addedFinalSignal = addedFinalSignal + harmonicSignal;
                end
            elseif (tracks(currentTrackIndex).instrument == 3)
                addedFinalSignal = addedSinSignal;
                for harmonicIndex = 2: numel(sawtoothHarmonics)
                    harmonicSignal = sawtoothHarmonics(harmonicIndex)*tracks(currentTrackIndex).volume*cos(2*pi*harmonicIndex*getFrequency(index)*[1/tracks(currentTrackIndex).samplingRate:1/tracks(currentTrackIndex).samplingRate:samplingPointTimes] + harmonicIndex*phaseShift);
                    addedFinalSignal = addedFinalSignal + harmonicSignal;
                end
            elseif (tracks(currentTrackIndex).instrument == 4)
                addedFinalSignal = addedSinSignal;
                for harmonicIndex = 2: numel(squareHarmonics)
                    harmonicSignal = squareHarmonics(harmonicIndex)*tracks(currentTrackIndex).volume*cos(2*pi*harmonicIndex*getFrequency(index)*[1/tracks(currentTrackIndex).samplingRate:1/tracks(currentTrackIndex).samplingRate:samplingPointTimes] + harmonicIndex*phaseShift);
                    addedFinalSignal = addedFinalSignal + harmonicSignal;
                end
            elseif (tracks(currentTrackIndex).instrument == 5)
                addedFinalSignal = addedSinSignal;
                for harmonicIndex = 2: numel(triangleHarmonics)
                    harmonicSignal = triangleHarmonics(harmonicIndex)*tracks(currentTrackIndex).volume*cos(2*pi*harmonicIndex*getFrequency(index)*[1/tracks(currentTrackIndex).samplingRate:1/tracks(currentTrackIndex).samplingRate:samplingPointTimes] + harmonicIndex*phaseShift);
                    addedFinalSignal = addedFinalSignal + harmonicSignal;
                end
            else
                
            end
            tracks(currentTrackIndex).sinSignal = [tracks(currentTrackIndex).sinSignal, addedSinSignal];
            tracks(currentTrackIndex).finalSignal = [tracks(currentTrackIndex).finalSignal, addedFinalSignal];
        end
        if (tracks(currentTrackIndex).instrument == 6)
            level = 0.75;
            tracks(currentTrackIndex).finalSignal = tracks(currentTrackIndex).volume/level*max(min(tracks(currentTrackIndex).sinSignal./tracks(currentTrackIndex).volume,level),-level);
        elseif (tracks(currentTrackIndex).instrument == 7)
            level = 0.1;
            tracks(currentTrackIndex).finalSignal = tracks(currentTrackIndex).volume/level*max(min(tracks(currentTrackIndex).sinSignal./tracks(currentTrackIndex).volume,level),-level);
        elseif (tracks(currentTrackIndex).instrument == 8)
            tracks(currentTrackIndex).finalSignal = wavread('mayonnaise');
        end

 
        tracks(currentTrackIndex).player = audioplayer(tracks(currentTrackIndex).finalSignal, tracks(currentTrackIndex).samplingRate);
    end

    function freq = getFrequency(index)
        freq = 0;
        if (tracks(currentTrackIndex).samplingPointIndexes(index) ~= 0)
            freq = power(2, (tracks(currentTrackIndex).samplingPointIndexes(index)+15 + tracks(currentTrackIndex).octave*12 + tracks(currentTrackIndex).pitch -49)/12)*440;
        end
    end

end  

