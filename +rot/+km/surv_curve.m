function [curve] = surv_curve(interval, objects)

	% objects: action, control, event

	[start_day end_day] = day_lim({objects.control objects.action objects.event});

	interval_count = ceil((end_day - start_day) / interval);
	
    timestamps = struct(
		'time', num2cell( 0:interval:interval * interval_count ),
	   	'risk', 0,
	   	'cens', 0,
	   	'event', 0,
		'surv_val', 0);

    init_set = length(objects);

	% to fill censored and event data
    for i = 1:init_set

        surv_start = objects(i).action;
        control_date = objects(i).control;
        event_date = objects(i).event;

        if( ! strcmp(event_date, 'NULL') )
            surv_end = event_date;
            is_event = 1;
        else
            surv_end = control_date;
            is_event = 0;
        endif

        if( strcmp(surv_end, 'NULL') )
            timestamps(2).cens = timestamps(2).cens + 1; % surv after action but communication lost
            continue
        endif

        surv_t = datenum(surv_end) - datenum(surv_start);
		ts_num = ceil(surv_t/interval) + 1; % start < surv_t <= end

        if( is_event )
            timestamps(ts_num).event = timestamps(ts_num).event + 1;
        else
            timestamps(ts_num).cens = timestamps(ts_num).cens + 1;
        endif
    endfor

	% to fill risk set and survival values
	for i = 1:length(timestamps)

        if(init_set == 0)
			timestamps = timestamps(1:i-1);
            break
        endif

        timestamps(i).risk = init_set;

        timestamps(i).surv_val = ...
			(timestamps(i).risk - timestamps(i).event) / timestamps(i).risk;
        init_set = init_set - timestamps(i).cens - timestamps(i).event;

        if(i != 1)
            timestamps(i).surv_val = timestamps(i-1).surv_val * timestamps(i).surv_val;
        endif
    endfor

	curve.timestamps = timestamps;

endfunction

function [min_day max_day] = day_lim(dates) % day limits
	min_day = max_day = -1;
	for date = dates

		if( strcmp(date, 'NULL') )
			continue
		endif

		day = datenum(date);

		if( min_day == -1 )
			min_day = day;
		elseif ( min_day > day )
			min_day = day;
		endif

		if( max_day == -1 )
			max_day = day;
		elseif ( max_day < day )
			max_day = day;
		endif
	endfor
endfunction
