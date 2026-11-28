
%% ================================================================
%  ECG-GUDB: COMPLETE RESEARCH FIGURE GENERATION
%
%  MATLAB R2024b
%  Source: all_record_outputs.mat
%  Model: Frozen ECG_GUDB_RPeak_Detector_Frozen.slx
%
%  Generates publication-quality figures directly from saved
%  ECG signals, reference annotations, Simulink outputs and
%  detector outputs.
%
%  IMPORTANT:
%  - Does NOT modify the frozen Simulink model.
%  - Does NOT rerun the 123-record experiment.
%  - Does NOT change detector parameters.
%  - Uses the original 48 ms matching results for primary plots.
%  - Reports requested and effective tolerance separately.
%  - Saves PNG (300 DPI), FIG and supporting CSV files.
%% ================================================================

clear;
clc;
close all;

fprintf('\n====================================================\n');
fprintf(' ECG-GUDB FIGURE GENERATION STARTED\n');
fprintf('====================================================\n');

%% 1. PROJECT PATHS

projectRoot = pwd;

experimentRoot = fullfile(projectRoot, ...
    '09_Final_Research_Experiment');

rawFile = fullfile(experimentRoot, ...
    '03_Raw_Detection_Outputs', ...
    'Full_4_Variant_Run', ...
    'all_record_outputs.mat');

modelFile = fullfile(experimentRoot, ...
    '01_Frozen_Model', ...
    'ECG_GUDB_RPeak_Detector_Frozen.slx');

outputFolder = fullfile(experimentRoot, ...
    '12_Figures', ...
    'MATLAB_Generated');

if ~isfile(rawFile)
    error(['Raw output file not found:\n%s\n', ...
        'Check project root and raw MAT file location.'],rawFile);
end

if ~isfolder(outputFolder)
    mkdir(outputFolder);
end

fprintf('Raw output file found.\n');
fprintf('Output folder:\n%s\n',outputFolder);

%% 2. CONFIGURATION

Fs = 250;

% Original evaluation tolerance
toleranceSamples = 12;
toleranceMs = 48;

activityOrder = { ...
    'sitting', ...
    'walking', ...
    'maths', ...
    'jogging', ...
    'hand_bike'};

variantOrder = { ...
    'Original_Maximum', ...
    'Percentile_90', ...
    'Percentile_92_5', ...
    'Percentile_95'};

nVariants = numel(variantOrder);

%% 3. LOAD RAW OUTPUTS

fprintf('\nLoading raw experiment outputs...\n');

D = load(rawFile,'allRawOutputs');
allRawOutputs = D.allRawOutputs;

recordNames = fieldnames(allRawOutputs);
nRecords = numel(recordNames);

fprintf('Records loaded: %d\n',nRecords);

if nRecords ~= 123
    warning('Expected 123 records. Found %d.',nRecords);
end

%% 4. EXTRACT RECORD-LEVEL METRICS

summaryRows = {};

allTimingErrors = [];
allFPDistances = [];
allFNDistances = [];

for r = 1:nRecords

    recordName = recordNames{r};
    R = allRawOutputs.(recordName);

    subject = str2double(recordName(2:3));
    activity = recordName(5:end);

    reference = unique(round(R.reference(:)));

    for v = 1:nVariants

        V = R.variants(v);

        TP = numel(V.matchedDetection);
        FP = numel(V.unmatchedDetection);
        FN = numel(V.unmatchedReference);

        P = safeDivide(TP,TP+FP);
        Rec = safeDivide(TP,TP+FN);
        F1 = safeDivide(2*P*Rec,P+Rec);

        summaryRows(end+1,:) = { ...
            recordName,subject,activity, ...
            variantOrder{v},TP,FP,FN, ...
            100*P,100*Rec,100*F1};

        % Timing errors from the original 48 ms matching.
        if v == 1

            allTimingErrors = [allTimingErrors; ...
                V.timingErrorMs(:)];

            detections = unique(round(V.refinedIndices(:)));

            % False-positive distance to nearest reference.
            fp = V.unmatchedDetection(:);

            for k = 1:numel(fp)

                if ~isempty(reference)

                    allFPDistances(end+1,1) = ...
                        min(abs(reference-fp(k)))*1000/Fs;

                end
            end

            % False-negative distance to nearest detection.
            fn = V.unmatchedReference(:);

            for k = 1:numel(fn)

                if ~isempty(detections)

                    allFNDistances(end+1,1) = ...
                        min(abs(detections-fn(k)))*1000/Fs;

                end
            end
        end
    end
