% compare curves (stat test)
function [tests] = cmp_surv_curves(curves)

	curve_len = length(curves(1).x);

    if( length(curves) < 2 )
        fprintf('[ERROR] For comparison must be at least 2 curves.\n');
        return 
    else
        for i = 1:length(curves)
            if( length(curves(i).x) != curve_len )
                fprintf('[ERROR] Not equal survival vectors length.\n');
                return
            endif
        endfor
    endif 
        
    e = E = ome = zeros(1, length(curves));
    var_ome = 0;
        
    for i = 1:curve_len
        
        for j = 1:length(curves)
            n(j) = curves(j).timestamps(i).risk;
            m(j) = curves(j).timestamps(i).event;
        endfor

        % event(death) proporion
        e = n ./ sum(n) .* sum(m);
    
        E = E + e;
    
        % ome - observed minus expected
        ome = ome + (m - e);

        if(length(curves) == 2)
            % variance ome
            var_ome = var_ome + ...
                (n(1) * n(2) * (m(1) + m(2)) * (n(1) + n(2) - m(1) - m(2))) / ((n(1) + n(2))^2 * (n(1) + n(2) - 1));
        endif
    endfor
    
    if(length(curves) == 2)
        tests.log_rank = ome(1)^2 / var_ome;
    endif

    tests.chi_square = sum(ome.^2 ./ E);

endfunction
