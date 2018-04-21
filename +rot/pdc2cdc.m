% probability density curve to cumulative distribution curve

function cdc = pdc2cdc(pdc)
	cdc = pdc;
	for i = 2:length(pdc.x)
		cdc.y(i) = cdc.y(i) + cdc.y(i-1);
	endfor
endfunction
