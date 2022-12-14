function [c1, s1] = v1model(imgmat, varargin)
%
% Get the C1 and S1 units modeled by HMAX
%
% USAGE: [c1, s1] = v1model(imgmat) % To use default values of parameters
%        [c1, s1] = v1model(imgmat,VALUES) % To change parameters. See below           
%
% Inputs:
%   MANDATORY:
%       imgmat = matrix of an image (double type of data and gray scale needed). 
%
%   VALUES:
%       orientations: vector with the angles in degrees for the gabor
%       filter. 
%           Default values = [90, -45, 0, 45]
%           EX: [c1,s1] = v1model(imgmat,'orienations', [0,5,90,180])
%
%       RFsizes: vector with the size of the receptive fields of the S1
%       units. A value of "a" means that the s1 unit will have a receptive
%       field of a x a pixels.
%           Default values = 7:2:39
%           EX: [c1,s1] =  v1model(imgmat,'RFsizes',1:2:10)
%
%       div: vector with scaling factors. Each element of the vector is
%       used to scale the wavelength of the gabor filters to the receptive
%       field. Thus length(div) == length(RFsizes).
%           Default values = 4:-0.05:3.2
%           Ex: [c1,s1] =  v1model(imgmat,'div',10:-2:1)
%
%       c1Scale: vector to define bands of receptive fields
%addpath('D:\Raul\Eduardo\mfiles\hmax');
% Default values (taken from the example.m file of the hmax scripts)
orientations = [90 -45 0 45]; % orientations for gabor filters
RFsizes      = 7:2:39;        % receptive field sizes
div          = 4:-.05:3.2;    % tuning parameters for the filters' "tightness"
c1Scale = 1:2:18;             % defining 8 scale bands
c1Space = 8:2:22;             % defining spatial
c1mean = 1;                   % get the mean of all c1 units resized to the biggest RF (ie. smallest matrix)
colvector = 0;                            


% Change default values
if ~(isempty(varargin))
    
    for ii = 1:2:length(varargin)-1
        switch varargin{ii}
            case 'orientations'
                orientations = varargin{ii+1};
            case 'RFsizes';
                RFsizes = varargin{ii+1};
            case 'div'
                div = varargin{ii+1};
            case 'c1Scale'
                c1Scale = varargin{ii+1};
            case 'c1Space'
                c1Space = varargin{ii+1}; 
            case 'c1mean'
                c1mean = varargin{ii+1};
            case 'colvector'
                colvector = varargin{ii+1};
        end
    end
end

% Check if input image is gray scale; transform it if is rgb (aka has 3rd dimension)
if length(size(imgmat)) == 3
   imgmat = rgb2gray(imgmat); 
end
% Get gabor filters from values
[filterSizes,filters,c1OL] = initGabor(orientations,RFsizes,div);

% Get c1 and s1 models
[c1,s1] = C1(imgmat,filters,filterSizes,c1Space,c1Scale,c1OL);

if colvector
    c1_stack = [];
    for c = 1:length(c1)
        c1_stack = [c1_stack; c1{c}(:)];
    end
    c1 = c1_stack;
end


    
