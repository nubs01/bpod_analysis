function fn = get_valid_states(states)
    fn = fieldnames(states);
    for i = length(fn):-1:1
        if any(isnan(states.(fn{i})))
            fn(i) = [];
        end
    end
end
