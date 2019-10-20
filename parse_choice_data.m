function [out, columns] = parse_choice_data(SessionData)
    n_trials = SessionData.nTrials;
    columns = {'trial','choice','presses','aborted', 'rewarded', 'PR_requirement'};
    out = zeros([n_trials, length(columns)]);
    PR_presses = 1;
    for i = 1:n_trials
        out(i, 1) = i;
        trial = SessionData.RawEvents.Trial{i};
        states = get_valid_states(trial.States);
        
        % Get side chosen
        if any(strcmp(states, 'Side_L'))
            out(i,2) = 1;
        elseif any(strcmp(states, 'Side_S'))
            out(i,2) = 0;
        end
        
        % Get if rewarded or aborted
        if any(cellfun(@(x) logical(contains(x, 'DeliverReward')), states))
            out(i,5) = 1;
        else
            out(i,4) = 1;
        end
        
        % Get number of presses
        db = states(cellfun(@(x) logical(contains(x, 'Debounce')), states));
        n = 0;
        if ~isempty(db)
            for j = 1:length(db)
                tmp = strsplit(db{j}, '_');
                tmp = str2double(tmp{2}(2:end));
                if tmp > n
                    n = tmp;
                end
            end
        end
        out(i, 3) = n;
        if out(i, 2) == 1 && out(i,5) == 1
            PR_presses = n;
        end
        out(i, 6) = PR_presses;
    end
end
