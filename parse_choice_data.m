function [out, columns] = parse_choice_data(SessionData)
    n_trials = SessionData.nTrials;
    columns = {'trial','choice','presses','aborted', 'rewarded', 'PR_requirement', 'FR_requirement', 'PR_reward_size','FR_reward_size'};
    out = zeros([n_trials, length(columns)]);
    for i = 1:n_trials
        out(i, 1) = i;
        trial = SessionData.RawEvents.Trial{i};
        settings = SessionData.TrialSettings(i).GUI;
        states = get_valid_states(trial.States);
        out(i,6) = settings.NumPressRequired_L;
        out(i,7) = settings.NumPressRequired_S;
        out(i,8) = settings.Reward_L;
        out(i,9) = settings.Reward_S;

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
    end
end