end

summaryTable = cell2table(summaryRows, ...
    'VariableNames',{ ...
    'Record','Subject','Activity','Variant', ...
    'TP','FP','FN','Precision','Recall','F1'});

writetable(summaryTable, ...
    fullfile(outputFolder,'Figure_Data_Record_Level.csv'));

fprintf('Record-level metrics extracted.\n');

%% 5. FIGURE 1: ACTIVITY-WISE F1 COMPARISON

fprintf('\nGenerating Figure 1...\n');

activityF1 = nan(numel(activityOrder),nVariants);

for a = 1:numel(activityOrder)

    for v = 1:nVariants

        mask = strcmp(summaryTable.Activity,activityOrder{a}) & ...
               strcmp(summaryTable.Variant,variantOrder{v});

        T = summaryTable(mask,:);

        TP = sum(T.TP);
        FP = sum(T.FP);
        FN = sum(T.FN);

        P = safeDivide(TP,TP+FP);
        Rec = safeDivide(TP,TP+FN);

        activityF1(a,v) = 100*safeDivide(2*P*Rec,P+Rec);

    end
end

fig = figure('Color','w','Position',[100 100 1100 650]);

bar(activityF1,'grouped');

title('Activity-Wise R-Peak Detection Performance');
xlabel('Activity');
ylabel('Pooled F1-score (%)');

set(gca,'XTick',1:numel(activityOrder), ...
    'XTickLabel',strrep(activityOrder,'_',' '));

ylim([75 101]);
grid on;
box off;

legend(strrep(variantOrder,'_',' '), ...
    'Location','southoutside', ...
    'Orientation','horizontal');

saveFigure(fig,outputFolder,'Figure_01_Activity_Wise_F1');

%% 6. FIGURE 2: SUBJECT-LEVEL DESCRIPTIVE PERFORMANCE

fprintf('Generating Figure 2...\n');

subjects = unique(summaryTable.Subject);
subjectF1 = nan(numel(subjects),1);

for s = 1:numel(subjects)

    mask = summaryTable.Subject==subjects(s) & ...
        strcmp(summaryTable.Variant,'Original_Maximum');

    T = summaryTable(mask,:);

    TP = sum(T.TP);
    FP = sum(T.FP);
    FN = sum(T.FN);

    P = safeDivide(TP,TP+FP);
    Rec = safeDivide(TP,TP+FN);

    subjectF1(s) = 100*safeDivide(2*P*Rec,P+Rec);

end

fig = figure('Color','w','Position',[100 100 1200 600]);

bar(subjects,subjectF1);

title('Subject-Level Descriptive Performance of Original Maximum');
xlabel('Subject');
ylabel('Pooled F1-score (%)');

xticks(subjects);
xticklabels(compose('S%02d',subjects));

ylim([max(0,min(subjectF1)-5) 101]);
grid on;
box off;

saveFigure(fig,outputFolder,'Figure_02_Subject_Wise_F1');

%% 7. FIGURE 3: WORST-PERFORMING RECORDINGS

fprintf('Generating Figure 3...\n');

originalMask = strcmp(summaryTable.Variant,'Original_Maximum');
originalTable = summaryTable(originalMask,:);

[~,order] = sort(originalTable.F1,'ascend');

nWorst = min(15,height(originalTable));
worstTable = originalTable(order(1:nWorst),:);

fig = figure('Color','w','Position',[100 100 1100 650]);

barh(categorical(worstTable.Record),worstTable.F1);

title('Lowest-Performing Recordings: Original Maximum');
xlabel('F1-score (%)');
ylabel('Recording');

grid on;
box off;

saveFigure(fig,outputFolder,'Figure_03_Worst_Recordings');

writetable(worstTable, ...
    fullfile(outputFolder,'Worst_Performing_Recordings.csv'));

%% 8. FIGURE 4: TIMING-ERROR DISTRIBUTION

fprintf('Generating Figure 4...\n');

validTiming = allTimingErrors(isfinite(allTimingErrors));

fig = figure('Color','w','Position',[100 100 950 600]);

histogram(validTiming, ...
    'BinWidth',4, ...
    'FaceColor',[0.2 0.45 0.7], ...
    'EdgeColor','k');

hold on;

xline(0,'k--','Zero error','LineWidth',1.2);

xline(median(validTiming),'r:', ...
    sprintf('Median = %.2f ms',median(validTiming)), ...
    'LineWidth',1.5);

