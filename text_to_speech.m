function [] = text_to_speech(final_output)

    % write the string argument to a text file
    file = fopen('number_Plate.txt', 'wt');
    fprintf(file,'%s\n',final_output);
    fclose(file);
    
    % open the text file
    winopen('number_Plate.txt')

    % Program to do text to speech.
    % Get user's sentence
    userPrompt = 'What do you want the computer to say?';
    titleBar = 'Text to Speech';

    % set the default string to the final_output argument
    defaultString = final_output;
    
    % get the user input as a dialog box
    caUserInput = inputdlg(userPrompt, titleBar, 1, {defaultString});
    
    % check if user cancelled the dialog box
    if isempty(caUserInput)
        return;
    end; % Bail out if they clicked Cancel.

    % convert the user input from cell to string
    caUserInput = char(caUserInput);

    % add the necessary assembly for speech synthesis
    NET.addAssembly('System.Speech');

    % create a SpeechSynthesizer object and set the volume to 100
    obj = System.Speech.Synthesis.SpeechSynthesizer;
    obj.Volume = 100;

    % use the Speak method to convert the user input to speech
    Speak(obj, caUserInput);
end
