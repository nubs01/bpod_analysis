function [out, columns, B, dev, stats] = get_choice_probability(SessionData)
    [data, columns] = parse_choice_data(SessionData);
    to_plot = true;
    % remove all aborted trials
    idx = data(:,5) == 1;
    data = data(idx,:);

    X = data(:,6); % using number of PR presses required as the predictor variable
    % X = data(:, [1,6]); % could use both trial and number of PR presses
    Y = data(:,2); % choice is the dependent varaible (1 for PR, 0 for FR)

    % Fit binomial glm (logistic regression)
    [B, dev, stats] = glmfit(X, Y, 'binomial');
    columns = [columns 'PR_probability' 'PR_Prob_low', 'PR_prob_hi'];
    [yfit, dylo, dyhi] = glmval(B, X, 'logit', stats);
    out = [data yfit yfit-dylo yfit+dyhi];

    if to_plot
        figure();
        subplot(2,1,1)
        xvec = [data(:,1)', fliplr(data(:,1)')];
        yvec = [out(:,end-1)', fliplr(out(:,end)')];
        plot(data(:,1), data(:,2), 'm.', 'markersize', 15);
        hold on
        fill(xvec, yvec, 'r', 'facealpha', 0.4, 'edgecolor', 'none');
        fill(xvec, 1-yvec, 'b', 'facealpha', 0.4, 'edgecolor', 'none');
        l_pr = plot(data(:,1), yfit, 'r-', 'linewidth', 3);
        l_fr = plot(data(:,1), 1-yfit, 'b-', 'linewidth',3);
        legend([l_pr, l_fr], {'PR', 'FR'}, 'location', 'east')
        xlabel('Trial')
        ylabel('Probability of choice')
        xlim([min(data(:,1)), max(data(:,1))])
        ylim([-0.2, 1.2])
        yticks(0:.2:1)
        yyaxis right
        ylim([-0.2,1.2])
        yticks([0,1])
        yticklabels({'FR', 'PR'})

        subplot(2,1,2)
        plot(data(:,6), yfit, 'r-', 'linewidth', 2)
        hold on
        plot(data(:,6), 1-yfit, 'b-', 'linewidth',2)
        xlabel('PR Presses Required')
        ylabel('Probability of choice')
        xlim([min(data(:,6)), max(data(:,6))])
        suptitle('Choice Probability')
    end




