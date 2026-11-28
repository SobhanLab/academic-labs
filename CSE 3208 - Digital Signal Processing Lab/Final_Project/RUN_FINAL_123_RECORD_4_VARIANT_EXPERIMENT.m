%% ================================================================
%  FINAL ECG-GUDB EXPERIMENT
%  123 Records x 4 Adaptive Threshold Configurations
%
%  Baseline: Frozen Simulink model
%  Variants: MATLAB reproduction of the same detector and refinement
%
%  MATLAB R2024b
%  Sampling frequency: 250 Hz
%  Matching tolerance: 48 ms (12 samples)
%
%  IMPORTANT:
%  - Does not modify the frozen Simulink model.
%  - Does not overwrite historical experiment folders.
%  - Saves checkpoint after every record.
%  - Backs up an existing incomplete checkpoint.
%  - Verifies MATLAB baseline reconstruction for every record.
%% ================================================================

clear;
clc;
close all;

fprintf('\n====================================================\n');
fprintf(' FINAL ECG-GUDB FOUR-VARIANT EXPERIMENT\n');
fprintf('====================================================\n');

%% 1. PROJECT PATHS

projectRoot = pwd;

experimentRoot = fullfile(projectRoot, ...
    '09_Final_Research_Experiment');

sourcePath = fullfile(projectRoot, ...
    'data','docs','new_model_results_00_24', ...
    'new_model_all_detections.mat');

modelPath = fullfile(experimentRoot, ...
    '01_Frozen_Model', ...
    'ECG_GUDB_RPeak_Detector_Frozen.slx');

outputRoot = fullfile(experimentRoot, ...
    '04_Record_Level_Results', ...
    'Full_4_Variant_Run');

rawRoot = fullfile(experimentRoot, ...
    '03_Raw_Detection_Outputs', ...
    'Full_4_Variant_Run');

reproRoot = fullfile(experimentRoot, ...
    '14_Reproducibility', ...
    'Full_4_Variant_Run');

if ~exist(sourcePath,'file')
    error('Dataset MAT file not found: %s',sourcePath);
end

if ~exist(modelPath,'file')
    error('Frozen Simulink model not found: %s',modelPath);
end

if ~exist(outputRoot,'dir'), mkdir(outputRoot); end
if ~exist(rawRoot,'dir'), mkdir(rawRoot); end
if ~exist(reproRoot,'dir'), mkdir(reproRoot); end

%% 2. EXPERIMENT CONFIGURATION

Fs = 250;
Ts = 1/Fs;

toleranceMs = 48;
toleranceSamples = round(toleranceMs*Fs/1000);

referenceWindow = 6*Fs;
refractorySamples = 50;
movingAverageSamples = 20;
refinementRadius = 15;

variantNames = { ...
    'Original_Maximum', ...
    'Percentile_90', ...
    'Percentile_92_5', ...
    'Percentile_95'};

percentileValues = [NaN 90 92.5 95];

nVariants = numel(variantNames);

%% 3. LOAD DATASET

fprintf('\nLoading ECG-GUDB dataset...\n');

D = load(sourcePath,'recordData');
recordData = D.recordData;

if ~isstruct(recordData) || ~isscalar(recordData)
    error('recordData must be a scalar structure with named recording fields.');
end

recordNames = fieldnames(recordData);
nRecords = numel(recordNames);

fprintf('Available annotated records: %d\n',nRecords);

if nRecords ~= 123
    warning('Expected 123 annotated records; found %d.',nRecords);
end

%% 4. DESIGN FILTERS

[bHP,aHP] = butter(2,0.5/(Fs/2),'high');
[bBP,aBP] = butter(2,[10 30]/(Fs/2),'bandpass');
[bLP,aLP] = butter(2,40/(Fs/2),'low');

%% 5. SAVE RUN CONFIGURATION

cfg = struct();

cfg.Fs = Fs;
cfg.Ts = Ts;
cfg.toleranceMs = toleranceMs;
cfg.toleranceSamples = toleranceSamples;
cfg.referenceWindowSamples = referenceWindow;
cfg.refractorySamples = refractorySamples;
cfg.movingAverageSamples = movingAverageSamples;
cfg.refinementRadius = refinementRadius;
cfg.variantNames = variantNames;
cfg.percentileValues = percentileValues;
cfg.recordCount = nRecords;
cfg.modelPath = modelPath;
cfg.datasetPath = sourcePath;
cfg.matlabVersion = version;
cfg.runDate = datetime('now');

