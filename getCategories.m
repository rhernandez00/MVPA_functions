function categories = getCategories(experiment,FSLModel)

switch experiment
    case 'Complex'
        switch FSLModel
            case 3
                categories = 48;
            otherwise
                error(['FSLModel not found, model introduced: ',num2str(FSLModel)]);
        end
    case 'Objects'
        switch FSLModel
            case 1
                categories = 3;
            case 2
                categories = 3;
            case 3
                categories = 3;
            case 4
                categories = 27;
            case 14
                categories = 27;
            otherwise
                error(['FSLModel not found, model introduced: ',num2str(FSLModel)]);
        end
    otherwise
        error('Write another experiment case')
        
end
