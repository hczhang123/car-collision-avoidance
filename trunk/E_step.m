function [model] = E_step(model, data, MAXESTEPITER, maxvalue, option, phase)

% E step of proposed model

count     = 0;

while(count<MAXESTEPITER)
    
    disp('count from E-step');
    count  = count+1

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%% for debugging 
    %%% model = update_phi(model, data);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    if (option==1)        %% unsupervised LDA
        model.phi = update_phi_cpp(model, data, psi(model.gamma), 1, [], []);
    elseif (option==2)    %% labeled LDA
        model.phi = update_phi_cpp(model, data, psi(model.gamma), 2, phase, data.annotations);
    elseif (option==3)    %% Med LDA
        model.phi = update_phi_cpp(model, data, psi(model.gamma), 3, [], []);
    elseif (option==4)    %% my model
        model.phi = update_phi_cpp(model, data, psi(model.gamma), 4, phase, [data.annotations ones(model.N,model.k2)]); %% to do
    else
    end
    
    %% for checking if lower bound increases after each update; useful for debugging -- should be commented out to save time while running experiments
    value1 = cal_likelihood(model, data)
    if (compareval(value1, maxvalue))
        maxvalue = value1;
    else
        error('Incorrect after phi');
    end
    
    model  = update_gamma(model, data);
    
    value2 = cal_likelihood(model, data) 
    if (compareval(value2, maxvalue))
        maxvalue = value2;
    else
        error('Incorrect after gamma');
    end
    
end

end
