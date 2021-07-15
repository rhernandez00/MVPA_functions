function matrix = vector2Matrix(vector,varargin)
categories = getArgumentValue('categories',[],varargin{:});

if isempty(categories)
    categories = categoriesFromCombinations(numel(dsmVector));
end

pairs = combinator(categories,2,'c');
matrix = zeros(categories);
for n = 1:size(pairs,1)
    matrix(pairs(n,1),pairs(n,2)) = vector(n);
    matrix(pairs(n,2),pairs(n,1)) = vector(n);
end