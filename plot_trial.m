function out = plot_trial(trial)
    state_names = fieldnames(trial.States)
    event_names = fieldnames(trial.Events)
    for i = length(state_names):-1:1
        if any(isnan(getfield(trial.States, state_names{i})))
            state_names(i) = [];
        end
    end
    event_names(strcmp(event_names, 'Tup')) = []


function get_bpod_trial_data(SessionData)
    out.inter_trial_interval = SessionData.TrialSettings.TimeBetweenTrials
    out.trial_starts = SessionData.TrialStartTimestamp
    out.trial_ends = SessionData.TrialEndTimestamp
    out.n_trials = SessionData.nTrials
    out.trials = {}
    out.target_ports = SessionData.TrialTypes
    for i in 1:out.n_trials
        all_times = union(SessionData.RawData.OriginalStateTimestamps{i}, SessionData.RawData.OriginalEventTimestamps{i})
        trial = SessionData.RawEvents.Trial{i}
        state_names = fieldnames(trial.States)
        event_names = fieldnames(trial.Events)
        for i = length(state_names):-1:1
            if any(isnan(getfield(trial.States, state_names{i})))
                state_names(i) = [];
            end
        end
        event_names(strcmp(event_names, 'Tup')) = []
