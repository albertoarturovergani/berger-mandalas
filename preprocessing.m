%%
eeglab

input_folder = '.\TDBRAIN-dataset\'

output_folder = '.\OUTPUT-TD-BRAIN';

subject_folders = dir(fullfile(input_folder, 'sub-*'));

num_subjects = numel(subject_folders);

selected_indices = randperm(num_subjects, 100);

for i = 1:numel(selected_indices)
    subject_folder_name = subject_folders(selected_indices(i)).name;
    subject_folder_path = fullfile(input_folder, subject_folder_name, 'ses-1', 'eeg');
   
    vhdr_files = dir(fullfile(subject_folder_path, '*task-restEC_eeg.vhdr'));
    
    for j = 1:numel(vhdr_files)
        
        vhdr_file_path = fullfile(subject_folder_path, vhdr_files(j).name);
        
        EEG = pop_loadbv(subject_folder_path, vhdr_files(j).name, [], [1:33]);
        [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 0, 'gui', 'off');
        eeglab redraw;

        eeg_downsampled = downsample(EEG.data', 1000)';

        [~, file_name, ~] = fileparts(vhdr_files(j).name);
        output_file_path = fullfile(output_folder, [file_name '.txt']);

        dlmwrite(output_file_path, eeg_downsampled, 'delimiter', '\t');
    end
end
