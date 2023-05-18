
pThr = 0.05;
participants = 13;
runs = 12;
categories = 3;
nRepetitions = 100000;
%calculating distribution
performanceDistribution = calculateDistribution(participants,runs,categories,nRepetitions);
%fitting the distribution
distribution = fitdist(performanceDistribution','Normal');
side = 'moreThan';

% 
valInit = 1/categories;
for val = valInit:0.01:1
    p = pFromDist(distribution,val,side);
    if p < pThr
        disp(['The performance threshold for a p < ',num2str(pThr), ' is ', num2str(val)]);
        break
    end
end

%additional check
calculatedP = 1 - sum(performanceDistribution < val) / length(performanceDistribution);
disp(['The actual p for a performance of ', num2str(val),' is ', num2str(calculatedP)]);