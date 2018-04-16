function curves = fit_surv_curves(curves)

    curve_len = length(curves(1).timestamps);
    for i = 2:length(curves)
        if(length(curves(i).timestamps) < curve_len)
            curve_len = length(curves(i).timestamps);
        endif
    endfor

    for i = 1:length(curves)
        curves(i).x = curves(i).x(1:curve_len);
        curves(i).y = curves(i).y(1:curve_len);
        curves(i).timestamps = curves(i).timestamps(1:curve_len);

    endfor
endfunction
