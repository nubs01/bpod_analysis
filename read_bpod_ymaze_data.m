function [out, columns] = read_bpod_ymaze_data(SessionData)
    nTrials = SessionData.nTrials;
    columns = {'trial', 'sample', 'sample_rewarded', 'target_choice', 'choice_rewarded'};
    out = zeros([nTrials, length(columns)]);
    for i = 1:nTrials
        out(i,1) = i;
        states = get_valid_states(SessionData.RawEvents.Trial{i}.States);
        for j = 1:length(states)
            s = states{j};
            if contains(s, 'ForcedRun') && contains(s, 'WaitForPoke')
                poke = str2double(s(end));
                if poke ~= 1
                    out(i, 2) = poke;
                end
            elseif contains(s,'ForcedRun') && contains(s,'DeliverReward')
                poke = str2double(s(end));
                if poke == out(i,2)
                    out(i,3) = 1;
                end
            elseif contains(s,'FreeRun') && contains(s,'WaitForPoke')
                poke = str2double(s(end));
                if poke ~= 1
                    out(i,4) = poke;
                end
            elseif contains(s,'FreeRun') && contains(s,'DeliverReward')
                poke = str2double(s(end));
                if poke == out(i,4)
                    out(i,5) = 1;
                end
            end
        end
    end


        