save(fullfile(reproRoot,'run_configuration.mat'),'cfg');

%% 6. LOAD FROZEN MODEL

[~,modelName] = fileparts(modelPath);

load_system(modelPath);

set_param(modelName,'SolverType','Fixed-step');
set_param(modelName,'Solver','FixedStepDiscrete');
set_param(modelName,'FixedStep',num2str(Ts,17));

assignin('base','Fs',Fs);
assignin('base','Ts',Ts);
assignin('base','bHP',bHP);
assignin('base','aHP',aHP);
assignin('base','bBP',bBP);
assignin('base','aBP',aBP);
assignin('base','bLP',bLP);
assignin('base','aLP',aLP);

fprintf('\nFrozen model loaded: %s\n',modelName);

%% 7. BASELINE VERIFICATION ON S00_SITTING

fprintf('\n====================================================\n');
fprintf(' BASELINE VERIFICATION\n');
fprintf('====================================================\n');

testName = 'S00_sitting';

if ~isfield(recordData,testName)
    error('Baseline verification record S00_sitting not found.');
end

Q = recordData.(testName);

testECG = double(Q.ecg(:));
testTime = (0:numel(testECG)-1)'*Ts;

assignin('base','ecg_input',timeseries(testECG,testTime));

set_param(modelName,'StopTime',num2str(testTime(end),17));

simOut = sim(modelName,'ReturnWorkspaceOutputs','on');

try
    simTS = simOut.get('rpeak_output');
catch
    error(['Cannot retrieve rpeak_output from Simulink. ', ...
        'Inspect the To Workspace block output.']);
end

simData = squeeze(simTS.Data);

if size(simData,2) ~= 4
    error('Expected four Simulink output channels.');
end

simCandidatePulse = simData(:,1) > 0.5;
simRefinedPulse = simData(:,2) > 0.5;
simRefinedIndex = round(simData(:,3));
simLocalization = simData(:,4);

simCandidateIndices = find(simCandidatePulse);
simRefinedIndices = simRefinedIndex(simRefinedPulse);

[matEnvelope,matLocalization] = localSignalPipeline( ...
    testECG,Fs,bHP,aHP,bBP,aBP,bLP,aLP);

[matCandidateIndices,~] = localAdaptiveDetector( ...
    matEnvelope,referenceWindow,refractorySamples,NaN);

matRefinedIndices = localRefinement( ...
    matCandidateIndices,matLocalization,refinementRadius);

candidateMatch = isequal( ...
    simCandidateIndices(:),matCandidateIndices(:));

refinedMatch = isequal( ...
    simRefinedIndices(:),matRefinedIndices(:));

localizationError = max(abs( ...
    simLocalization(:)-matLocalization(:)));

fprintf('Simulink candidates: %d\n',numel(simCandidateIndices));
fprintf('MATLAB candidates:   %d\n',numel(matCandidateIndices));
fprintf('Candidate streams identical: %d\n',candidateMatch);

fprintf('Simulink refined: %d\n',numel(simRefinedIndices));
fprintf('MATLAB refined:   %d\n',numel(matRefinedIndices));
fprintf('Refined streams identical: %d\n',refinedMatch);

fprintf('Localization max absolute difference: %.12g\n', ...
    localizationError);

if ~candidateMatch || ~refinedMatch || localizationError > 1e-9
    error(['BASELINE VERIFICATION FAILED. ', ...
        'Full experiment stopped. Do not proceed until resolved.']);
end

fprintf('\nBASELINE VERIFICATION PASSED.\n');

save(fullfile(reproRoot,'baseline_verification.mat'), ...
    'simCandidateIndices','simRefinedIndices', ...
    'matCandidateIndices','matRefinedIndices', ...
    'candidateMatch','refinedMatch','localizationError');

%% 8. PREPARE RESULT STORAGE

% Consistent variant structure
emptyVariant = struct( ...
    'name','', ...
    'candidateIndices',[], ...
    'refinedIndices',[], ...
    'TP',0, ...
    'FP',0, ...
    'FN',0, ...
    'Precision',0, ...
    'Recall',0, ...
    'F1',0, ...
    'matchedReference',[], ...
    'matchedDetection',[], ...
    'timingErrorSamples',[], ...
    'timingErrorMs',[], ...
    'unmatchedReference',[], ...
    'unmatchedDetection',[]);

