function FSLBase = getFSLBase(experiment,FSLModel)
%gives back the FSL contrast number used for stim > baseline
    switch experiment
        case 'Complex'
            switch FSLModel
                case 50
                    FSLBase = 53;
                case 51
                    FSLBase = 52;
                otherwise
                    FSLBase = 8;
            end
        otherwise
            error('experiment not found, write new experiment')
    end
end