title('Matched R-Peak Timing Error Distribution');
xlabel('Signed timing error (ms)');
ylabel('Number of matched beats');

grid on;
box off;

saveFigure(fig,outputFolder,'Figure_04_Timing_Error_Distribution');

%% 9. FIGURE 5: REPRESENTATIVE ECG WITH R-PEAKS

fprintf('Generating Figure 5...\n');

% Prefer S00_sitting. Otherwise select first sitting record.
selectedRecord = '';

if isfield(allRawOutputs,'S00_sitting')

    selectedRecord = 'S00_sitting';

else

    for r = 1:nRecords

        if contains(recordNames{r},'sitting')

            selectedRecord = recordNames{r};
            break;

        end
    end
end

if isempty(selectedRecord)
    selectedRecord = recordNames{1};
end

R = allRawOutputs.(selectedRecord);

ecg = double(R.ecg(:));
reference = unique(round(R.reference(:)));

V = R.variants(1);
detections = unique(round(V.refinedIndices(:)));

% Select a representative 8-second segment.
segmentStart = 10*Fs+1;
segmentEnd = min(segmentStart+8*Fs-1,numel(ecg));

if segmentEnd <= segmentStart

    segmentStart = 1;
    segmentEnd = min(8*Fs,numel(ecg));

end

sampleRange = segmentStart:segmentEnd;
time = (sampleRange-1)/Fs;

refSegment = reference( ...
    reference>=segmentStart & reference<=segmentEnd);

detSegment = detections( ...
    detections>=segmentStart & detections<=segmentEnd);

fig = figure('Color','w','Position',[100 100 1200 600]);

plot(time,ecg(sampleRange),'k','LineWidth',1);
hold on;

if ~isempty(refSegment)

    scatter((refSegment-1)/Fs,ecg(refSegment), ...
        45,'v','filled','MarkerFaceColor',[0.1 0.55 0.2]);

end

if ~isempty(detSegment)

    scatter((detSegment-1)/Fs,ecg(detSegment), ...
        45,'rx','LineWidth',1.5);

end

title(['ECG R-Peak Detection: ',strrep(selectedRecord,'_',' ')]);
xlabel('Time (s)');
ylabel('ECG amplitude (a.u.)');

legend('ECG signal','Reference R-peaks', ...
    'Detected R-peaks','Location','best');

grid on;
box off;

saveFigure(fig,outputFolder,'Figure_05_Representative_ECG');

%% 10. FIGURE 6: FALSE-POSITIVE / FALSE-NEGATIVE DIAGNOSTICS

fprintf('Generating Figure 6...\n');

fig = figure('Color','w','Position',[100 100 1100 500]);

subplot(1,2,1);

if ~isempty(allFPDistances)

    histogram(allFPDistances,30);

end

title('False-Positive Temporal Distance');
xlabel('Distance to nearest reference (ms)');
ylabel('Count');
grid on;

subplot(1,2,2);

if ~isempty(allFNDistances)

    histogram(allFNDistances,30);

end

title('False-Negative Temporal Distance');
xlabel('Distance to nearest detection (ms)');
ylabel('Count');
grid on;

saveFigure(fig,outputFolder,'Figure_06_FP_FN_Diagnostics');

%% 11. FIGURE 7: TOLERANCE-DEPENDENT PERFORMANCE

fprintf('Generating Figure 7...\n');

% Requested matching tolerances in milliseconds.
requestedToleranceMs = [4 10 25 48 50 100];

% Convert requested tolerances into discrete samples.
toleranceSamples = round(requestedToleranceMs*Fs/1000);

% Actual effective tolerance after sample quantization.
effectiveToleranceMs = toleranceSamples*1000/Fs;

tolTP = zeros(size(requestedToleranceMs));
tolFP = zeros(size(requestedToleranceMs));
tolFN = zeros(size(requestedToleranceMs));

for r = 1:nRecords

    R = allRawOutputs.(recordNames{r});

    reference = unique(round(R.reference(:)));
    detections = unique(round(R.variants(1).refinedIndices(:)));

    for t = 1:numel(requestedToleranceMs)

        tolerance = toleranceSamples(t);

        M = localEvaluate(detections,reference,tolerance);

        tolTP(t) = tolTP(t)+M.TP;
        tolFP(t) = tolFP(t)+M.FP;
        tolFN(t) = tolFN(t)+M.FN;

    end
end

%% Calculate performance metrics