% Consistent record structure
emptyRecord = struct( ...
    'record','', ...
    'subject',NaN, ...
    'activity','', ...
    'sampleCount',0, ...
    'referenceCount',0, ...
    'durationSeconds',0, ...
    'variants',repmat(emptyVariant,1,nVariants), ...
    'status','', ...
    'error','');

recordResults = repmat(emptyRecord,nRecords,1);

allRawOutputs = struct();

completedRecords = false(nRecords,1);
failureMessages = strings(nRecords,1);

checkpointPath = fullfile(outputRoot,'checkpoint.mat');

% Preserve an existing checkpoint instead of overwriting it.
if exist(checkpointPath,'file')

    backupPath = fullfile(outputRoot, ...
        'checkpoint_failed_initialization.mat');

    if exist(backupPath,'file')
        backupPath = fullfile(outputRoot, ...
            ['checkpoint_backup_' ...
            char(datetime('now','Format','yyyyMMdd_HHmmss')) '.mat']);
    end

    [moveStatus,moveMessage] = movefile(checkpointPath,backupPath);

    if ~moveStatus
        error('Could not back up existing checkpoint: %s',moveMessage);
    end

    fprintf('Previous checkpoint backed up:\n%s\n',backupPath);
end

%% 9. FOUR-VARIANT FULL DATASET EVALUATION

fprintf('\n====================================================\n');
fprintf(' STARTING FULL DATASET EVALUATION\n');
fprintf('====================================================\n');

runTimer = tic;

