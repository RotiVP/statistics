function show_surv_curves(curves, legends)
	figure
    grid on
    hold on
    set(gca, 'FontSize', 15);

	curves = fit_surv_curves(curves);

    for curve = curves
        stairs(curve.x, curve.y);
    endfor

    legend(legends);
    title('Выживаемость');
    xlabel('День');
    ylabel('Вероятность');
endfunction