tolPrecision = zeros(size(requestedToleranceMs));
tolRecall = zeros(size(requestedToleranceMs));
tolF1 = zeros(size(requestedToleranceMs));

for t = 1:numel(requestedToleranceMs)

    tolPrecision(t) = safeDivide( ...
        tolTP(t),tolTP(t)+tolFP(t));

    tolRecall(t) = safeDivide( ...
        tolTP(t),tolTP(t)+tolFN(t));

    tolF1(t) = safeDivide( ...
        2*tolPrecision(t)*tolRecall(t), ...
        tolPrecision(t)+tolRecall(t));

end

%% Create corrected tolerance table

toleranceTable = table( ...
    requestedToleranceMs(:), ...
    toleranceSamples(:), ...
    effectiveToleranceMs(:), ...
    tolTP(:), ...
    tolFP(:), ...
    tolFN(:), ...
    100*tolPrecision(:), ...
    100*tolRecall(:), ...
    100*tolF1(:), ...
    'VariableNames',{ ...
    'RequestedToleranceMs', ...
    'ToleranceSamples', ...
    'EffectiveToleranceMs', ...
    'TP','FP','FN', ...
    'PrecisionPercent', ...
    'RecallPercent', ...
    'F1Percent'});

writetable(toleranceTable, ...
    fullfile(outputFolder,'Tolerance_Performance.csv'));

%% Generate corrected Figure 7

fig = figure('Color','w','Position',[100 100 1050 650]);

plot(effectiveToleranceMs,100*tolPrecision, ...
    '-o','LineWidth',1.8,'MarkerSize',7);

hold on;

plot(effectiveToleranceMs,100*tolRecall, ...
    '-s','LineWidth',1.8,'MarkerSize',7);

plot(effectiveToleranceMs,100*tolF1, ...
    '-d','LineWidth',1.8,'MarkerSize',7);

title('Tolerance-Dependent Performance: Original Maximum');

xlabel('Effective Matching Tolerance (ms)');
ylabel('Performance (%)');

% Display requested and effective tolerance together.
xticks(effectiveToleranceMs);

tickLabels = strings(size(requestedToleranceMs));

for t = 1:numel(requestedToleranceMs)

    tickLabels(t) = sprintf('%g (%g)', ...
        requestedToleranceMs(t), ...
        effectiveToleranceMs(t));

end

xticklabels(tickLabels);

ylim([0 102]);

legend('Precision','Recall','F1-score', ...
    'Location','best');

grid on;
box off;

saveFigure(fig,outputFolder,'Figure_07_Tolerance_Performance');

fprintf('\nTolerance conversion:\n');
disp(toleranceTable);

%% 12. FIGURE 8: ACTIVITY-WISE MEDIAN ECG BEAT TEMPLATES

fprintf('Generating Figure 8...\n');

preSamples = 50;
postSamples = 100;

timeTemplate = (-preSamples:postSamples)/Fs*1000;

fig = figure('Color','w','Position',[100 100 1100 650]);
hold on;

templateRows = {};

for a = 1:numel(activityOrder)

    beatSegments = [];

    for r = 1:nRecords

        recordName = recordNames{r};

        if ~contains(recordName,activityOrder{a})
            continue;
        end

        R = allRawOutputs.(recordName);
        ecg = double(R.ecg(:));
        refs = unique(round(R.reference(:)));

        for k = 1:numel(refs)

            idx = refs(k);

            if idx-preSamples >= 1 && ...
               idx+postSamples <= numel(ecg)

                beat = ecg(idx-preSamples:idx+postSamples);

                beatSegments(:,end+1) = beat;

            end
        end
    end

    if ~isempty(beatSegments)

        medianBeat = median(beatSegments,2);

        plot(timeTemplate,medianBeat,'LineWidth',1.6, ...
            'DisplayName',strrep(activityOrder{a},'_',' '));

        templateRows(end+1,:) = { ...
            activityOrder{a},size(beatSegments,2)};

    end
end

xline(0,'k--','Reference annotation');

title('Activity-Wise Median ECG Beat Templates');
xlabel('Time relative to reference annotation (ms)');
ylabel('ECG amplitude (a.u.)');

legend('Location','best');
grid on;
box off;

saveFigure(fig,outputFolder,'Figure_08_Median_Beat_Templates');


%% 13. FIGURE 9: CLEAN FROZEN SIMULINK MODEL ARCHITECTURE

fprintf('Generating clean Figure 9: Simulink Architecture...\n');

