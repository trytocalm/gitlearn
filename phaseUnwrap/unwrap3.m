function [pdU, h] = unwrap3(pd, params)
% params.upThresh and params.upCor. Points where postive jump is greater
% than upThresh will be corrected by upCor (so upCor should probably be 
% negative)
%
% params.downThresh and params.upCor. Points where postive jump is greater
% than downThresh will be corrected by downCor (so downCor should probably
% be positive)

%% Set params

% upThresh: Threshold for up jumps
if nargin < 2 || ~isfield(params, 'upThresh')
    upThresh = 180;
else
    upThresh = params.upThresh;
end
% upCor: Correction mag for up jumps (showld be down)
if nargin < 2 || ~isfield(params, 'upCor')
    upCor = -360;
else
    upCor = params.upCor;
end
% downThresh: Threshold for down jumps
if nargin < 2 || ~isfield(params, 'downThresh')
    downThresh = -180;
else
    downThresh = params.downThresh;
end
% downCor: Correction mag for down jumps (showld be up)
if nargin < 2 || ~isfield(params, 'downCor')
    downCor = 360;
else
    downCor = params.downCor;
end
% norm: Normalise start to zero?
if nargin < 2 || ~isfield(params, 'norm')
    norm = true;
else
    norm = params.norm;
end
% pltOn: Plot?
if nargin < 2 || ~isfield(params, 'plotOn')
    plotOn = true;
else
    plotOn = params.plotOn;
end

inRow = size(pd,2)>1;


%% Run

% If input col, switch to row
if ~inRow
    pd = pd';
end

% Find differences
pdDiff = [0, diff(pd)];

% Find differences above thresholds
pdDiffLog = any([(pdDiff > 0) & (pdDiff > upThresh); ...
    (pdDiff < 0) & (pdDiff < downThresh)]);

pdU = pd;
if any(pdDiffLog)
    % At each of these locations, add or subtract to point and each 
    % subsequent point
    for p = 1:length(pd)
        if pdDiffLog(p)
            
            % Find direction to adjust
            if pdDiff(p) > 0
                adjust = upCor; % Correct down
            else
                adjust = downCor; % Correct up
            end
            
            pdU(p:end) = pdU(p:end) + adjust;
        end
    end
    
end

% Roughly normalise phase
% Adjust to 0 start using mean of first 2 points
if norm
    pdU = pdU - mean(pdU(1:2));
end

% If input was a col, return a col
if ~inRow
    pdU = pdU';
end

% If plot requested, plot
if plotOn
    h = figure;
    plot(pd)
    hold on
    plot(pdU)
end
