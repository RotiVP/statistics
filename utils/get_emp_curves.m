function [cumul_dist prob_density] = get_emp_curves(interval_count, sample) % get empirical curves

    s_sample = sort(sample);

    interval = (s_sample(end) - s_sample(1)) / interval_count;
    x = s_sample(1) - interval:interval:s_sample(end) + interval;

    element_count = zeros(1, length(x));

    x_pos = 1;
    for element = s_sample
        while( x(x_pos) <= element ) % start <= element < end

            x_pos = x_pos + 1;
        endwhile

        element_count(x_pos - 1) = element_count(x_pos - 1) + 1;
    endfor

    cumul_dist.x = x;
	cumul_dist.y = element_count;

    prob_density = cumul_dist;
    prob_density.y(end - 1) = prob_density.y(end - 1) + prob_density.y(end);
    prob_density.y(end) = 0;

    for i = 1:length(x)
        prob_density.y(i) = prob_density.y(i) / length(sample);
        cumul_dist.y(i) = cumul_dist.y(i) / length(sample);
        if( i > 1 )
            cumul_dist.y(i) = cumul_dist.y(i) + cumul_dist.y(i - 1);
        endif
    endfor
endfunction