if isfile(modelFile)

    try
        [~,modelName] = fileparts(modelFile);

        % Close any previously loaded copy without saving changes.
        if bdIsLoaded(modelName)
            close_system(modelName,0);
        end

        % Reload the original frozen model from disk.
        load_system(modelFile);

        % Clear all existing block and signal highlighting.
        hilite_system(modelName,'none');

        % Open the model for clean architecture rendering.
        open_system(modelName);

        % Ensure the complete architecture fits in the view.
        set_param(modelName,'ZoomFactor','FitSystem');

        % Stop any residual simulation state.
        set_param(modelName,'SimulationCommand','stop');

        % Clear highlighting again after opening.
        hilite_system(modelName,'none');

        drawnow;

        % Export high-resolution architecture image.
        architectureFile = fullfile(outputFolder, ...
            'Figure_09_Simulink_Model_Architecture.png');

        print(['-s',modelName], ...
            '-dpng','-r300',architectureFile);

        fprintf('\nFigure 9 exported successfully.\n');
        fprintf('File: %s\n',architectureFile);

        % Close without modifying or saving the frozen model.
        close_system(modelName,0);

    catch ME

        warning('Figure 9 export failed: %s',ME.message);

        if bdIsLoaded(modelName)
            close_system(modelName,0);
        end

    end

else

    warning('Frozen Simulink model not found. Figure 9 skipped.');

end


%% 14. SAVE SUMMARY STATISTICS

fprintf('\nSaving timing summary...\n');

timingSummary = table( ...
    numel(validTiming), ...
    mean(validTiming), ...
    median(validTiming), ...
    mean(abs(validTiming)), ...
    std(validTiming), ...
    min(validTiming), ...
    max(validTiming), ...
    'VariableNames',{ ...
    'MatchedBeatCount','MeanSignedErrorMs','MedianErrorMs', ...
    'MAE_Ms','SD_Ms','MinimumErrorMs','MaximumErrorMs'});

writetable(timingSummary, ...
    fullfile(outputFolder,'Timing_Error_Summary.csv'));

%% 15. SAVE EXPERIMENT FIGURE DATA

save(fullfile(outputFolder,'Figure_Generation_Data.mat'), ...
    'summaryTable','activityF1','subjectF1','subjects', ...
    'worstTable','toleranceTable','timingSummary', ...
    'allTimingErrors','allFPDistances','allFNDistances', ...
    'selectedRecord', ...
    'requestedToleranceMs', ...
    'toleranceSamples', ...
    'effectiveToleranceMs', ...
    'toleranceMs','Fs','-v7.3');

%% 16. FINAL REPORT

pngFiles = dir(fullfile(outputFolder,'*.png'));
figFiles = dir(fullfile(outputFolder,'*.fig'));

fprintf('\n====================================================\n');
fprintf(' FIGURE GENERATION COMPLETED\n');
fprintf('====================================================\n');

fprintf('Records processed: %d\n',nRecords);
fprintf('PNG figures saved: %d\n',numel(pngFiles));
fprintf('FIG files saved: %d\n',numel(figFiles));

fprintf('\nOutput directory:\n%s\n',outputFolder);

fprintf('\nTiming statistics (48 ms matched beats):\n');
disp(timingSummary);

fprintf('\nTolerance performance:\n');
disp(toleranceTable);

fprintf('\nAll available outputs saved.\n');

%% ================================================================
% LOCAL FUNCTIONS
%% ================================================================

function saveFigure(fig,folder,baseName)

    pngPath = fullfile(folder,[baseName,'.png']);
    figPath = fullfile(folder,[baseName,'.fig']);

    exportgraphics(fig,pngPath,'Resolution',300);
    savefig(fig,figPath);

    close(fig);

    fprintf('Saved: %s\n',baseName);

end


function value = safeDivide(a,b)

    if b == 0

        value = 0;

    else

        value = a/b;

    end

end


function M = localEvaluate(det,ref,tolerance)

    det = sort(unique(round(det(:))));
    ref = sort(unique(round(ref(:))));

    i = 1;
    j = 1;

    matchedDet = [];
    matchedRef = [];

    while i<=numel(det) && j<=numel(ref)

        delta = det(i)-ref(j);

        if abs(delta)<=tolerance

            matchedDet(end+1,1) = det(i);
            matchedRef(end+1,1) = ref(j);

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

    M.TP = TP;
    M.FP = FP;
    M.FN = FN;

end
