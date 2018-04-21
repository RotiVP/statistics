function density_val = density(cumul_val)
	density_val = zeros(1, length(cumul_val));

	density_val(1) = cumul_val(1);

	for i = 2:length(cumul_val)
		density_val(i) = cumul_val(i) - cumul_val(i-1);	
	endfor
endfunction