for r = 1:nRecords

    recordName = recordNames{r};

    fprintf('\n--------------------------------------------\n');
    fprintf('Record %d / %d: %s\n',r,nRecords,recordName);
    fprintf('--------------------------------------------\n');

    try

        Q = recordData.(recordName);

        ecg = double(Q.ecg(:));
        reference = round(double(Q.reference(:)));

        if isempty(ecg) || isempty(reference)
            error('Empty ECG or reference annotations.');
        end

        reference = reference( ...
            isfinite(reference) & ...
            reference >= 1 & ...
            reference <= numel(ecg));

        if isempty(reference)
            error('No valid reference indices.');
        end

        reference = unique(reference);

        activity = char(Q.activity);
        subject = double(Q.subject);

        time = (0:numel(ecg)-1)'*Ts;

        %% 9.1 SIMULINK MODEL EXECUTION

        assignin('base','ecg_input',timeseries(ecg,time));

        set_param(modelName,'StopTime',num2str(time(end),17));

        simOut = sim(modelName,'ReturnWorkspaceOutputs','on');
        simTS = simOut.get('rpeak_output');

        Y = squeeze(simTS.Data);

        if size(Y,2) ~= 4
            error('Unexpected Simulink output dimensions.');
        end

        baselineCandidates = find(Y(:,1)>0.5);

        baselinePulse = Y(:,2)>0.5;
        baselineIndices = round(Y(:,3));
        baselineRefined = baselineIndices(baselinePulse);

        localization = Y(:,4);

        %% 9.2 MATLAB SIGNAL PIPELINE

        [envelope,matLocalization] = localSignalPipeline( ...
            ecg,Fs,bHP,aHP,bBP,aBP,bLP,aLP);

        localizationError = max(abs( ...
            localization(:)-matLocalization(:)));

        if localizationError > 1e-9
            error('Localization signal mismatch for %s.',recordName);
        end

        %% 9.3 PER-RECORD BASELINE RECONSTRUCTION VERIFICATION

        [checkCandidates,~] = localAdaptiveDetector( ...
            envelope,referenceWindow,refractorySamples,NaN);

        checkRefined = localRefinement( ...
            checkCandidates,localization,refinementRadius);

        candidateMatch = isequal( ...
            checkCandidates(:),baselineCandidates(:));

        refinedMatch = isequal( ...
            checkRefined(:),baselineRefined(:));

        if ~candidateMatch
            error(['MATLAB baseline candidate mismatch for %s. ', ...
                'Simulink and MATLAB candidate streams differ.'],recordName);
        end

        if ~refinedMatch
            error(['MATLAB baseline refinement mismatch for %s. ', ...
                'Simulink and MATLAB refined indices differ.'],recordName);
        end

        fprintf('Baseline reconstruction verified for %s.\n',recordName);

        %% 9.4 STORE PER-VARIANT OUTPUTS

        variantOutput = repmat(emptyVariant,1,nVariants);

        for v = 1:nVariants

            if v == 1

                candidateIndices = baselineCandidates;
                refinedIndices = baselineRefined;

            else

                [candidateIndices,~] = localAdaptiveDetector( ...
                    envelope,referenceWindow, ...
                    refractorySamples,percentileValues(v));

                refinedIndices = localRefinement( ...
                    candidateIndices,localization, ...
                    refinementRadius);

            end

            M = localEvaluate( ...
                refinedIndices,reference,toleranceSamples);

            variantOutput(v).name = variantNames{v};
            variantOutput(v).candidateIndices = candidateIndices;
            variantOutput(v).refinedIndices = refinedIndices;
            variantOutput(v).TP = M.TP;
            variantOutput(v).FP = M.FP;
            variantOutput(v).FN = M.FN;
            variantOutput(v).Precision = M.Precision;
            variantOutput(v).Recall = M.Recall;
            variantOutput(v).F1 = M.F1;
            variantOutput(v).matchedReference = M.matchedReference;
            variantOutput(v).matchedDetection = M.matchedDetection;
            variantOutput(v).timingErrorSamples = M.errors;
            variantOutput(v).timingErrorMs = M.errors*1000/Fs;
            variantOutput(v).unmatchedReference = M.unmatchedReference;
            variantOutput(v).unmatchedDetection = M.unmatchedDetection;

        end

        %% 9.5 RECORD-LEVEL RESULT ASSIGNMENT

        R = emptyRecord;

        R.record = recordName;
        R.subject = subject;
        R.activity = activity;
        R.sampleCount = numel(ecg);
        R.referenceCount = numel(reference);
        R.durationSeconds = numel(ecg)/Fs;
        R.variants = variantOutput;
        R.status = 'SUCCESS';
        R.error = '';

        recordResults(r) = R;

        %% 9.6 RAW OUTPUT STORAGE

        raw = struct();

        raw.ecg = ecg;
        raw.reference = reference;
        raw.envelope = envelope;
        raw.localization = localization;
        raw.simulinkOutput = Y;
        raw.variants = variantOutput;

        allRawOutputs.(recordName) = raw;

        completedRecords(r) = true;

        fprintf('Activity: %s | Subject: %.0f\n',activity,subject);

        for v = 1:nVariants

            fprintf('%-20s TP=%d FP=%d FN=%d F1=%.3f%%\n', ...
                variantNames{v}, ...
                variantOutput(v).TP, ...
                variantOutput(v).FP, ...
                variantOutput(v).FN, ...
                variantOutput(v).F1*100);

        end

    catch ME

        failureMessages(r) = string(ME.message);

        % Maintain exactly the same structure for failed records.
        recordResults(r).record = recordName;
        recordResults(r).subject = NaN;
        recordResults(r).activity = '';
        recordResults(r).sampleCount = 0;
        recordResults(r).referenceCount = 0;
        recordResults(r).durationSeconds = 0;
        recordResults(r).variants = repmat(emptyVariant,1,nVariants);
        recordResults(r).status = 'FAILED';
        recordResults(r).error = ME.message;

        completedRecords(r) = false;

        fprintf(2,'FAILED: %s\n',ME.message);

    end

    %% 9.7 SAVE CHECKPOINT AFTER EVERY RECORD

    save(checkpointPath, ...
        'recordResults','allRawOutputs', ...
        'completedRecords','failureMessages', ...
        'recordNames','cfg','-v7.3');

    fprintf('Checkpoint saved: %d/%d successful.\n', ...
        nnz(completedRecords),nRecords);

end

totalRuntime = toc(runTimer);

%% 10. SAVE COMPLETE RAW OUTPUTS

save(fullfile(rawRoot,'all_record_outputs.mat'), ...
    'allRawOutputs','-v7.3');

save(fullfile(outputRoot,'record_level_results.mat'), ...
    'recordResults','-v7.3');

%% 11. CREATE SUMMARY TABLES

summaryRows = {};

for r = 1:nRecords

    % Exclude failed records from all performance summaries.
    if ~strcmp(recordResults(r).status,'SUCCESS')
        continue;
    end

    R = recordResults(r);

    for v = 1:nVariants

        V = R.variants(v);

        summaryRows(end+1,:) = { ...
            R.record,R.subject,R.activity, ...
            V.name,R.referenceCount, ...
            numel(V.refinedIndices), ...
            V.TP,V.FP,V.FN, ...
            V.Precision,V.Recall,V.F1, ...
            mean(V.timingErrorMs,'omitnan'), ...
            median(V.timingErrorMs,'omitnan'), ...
            mean(abs(V.timingErrorMs),'omitnan'), ...
            std(V.timingErrorMs,'omitnan')};

    end
end

