% empirical probability density curve

function [curve] = pdc(interval_count, sample)

    s_sample = sort(sample);

    interval = (s_sample(end) - s_sample(1)) / interval_count;
    curve.x = s_sample(1) - interval:interval:s_sample(end) + interval;

    curve.y = zeros(1, length(curve.x));

    x_pos = 1;
    for element = s_sample
        while( curve.x(x_pos) <= element ) % start <= element < end

            x_pos = x_pos + 1;
        endwhile

        curve.y(x_pos - 1) = curve.y(x_pos - 1) + 1;
    endfor

    for i = 1:length(curve.x)
        curve.y(i) = curve.y(i) / length(sample);
    endfor
endfunction
