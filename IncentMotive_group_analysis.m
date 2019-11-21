function [out, columns, data_labels, B, dev, stats] = IncentMotive_group_analysis(file_dir)
    out = -1;
    if ~exist('file_dir','var')
        file_dir = uigetdir(pwd, 'Choose folder containing all files to analyze');
        if isequal(file_dir, 0)
            return;
        end
    end

    file_list = dir(file_dir);
    if isempty(file_list)
        disp('No file found in folder')
        return;
    end

    data = [];
    data_labels = {};
    file_pattern = '(?<anim>\w+)_[a-zA-Z]+_(?<date>\d+)_(?<time>\d+)\.mat';
    for f = file_list'
        if endsWith(f.name, 'mat')
            fn = [f.folder filesep f.name];
            tmp = load(fn);
            if ~isfield(tmp, 'SessionData')
                continue
            end
            sd = tmp.SessionData;
            [dat, columns] = parse_choice_data(sd);

            % Parse filename for animal name, date, time
            parsed = regexp(f.name, file_pattern, 'names');
            data_labels = [data_labels; repmat({parsed.anim, parsed.date, parsed.time}, size(dat,1),1)];

            data = [data;dat];
        end
    end

    choice_col = strcmp(columns, 'choice');
    c1 = strcmp(columns, 'PR_requirement');
    c2 = strcmp(columns, 'FR_requirement');
    c3 = strcmp(columns, 'PR_reward_size');
    c4 = strcmp(columns, 'FR_reward_size');
    fit_Y = data(:, choice_col);
    fit_data = [data(:,c1), data(:,c2), data(:,c3)./data(:,c4)];

    % Fit binomial glm (logistic regression)
    [B, dev, stats] = glmfit(fit_data, fit_Y, 'binomial');
    columns = [columns 'Reward_Ratio' 'PR_probability' 'PR_Prob_low', 'PR_prob_hi'];
    [yfit, dylo, dyhi] = glmval(B, fit_data, 'logit', stats);
    out = [data fit_data(:,end) yfit yfit-dylo yfit+dyhi];