if isempty(summaryRows)
    error(['No successful records available. ', ...
        'Summary tables cannot be generated. Inspect failures.csv.']);
end

summaryTable = cell2table(summaryRows,'VariableNames',{ ...
    'Record','Subject','Activity','Variant', ...
    'ReferenceCount','DetectionCount', ...
    'TP','FP','FN','Precision','Recall','F1', ...
    'MeanSignedErrorMs','MedianSignedErrorMs', ...
    'MAE_Ms','SD_ErrorMs'});

writetable(summaryTable, ...
    fullfile(outputRoot,'record_level_results.csv'));

%% 12. POOLED OVERALL PERFORMANCE

overallRows = {};

for v = 1:nVariants

    T = summaryTable(strcmp(summaryTable.Variant,variantNames{v}),:);

    TP = sum(T.TP);
    FP = sum(T.FP);
    FN = sum(T.FN);

    P = TP/max(TP+FP,1);
    R = TP/max(TP+FN,1);
    F1 = 2*P*R/max(P+R,eps);

    overallRows(end+1,:) = { ...
        variantNames{v},height(T),TP,FP,FN,P*100,R*100,F1*100};

end

overallTable = cell2table(overallRows,'VariableNames',{ ...
    'Variant','SuccessfulRecords','TP','FP','FN', ...
    'PrecisionPercent','RecallPercent','F1Percent'});

writetable(overallTable, ...
    fullfile(outputRoot,'overall_performance.csv'));

%% 13. ACTIVITY-WISE PERFORMANCE

activityNames = unique(summaryTable.Activity);
activityRows = {};

for a = 1:numel(activityNames)

    for v = 1:nVariants

        mask = strcmp(summaryTable.Activity,activityNames{a}) & ...
               strcmp(summaryTable.Variant,variantNames{v});

        T = summaryTable(mask,:);

        if isempty(T)
            continue;
        end

        TP = sum(T.TP);
        FP = sum(T.FP);
        FN = sum(T.FN);

        P = TP/max(TP+FP,1);
        R = TP/max(TP+FN,1);
        F1 = 2*P*R/max(P+R,eps);

        activityRows(end+1,:) = { ...
            activityNames{a},variantNames{v}, ...
            height(T),TP,FP,FN,P*100,R*100,F1*100};

    end
end

activityTable = cell2table(activityRows,'VariableNames',{ ...
    'Activity','Variant','Records','TP','FP','FN', ...
    'PrecisionPercent','RecallPercent','F1Percent'});

writetable(activityTable, ...
    fullfile(outputRoot,'activity_level_results.csv'));

%% 14. SUBJECT-WISE PERFORMANCE

subjectNames = unique(summaryTable.Subject);
subjectRows = {};

for s = 1:numel(subjectNames)

    for v = 1:nVariants

        mask = summaryTable.Subject==subjectNames(s) & ...
               strcmp(summaryTable.Variant,variantNames{v});

        T = summaryTable(mask,:);

        if isempty(T)
            continue;
        end

        TP = sum(T.TP);
        FP = sum(T.FP);
        FN = sum(T.FN);

        P = TP/max(TP+FP,1);
        R = TP/max(TP+FN,1);
        F1 = 2*P*R/max(P+R,eps);

        subjectRows(end+1,:) = { ...
            subjectNames(s),variantNames{v}, ...
            height(T),TP,FP,FN,P*100,R*100,F1*100};

    end
end

subjectTable = cell2table(subjectRows,'VariableNames',{ ...
    'Subject','Variant','Records','TP','FP','FN', ...
    'PrecisionPercent','RecallPercent','F1Percent'});

writetable(subjectTable, ...
    fullfile(outputRoot,'subject_level_results.csv'));

%% 15. FAILURE LOG

failedMask = ~completedRecords;

failureTable = table( ...
    string(recordNames(failedMask)), ...
    failureMessages(failedMask), ...
    'VariableNames',{'Record','Error'});

writetable(failureTable, ...
    fullfile(outputRoot,'failures.csv'));

%% 16. FINAL SAVE

save(fullfile(outputRoot,'complete_experiment.mat'), ...
    'recordResults','summaryTable','overallTable', ...
    'activityTable','subjectTable','failureTable', ...
    'cfg','totalRuntime','-v7.3');

fprintf('\n====================================================\n');
fprintf(' EXPERIMENT COMPLETED\n');
fprintf('====================================================\n');

