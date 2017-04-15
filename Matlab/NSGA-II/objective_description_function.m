function [number_of_objectives, number_of_decision_variables, min_range_of_decesion_variable, max_range_of_decesion_variable] = objective_description_function()
    global par_ig1 par_ig2 par_ig3 par_ig4 par_io par_turbineD;
    number_of_objectives=2; 
    number_of_decision_variables=6;
    min_range_of_decesion_variable=[par_ig1-0.3 par_ig2-0.3 par_ig3-0.2 par_ig4-0.1 par_io-0.5 par_turbineD-0.02];
    max_range_of_decesion_variable=[par_ig1+0.3 par_ig2+0.3 par_ig3+0.2 par_ig4+0.1 par_io+0.5 par_turbineD+0.02];
end