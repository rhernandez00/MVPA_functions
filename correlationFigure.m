% Mostrar en una figura como correlacionan los patrones de actividad entre 
% categor�as. Entonces voy a poner una matriz con cuatro renglones, un 
% rengl�n por categor�a. Cada rengl�n va a tener gr�ficas de barras que 
% van a representar la correlaci�n promedio entre los patrones de cada 
% categor�a.
%
% Por cada v�deo, tenemos una imagen que representa la actividad que 
% gener� ese v�deo. 
%
% Recordemos que tenemos 4 categor�as, 12 videos por categor�a por cada 
% corrida y 6 corridas por cada participante.
%
% Lo que te encargar�a, es una funci�n que genere una tabla para hacer esa 
% figura. 
% La tabla tendr�a 4 columnas:
% Categor�a 1, categor�a 2, correlaci�n promedio, error est�ndar.
% 
% Estoy trabajando en una funci�n que devuelve el vector que se necesita 
% para hacer las correlaciones. La funci�n recibe como input:
% participante, corrida, n�mero de v�deo (1-48).
% 
% Cabe destacar que los vectores solo se correlacionan entre la misma 
% corrida y mismo participante.
%
% Y los la numeraci�n de los v�deos es:
% 1-12 carros
% 13-24 gatos
% 25-36 perros
% 37-48 humanos

% experiment,specie,FSLModel,sub,run,nCat,

% Experiment Variables
sub = 5;
nVid = 12; % videos per category
nCat = 1:48;
run = 6;
catlen = 4;
L = [ones(nVid,1); 2*ones(nVid,1); 3*ones(nVid,1); 4*ones(nVid,1)]; % num label for each video

% Cell array to store all the correlation values
C = cell(sub*run, catlen);

% ACTIVITY SIMULATION

% Genearate vectors correlated within categories. 
xlen = 100; % length of the simulated activty vector
X = rand(xlen, catlen); % vectors for each category from which a correlated activity will be taken from

% Force a correlation between Cats and Dogs
scalar = 0.5;
X(:,3) = X(:,2)*scalar + scalar*(X(:,3));



% Initialize matrix to save all the activity vectors for one subject in one
% run
S = zeros(xlen, nVid*catlen);

% For loop simulating the activty 
for ii = 1:length(nCat)
    x = X(:,L(ii)); % select the reference vector designated for each category
    mu = mean(x); % use mean and sd as parameters to generate correlated simulated activity
    sigma = std(x);
    S(:,ii) = dummyFunc(x, mu, sigma); % correlated activity
end

% CORRELATION MATRIX 

S_corr = corr(S);

% MEAN CORRELATION

% Get the upper triangle of the matrix; exclude main diagonal
S_upper = triu(S_corr,1);
S_upper(S_upper == 0) = nan;

C = cell(catlen,catlen);

% Use labels to select the wanted subset of correlations and store them
for numL = 1:catlen
    for cc = 1:catlen
       subset = S_upper(L==numL, L == cc);
       C{numL,cc} = subset(:);
    end
end