fprintf('Total records: %d\n',nRecords);
fprintf('Successful: %d\n',nnz(completedRecords));
fprintf('Failed: %d\n',nnz(failedMask));
fprintf('Runtime: %.2f minutes\n',totalRuntime/60);

disp(overallTable);

fprintf('\nResults directory:\n%s\n',outputRoot);

if any(failedMask)
    fprintf(2,'WARNING: Some records failed. Inspect failures.csv.\n');
end

%% ================================================================
% LOCAL FUNCTIONS
%% ================================================================

function [envelope,localization] = localSignalPipeline( ...
    ecg,Fs,bHP,aHP,bBP,aBP,bLP,aLP)

    ecg = ecg(:);

    hp = filter(bHP,aHP,ecg);

    bp = filter(bBP,aBP,hp);

    derivative = [bp(1); diff(bp)]*Fs;

    absoluteSlope = abs(derivative);

    envelope = filter(ones(1,20)/20,1,absoluteSlope);

    localization = filter(bLP,aLP,hp);

end


function [candidateIndices,candidatePulse] = ...
    localAdaptiveDetector(x,windowLength,refractory,percentile)

    x = x(:);
    N = numel(x);

    candidatePulse = false(N,1);

    prev2 = 0;
    prev1 = 0;
    sampleCount = 0;
    lastPeak = -10000;

    refBuffer = zeros(windowLength,1);
    writeIdx = 1;

    for k = 1:N

        sampleCount = sampleCount+1;

        current = x(k);

        refBuffer(writeIdx) = current;

        writeIdx = writeIdx+1;

        if writeIdx > windowLength
            writeIdx = 1;
        end

        if isnan(percentile)
            localReference = max(refBuffer);
        else
            localReference = prctile(refBuffer,percentile);
        end

        threshold = 0.35*localReference;

        isLocalMaximum = (prev1>prev2) && (prev1>=current);

        if isLocalMaximum

            candidateValue = prev1;
            candidateSample = sampleCount-1;

            if candidateValue > threshold && ...
                    (candidateSample-lastPeak)>=refractory

                candidatePulse(k) = true;
                lastPeak = candidateSample;

            end
        end

        prev2 = prev1;
        prev1 = current;

    end

    candidateIndices = find(candidatePulse);

end


function refinedIndices = localRefinement( ...
    candidateIndices,ecg,radius)

    ecg = ecg(:);
    refinedIndices = [];

    N = numel(ecg);

    for k = 1:numel(candidateIndices)

        % Candidate pulse is emitted one sample after envelope maximum.
        pendingSample = candidateIndices(k)-1;

        if pendingSample < radius+1
            continue;
        end

        firstIndex = pendingSample-radius;
        lastIndex = pendingSample+radius;

        if lastIndex>N
            continue;
        end

        w = ecg(firstIndex:lastIndex);

        baseline = median(w);

        [maxValue,iMax] = max(w-baseline);
        [minValue,iMin] = min(w-baseline);

        if abs(maxValue)>=abs(minValue)
            refinedOffset = iMax;
        else
            refinedOffset = iMin;
        end

        refinedIndex = firstIndex+refinedOffset-1;

        refinedIndices(end+1,1) = refinedIndex;

    end

    refinedIndices = unique(refinedIndices);

end


function M = localEvaluate(det,ref,tolerance)

    det = sort(unique(round(det(:))));
    ref = sort(unique(round(ref(:))));

    i = 1;
    j = 1;

    matchedDet = [];
    matchedRef = [];
    errors = [];

    while i<=numel(det) && j<=numel(ref)

        delta = det(i)-ref(j);

        if abs(delta)<=tolerance

            matchedDet(end+1,1) = det(i);
            matchedRef(end+1,1) = ref(j);
            errors(end+1,1) = delta;

            i = i+1;
            j = j+1;

        elseif delta < -tolerance

            i = i+1;

        else

            j = j+1;

        end

    end

    TP = numel(matchedDet);
    FP = numel(det)-TP;
    FN = numel(ref)-TP;

    P = TP/max(TP+FP,1);
    R = TP/max(TP+FN,1);
    F1 = 2*P*R/max(P+R,eps);

    M = struct();

    M.TP = TP;
    M.FP = FP;
    M.FN = FN;

    M.Precision = P;
    M.Recall = R;
    M.F1 = F1;

    M.matchedReference = matchedRef;
    M.matchedDetection = matchedDet;
    M.errors = errors;

    M.unmatchedReference = setdiff(ref,matchedRef);
    M.unmatchedDetection = setdiff(det,matchedDet);

end