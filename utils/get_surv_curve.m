function [surv_curve] = get_surv_curve(interval, objects)

	% objects: action, control, event

	[start_day end_day] = get_day_limit({objects.control objects.action objects.event});

	interval_count = ceil((end_day - start_day) / interval);

	surv_curve.x = 0:interval:interval * interval_count;

    c = cell(1, length(surv_curve.x)); 
	c(:) = 0;
    timestamps = struct('risk', c, 'cens', c, 'event', c);

    init_set = length(objects);

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

	[surv_curve.y, surv_curve.timestamps ] = get_surv_val(timestamps, init_set);

endfunction

function [surv_val, timestamps] = get_surv_val(timestamps, init_set)

    for i = 1:length(timestamps)

        if(init_set == 0)
            break
        endif

        timestamps(i).risk = init_set;

        surv_val(i) = (init_set - timestamps(i).event) / init_set;
        init_set = init_set - timestamps(i).cens - timestamps(i).event;

        if(i != 1)
            surv_val(i) = surv_val(i-1) * surv_val(i);
        endif
    endfor

    if(length(timestamps) != length(surv_val))
        fprintf('[WARNING] Too long time interval. Cutting...\n');
        timestamps = timestamps(1:length(surv_val));
    endif

endfunction

function [min_day max_day] = get_day_limit(dates)
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
