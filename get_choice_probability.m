function [out, columns, switch_point, B, dev, stats] = get_choice_probability(SessionData)
    [data, columns] = parse_choice_data(SessionData);
    pr_col = find(strcmp(columns, 'PR_requirement'));
    choice_col = find(strcmp(columns, 'choice'));
    trial_col = find(strcmp(columns, 'trial'));
    to_plot = true;
    % remove all aborted trials
    idx = data(:,5) == 1;
    data = data(idx,:);

    X = data(:,pr_col); % using number of PR presses required as the predictor variable
    % X = data(:, [1,6]); % could use both trial and number of PR presses
    Y = data(:,choice_col); % choice is the dependent varaible (1 for PR, 0 for FR)
    trials = data(:, trial_col);

    % Fit binomial glm (logistic regression)
    [B, dev, stats] = glmfit(X, Y, 'binomial');
    columns = [columns 'PR_probability' 'PR_Prob_low', 'PR_prob_hi'];
    [yfit, dylo, dyhi] = glmval(B, X, 'logit', stats);
    out = [data yfit yfit-dylo yfit+dyhi];

    switch_point = -B(1)/B(2);
    if to_plot
        figure('Position', [59, 2, 1800, 900]);
        subplot(2,1,1)
        xvec = [trials', fliplr(trials')];
        yvec = [out(:,end-1)', fliplr(out(:,end)')];
        plot(trials, Y, 'm.', 'markersize', 15);
        hold on
        fill(xvec, yvec, 'r', 'facealpha', 0.4, 'edgecolor', 'none');
        fill(xvec, 1-yvec, 'b', 'facealpha', 0.4, 'edgecolor', 'none');
        l_pr = plot(trials, yfit, 'r-', 'linewidth', 3);
        l_fr = plot(trials, 1-yfit, 'b-', 'linewidth',3);
        legend([l_pr, l_fr], {'PR', 'FR'}, 'location', 'east')
        xlabel('Trial')
        ylabel('Probability of choice')
        xlim([min(trials), max(trials)])
        ylim([-0.2, 1.2])
        yticks(0:.2:1)
        yyaxis right
        ylim([-0.2,1.2])
        yticks([0,1])
        yticklabels({'FR', 'PR'})

        subplot(2,1,2)
        xvec = [X', fliplr(X')];
        fill(xvec, yvec, 'r', 'facealpha', 0.4, 'edgecolor', 'none');
        hold on
        fill(xvec, 1-yvec, 'b', 'facealpha', 0.4, 'edgecolor', 'none');
        plot(X, yfit, 'r-', 'linewidth', 3)
        plot(X, 1-yfit, 'b-', 'linewidth',3)
        l1 = xline(switch_point, '-', 'Switch Point', 'linewidth',1);
        legend(l1, {sprintf('%0.3g', switch_point)}, 'location','east');
        xlabel('PR Presses Required')
        ylabel('Probability of choice')
        xlim([min(X), max(X)])
        suptitle('Choice Probability')
    end




